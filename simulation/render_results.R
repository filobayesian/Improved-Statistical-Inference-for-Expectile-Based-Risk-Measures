#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
mode <- if ("--final" %in% args) "final" else if ("--pilot" %in% args) "pilot" else "smoke"

repo_root <- normalizePath(getwd(), mustWork = TRUE)
summary_path <- file.path(repo_root, "simulation", "results",
                          paste0("finite_sample_", mode, "_summary_latest.rds"))
if (!file.exists(summary_path)) {
  stop("Missing summary file: ", summary_path,
       ". Run simulation/run_simulation.R first.")
}

summary <- readRDS(summary_path)
fig_dir <- file.path(repo_root, "thesis", "figures", "simulation")
tab_dir <- file.path(repo_root, "thesis", "tables", "simulation")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tab_dir, recursive = TRUE, showWarnings = FALSE)

fmt <- function(x, digits = 3) {
  ifelse(is.na(x), "--", formatC(x, digits = digits, format = "f"))
}

selected <- summary[summary$k_fraction == 0.05 &
                      summary$target %in% c("intermediate", "very_extreme") &
                      summary$m == 10 &
                      summary$regime == "strong" &
                      summary$estimator %in% c("variance", "full_sample"), ]
selected <- selected[order(selected$target, selected$dgp, selected$estimator), ]

table_path <- file.path(tab_dir, "finite_sample_summary.tex")
con <- file(table_path, open = "w")
writeLines(c(
  "\\begin{tabular}{lllrrr}",
  "\\toprule",
  "Target & DGP & Estimator & Bias & MSE & Coverage \\\\",
  "\\midrule"
), con)
if (nrow(selected) == 0) {
  writeLines("No rows & -- & -- & -- & -- & -- \\\\", con)
} else {
  for (i in seq_len(nrow(selected))) {
    row <- selected[i, ]
    writeLines(sprintf(
      "%s & %s & %s & %s & %s & %s \\\\",
      gsub("_", "\\\\_", row$target), row$dgp,
      gsub("_", "\\\\_", row$estimator),
      fmt(row$bias), fmt(row$mse), fmt(row$coverage)
    ), con)
  }
}
writeLines(c("\\bottomrule", "\\end{tabular}"), con)
close(con)

validity <- summary[summary$k_fraction == 0.05 &
                      summary$target == "intermediate" &
                      summary$m == 10 &
                      summary$regime == "strong" &
                      summary$estimator %in% c("naive", "variance",
                                               "amse_oracle", "amse_plugin",
                                               "full_sample"), ]
validity <- validity[order(validity$dgp, validity$estimator), ]
valid_path <- file.path(tab_dir, "domain_validity.tex")
con <- file(valid_path, open = "w")
writeLines(c(
  "\\begin{tabular}{llrr}",
  "\\toprule",
  "DGP & Estimator & Invalid rate & Valid reps \\\\",
  "\\midrule"
), con)
if (nrow(validity) == 0) {
  writeLines("No rows & -- & -- & 0 \\\\", con)
} else {
  for (i in seq_len(nrow(validity))) {
    row <- validity[i, ]
    writeLines(sprintf(
      "%s & %s & %s & %d \\\\",
      row$dgp, gsub("_", "\\\\_", row$estimator),
      fmt(row$invalid_rate, digits = 4), as.integer(row$valid_replications)
    ), con)
  }
}
writeLines(c("\\bottomrule", "\\end{tabular}"), con)
close(con)

stability <- summary[summary$estimator %in% c("amse_oracle", "amse_plugin") &
                       summary$target == "intermediate" &
                       summary$m == 10 &
                       summary$k_fraction == 0.05, ]
stability <- stability[order(stability$dgp, stability$m, stability$regime,
                             stability$estimator), ]
stab_path <- file.path(tab_dir, "weight_stability.tex")
con <- file(stab_path, open = "w")
writeLines(c(
  "\\begin{tabular}{llrlrr}",
  "\\toprule",
  "DGP & Regime & $m$ & Estimator & Neg. rate & Avg. max $|w|$ \\\\",
  "\\midrule"
), con)
if (nrow(stability) == 0) {
  writeLines("No AMSE rows & -- & 0 & -- & -- & -- \\\\", con)
} else {
  for (i in seq_len(nrow(stability))) {
    row <- stability[i, ]
    writeLines(sprintf(
      "%s & %s & %d & %s & %s & %s \\\\",
      row$dgp, gsub("_", "\\\\_", row$regime), row$m,
      gsub("_", "\\\\_", row$estimator),
      fmt(row$negative_weight_rate), fmt(row$avg_max_abs_weight)
    ), con)
  }
}
writeLines(c("\\bottomrule", "\\end{tabular}"), con)
close(con)

if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  plot_data <- summary[summary$k_fraction == 0.05 &
                         summary$target == "intermediate", ]
  p <- ggplot(plot_data,
              aes(x = estimator, y = mse, fill = estimator_kind)) +
    geom_col(position = "dodge") +
    facet_grid(dgp ~ regime, scales = "free_y") +
    labs(x = NULL, y = "MSE of log relative error", fill = "Type") +
    theme_minimal(base_size = 9) +
    theme(axis.text.x = element_text(angle = 35, hjust = 1),
          legend.position = "bottom")
  ggsave(file.path(fig_dir, "mse_by_estimator.pdf"), p,
         width = 7.2, height = 5.2)

  sens <- summary[summary$target == "intermediate" &
                    summary$regime == "strong", ]
  p2 <- ggplot(sens, aes(x = k_fraction, y = mse, color = estimator)) +
    geom_point(size = 1.2) +
    facet_wrap(~ dgp, scales = "free_y") +
    labs(x = "$k/n$", y = "MSE of log relative error", color = "Estimator") +
    theme_minimal(base_size = 9) +
    theme(legend.position = "bottom")
  if (length(unique(sens$k_fraction)) > 1) {
    p2 <- p2 + geom_line()
  }
  ggsave(file.path(fig_dir, "k_sensitivity.pdf"), p2,
         width = 7.2, height = 4.4)
}

message("Wrote tables to ", tab_dir)
message("Wrote figures to ", fig_dir)
