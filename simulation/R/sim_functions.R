# Utilities for the finite-sample study in Chapter 5.
#
# The implementation is deliberately self-contained. ExtremeRisks and evt0 are
# used only through optional hooks because they are not guaranteed to be
# installed on every machine that compiles the thesis.

valid_gamma_domain <- function(gamma) {
  is.finite(gamma) & gamma > 0 & gamma < 1
}

psi_fn <- function(gamma) {
  out <- rep(NA_real_, length(gamma))
  ok <- valid_gamma_domain(gamma)
  out[ok] <- ((1 / gamma[ok]) - 1)^(-gamma[ok])
  out
}

m_fn <- function(gamma) {
  out <- rep(NA_real_, length(gamma))
  ok <- valid_gamma_domain(gamma)
  out[ok] <- 1 / (1 - gamma[ok]) - log((1 / gamma[ok]) - 1)
  out
}

c_gamma_rho <- function(gamma, rho) {
  if (abs(rho) < 1e-10) {
    stop("rho = 0 is not used in the finite-sample DGP grid")
  }
  a <- (1 / gamma) - 1
  a^(-rho) / (1 - gamma - rho) + (a^(-rho) - 1) / rho
}

psi_rho <- function(y, rho) {
  if (abs(rho) < 1e-10) log(y) else (y^rho - 1) / rho
}

normalize_weights <- function(w) {
  s <- sum(w)
  if (!is.finite(s) || abs(s) < 1e-12) {
    return(rep(NA_real_, length(w)))
  }
  w / s
}

safe_solve <- function(a, b) {
  tryCatch(solve(a, b), error = function(e) NULL)
}

student_tail_beta <- function(df) {
  c_t <- gamma((df + 1) / 2) / (sqrt(df * pi) * gamma(df / 2))
  tail_const <- 2 * c_t * df^((df - 1) / 2)
  d_const <- df^2 * (df + 1) / (2 * (df + 2))
  df * (df + 1) / (df + 2) * tail_const^(-2 / df)
}

