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
script_path <- if (length(file_arg) == 1) sub("^--file=", "", file_arg) else "simulation/run_simulation.R"
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
if (!file.exists(file.path(repo_root, "simulation", "R", "sim_functions.R"))) {
  repo_root <- normalizePath(getwd(), mustWork = TRUE)
}
source(file.path(repo_root, "simulation", "R", "sim_functions.R"))

seed <- 20260602
set.seed(seed)

nrep <- switch(mode, smoke = 10, pilot = 300, final = 5000)
grid <- scenario_grid(mode)
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

message("Running ", mode, " simulation with ", nrow(grid),
        " scenarios and ", nrep, " replications per scenario.")
message("Using ", cores, " worker(s).")
if (!requireNamespace("evt0", quietly = TRUE)) {
  message("Package evt0 is not installed; feasible plug-in AMSE rows will be skipped.")
}

all_rows <- vector("list", nrow(grid))
for (s in seq_len(nrow(grid))) {
  scenario <- grid[s, ]
  message("Scenario ", s, "/", nrow(grid), ": ",
          paste(names(scenario), unlist(scenario), sep = "=", collapse = ", "))
  worker <- function(r) {
    set.seed(seed + 100000 * s + r)
    run_one_replication(scenario, r)
  }
  scenario_rows <- if (cores > 1) {
    parallel::mclapply(seq_len(nrep), worker, mc.cores = cores)
  } else {
    lapply(seq_len(nrep), worker)
  }
  all_rows[[s]] <- do.call(rbind, scenario_rows)
}

results <- do.call(rbind, all_rows)
summary <- summarise_results(results)
summary$bias <- summary$log_error
summary$mse <- summary$log_error_sq
summary$variance <- pmax(summary$mse - summary$bias^2, 0)
summary$coverage <- summary$covered
summary$negative_weight_rate <- summary$any_negative_weight
summary$avg_max_abs_weight <- summary$max_abs_weight
summary$valid_rate <- summary$valid_replications / summary$n_replications
summary$valid_ci_rate <- summary$valid_ci_replications / summary$n_replications

out_dir <- file.path(repo_root, "simulation", "results")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
stamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
raw_path <- file.path(out_dir, paste0("finite_sample_", mode, "_raw_", stamp, ".rds"))
sum_path <- file.path(out_dir, paste0("finite_sample_", mode, "_summary_", stamp, ".rds"))
latest_raw <- file.path(out_dir, paste0("finite_sample_", mode, "_raw_latest.rds"))
latest_sum <- file.path(out_dir, paste0("finite_sample_", mode, "_summary_latest.rds"))
saveRDS(results, raw_path)
saveRDS(summary, sum_path)
saveRDS(results, latest_raw)
saveRDS(summary, latest_sum)

message("Wrote raw results to ", raw_path)
message("Wrote summary results to ", sum_path)
