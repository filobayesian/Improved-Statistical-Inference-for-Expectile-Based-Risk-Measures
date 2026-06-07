#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
mode <- "smoke"
if ("--pilot" %in% args) mode <- "pilot"
if ("--final" %in% args) mode <- "final"
if ("--smoke" %in% args) mode <- "smoke"

cores_arg <- grep("^--cores=", args, value = TRUE)
requested_cores <- if (length(cores_arg) == 1) {
  as.integer(sub("^--cores=", "", cores_arg))
} else {
  NA_integer_
}

cmd_args <- commandArgs(FALSE)
file_arg <- grep("^--file=", cmd_args, value = TRUE)
script_path <- if (length(file_arg) == 1) {
  sub("^--file=", "", file_arg)
} else {
  "simulation/run_interval_diagnostics.R"
}
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
if (!file.exists(file.path(repo_root, "simulation", "R", "sim_functions.R"))) {
  repo_root <- normalizePath(getwd(), mustWork = TRUE)
}

local_lib <- file.path(repo_root, "simulation", "Rlib")
if (dir.exists(local_lib)) {
  .libPaths(c(normalizePath(local_lib, mustWork = TRUE), .libPaths()))
}

source(file.path(repo_root, "simulation", "R", "sim_functions.R"))
ensure_extremerisks()

diagnostic_grid <- function(mode) {
  if (mode == "smoke") {
    return(data.frame(
      dgp = "burr_heavy", n_total = 2500, k_rule = "fraction",
      k_fraction = 0.05, k_power = NA_real_, design_role = "diagnostic",
      stringsAsFactors = FALSE
    ))
  }

  dgp_names <- c(
    "pareto_light", "pareto_heavy", "burr_light", "burr_heavy", "student3"
  )
  designs <- data.frame(
    n_total = c(10000, 100000),
    k_rule = c("fraction", "power"),
    k_fraction = c(0.05, NA_real_),
    k_power = c(NA_real_, 0.45),
    design_role = "diagnostic",
    stringsAsFactors = FALSE
  )
  if (mode == "pilot") {
    dgp_names <- c("pareto_light", "burr_heavy", "student3")
    designs <- designs[1, , drop = FALSE]
  }
  merge(
    data.frame(dgp = dgp_names, stringsAsFactors = FALSE),
    designs
  )
}

cover_log_target <- function(ci, target) {
  if (!all(is.finite(ci)) || !is.finite(target) || target <= 0) {
    return(NA_integer_)
  }
  as.integer(log(target) >= ci[1] && log(target) <= ci[2])
}

run_one_diagnostic <- function(scenario, rep_id, alpha = 0.05) {
  dgp <- make_dgp(scenario$dgp)
  k_rule <- as.character(scenario_value(scenario, "k_rule", "fraction"))
  k_fraction_design <- suppressWarnings(as.numeric(
    scenario_value(scenario, "k_fraction", NA_real_)
  ))
  k_power <- suppressWarnings(as.numeric(
    scenario_value(scenario, "k_power", NA_real_)
  ))
  sizes <- scenario_sizes(
    m = 10, regime = "strong",
    n_total = scenario$n_total,
    k_fraction = k_fraction_design,
    k_rule = k_rule,
    k_power = k_power
  )
  n_vec <- sizes$n_vec
  k_vec <- sizes$k_vec
  n_total <- sum(n_vec)
  k_total <- sum(k_vec)
  np_target <- 5
  p <- np_target / n_total
  tau <- 1 - p
  ell <- log(k_total / (n_total * p))
  scale <- sqrt(k_total) / ell
  k_fraction_actual <- k_total / n_total
  k_design <- if (k_rule == "power") {
    paste0("n^", format(k_power, trim = TRUE, scientific = FALSE))
  } else {
    paste0("fraction=", format(k_fraction_design, trim = TRUE, scientific = FALSE))
  }

  samples <- lapply(n_vec, dgp$r)
  prim <- local_primitives(samples, k_vec, p)
  nu <- variance_weights(k_vec)
  omega <- variance_weights(k_vec)
  pooled <- pooled_expectile(prim$gamma_hat, prim$q_hat, nu, omega)

  exact_target <- expectile_truth_cached(dgp, tau)
  q_target <- dgp$quantile(tau)
  bridge_target <- psi_fn(dgp$gamma) * q_target
  eta <- if (is.finite(q_target) && q_target > 0 &&
             is.finite(ell) && ell > 0) {
    sqrt(k_total) / (ell * q_target)
  } else {
    NA_real_
  }
  bridge_log_gap <- if (is.finite(exact_target) && exact_target > 0 &&
                        is.finite(bridge_target) && bridge_target > 0) {
    log(exact_target / bridge_target)
  } else {
    NA_real_
  }

  oracle <- dps_objects(dgp$gamma, dgp$rho, dgp$beta, n_vec, k_vec)
  plugin_second <- if (plugin_source_eligible(dgp)) {
    plugin_second_order(samples, n_vec)
  } else {
    NULL
  }
  plugin <- plugin_dps_objects(
    samples, n_vec, k_vec, prim$gamma_hat, nu, plugin_second, dgp
  )
  objects <- list(oracle = oracle, plugin = plugin)

  rows <- list()
  for (kind in names(objects)) {
    obj <- objects[[kind]]
    if (is.null(obj) || !is.finite(pooled$estimate) || pooled$estimate <= 0) {
      B_hat <- V_hat <- NA_real_
      ci <- c(NA_real_, NA_real_)
    } else {
      B_hat <- sum(omega * obj$Bc)
      V_hat <- as.numeric(t(omega) %*% obj$Vc %*% omega)
      ci <- log_ci(pooled$estimate, ell, k_total, B_hat, V_hat, alpha)
    }

    log_error_exact <- if (is.finite(pooled$estimate) && pooled$estimate > 0 &&
                           is.finite(exact_target) && exact_target > 0) {
      log(pooled$estimate / exact_target)
    } else {
      NA_real_
    }
    log_error_bridge <- if (is.finite(pooled$estimate) && pooled$estimate > 0 &&
                            is.finite(bridge_target) && bridge_target > 0) {
      log(pooled$estimate / bridge_target)
    } else {
      NA_real_
    }
    z_exact <- if (is.finite(log_error_exact) &&
                   is.finite(B_hat) && is.finite(V_hat) && V_hat > 0) {
      (scale * log_error_exact - B_hat) / sqrt(V_hat)
    } else {
      NA_real_
    }
    z_bridge <- if (is.finite(log_error_bridge) &&
                    is.finite(B_hat) && is.finite(V_hat) && V_hat > 0) {
      (scale * log_error_bridge - B_hat) / sqrt(V_hat)
    } else {
      NA_real_
    }

    rows[[length(rows) + 1]] <- data.frame(
      rep = rep_id,
      design_version = SIMULATION_DESIGN_VERSION,
      design_role = as.character(scenario_value(scenario, "design_role", "diagnostic")),
      dgp = dgp$name,
      dgp_key = dgp$key,
      n_total = n_total,
      k_total = k_total,
      k_rule = k_rule,
      k_design = k_design,
      k_fraction = k_fraction_actual,
      k_power = if (is.finite(k_power)) k_power else NA_real_,
      np_target = np_target,
      ell = ell,
      sqrtk_over_ell = sqrt(k_total) / ell,
      eta = eta,
      kind = kind,
      plugin_status = if (kind == "plugin") {
        plugin_status(dgp, plugin_second, plugin)
      } else {
        "not_used"
      },
      B = B_hat,
      V = V_hat,
      log_error_exact = log_error_exact,
      log_error_bridge = log_error_bridge,
      z_exact = z_exact,
      z_bridge = z_bridge,
      cover_exact = cover_log_target(ci, exact_target),
      cover_bridge = cover_log_target(ci, bridge_target),
      bridge_log_gap = bridge_log_gap,
      stringsAsFactors = FALSE
    )
  }

  do.call(rbind, rows)
}