make_dgp <- function(name) {
  switch(
    name,
    pareto = {
      gamma <- 0.25
      list(
        name = "Pareto", key = "pareto", gamma = gamma, rho = -1, beta = 0,
        r = function(n) stats::runif(n)^(-gamma),
        cdf = function(x) ifelse(x < 1, 0, 1 - x^(-1 / gamma)),
        surv = function(x) ifelse(x < 1, 1, x^(-1 / gamma)),
        quantile = function(tau) (1 - tau)^(-gamma)
      )
    },
    pareto_heavy = {
      gamma <- 0.60
      list(
        name = "ParetoHeavy", key = "pareto_heavy", gamma = gamma, rho = -1,
        beta = 0,
        r = function(n) stats::runif(n)^(-gamma),
        cdf = function(x) ifelse(x < 1, 0, 1 - x^(-1 / gamma)),
        surv = function(x) ifelse(x < 1, 1, x^(-1 / gamma)),
        quantile = function(tau) (1 - tau)^(-gamma)
      )
    },
    frechet = {
      gamma <- 0.25
      list(
        name = "Frechet", key = "frechet", gamma = gamma, rho = -1, beta = 0.5,
        r = function(n) (-log(stats::runif(n)))^(-gamma),
        cdf = function(x) ifelse(x <= 0, 0, exp(-x^(-1 / gamma))),
        surv = function(x) ifelse(x <= 0, 1, 1 - exp(-x^(-1 / gamma))),
        quantile = function(tau) (-log(tau))^(-gamma)
      )
    },
    burr = {
      gamma <- 0.25
      rho <- -1
      list(
        name = "Burr", key = "burr", gamma = gamma, rho = rho, beta = 1,
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
        name = "BurrHeavy", key = "burr_heavy", gamma = gamma, rho = rho,
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
    student = {
      df <- 3
      gamma <- 1 / df
      list(
        name = "AbsStudent3", key = "student", gamma = gamma, rho = -2 / df,
        beta = student_tail_beta(df), df = df,
        r = function(n) abs(stats::rt(n, df = df)),
        cdf = function(x) ifelse(x <= 0, 0, 2 * stats::pt(x, df = df) - 1),
        surv = function(x) ifelse(x <= 0, 1, 2 * stats::pt(-x, df = df)),
        quantile = function(tau) stats::qt((tau + 1) / 2, df = df)
      )
    },
    stop("Unknown DGP: ", name)
  )
}

tail_auxiliary <- function(dgp, t) {
  dgp$gamma * dgp$beta * t^dgp$rho
}

expectile_truth <- function(dgp, tau) {
  f <- function(x) {
    upper <- stats::integrate(dgp$surv, lower = x, upper = Inf,
                              rel.tol = 1e-8, subdivisions = 500)$value
    lower <- if (x <= 0) 0 else stats::integrate(dgp$cdf, lower = 0, upper = x,
                                                 rel.tol = 1e-8,
                                                 subdivisions = 500)$value
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

hill_estimator <- function(x, k) {
  x <- sort(x)
  n <- length(x)
  if (k < 1 || k >= n) return(NA_real_)
  threshold <- x[n - k]
  mean(log(x[(n - k + 1):n]) - log(threshold))
}

weissman_quantile <- function(x, k, tau, gamma_hat = NULL) {
  x <- sort(x)
  n <- length(x)
  if (k < 1 || k >= n) return(NA_real_)
  if (is.null(gamma_hat)) gamma_hat <- hill_estimator(x, k)
  threshold <- x[n - k]
  (k / (n * (1 - tau)))^gamma_hat * threshold
}

local_primitives <- function(samples, k_vec, tau) {
  m <- length(samples)
  gamma_hat <- q_hat <- numeric(m)
  for (j in seq_len(m)) {
    gamma_hat[j] <- hill_estimator(samples[[j]], k_vec[j])
    q_hat[j] <- weissman_quantile(samples[[j]], k_vec[j], tau, gamma_hat[j])
  }
  list(gamma_hat = gamma_hat, q_hat = q_hat)
}

pooled_qb_expectile <- function(gamma_hat, q_hat, w_gamma, w_q) {
  gamma_pool <- sum(w_gamma * gamma_hat)
  if (!valid_gamma_domain(gamma_pool) || any(!is.finite(q_hat)) ||
      any(q_hat <= 0)) {
    return(NA_real_)
  }
  q_pool <- exp(sum(w_q * log(q_hat)))
  if (!is.finite(q_pool) || q_pool <= 0) return(NA_real_)
  psi_fn(gamma_pool) * q_pool
}

oracle_bias_inputs <- function(dgp, n_vec, k_vec, tau) {
  m <- length(n_vec)
  k_total <- sum(k_vec)
  c_vec <- k_vec[1] / k_vec
  s_const <- sum(1 / c_vec)
  lambda <- sqrt(k_vec) * tail_auxiliary(dgp, n_vec / k_vec)
  l_vec <- log(k_vec / (n_vec * (1 - tau)))
  v_c <- diag(dgp$gamma^2 * k_total / k_vec, nrow = m)
  b_c <- sqrt(c_vec * s_const) * lambda / (1 - dgp$rho)
  b_c_star <- sqrt(c_vec * s_const) * lambda *
    (l_vec / (1 - dgp$rho) - psi_rho(exp(l_vec), dgp$rho))
  lambda_bullet <- sqrt(k_total) * tail_auxiliary(dgp, 1 / (1 - tau))
  b_gap <- -c_gamma_rho(dgp$gamma, dgp$rho) * lambda_bullet
  list(Vc = v_c, Bc = b_c, Bcstar = b_c_star, L = l_vec, b_gap = b_gap)
}

variance_weights <- function(k_vec) {
  k_vec / sum(k_vec)
}

intermediate_amse_weights <- function(gamma, Vc, L, Bc, Bcstar, b_gap) {
  m <- length(L)
  mg <- m_fn(gamma)
  if (!is.finite(mg)) return(NULL)
  D <- diag(L, nrow = m)
  h <- c(mg * Bc, Bcstar)
  Q <- rbind(
    cbind(mg^2 * Vc, mg * D %*% Vc),
    cbind(mg * D %*% Vc, Vc + D %*% D %*% Vc)
  )
  M <- Q + tcrossprod(h)
  A <- cbind(c(rep(1, m), rep(0, m)), c(rep(0, m), rep(1, m)))
  MinvA <- safe_solve(M, A)
  Minvh <- safe_solve(M, h)
  if (is.null(MinvA) || is.null(Minvh)) return(NULL)
  middle <- safe_solve(t(A) %*% MinvA, rep(1, 2) + b_gap * (t(A) %*% Minvh))
  if (is.null(middle)) return(NULL)
  w <- MinvA %*% middle - b_gap * Minvh
  w <- as.numeric(w)
  list(w_gamma = w[seq_len(m)], w_q = w[m + seq_len(m)])
}

extreme_amse_weights <- function(Vc, Bc) {
  vinv1 <- safe_solve(Vc, rep(1, length(Bc)))
  vinvb <- safe_solve(Vc, Bc)
  if (is.null(vinv1) || is.null(vinvb)) return(NULL)
  bt_vinv_b <- as.numeric(t(Bc) %*% vinvb)
  one_vinv_b <- sum(vinvb)
  one_vinv_one <- sum(vinv1)
  den <- (1 + bt_vinv_b) * one_vinv_one - one_vinv_b^2
  if (!is.finite(den) || abs(den) < 1e-12) return(NULL)
  w <- ((1 + bt_vinv_b) * vinv1 - one_vinv_b * vinvb) / den
  as.numeric(w)
}

estimate_second_order_evt0 <- function(x) {
  if (!requireNamespace("evt0", quietly = TRUE)) return(NULL)
  rho_fun <- tryCatch(getExportedValue("evt0", "mop.rho"), error = function(e) NULL)
  beta_fun <- tryCatch(getExportedValue("evt0", "mop.beta"), error = function(e) NULL)
  if (is.null(rho_fun) || is.null(beta_fun)) return(NULL)
  osx <- sort(x)
  losx <- log(osx)
  rho_raw <- tryCatch(rho_fun(osx), error = function(e) NULL)
  rho <- suppressWarnings(tail(as.numeric(rho_raw), 1))
  if (!is.finite(rho) || rho >= 0) return(NULL)
  beta_raw <- tryCatch(beta_fun(losx, rho), error = function(e) NULL)
  beta <- suppressWarnings(tail(as.numeric(beta_raw), 1))
  if (!is.finite(rho) || !is.finite(beta) || rho >= 0) return(NULL)
  list(rho = rho, beta = beta)
}

plugin_bias_inputs <- function(samples, n_vec, k_vec, tau, gamma_hat) {
  second <- lapply(samples, estimate_second_order_evt0)
  if (any(vapply(second, is.null, logical(1)))) return(NULL)
  rho_hat <- sum((n_vec / sum(n_vec)) * vapply(second, `[[`, numeric(1), "rho"))
  beta_hat <- sum((n_vec / sum(n_vec)) * vapply(second, `[[`, numeric(1), "beta"))
  if (!is.finite(rho_hat) || !is.finite(beta_hat) || rho_hat >= 0) return(NULL)
  gamma_bar <- mean(gamma_hat)
  if (!valid_gamma_domain(gamma_bar)) return(NULL)
  dgp_hat <- list(gamma = gamma_bar, rho = rho_hat, beta = beta_hat)
  oracle_bias_inputs(dgp_hat, n_vec, k_vec, tau)
}

sigma2_intermediate <- function(gamma, Vc, L, w_gamma, w_q) {
  mg <- m_fn(gamma)
  if (!is.finite(mg)) return(NA_real_)
  D <- diag(L, nrow = length(L))
  as.numeric(mg^2 * t(w_gamma) %*% Vc %*% w_gamma +
               2 * mg * t(w_gamma) %*% D %*% Vc %*% w_q +
               t(w_q) %*% (Vc + D %*% D %*% Vc) %*% w_q)
}

sigma2_extreme <- function(Vc, w_gamma) {
  as.numeric(t(w_gamma) %*% Vc %*% w_gamma)
}

ci_log <- function(est, se_log, alpha = 0.05) {
  if (!is.finite(est) || est <= 0 || !is.finite(se_log)) {
    return(c(NA_real_, NA_real_))
  }
  z <- stats::qnorm(1 - alpha / 2)
  c(log(est) - z * se_log, log(est) + z * se_log)
}

allocation_weights <- function(m, regime) {
  if (regime == "balanced") return(rep(1 / m, m))
  if (regime == "moderate") return(normalize_weights(seq(1, 2, length.out = m)))
  if (regime %in% c("strong", "strong_equal_k")) {
    return(normalize_weights(exp(seq(0, log(10), length.out = m))))
  }
  stop("Unknown regime: ", regime)
}

scenario_grid <- function(mode) {
  dgp_names <- c("pareto", "frechet", "burr", "student",
                 "pareto_heavy", "burr_heavy")
  if (mode == "smoke") {
    return(data.frame(dgp = "burr_heavy", m = 5, regime = "strong",
                      k_fraction = 0.05, n_total = 3000,
                      stringsAsFactors = FALSE))
  }
  if (mode == "pilot") {
    return(expand.grid(
      dgp = c("pareto", "burr", "pareto_heavy"),
      m = c(5, 10),
      regime = c("balanced", "strong"),
      k_fraction = 0.05,
      n_total = 5000,
      stringsAsFactors = FALSE
    ))
  }
  main <- expand.grid(
    dgp = dgp_names,
    m = c(5, 10, 20),
    regime = c("balanced", "moderate", "strong"),
    k_fraction = 0.05,
    n_total = 10000,
    stringsAsFactors = FALSE
  )
  sensitivity <- expand.grid(
    dgp = dgp_names,
    m = 10,
    regime = "strong",
    k_fraction = c(0.02, 0.05, 0.10, 0.15),
    n_total = 10000,
    stringsAsFactors = FALSE
  )
  stress <- expand.grid(
    dgp = dgp_names,
    m = 10,
    regime = "strong_equal_k",
    k_fraction = 0.05,
    n_total = 10000,
    stringsAsFactors = FALSE
  )
  unique(rbind(main, sensitivity, stress))
}

scenario_sizes <- function(m, regime, n_total, k_fraction) {
  w <- allocation_weights(m, regime)
  n_vec <- floor(n_total * w)
  n_vec[length(n_vec)] <- n_vec[length(n_vec)] + n_total - sum(n_vec)
  if (regime == "strong_equal_k") {
    k_base <- max(5, floor(k_fraction * n_total / m))
    k_vec <- rep(k_base, m)
    k_vec <- pmin(k_vec, n_vec - 2)
  } else {
    k_vec <- pmax(5, floor(k_fraction * n_vec))
  }
  list(n_vec = n_vec, k_vec = k_vec)
}

run_one_replication <- function(scenario, rep_id, tau = 0.99, alpha = 0.05) {
  dgp <- make_dgp(scenario$dgp)
  sizes <- scenario_sizes(scenario$m, scenario$regime,
                          scenario$n_total, scenario$k_fraction)
  n_vec <- sizes$n_vec
  k_vec <- sizes$k_vec
  n_total <- sum(n_vec)
  k_total <- sum(k_vec)
  tau_ext <- 1 - 1 / n_total
  samples <- lapply(n_vec, dgp$r)
  combined <- unlist(samples, use.names = FALSE)
  prim <- local_primitives(samples, k_vec, tau)
  gamma_seed <- sum(variance_weights(k_vec) * prim$gamma_hat)
  truth_int <- expectile_truth_cached(dgp, tau)
  truth_ext <- expectile_truth_cached(dgp, tau_ext)
  oracle <- oracle_bias_inputs(dgp, n_vec, k_vec, tau)
  Vc_hat <- diag(gamma_seed^2 * k_total / k_vec, nrow = length(k_vec))
  L <- oracle$L

  estimators <- list(
    naive = list(w_gamma = rep(1 / scenario$m, scenario$m),
                 w_q = rep(1 / scenario$m, scenario$m),
                 kind = "feasible"),
    variance = list(w_gamma = variance_weights(k_vec),
                    w_q = variance_weights(k_vec),
                    kind = "feasible")
  )

  oracle_int <- intermediate_amse_weights(dgp$gamma, oracle$Vc, oracle$L,
                                          oracle$Bc, oracle$Bcstar,
                                          oracle$b_gap)
  if (!is.null(oracle_int)) {
    estimators$amse_oracle <- c(oracle_int, list(kind = "oracle"))
  }

  plugin <- plugin_bias_inputs(samples, n_vec, k_vec, tau, prim$gamma_hat)
  if (!is.null(plugin)) {
    plugin_int <- intermediate_amse_weights(gamma_seed, Vc_hat, plugin$L,
                                            plugin$Bc, plugin$Bcstar,
                                            plugin$b_gap)
    if (!is.null(plugin_int)) {
      estimators$amse_plugin <- c(plugin_int, list(kind = "feasible"))
    }
  }

  rows <- list()
  add_row <- function(estimator, target, xi_hat, truth, gamma_est, w_gamma, w_q,
                      sigma2, ell = 1, kind = "feasible") {
    domain_ok <- valid_gamma_domain(gamma_est)
    estimate_ok <- domain_ok && is.finite(xi_hat) && xi_hat > 0 &&
      is.finite(truth) && truth > 0
    se_log <- if (is.finite(sigma2) && sigma2 >= 0) {
      ell * sqrt(sigma2 / k_total)
    } else {
      NA_real_
    }
    ci <- ci_log(xi_hat, se_log, alpha)
    ci_ok <- estimate_ok && all(is.finite(ci))
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
      estimator = estimator,
      estimator_kind = kind,
      target = target,
      gamma_estimate = gamma_est,
      estimate = if (estimate_ok) xi_hat else NA_real_,
      truth = truth,
      log_error = if (estimate_ok) log(xi_hat / truth) else NA_real_,
      covered = if (ci_ok) {
        as.integer(log(truth) >= ci[1] && log(truth) <= ci[2])
      } else {
        NA_integer_
      },
      ci_log_length = if (ci_ok) ci[2] - ci[1] else NA_real_,
      ci_length = if (ci_ok) exp(ci[2]) - exp(ci[1]) else NA_real_,
      invalid_domain = as.integer(!domain_ok),
      valid_estimate = as.integer(estimate_ok),
      valid_ci = as.integer(ci_ok),
      any_negative_weight = as.integer(any(c(w_gamma, w_q) < 0)),
      max_abs_weight = max(abs(c(w_gamma, w_q))),
      plugin_available = requireNamespace("evt0", quietly = TRUE),
      stringsAsFactors = FALSE
    )
  }

  for (name in names(estimators)) {
    est <- estimators[[name]]
    xi_int <- pooled_qb_expectile(prim$gamma_hat, prim$q_hat,
                                  est$w_gamma, est$w_q)
    gamma_pool <- sum(est$w_gamma * prim$gamma_hat)
    xi_ext <- if (valid_gamma_domain(gamma_pool) && is.finite(xi_int) &&
                  xi_int > 0) {
      ((1 - tau) / (1 - tau_ext))^gamma_pool * xi_int
    } else {
      NA_real_
    }
    sig_int <- sigma2_intermediate(gamma_seed, Vc_hat, L,
                                   est$w_gamma, est$w_q)
    sig_ext <- sigma2_extreme(Vc_hat, est$w_gamma)
    ell <- log((1 - tau) / (1 - tau_ext))
    add_row(name, "intermediate", xi_int, truth_int, gamma_pool,
            est$w_gamma, est$w_q, sig_int, kind = est$kind)
    add_row(name, "very_extreme", xi_ext, truth_ext, gamma_pool,
            est$w_gamma, est$w_q, sig_ext, ell = ell, kind = est$kind)
  }

  gamma_full <- hill_estimator(combined, k_total)
  q_full <- weissman_quantile(combined, k_total, tau, gamma_full)
  xi_full_int <- if (valid_gamma_domain(gamma_full) && is.finite(q_full) &&
                     q_full > 0) {
    psi_fn(gamma_full) * q_full
  } else {
    NA_real_
  }
  xi_full_ext <- if (valid_gamma_domain(gamma_full) && is.finite(xi_full_int) &&
                     xi_full_int > 0) {
    ((1 - tau) / (1 - tau_ext))^gamma_full * xi_full_int
  } else {
    NA_real_
  }
  L_full <- log(k_total / (n_total * (1 - tau)))
  V_full <- matrix(gamma_full^2, 1, 1)
  sig_full_int <- sigma2_intermediate(gamma_full, V_full, L_full, 1, 1)
  sig_full_ext <- gamma_full^2
  add_row("full_sample", "intermediate", xi_full_int, truth_int,
          gamma_full, 1, 1, sig_full_int, kind = "benchmark")
  add_row("full_sample", "very_extreme", xi_full_ext, truth_ext,
          gamma_full, 1, 1, sig_full_ext, ell = log((1 - tau) / (1 - tau_ext)),
          kind = "benchmark")

  do.call(rbind, rows)
}

summarise_results <- function(results) {
  mean_na <- function(x) {
    if (all(is.na(x))) return(NA_real_)
    mean(x, na.rm = TRUE)
  }
  sum_na <- function(x) sum(x, na.rm = TRUE)
  group_vars <- c("dgp", "gamma", "m", "regime", "k_fraction", "n_total",
                  "k_total", "estimator", "estimator_kind", "target",
                  "plugin_available")
  summary_input <- transform(
    results,
    log_error_sq = ifelse(is.na(log_error), NA_real_, log_error^2)
  )
  out <- aggregate(
    cbind(log_error, log_error_sq = log_error^2, covered, ci_log_length,
          ci_length, any_negative_weight, max_abs_weight) ~
      dgp + gamma + m + regime + k_fraction + n_total + k_total +
      estimator + estimator_kind + target + plugin_available,
    data = summary_input,
    FUN = mean_na,
    na.action = na.pass
  )
  counts <- aggregate(
    rep ~ dgp + gamma + m + regime + k_fraction + n_total + k_total +
      estimator + estimator_kind + target + plugin_available,
    data = summary_input,
    FUN = length,
    na.action = na.pass
  )
  diagnostics <- aggregate(
    cbind(valid_estimate, valid_ci, invalid_domain) ~
      dgp + gamma + m + regime + k_fraction + n_total + k_total +
      estimator + estimator_kind + target + plugin_available,
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
  merged$invalid_rate <- merged$invalid_count / merged$n_replications
  merged
}
