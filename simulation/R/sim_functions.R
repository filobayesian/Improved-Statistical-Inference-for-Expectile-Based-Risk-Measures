# Utilities for the finite-sample study in Chapter 5.
#
# The simulation uses ExtremeRisks for the importable univariate EVT
# primitives: Hill tail-index estimation and Weissman extreme-quantile
# extrapolation. The remaining code is the thesis-specific glue for the
# two-weight pooled extreme-expectile estimator.

ensure_extremerisks <- function() {
  if (!requireNamespace("ExtremeRisks", quietly = TRUE)) {
    stop(
      "Package ExtremeRisks is required. Install it before running the ",
      "finite-sample simulations; no local fallback is used.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

valid_gamma_domain <- function(gamma) {
  is.finite(gamma) & gamma > 0 & gamma < 1
}

psi_fn <- function(gamma) {
  out <- rep(NA_real_, length(gamma))
  ok <- valid_gamma_domain(gamma)
  out[ok] <- ((1 / gamma[ok]) - 1)^(-gamma[ok])
  out
}

normalize_weights <- function(w) {
  s <- sum(w)
  if (!is.finite(s) || abs(s) < 1e-12) {
    return(rep(NA_real_, length(w)))
  }
  as.numeric(w / s)
}

safe_solve <- function(a, b) {
  tryCatch(solve(a, b), error = function(e) NULL)
}

finite_or_na <- function(x) {
  x <- suppressWarnings(as.numeric(x))
  if (length(x) == 0 || !is.finite(x[1])) NA_real_ else x[1]
}

student_tail_beta <- function(df) {
  c_t <- gamma((df + 1) / 2) / (sqrt(df * pi) * gamma(df / 2))
  tail_const <- 2 * c_t * df^((df - 1) / 2)
  df * (df + 1) / (df + 2) * tail_const^(-2 / df)
}

make_dgp <- function(key) {
  switch(
    key,
    pareto_light = {
      gamma <- 0.25
      list(
        key = key, name = "Pareto light", gamma = gamma, rho = -1,
        beta = 0,
        r = function(n) stats::runif(n)^(-gamma),
        cdf = function(x) ifelse(x < 1, 0, 1 - x^(-1 / gamma)),
        surv = function(x) ifelse(x < 1, 1, x^(-1 / gamma)),
        quantile = function(tau) (1 - tau)^(-gamma)
      )
    },
    pareto_heavy = {
      gamma <- 0.60
      list(
        key = key, name = "Pareto heavy", gamma = gamma, rho = -1,
        beta = 0,
        r = function(n) stats::runif(n)^(-gamma),
        cdf = function(x) ifelse(x < 1, 0, 1 - x^(-1 / gamma)),
        surv = function(x) ifelse(x < 1, 1, x^(-1 / gamma)),
        quantile = function(tau) (1 - tau)^(-gamma)
      )
    },
    burr_light = {
      gamma <- 0.25
      rho <- -1
      list(
        key = key, name = "Burr light", gamma = gamma, rho = rho,
        beta = 1,
        r = function(n) {
          p <- 1 - stats::runif(n)
          (p^rho - 1)^(-gamma / rho)
        },
        cdf = function(x) ifelse(x <= 0, 0, 1 - (1 + x^(-rho / gamma))^(1 / rho)),
        surv = function(x) ifelse(x <= 0, 1, (1 + x^(-rho / gamma))^(1 / rho)),
        quantile = function(tau) {
          p <- 1 - tau
          (p^rho - 1)^(-gamma / rho)
        }
      )
    },
    burr_heavy = {
      gamma <- 0.60
      rho <- -1
      list(
        key = key, name = "Burr heavy", gamma = gamma, rho = rho,
        beta = 1,
        r = function(n) {
          p <- 1 - stats::runif(n)
          (p^rho - 1)^(-gamma / rho)
        },
        cdf = function(x) ifelse(x <= 0, 0, 1 - (1 + x^(-rho / gamma))^(1 / rho)),
        surv = function(x) ifelse(x <= 0, 1, (1 + x^(-rho / gamma))^(1 / rho)),
        quantile = function(tau) {
          p <- 1 - tau
          (p^rho - 1)^(-gamma / rho)
        }
      )
    },
    student3 = {
      df <- 3
      gamma <- 1 / df
      list(
        key = key, name = "Abs. Student-3", gamma = gamma, rho = -2 / df,
        beta = student_tail_beta(df), df = df,
        r = function(n) abs(stats::rt(n, df = df)),
        cdf = function(x) ifelse(x <= 0, 0, 2 * stats::pt(x, df = df) - 1),
        surv = function(x) ifelse(x <= 0, 1, 2 * stats::pt(-x, df = df)),
        quantile = function(tau) stats::qt((tau + 1) / 2, df = df)
      )
    },
    stop("Unknown DGP: ", key, call. = FALSE)
  )
}

tail_auxiliary <- function(dgp, t) {
  dgp$gamma * dgp$beta * t^dgp$rho
}

expectile_truth <- function(dgp, tau) {
  f <- function(x) {
    upper <- stats::integrate(
      dgp$surv, lower = x, upper = Inf,
      rel.tol = 1e-8, subdivisions = 500
    )$value
    lower <- if (x <= 0) {
      0
    } else {
      stats::integrate(
        dgp$cdf, lower = 0, upper = x,
        rel.tol = 1e-8, subdivisions = 500
      )$value
    }
    tau * upper - (1 - tau) * lower
  }

  upper <- dgp$quantile(min(1 - 1e-10, 1 - 0.01 * (1 - tau)))
  if (!is.finite(upper) || upper <= 0) upper <- 1
  while (f(upper) > 0) upper <- upper * 2
  stats::uniroot(f, lower = 0, upper = upper, tol = 1e-8)$root
}

EXPECTILE_TRUTH_CACHE <- new.env(parent = emptyenv())

expectile_truth_cached <- function(dgp, tau) {
  key <- paste(dgp$key, format(tau, digits = 16), sep = "::")
  if (!exists(key, envir = EXPECTILE_TRUTH_CACHE, inherits = FALSE)) {
    assign(key, expectile_truth(dgp, tau), envir = EXPECTILE_TRUTH_CACHE)
  }
  get(key, envir = EXPECTILE_TRUTH_CACHE, inherits = FALSE)
}

er_hill <- function(x, k) {
  ensure_extremerisks()
  fit <- tryCatch(
    ExtremeRisks::HTailIndex(
      data = x, k = as.integer(k), var = FALSE, bias = FALSE,
      varType = "asym-Ind"
    ),
    error = function(e) NULL
  )
  if (is.null(fit)) return(NA_real_)
  finite_or_na(fit$gammaHat)
}

er_weissman <- function(x, k, p) {
  ensure_extremerisks()
  n <- length(x)
  tau_intermediate <- 1 - k / n
  tau_extreme <- 1 - p
  fit <- tryCatch(
    ExtremeRisks::extQuantile(
      data = x, tau = tau_intermediate, tau1 = tau_extreme,
      var = FALSE, bias = FALSE, varType = "asym-Ind", k = as.integer(k)
    ),
    error = function(e) NULL
  )
  if (is.null(fit)) return(NA_real_)
  finite_or_na(fit$ExtQHat)
}

local_primitives <- function(samples, k_vec, p) {
  m <- length(samples)
  gamma_hat <- q_hat <- numeric(m)
  for (j in seq_len(m)) {
    gamma_hat[j] <- er_hill(samples[[j]], k_vec[j])
    q_hat[j] <- er_weissman(samples[[j]], k_vec[j], p)
  }
  list(gamma_hat = gamma_hat, q_hat = q_hat)
}

pooled_expectile <- function(gamma_hat, q_hat, nu, omega) {
  gamma_bridge <- sum(nu * gamma_hat)
  if (!valid_gamma_domain(gamma_bridge) ||
      any(!is.finite(q_hat)) || any(q_hat <= 0) ||
      any(!is.finite(omega))) {
    return(list(estimate = NA_real_, gamma_bridge = gamma_bridge))
  }
  q_pool <- exp(sum(omega * log(q_hat)))
  if (!is.finite(q_pool) || q_pool <= 0) {
    return(list(estimate = NA_real_, gamma_bridge = gamma_bridge))
  }
  list(estimate = psi_fn(gamma_bridge) * q_pool,
       gamma_bridge = gamma_bridge)
}

dps_objects <- function(gamma, rho, beta, n_vec, k_vec) {
  m <- length(n_vec)
  k_total <- sum(k_vec)
  n_total <- sum(n_vec)
  if (!valid_gamma_domain(gamma) || !is.finite(rho) || rho >= 0 ||
      !is.finite(beta)) {
    return(NULL)
  }
  c_vec <- k_vec[1] / k_vec
  b_vec <- n_vec[1] / n_vec
  d_vec <- (c_vec / b_vec) * (sum(1 / c_vec) / sum(1 / b_vec))
  lambda <- sqrt(k_total) * gamma * beta * (n_total / k_total)^rho
  Bc <- lambda / (1 - rho) * d_vec^rho
  Vc <- diag(gamma^2 * sum(1 / c_vec) * c_vec, nrow = m)
  list(Bc = as.numeric(Bc), Vc = Vc, c = c_vec, b = b_vec, d = d_vec)
}

variance_weights <- function(k_vec) {
  normalize_weights(k_vec)
}

amse_weights <- function(Bc, Vc) {
  vinv1 <- safe_solve(Vc, rep(1, length(Bc)))
  vinvb <- safe_solve(Vc, Bc)
  if (is.null(vinv1) || is.null(vinvb)) return(rep(NA_real_, length(Bc)))
  bt_vinv_b <- as.numeric(t(Bc) %*% vinvb)
  one_vinv_b <- sum(vinvb)
  one_vinv_one <- sum(vinv1)
  den <- (1 + bt_vinv_b) * one_vinv_one - one_vinv_b^2
  if (!is.finite(den) || abs(den) < 1e-12) {
    return(rep(NA_real_, length(Bc)))
  }
  as.numeric(((1 + bt_vinv_b) * vinv1 - one_vinv_b * vinvb) / den)
}

estimate_second_order_evt0 <- function(x) {
  if (!requireNamespace("evt0", quietly = TRUE)) return(NULL)
  rho_fun <- tryCatch(getExportedValue("evt0", "mop.rho"), error = function(e) NULL)
  beta_fun <- tryCatch(getExportedValue("evt0", "mop.beta"), error = function(e) NULL)
  if (is.null(rho_fun) || is.null(beta_fun)) return(NULL)
  osx <- sort(x)
  rho_raw <- tryCatch(rho_fun(osx), error = function(e) NULL)
  rho <- suppressWarnings(tail(as.numeric(rho_raw), 1))
  if (!is.finite(rho) || rho >= 0) return(NULL)
  beta_raw <- tryCatch(beta_fun(log(osx), rho), error = function(e) NULL)
  beta <- suppressWarnings(tail(as.numeric(beta_raw), 1))
  if (!is.finite(beta)) return(NULL)
  list(rho = rho, beta = beta)
}

plugin_dps_objects <- function(samples, n_vec, k_vec, gamma_hat, nu) {
  second <- lapply(samples, estimate_second_order_evt0)
  if (any(vapply(second, is.null, logical(1)))) return(NULL)
  n_weight <- n_vec / sum(n_vec)
  rho_hat <- sum(n_weight * vapply(second, `[[`, numeric(1), "rho"))
  beta_hat <- sum(n_weight * vapply(second, `[[`, numeric(1), "beta"))
  gamma_hat_pool <- sum(nu * gamma_hat)
  dps_objects(gamma_hat_pool, rho_hat, beta_hat, n_vec, k_vec)
}

log_ci <- function(est, ell, k_total, B_hat, V_hat, alpha = 0.05) {
  if (!is.finite(est) || est <= 0 || !is.finite(ell) || ell <= 0 ||
      !is.finite(k_total) || k_total <= 0 ||
      !is.finite(B_hat) || !is.finite(V_hat) || V_hat <= 0) {
    return(c(NA_real_, NA_real_))
  }
  z <- stats::qnorm(1 - alpha / 2)
  half <- z * sqrt(V_hat)
  scale <- ell / sqrt(k_total)
  c(log(est) - scale * (B_hat + half),
    log(est) - scale * (B_hat - half))
}

allocation_weights <- function(m, regime) {
  if (regime == "balanced") return(rep(1 / m, m))
  if (regime == "strong") {
    return(normalize_weights(exp(seq(0, log(10), length.out = m))))
  }
  stop("Unknown allocation regime: ", regime, call. = FALSE)
}

scenario_grid <- function(mode) {
  if (mode == "smoke") {
    return(data.frame(
      dgp = "burr_heavy", m = 5, regime = "strong",
      k_fraction = 0.05, n_total = 2500, np_target = 5,
      stringsAsFactors = FALSE
    ))
  }

  dgp_names <- c(
    "pareto_light", "pareto_heavy", "burr_light", "burr_heavy", "student3"
  )

  if (mode == "pilot") {
    return(expand.grid(
      dgp = c("pareto_light", "burr_heavy", "student3"),
      m = c(5, 10),
      regime = c("balanced", "strong"),
      k_fraction = 0.05,
      n_total = 5000,
      np_target = 5,
      stringsAsFactors = FALSE
    ))
  }

  main <- expand.grid(
    dgp = dgp_names,
    m = c(5, 10),
    regime = c("balanced", "strong"),
    k_fraction = 0.05,
    n_total = 10000,
    np_target = 5,
    stringsAsFactors = FALSE
  )
  threshold <- expand.grid(
    dgp = dgp_names,
    m = 10,
    regime = "strong",
    k_fraction = c(0.03, 0.05, 0.10),
    n_total = 10000,
    np_target = 5,
    stringsAsFactors = FALSE
  )
  target <- expand.grid(
    dgp = dgp_names,
    m = 10,
    regime = "strong",
    k_fraction = 0.05,
    n_total = 10000,
    np_target = c(1, 5, 10),
    stringsAsFactors = FALSE
  )
  unique(rbind(main, threshold, target))
}

scenario_sizes <- function(m, regime, n_total, k_fraction) {
  w <- allocation_weights(m, regime)
  n_vec <- pmax(20, floor(n_total * w))
  n_vec[length(n_vec)] <- n_vec[length(n_vec)] + n_total - sum(n_vec)
  k_vec <- pmax(5, floor(k_fraction * n_vec))
  k_vec <- pmin(k_vec, n_vec - 2)
  list(n_vec = as.integer(n_vec), k_vec = as.integer(k_vec))
}

estimator_specs <- function(dgp, samples, n_vec, k_vec, gamma_hat, nu) {
  m <- length(k_vec)
  oracle <- dps_objects(dgp$gamma, dgp$rho, dgp$beta, n_vec, k_vec)
  plugin <- plugin_dps_objects(samples, n_vec, k_vec, gamma_hat, nu)

  specs <- list(
    equal = list(
      omega = rep(1 / m, m),
      kind = "deterministic",
      objects = plugin
    ),
    dps_variance = list(
      omega = variance_weights(k_vec),
      kind = "deterministic",
      objects = plugin
    ),
    dps_amse_oracle = list(
      omega = if (is.null(oracle)) rep(NA_real_, m) else amse_weights(oracle$Bc, oracle$Vc),
      kind = "oracle",
      objects = oracle
    ),
    dps_amse_plugin = list(
      omega = if (is.null(plugin)) rep(NA_real_, m) else amse_weights(plugin$Bc, plugin$Vc),
      kind = "plugin",
      objects = plugin
    )
  )
  specs
}

run_one_replication <- function(scenario, rep_id, alpha = 0.05) {
  dgp <- make_dgp(scenario$dgp)
  sizes <- scenario_sizes(
    scenario$m, scenario$regime, scenario$n_total, scenario$k_fraction
  )
  n_vec <- sizes$n_vec
  k_vec <- sizes$k_vec
  n_total <- sum(n_vec)
  k_total <- sum(k_vec)
  p <- scenario$np_target / n_total
  tau <- 1 - p
  ell <- log(k_total / (n_total * p))
  nu <- variance_weights(k_vec)

  samples <- lapply(n_vec, dgp$r)
  combined <- unlist(samples, use.names = FALSE)
  prim <- local_primitives(samples, k_vec, p)
  truth <- expectile_truth_cached(dgp, tau)
  specs <- estimator_specs(dgp, samples, n_vec, k_vec, prim$gamma_hat, nu)

  rows <- list()
  add_row <- function(estimator, kind, xi_hat, gamma_bridge, omega, objects,
                      is_centralised = FALSE) {
    valid_estimate <- is.finite(xi_hat) && xi_hat > 0 &&
      is.finite(truth) && truth > 0 && valid_gamma_domain(gamma_bridge)
    B_hat <- V_hat <- NA_real_
    if (is_centralised) {
      B_hat <- 0
      V_hat <- if (valid_gamma_domain(gamma_bridge)) gamma_bridge^2 else NA_real_
    } else if (!is.null(objects) && all(is.finite(omega))) {
      B_hat <- sum(omega * objects$Bc)
      V_hat <- as.numeric(t(omega) %*% objects$Vc %*% omega)
    }
    ci <- log_ci(xi_hat, ell, k_total, B_hat, V_hat, alpha)
    valid_ci <- valid_estimate && all(is.finite(ci))
    rows[[length(rows) + 1]] <<- data.frame(
      rep = rep_id,
      dgp = dgp$name,
      dgp_key = dgp$key,
      gamma = dgp$gamma,
      m = scenario$m,
      regime = scenario$regime,
      k_fraction = scenario$k_fraction,
      n_total = n_total,
      k_total = k_total,
      np_target = scenario$np_target,
      tau = tau,
      estimator = estimator,
      estimator_kind = kind,
      estimate = if (valid_estimate) xi_hat else NA_real_,
      truth = truth,
      log_error = if (valid_estimate) log(xi_hat / truth) else NA_real_,
      abs_log_error = if (valid_estimate) abs(log(xi_hat / truth)) else NA_real_,
      covered = if (valid_ci) {
        as.integer(log(truth) >= ci[1] && log(truth) <= ci[2])
      } else {
        NA_integer_
      },
      ci_log_length = if (valid_ci) ci[2] - ci[1] else NA_real_,
      invalid_domain = as.integer(!valid_gamma_domain(gamma_bridge)),
      valid_estimate = as.integer(valid_estimate),
      valid_ci = as.integer(valid_ci),
      any_negative_weight = if (is_centralised) 0L else as.integer(any(omega < 0, na.rm = TRUE)),
      max_abs_weight = if (is_centralised) 1 else max(abs(omega), na.rm = TRUE),
      plugin_available = requireNamespace("evt0", quietly = TRUE),
      stringsAsFactors = FALSE
    )
  }

  for (name in names(specs)) {
    spec <- specs[[name]]
    pooled <- pooled_expectile(prim$gamma_hat, prim$q_hat, nu, spec$omega)
    add_row(
      name, spec$kind, pooled$estimate, pooled$gamma_bridge,
      spec$omega, spec$objects
    )
  }

  gamma_full <- er_hill(combined, k_total)
  q_full <- er_weissman(combined, k_total, p)
  xi_full <- if (valid_gamma_domain(gamma_full) &&
                 is.finite(q_full) && q_full > 0) {
    psi_fn(gamma_full) * q_full
  } else {
    NA_real_
  }
  add_row(
    "centralised", "benchmark", xi_full, gamma_full, 1, NULL,
    is_centralised = TRUE
  )

  do.call(rbind, rows)
}

summarise_results <- function(results) {
  mean_na <- function(x) {
    if (all(is.na(x))) return(NA_real_)
    mean(x, na.rm = TRUE)
  }
  sum_na <- function(x) sum(x, na.rm = TRUE)
  group_vars <- c(
    "dgp", "dgp_key", "gamma", "m", "regime", "k_fraction", "n_total",
    "k_total", "np_target", "estimator", "estimator_kind", "plugin_available"
  )
  summary_input <- transform(
    results,
    log_error_sq = ifelse(is.na(log_error), NA_real_, log_error^2)
  )
  out <- aggregate(
    cbind(
      log_error, log_error_sq, abs_log_error, covered, ci_log_length,
      any_negative_weight, max_abs_weight
    ) ~ dgp + dgp_key + gamma + m + regime + k_fraction + n_total +
      k_total + np_target + estimator + estimator_kind + plugin_available,
    data = summary_input,
    FUN = mean_na,
    na.action = na.pass
  )
  counts <- aggregate(
    rep ~ dgp + dgp_key + gamma + m + regime + k_fraction + n_total +
      k_total + np_target + estimator + estimator_kind + plugin_available,
    data = summary_input,
    FUN = length,
    na.action = na.pass
  )
  diagnostics <- aggregate(
    cbind(valid_estimate, valid_ci, invalid_domain) ~
      dgp + dgp_key + gamma + m + regime + k_fraction + n_total +
      k_total + np_target + estimator + estimator_kind + plugin_available,
    data = summary_input,
    FUN = sum_na,
    na.action = na.pass
  )
  names(counts)[names(counts) == "rep"] <- "n_replications"
  names(diagnostics)[names(diagnostics) == "valid_estimate"] <- "valid_replications"
  names(diagnostics)[names(diagnostics) == "valid_ci"] <- "valid_ci_replications"
  names(diagnostics)[names(diagnostics) == "invalid_domain"] <- "invalid_count"
  merged <- merge(out, counts, by = group_vars)
  merged <- merge(merged, diagnostics, by = group_vars)
  merged$log_bias <- merged$log_error
  merged$log_rmse <- sqrt(merged$log_error_sq)
  merged$coverage <- merged$covered
  merged$invalid_rate <- merged$invalid_count / merged$n_replications
  merged$valid_rate <- merged$valid_replications / merged$n_replications
  merged$valid_ci_rate <- merged$valid_ci_replications / merged$n_replications
  merged$negative_weight_rate <- merged$any_negative_weight
  merged$avg_max_abs_weight <- merged$max_abs_weight
  merged
}
