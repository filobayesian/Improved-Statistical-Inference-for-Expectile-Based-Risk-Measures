# Utilities for the finite-sample study in Chapter 5.
#
# The simulation uses ExtremeRisks for the importable univariate EVT
# primitives: Hill tail-index estimation and Weissman extreme-quantile
# extrapolation. The remaining code is the thesis-specific glue for the
# two-weight pooled extreme-expectile estimator.

SIMULATION_DESIGN_VERSION <- "two_weight_pooled_extreme_20260607"

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

scenario_value <- function(scenario, name, default) {
  if (!name %in% names(scenario)) return(default)
  value <- scenario[[name]][1]
  if (length(value) == 0 || is.na(value)) default else value
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
    return(list(
      estimate = NA_real_,
      gamma_bridge = gamma_bridge,
      q_pool = NA_real_
    ))
  }
  q_pool <- exp(sum(omega * log(q_hat)))
  if (!is.finite(q_pool) || q_pool <= 0) {
    return(list(
      estimate = NA_real_,
      gamma_bridge = gamma_bridge,
      q_pool = q_pool
    ))
  }
  list(estimate = psi_fn(gamma_bridge) * q_pool,
       gamma_bridge = gamma_bridge,
       q_pool = q_pool)
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

nu_specs <- function(n_vec, k_vec) {
  m <- length(k_vec)
  list(
    threshold = variance_weights(k_vec),
    equal = rep(1 / m, m),
    sample = variance_weights(n_vec)
  )
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

plugin_second_order <- function(samples, n_vec) {
  second <- lapply(samples, estimate_second_order_evt0)
  if (any(vapply(second, is.null, logical(1)))) return(NULL)
  n_weight <- n_vec / sum(n_vec)
  list(
    rho = sum(n_weight * vapply(second, `[[`, numeric(1), "rho")),
    beta = sum(n_weight * vapply(second, `[[`, numeric(1), "beta"))
  )
}

plugin_source_eligible <- function(dgp) {
  is.null(dgp) || (is.finite(dgp$beta) && abs(dgp$beta) > 1e-12)
}

plugin_status <- function(dgp, second_order, objects) {
  if (!requireNamespace("evt0", quietly = TRUE)) return("evt0_unavailable")
  if (!plugin_source_eligible(dgp)) return("source_ineligible")
  if (is.null(second_order)) return("second_order_failed")
  if (is.null(objects)) return("object_failed")
  "ok"
}

plugin_dps_objects <- function(samples, n_vec, k_vec, gamma_hat, nu,
                               second_order = NULL, dgp = NULL) {
  if (!plugin_source_eligible(dgp)) return(NULL)
  if (is.null(second_order)) {
    second_order <- plugin_second_order(samples, n_vec)
  }
  if (is.null(second_order)) return(NULL)
  gamma_hat_pool <- sum(nu * gamma_hat)
  dps_objects(gamma_hat_pool, second_order$rho, second_order$beta, n_vec, k_vec)
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
      dgp = "burr_heavy", m = 10, regime = "strong",
      k_rule = "fraction", k_fraction = 0.05, k_power = NA_real_,
      n_total = 2500, np_target = 5, design_role = "main",
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
      k_rule = "fraction",
      k_fraction = 0.05,
      k_power = NA_real_,
      n_total = 5000,
      np_target = 5,
      design_role = "main",
      stringsAsFactors = FALSE
    ))
  }

  main <- expand.grid(
    dgp = dgp_names,
    m = c(5, 10),
    regime = c("balanced", "strong"),
    k_rule = "fraction",
    k_fraction = 0.05,
    k_power = NA_real_,
    n_total = 10000,
    np_target = 5,
    design_role = "main",
    stringsAsFactors = FALSE
  )
  threshold <- expand.grid(
    dgp = dgp_names,
    m = 10,
    regime = "strong",
    k_rule = "fraction",
    k_fraction = c(0.03, 0.05, 0.10),
    k_power = NA_real_,
    n_total = 10000,
    np_target = 5,
    design_role = "threshold",
    stringsAsFactors = FALSE
  )
  target <- expand.grid(
    dgp = dgp_names,
    m = 10,
    regime = "strong",
    k_rule = "fraction",
    k_fraction = 0.05,
    k_power = NA_real_,
    n_total = 10000,
    np_target = c(1, 5, 10),
    design_role = "target",
    stringsAsFactors = FALSE
  )
  unique(rbind(main, threshold, target))
}