summarise_diagnostics <- function(results) {
  mean_na <- function(x) {
    if (all(is.na(x))) return(NA_real_)
    mean(x, na.rm = TRUE)
  }
  aggregate(
    cbind(
      B, V, log_error_exact, log_error_bridge, z_exact, z_bridge,
      cover_exact, cover_bridge, bridge_log_gap
    ) ~ design_version + design_role + dgp + dgp_key + n_total + k_total +
      k_rule + k_design + k_fraction + np_target + ell + sqrtk_over_ell +
      eta + kind + plugin_status,
    data = results,
    FUN = mean_na,
    na.action = na.pass
  )
}

seed <- 20260607
set.seed(seed)

nrep <- switch(mode, smoke = 10, pilot = 300, final = 1500)
grid <- diagnostic_grid(mode)
cores <- if (is.finite(requested_cores) && requested_cores > 0) {
  requested_cores
} else if (mode == "final") {
  detected_cores <- parallel::detectCores(logical = TRUE)
  if (!is.finite(detected_cores) || detected_cores < 2) {
    1
  } else {
    max(1, min(8, detected_cores - 1))
  }
} else {
  1
}

message("Running ", mode, " interval diagnostics with ", nrow(grid),
        " scenarios and ", nrep, " replications per scenario.")
message("Using ", cores, " worker(s).")

all_rows <- vector("list", nrow(grid))
for (s in seq_len(nrow(grid))) {
  scenario <- grid[s, ]
  message(
    "Diagnostic scenario ", s, "/", nrow(grid), ": ",
    paste(names(scenario), unlist(scenario), sep = "=", collapse = ", ")
  )
  worker <- function(r) {
    set.seed(seed + 100000 * s + r)
    run_one_diagnostic(scenario, r)
  }
  scenario_rows <- if (cores > 1) {
    parallel::mclapply(seq_len(nrep), worker, mc.cores = cores)
  } else {
    lapply(seq_len(nrep), worker)
  }
  all_rows[[s]] <- do.call(rbind, scenario_rows)
}

results <- do.call(rbind, all_rows)
summary <- summarise_diagnostics(results)

out_dir <- file.path(repo_root, "simulation", "results")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
stamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
raw_path <- file.path(out_dir, paste0("interval_diagnostics_", mode, "_raw_", stamp, ".rds"))
sum_path <- file.path(out_dir, paste0("interval_diagnostics_", mode, "_summary_", stamp, ".rds"))
latest_raw <- file.path(out_dir, paste0("interval_diagnostics_", mode, "_raw_latest.rds"))
latest_sum <- file.path(out_dir, paste0("interval_diagnostics_", mode, "_summary_latest.rds"))
saveRDS(results, raw_path)
saveRDS(summary, sum_path)
saveRDS(results, latest_raw)
saveRDS(summary, latest_sum)

message("Wrote raw diagnostics to ", raw_path)
message("Wrote diagnostic summary to ", sum_path)