allocate_counts <- function(total, weights, min_count = 0L) {
  weights <- normalize_weights(weights)
  raw <- total * weights
  counts <- pmax(as.integer(min_count), floor(raw))
  delta <- as.integer(total - sum(counts))
  if (delta > 0) {
    order_add <- order(raw - floor(raw), decreasing = TRUE)
    for (idx in rep(order_add, length.out = delta)) {
      counts[idx] <- counts[idx] + 1L
    }
  } else if (delta < 0) {
    order_drop <- order(counts - min_count, decreasing = TRUE)
    for (idx in rep(order_drop, length.out = abs(delta))) {
      if (counts[idx] > min_count) counts[idx] <- counts[idx] - 1L
    }
  }
  counts
}

scenario_sizes <- function(m, regime, n_total, k_fraction = NA_real_,
                           k_rule = "fraction", k_power = NA_real_) {
  w <- allocation_weights(m, regime)
  n_vec <- pmax(20, floor(n_total * w))
  n_vec[length(n_vec)] <- n_vec[length(n_vec)] + n_total - sum(n_vec)
  if (k_rule == "fraction") {
    if (!is.finite(k_fraction) || k_fraction <= 0) {
      stop("A positive k_fraction is required for fraction threshold designs.",
           call. = FALSE)
    }
    k_vec <- pmax(5, floor(k_fraction * n_vec))
  } else if (k_rule == "power") {
    if (!is.finite(k_power) || k_power <= 0 || k_power >= 1) {
      stop("k_power must be in (0, 1) for power threshold designs.",
           call. = FALSE)
    }
    k_total_target <- max(5L * m, as.integer(floor(n_total^k_power)))
    k_vec <- allocate_counts(k_total_target, w, min_count = 5L)
  } else {
    stop("Unknown threshold rule: ", k_rule, call. = FALSE)
  }
  k_vec <- pmin(k_vec, n_vec - 2)
  list(n_vec = as.integer(n_vec), k_vec = as.integer(k_vec))
}

estimator_specs <- function(dgp, samples, n_vec, k_vec, gamma_hat, plugin_nu,
                            plugin_second = NULL) {
  m <- length(k_vec)
  oracle <- dps_objects(dgp$gamma, dgp$rho, dgp$beta, n_vec, k_vec)
  plugin <- plugin_dps_objects(
    samples, n_vec, k_vec, gamma_hat, plugin_nu, plugin_second, dgp
  )
  plugin_state <- plugin_status(dgp, plugin_second, plugin)

  specs <- list(
    equal = list(
      omega = rep(1 / m, m),
      kind = "deterministic",
      objects = plugin,
      standardization = if (is.null(plugin)) "none" else "plugin",
      plugin_status = plugin_state
    ),
    dps_variance = list(
      omega = variance_weights(k_vec),
      kind = "deterministic",
      objects = plugin,
      standardization = if (is.null(plugin)) "none" else "plugin",
      plugin_status = plugin_state
    ),
    dps_amse_oracle = list(
      omega = if (is.null(oracle)) rep(NA_real_, m) else amse_weights(oracle$Bc, oracle$Vc),
      kind = "oracle",
      objects = oracle,
      standardization = if (is.null(oracle)) "none" else "oracle",
      plugin_status = "not_used"
    ),
    dps_amse_plugin = list(
      omega = if (is.null(plugin)) rep(NA_real_, m) else amse_weights(plugin$Bc, plugin$Vc),
      kind = "plugin",
      objects = plugin,
      standardization = if (is.null(plugin)) "none" else "plugin",
      plugin_status = plugin_state
    )
  )
  specs
}

run_one_replication <- function(scenario, rep_id, alpha = 0.05) {
  dgp <- make_dgp(scenario$dgp)
  k_rule <- as.character(scenario_value(scenario, "k_rule", "fraction"))
  k_fraction_design <- suppressWarnings(as.numeric(
    scenario_value(scenario, "k_fraction", NA_real_)
  ))
  k_power <- suppressWarnings(as.numeric(
    scenario_value(scenario, "k_power", NA_real_)
  ))
  design_role <- as.character(scenario_value(scenario, "design_role", "main"))
  sizes <- scenario_sizes(
    scenario$m, scenario$regime, scenario$n_total, k_fraction_design,
    k_rule, k_power
  )
  n_vec <- sizes$n_vec
  k_vec <- sizes$k_vec
  n_total <- sum(n_vec)
  k_total <- sum(k_vec)
  k_fraction_actual <- k_total / n_total
  k_design <- if (k_rule == "power") {
    paste0("n^", format(k_power, trim = TRUE, scientific = FALSE))
  } else {
    paste0("fraction=", format(k_fraction_design, trim = TRUE, scientific = FALSE))
  }
  p <- scenario$np_target / n_total
  tau <- 1 - p
  ell <- log(k_total / (n_total * p))
  scale <- sqrt(k_total) / ell

  samples <- lapply(n_vec, dgp$r)
  combined <- unlist(samples, use.names = FALSE)
  prim <- local_primitives(samples, k_vec, p)
  truth <- expectile_truth_cached(dgp, tau)
  q_truth <- dgp$quantile(tau)
  psi_true <- psi_fn(dgp$gamma)
  bridge_target <- psi_true * q_truth
  eta <- if (is.finite(q_truth) && q_truth > 0 && is.finite(ell) && ell > 0) {
    sqrt(k_total) / (ell * q_truth)
  } else {
    NA_real_
  }
  C_term <- if (is.finite(truth) && truth > 0 &&
                is.finite(bridge_target) && bridge_target > 0) {
    log(truth / bridge_target)
  } else {
    NA_real_
  }

  rows <- list()
  add_row <- function(estimator, kind, nu_choice, xi_hat, gamma_bridge,
                      q_pool, omega, objects,
                      standardization = "none", plugin_state = "not_used",
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
    psi_bridge <- psi_fn(gamma_bridge)
    A_term <- if (is.finite(q_pool) && q_pool > 0 &&
                  is.finite(q_truth) && q_truth > 0) {
      log(q_pool / q_truth)
    } else {
      NA_real_
    }
    B_term <- if (is.finite(psi_bridge) && psi_bridge > 0 &&
                  is.finite(psi_true) && psi_true > 0) {
      log(psi_bridge) - log(psi_true)
    } else {
      NA_real_
    }
    log_error <- if (valid_estimate) log(xi_hat / truth) else NA_real_
    scaled_log_error <- if (is.finite(log_error)) scale * log_error else NA_real_
    studentized <- if (is.finite(scaled_log_error) &&
                       is.finite(B_hat) &&
                       is.finite(V_hat) && V_hat > 0) {
      (scaled_log_error - B_hat) / sqrt(V_hat)
    } else {
      NA_real_
    }
    any_negative <- if (is_centralised) {
      0L
    } else if (any(is.finite(omega))) {
      as.integer(any(omega[is.finite(omega)] < 0))
    } else {
      NA_integer_
    }
    max_abs <- if (is_centralised) {
      1
    } else if (any(is.finite(omega))) {
      max(abs(omega[is.finite(omega)]))
    } else {
      NA_real_
    }
    rows[[length(rows) + 1]] <<- data.frame(
      rep = rep_id,
      design_version = SIMULATION_DESIGN_VERSION,
      design_role = design_role,
      dgp = dgp$name,
      dgp_key = dgp$key,
      gamma = dgp$gamma,
      m = scenario$m,
      regime = scenario$regime,
      k_rule = k_rule,
      k_design = k_design,
      k_fraction_design = k_fraction_design,
      k_power = if (is.finite(k_power)) k_power else NA_real_,
      k_fraction = k_fraction_actual,
      n_total = n_total,
      k_total = k_total,
      np_target = scenario$np_target,
      tau = tau,
      ell = ell,
      sqrtk_over_ell = sqrt(k_total) / ell,
      eta = eta,
      bridge_log_gap = C_term,
      nu_choice = nu_choice,
      estimator = estimator,
      estimator_kind = kind,
      standardization = standardization,
      plugin_status = plugin_state,
      estimate = if (valid_estimate) xi_hat else NA_real_,
      truth = truth,
      bridge_target = bridge_target,
      q_truth = q_truth,
      q_pool = q_pool,
      gamma_bridge = gamma_bridge,
      B_hat = B_hat,
      V_hat = V_hat,
      log_error = log_error,
      abs_log_error = if (valid_estimate) abs(log_error) else NA_real_,
      scaled_log_error = scaled_log_error,
      studentized = studentized,
      decomp_A = A_term,
      decomp_B = B_term,
      decomp_C = C_term,
      decomp_remainder = if (all(is.finite(c(A_term, B_term, C_term, log_error)))) {
        log_error - (A_term + B_term - C_term)
      } else {
        NA_real_
      },
      scaled_A = if (is.finite(A_term)) scale * A_term else NA_real_,
      scaled_B = if (is.finite(B_term)) scale * B_term else NA_real_,
      scaled_C = if (is.finite(C_term)) scale * C_term else NA_real_,
      covered = if (valid_ci) {
        as.integer(log(truth) >= ci[1] && log(truth) <= ci[2])
      } else {
        NA_integer_
      },
      ci_log_length = if (valid_ci) ci[2] - ci[1] else NA_real_,
      invalid_domain = as.integer(!valid_gamma_domain(gamma_bridge)),
      valid_estimate = as.integer(valid_estimate),
      valid_ci = as.integer(valid_ci),
      any_negative_weight = any_negative,
      max_abs_weight = max_abs,
      plugin_available = requireNamespace("evt0", quietly = TRUE),
      stringsAsFactors = FALSE
    )
  }

  nu_choices <- nu_specs(n_vec, k_vec)
  plugin_second <- if (plugin_source_eligible(dgp)) {
    plugin_second_order(samples, n_vec)
  } else {
    NULL
  }
  plugin_nu <- nu_choices$threshold
  for (nu_choice in names(nu_choices)) {
    nu <- nu_choices[[nu_choice]]
    specs <- estimator_specs(
      dgp, samples, n_vec, k_vec, prim$gamma_hat, plugin_nu, plugin_second
    )
    for (name in names(specs)) {
      spec <- specs[[name]]
      pooled <- pooled_expectile(prim$gamma_hat, prim$q_hat, nu, spec$omega)
      add_row(
        name, spec$kind, nu_choice, pooled$estimate, pooled$gamma_bridge,
        pooled$q_pool, spec$omega, spec$objects,
        spec$standardization, spec$plugin_status
      )
    }
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
    "centralised", "benchmark", "centralised", xi_full, gamma_full, q_full,
    1, NULL,
    "oracle", "not_applicable",
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
    "design_version", "design_role", "dgp", "dgp_key", "gamma", "m",
    "regime", "k_rule", "k_design", "k_fraction", "n_total", "k_total",
    "np_target", "ell", "sqrtk_over_ell", "eta", "bridge_log_gap",
    "nu_choice", "estimator", "estimator_kind", "standardization",
    "plugin_status", "plugin_available"
  )
  summary_input <- transform(
    results,
    log_error_sq = ifelse(is.na(log_error), NA_real_, log_error^2),
    scaled_log_error_sq = ifelse(is.na(scaled_log_error), NA_real_, scaled_log_error^2),
    studentized_sq = ifelse(is.na(studentized), NA_real_, studentized^2),
    scaled_A_sq = ifelse(is.na(scaled_A), NA_real_, scaled_A^2),
    scaled_B_sq = ifelse(is.na(scaled_B), NA_real_, scaled_B^2),
    scaled_C_sq = ifelse(is.na(scaled_C), NA_real_, scaled_C^2),
    decomp_remainder_abs = abs(decomp_remainder)
  )
  grouped_formula <- function(lhs) {
    stats::as.formula(paste(lhs, "~", paste(group_vars, collapse = " + ")))
  }
  out <- aggregate(
    grouped_formula("cbind(
      log_error, log_error_sq, abs_log_error, covered, ci_log_length,
      scaled_log_error, scaled_log_error_sq, studentized, studentized_sq,
      scaled_A, scaled_A_sq, scaled_B, scaled_B_sq, scaled_C, scaled_C_sq,
      decomp_remainder_abs, any_negative_weight, max_abs_weight
    )"),
    data = summary_input,
    FUN = mean_na,
    na.action = na.pass
  )
  counts <- aggregate(
    grouped_formula("rep"),
    data = summary_input,
    FUN = length,
    na.action = na.pass
  )
  diagnostics <- aggregate(
    grouped_formula("cbind(valid_estimate, valid_ci, invalid_domain)"),
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
  merged$scaled_log_rmse <- sqrt(merged$scaled_log_error_sq)
  merged$studentized_sd <- sqrt(pmax(0, merged$studentized_sq - merged$studentized^2))
  merged$scaled_A_rms <- sqrt(merged$scaled_A_sq)
  merged$scaled_B_rms <- sqrt(merged$scaled_B_sq)
  merged$scaled_C_rms <- sqrt(merged$scaled_C_sq)
  merged$coverage <- merged$covered
  merged$invalid_rate <- merged$invalid_count / merged$n_replications
  merged$valid_rate <- merged$valid_replications / merged$n_replications
  merged$valid_ci_rate <- merged$valid_ci_replications / merged$n_replications
  merged$negative_weight_rate <- merged$any_negative_weight
  merged$avg_max_abs_weight <- merged$max_abs_weight
  merged
}
