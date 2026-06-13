#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
mode <- if ("--final" %in% args) {
  "final"
} else if ("--pilot" %in% args) {
  "pilot"
} else {
  "smoke"
}
artifact_arg <- grep("^--artifact-root=", args, value = TRUE)
artifact_root <- if (length(artifact_arg) == 1) {
  normalizePath(sub("^--artifact-root=", "", artifact_arg), mustWork = FALSE)
} else {
  NA_character_
}

repo_root <- normalizePath(getwd(), mustWork = TRUE)
if (!file.exists(file.path(repo_root, "simulation", "run_simulation.R"))) {
  repo_root <- normalizePath(file.path(repo_root, ".."), mustWork = TRUE)
}

local_lib <- file.path(repo_root, "simulation", "Rlib")
if (dir.exists(local_lib)) {
  .libPaths(c(normalizePath(local_lib, mustWork = TRUE), .libPaths()))
}
source(file.path(repo_root, "simulation", "R", "sim_functions.R"))

summary_path <- file.path(
  repo_root, "simulation", "results",
  paste0("finite_sample_", mode, "_summary_latest.rds")
)
if (!file.exists(summary_path)) {
  stop("Missing summary file: ", summary_path,
       ". Run simulation/run_simulation.R first.", call. = FALSE)
}

summary <- readRDS(summary_path)
required_cols <- c(
  "design_version", "design_role", "k_rule", "k_design", "k_fraction",
  "k_profile", "ell", "sqrtk_over_ell", "eta", "bridge_log_gap", "nu_choice",
  "standardization", "plugin_status", "scaled_log_rmse", "studentized_sd",
  "scaled_A_rms", "scaled_B_rms", "scaled_C_rms", "decomp_remainder_abs",
  "log_bias_mcse", "log_rmse_mcse", "valid_rate_mcse",
  "coverage_mcse", "ci_log_length_mcse", "valid_ci_rate_mcse",
  "scaled_log_rmse_mcse", "scaled_A_rms_mcse", "scaled_B_rms_mcse",
  "scaled_C_rms_mcse", "decomp_remainder_abs_mcse",
  "negative_weight_rate_mcse", "avg_max_abs_weight_mcse"
)
missing_cols <- setdiff(required_cols, names(summary))
if (length(missing_cols) > 0) {
  stop(
    "Summary file is stale for the current two-weight simulation design. ",
    "Missing columns: ", paste(missing_cols, collapse = ", "),
    ". Regenerate with simulation/run_simulation.R before rendering.",
    call. = FALSE
  )
}
if (any(summary$design_version != SIMULATION_DESIGN_VERSION)) {
  stop(
    "Summary file design_version does not match current code. ",
    "Regenerate with simulation/run_simulation.R before rendering.",
    call. = FALSE
  )
}
output_root <- if (is.na(artifact_root)) {
  file.path(repo_root, "thesis", "generated", "simulation")
} else {
  artifact_root
}
fig_dir <- file.path(output_root, "figures")
tab_dir <- file.path(output_root, "tables")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tab_dir, recursive = TRUE, showWarnings = FALSE)

fmt <- function(x, digits = 3) {
  ifelse(is.na(x), "--", formatC(x, digits = digits, format = "f"))
}

fmt_mcse <- function(x, se, digits = 3) {
  if (is.na(x)) {
    return("--")
  }
  if (is.na(se)) {
    return(fmt(x, digits))
  }
  paste0(fmt(x, digits), " (", fmt(se, digits), ")")
}

fmt_mcse_stack <- function(x, se, digits = 3) {
  if (is.na(x)) {
    return("--")
  }
  if (is.na(se)) {
    return(fmt(x, digits))
  }
  paste0(
    "\\begin{tabular}[t]{@{}r@{}}",
    fmt(x, digits), "\\\\(", fmt(se, digits), ")",
    "\\end{tabular}"
  )
}

esc <- function(x) {
  gsub("_", "\\\\_", x, fixed = TRUE)
}

estimator_label <- function(x) {
  labels <- c(
    equal = "Equal",
    dps_variance = "DPS variance",
    dps_amse_oracle = "DPS AMSE oracle",
    dps_amse_plugin = "DPS AMSE plug-in",
    centralised = "Centralised"
  )
  out <- labels[x]
  out[is.na(out)] <- x[is.na(out)]
  out
}

nu_label <- function(x) {
  labels <- c(
    threshold = "$\\nu^k$",
    equal = "Equal",
    sample = "Sample",
    centralised = "Centralised"
  )
  out <- labels[x]
  out[is.na(out)] <- x[is.na(out)]
  out
}

write_table <- function(path, header, rows, align) {
  con <- file(path, open = "w")
  on.exit(close(con), add = TRUE)
  writeLines(sprintf("\\begin{tabular}{%s}", align), con)
  writeLines("\\toprule", con)
  writeLines(header, con)
  writeLines("\\midrule", con)
  if (length(rows) == 0) {
    n_cols <- lengths(regmatches(align, gregexpr("[lcr]", align)))
    empty_row <- paste(c("No rows", rep("--", max(0, n_cols - 1))),
                       collapse = " & ")
    writeLines(paste0(empty_row, " \\\\"), con)
  } else {
    writeLines(rows, con)
  }
  writeLines("\\bottomrule", con)
  writeLines("\\end{tabular}", con)
}

main_rows <- summary[
  summary$design_role == "main" &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$nu_choice %in% c("threshold", "centralised") &
    summary$estimator %in% c(
      "equal", "dps_variance", "dps_amse_oracle",
      "dps_amse_plugin", "centralised"
    ),
]
main_rows <- main_rows[order(
  main_rows$regime, main_rows$m, main_rows$dgp_key, main_rows$estimator
), ]

point_lines <- character(0)
if (nrow(main_rows) > 0) {
  for (i in seq_len(nrow(main_rows))) {
    row <- main_rows[i, ]
    point_lines <- c(point_lines, sprintf(
      "%s & %d & %s & %s & %s & %s & %s \\\\",
      row$dgp, as.integer(row$m), esc(row$regime),
      estimator_label(row$estimator),
      fmt_mcse(row$log_bias, row$log_bias_mcse),
      fmt_mcse(row$log_rmse, row$log_rmse_mcse),
      if (row$estimator == "dps_amse_plugin" &&
          row$plugin_status %in% "source_ineligible") {
        "--"
      } else {
        fmt_mcse(row$valid_rate, row$valid_rate_mcse)
      }
    ))
  }
}
write_table(
  file.path(tab_dir, "finite_sample_summary.tex"),
  "DGP & $m$ & Regime & Estimator & Log bias & Log RMSE & Valid rate \\\\",
  point_lines,
  "lrllrrr"
)

interval_rows <- summary[
  summary$design_role == "main" &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$nu_choice %in% c("threshold", "centralised") &
    summary$estimator %in% c(
      "dps_variance", "dps_amse_plugin", "centralised"
    ) &
    summary$valid_ci_rate > 0,
]
interval_rows <- interval_rows[order(
  interval_rows$regime, interval_rows$m, interval_rows$dgp_key,
  interval_rows$estimator
), ]
interval_lines <- character(0)
if (nrow(interval_rows) > 0) {
  for (i in seq_len(nrow(interval_rows))) {
    row <- interval_rows[i, ]
    interval_lines <- c(interval_lines, sprintf(
      "%s & %d & %s & %s & %s & %s & %s & %s & %s \\\\",
      row$dgp, as.integer(row$m), esc(row$regime),
      estimator_label(row$estimator),
      fmt_mcse_stack(row$coverage, row$coverage_mcse),
      fmt_mcse_stack(row$ci_log_length, row$ci_log_length_mcse),
      fmt_mcse_stack(row$valid_ci_rate, row$valid_ci_rate_mcse),
      fmt(row$eta), fmt(row$bridge_log_gap)
    ))
  }
}
write_table(
  file.path(tab_dir, "interval_summary.tex"),
  "DGP & $m$ & Regime & Estimator & Coverage & Log width & CI rate & $\\eta_n$ & Bridge gap \\\\",
  interval_lines,
  "lrllrrrrr"
)

threshold_rows <- summary[
  summary$design_role == "threshold" &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$np_target == 5 &
    summary$nu_choice == "threshold" &
    summary$estimator %in% c("dps_variance", "dps_amse_plugin"),
]
threshold_rows <- threshold_rows[order(
  threshold_rows$dgp_key, threshold_rows$k_fraction,
  threshold_rows$estimator
), ]
threshold_lines <- character(0)
if (nrow(threshold_rows) > 0) {
  for (i in seq_len(nrow(threshold_rows))) {
    row <- threshold_rows[i, ]
    threshold_lines <- c(threshold_lines, sprintf(
      "%s & %s & %s & %s & %s & %s \\\\",
      row$dgp, esc(row$k_design), estimator_label(row$estimator),
      fmt(row$k_fraction, 3),
      fmt_mcse(row$log_rmse, row$log_rmse_mcse),
      fmt_mcse(row$coverage, row$coverage_mcse)
    ))
  }
}
write_table(
  file.path(tab_dir, "threshold_sensitivity.tex"),
  "DGP & Threshold rule & Estimator & $k/n$ & Log RMSE & Coverage \\\\",
  threshold_lines,
  "lllrrr"
)

target_rows <- summary[
  summary$design_role == "target" &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$nu_choice == "threshold" &
    summary$estimator %in% c("dps_variance", "dps_amse_plugin"),
]
target_rows <- target_rows[order(
  target_rows$dgp_key, target_rows$np_target, target_rows$estimator
), ]
target_lines <- character(0)
if (nrow(target_rows) > 0) {
  for (i in seq_len(nrow(target_rows))) {
    row <- target_rows[i, ]
    target_lines <- c(target_lines, sprintf(
      "%s & %s & %s & %s & %s & %s \\\\",
      row$dgp, fmt(row$np_target, 0), estimator_label(row$estimator),
      fmt(row$eta),
      fmt_mcse(row$log_rmse, row$log_rmse_mcse),
      fmt_mcse(row$coverage, row$coverage_mcse)
    ))
  }
}
write_table(
  file.path(tab_dir, "target_sensitivity.tex"),
  "DGP & $np$ & Estimator & $\\eta_n$ & Log RMSE & Coverage \\\\",
  target_lines,
  "lrlrrr"
)

stability <- summary[
  summary$design_role == "main" &
    summary$estimator %in% c(
      "dps_variance", "dps_amse_oracle", "dps_amse_plugin"
    ) &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$nu_choice == "threshold",
]
stability$estimator_order <- match(
  stability$estimator,
  c("dps_variance", "dps_amse_oracle", "dps_amse_plugin")
)
stability <- stability[order(
  stability$regime, stability$m, stability$dgp_key,
  stability$estimator_order
), ]
stability_lines <- character(0)
if (nrow(stability) > 0) {
  for (i in seq_len(nrow(stability))) {
    row <- stability[i, ]
    stability_lines <- c(stability_lines, sprintf(
      "%s & %d & %s & %s & %s & %s \\\\",
      row$dgp, as.integer(row$m), esc(row$regime),
      estimator_label(row$estimator),
      fmt_mcse(row$negative_weight_rate, row$negative_weight_rate_mcse),
      fmt_mcse(row$avg_max_abs_weight, row$avg_max_abs_weight_mcse)
    ))
  }
}
write_table(
  file.path(tab_dir, "weight_stability.tex"),
  "DGP & $m$ & Regime & Estimator & Neg. rate & Avg. max $|\\omega|$ \\\\",
  stability_lines,
  "lrllrr"
)

omega_hetero <- summary[
  summary$design_role == "nu_heterogeneous" &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$k_profile == "inverse_allocation" &
    summary$nu_choice == "threshold" &
    summary$estimator %in% c(
      "dps_variance", "dps_amse_oracle", "dps_amse_plugin"
    ),
]
omega_hetero <- omega_hetero[order(
  omega_hetero$dgp_key, omega_hetero$estimator
), ]
omega_hetero_lines <- character(0)
if (nrow(omega_hetero) > 0) {
  for (i in seq_len(nrow(omega_hetero))) {
    row <- omega_hetero[i, ]
    omega_hetero_lines <- c(omega_hetero_lines, sprintf(
      "%s & %s & %s & %s & %s & %s & %s \\\\",
      row$dgp, estimator_label(row$estimator),
      fmt_mcse_stack(row$log_bias, row$log_bias_mcse),
      fmt_mcse_stack(row$log_rmse, row$log_rmse_mcse),
      fmt_mcse_stack(row$coverage, row$coverage_mcse),
      fmt_mcse_stack(row$negative_weight_rate, row$negative_weight_rate_mcse),
      fmt_mcse_stack(row$avg_max_abs_weight, row$avg_max_abs_weight_mcse)
    ))
  }
}
write_table(
  file.path(tab_dir, "omega_heterogeneous_sensitivity.tex"),
  "DGP & Estimator & Log bias & Log RMSE & Coverage & Neg. rate & Avg. max $|\\omega|$ \\\\",
  omega_hetero_lines,
  "llrrrrr"
)

validity <- summary[
  summary$design_role == "main" &
    summary$np_target == 5 &
    summary$nu_choice %in% c("threshold", "centralised") &
    summary$estimator %in% c(
      "equal", "dps_variance", "dps_amse_oracle",
      "dps_amse_plugin", "centralised"
    ),
]
validity <- validity[order(
  validity$regime, validity$m, validity$dgp_key, validity$estimator
), ]
validity_lines <- character(0)
if (nrow(validity) > 0) {
  for (i in seq_len(nrow(validity))) {
    row <- validity[i, ]
    validity_lines <- c(validity_lines, sprintf(
      "%s & %d & %s & %s & %s & %d \\\\",
      row$dgp, as.integer(row$m), esc(row$regime),
      estimator_label(row$estimator),
      if (row$estimator == "dps_amse_plugin" &&
          row$plugin_status %in% "source_ineligible") {
        "--"
      } else {
        fmt_mcse(1 - row$valid_rate, row$valid_rate_mcse)
      },
      as.integer(row$valid_replications)
    ))
  }
}
write_table(
  file.path(tab_dir, "domain_validity.tex"),
  "DGP & $m$ & Regime & Estimator & Invalid rate & Valid reps \\\\",
  validity_lines,
  "lrllrr"
)

nu_rows <- summary[
  summary$design_role == "main" &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$estimator == "dps_variance" &
    summary$nu_choice %in% c("threshold", "equal", "sample"),
]
nu_rows <- nu_rows[order(nu_rows$dgp_key, nu_rows$nu_choice), ]
nu_lines <- character(0)
if (nrow(nu_rows) > 0) {
  for (i in seq_len(nrow(nu_rows))) {
    row <- nu_rows[i, ]
    nu_lines <- c(nu_lines, sprintf(
      "%s & %s & %s & %s & %s \\\\",
      row$dgp, nu_label(row$nu_choice),
      fmt_mcse(row$log_bias, row$log_bias_mcse),
      fmt_mcse(row$log_rmse, row$log_rmse_mcse),
      fmt_mcse(row$coverage, row$coverage_mcse)
    ))
  }
}
write_table(
  file.path(tab_dir, "nu_sensitivity.tex"),
  "DGP & Bridge weights & Log bias & Log RMSE & Coverage \\\\",
  nu_lines,
  "llrrr"
)

nu_hetero_rows <- summary[
  summary$design_role == "nu_heterogeneous" &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$estimator == "dps_variance" &
    summary$k_profile == "inverse_allocation" &
    summary$nu_choice %in% c("threshold", "equal", "sample"),
]
nu_hetero_rows <- nu_hetero_rows[order(
  nu_hetero_rows$dgp_key, nu_hetero_rows$nu_choice
), ]
nu_hetero_lines <- character(0)
if (nrow(nu_hetero_rows) > 0) {
  for (i in seq_len(nrow(nu_hetero_rows))) {
    row <- nu_hetero_rows[i, ]
    nu_hetero_lines <- c(nu_hetero_lines, sprintf(
      "%s & %s & %s & %s & %s & %s \\\\",
      row$dgp, nu_label(row$nu_choice),
      fmt_mcse(row$log_bias, row$log_bias_mcse),
      fmt_mcse(row$log_rmse, row$log_rmse_mcse),
      fmt_mcse(row$coverage, row$coverage_mcse),
      fmt_mcse(row$scaled_B_rms, row$scaled_B_rms_mcse)
    ))
  }
}
write_table(
  file.path(tab_dir, "nu_heterogeneous_sensitivity.tex"),
  "DGP & Bridge weights & Log bias & Log RMSE & Coverage & RMS scaled $B_n$ \\\\",
  nu_hetero_lines,
  "llrrrr"
)

decomp_rows <- summary[
  summary$design_role == "main" &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$nu_choice == "threshold" &
    summary$estimator == "dps_variance",
]
decomp_rows <- decomp_rows[order(decomp_rows$dgp_key), ]
decomp_lines <- character(0)
if (nrow(decomp_rows) > 0) {
  for (i in seq_len(nrow(decomp_rows))) {
    row <- decomp_rows[i, ]
    decomp_lines <- c(decomp_lines, sprintf(
      "%s & %s & %s & %s & %s & %s \\\\",
      row$dgp,
      fmt_mcse_stack(row$scaled_log_rmse, row$scaled_log_rmse_mcse),
      fmt_mcse_stack(row$scaled_A_rms, row$scaled_A_rms_mcse),
      fmt_mcse_stack(row$scaled_B_rms, row$scaled_B_rms_mcse),
      fmt_mcse_stack(row$scaled_C_rms, row$scaled_C_rms_mcse),
      fmt_mcse_stack(row$decomp_remainder_abs, row$decomp_remainder_abs_mcse, 2)
    ))
  }
}
write_table(
  file.path(tab_dir, "decomposition_summary.tex"),
  paste(
    "DGP & RMS scaled log error & RMS scaled $A_n$ &",
    "RMS scaled $B_n$ & $|$scaled $C_n|$ & Check \\\\"
  ),
  decomp_lines,
  "lrrrrr"
)

if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  dgp_order <- c(
    "Pareto light", "Pareto heavy", "Burr light",
    "Burr heavy", "Abs. Student-3"
  )
  dgp_cols <- c(
    "Pareto light" = "#1B9E77",
    "Pareto heavy" = "#D95F02",
    "Burr light" = "#7570B3",
    "Burr heavy" = "#E7298A",
    "Abs. Student-3" = "#666666"
  )

  rmse_data <- summary[
    summary$design_role == "main" &
      summary$np_target == 5 &
      summary$nu_choice %in% c("threshold", "centralised") &
      summary$estimator %in% c("centralised", "dps_variance"),
  ]
  if (nrow(rmse_data) > 0) {
    central <- rmse_data[
      rmse_data$estimator == "centralised",
      c("dgp", "dgp_key", "m", "regime", "log_rmse")
    ]
    pooled <- rmse_data[
      rmse_data$estimator == "dps_variance",
      c("dgp", "dgp_key", "m", "regime", "log_rmse")
    ]
    names(central)[names(central) == "log_rmse"] <- "centralised_rmse"
    names(pooled)[names(pooled) == "log_rmse"] <- "pooled_rmse"
    rmse_pairs <- merge(
      pooled, central,
      by = c("dgp", "dgp_key", "m", "regime")
    )
    rmse_pairs$dgp <- factor(rmse_pairs$dgp, levels = dgp_order)
    rmse_pairs$Machines <- factor(paste0("m = ", rmse_pairs$m))
    lims <- range(
      c(rmse_pairs$centralised_rmse, rmse_pairs$pooled_rmse),
      finite = TRUE
    )
    pad <- 0.04 * diff(lims)
    if (!is.finite(pad) || pad == 0) {
      pad <- 0.01
    }
    p <- ggplot(
      rmse_pairs,
      aes(
        x = centralised_rmse, y = pooled_rmse,
        color = dgp, shape = Machines
      )
    ) +
      geom_abline(
        slope = 1, intercept = 0, linetype = "dashed",
        linewidth = 0.35, color = "grey45"
      ) +
      geom_point(size = 2.5, alpha = 0.9) +
      facet_wrap(~ regime) +
      coord_equal(xlim = lims + c(-pad, pad), ylim = lims + c(-pad, pad)) +
      scale_color_manual(values = dgp_cols, drop = FALSE) +
      labs(
        x = "Centralised log RMSE",
        y = "DPS variance pooled log RMSE",
        color = "DGP", shape = NULL
      ) +
      theme_minimal(base_size = 9) +
      theme(
        legend.position = "bottom",
        panel.grid.minor = element_blank()
      )
    ggsave(
      file.path(fig_dir, "rmse_pooled_vs_centralised.pdf"), p,
      width = 7.2, height = 4.6
    )
  }

  cov_data <- summary[
    summary$design_role == "main" &
      summary$np_target == 5 &
      summary$m == 10 &
      summary$regime == "strong" &
      summary$nu_choice %in% c("threshold", "centralised") &
      summary$estimator %in% c(
        "centralised", "dps_variance", "dps_amse_plugin"
      ),
  ]
  if (nrow(cov_data) > 0) {
    estimator_levels <- estimator_label(c(
      "centralised", "dps_variance", "dps_amse_plugin"
    ))
    cov_data$Estimator <- estimator_label(cov_data$estimator)
    coverage_grid <- expand.grid(
      dgp = dgp_order,
      Estimator = estimator_levels,
      stringsAsFactors = FALSE
    )
    cov_data <- merge(
      coverage_grid,
      cov_data[, c("dgp", "Estimator", "coverage", "valid_ci_rate")],
      by = c("dgp", "Estimator"),
      all.x = TRUE,
      sort = FALSE
    )
    cov_data$dgp <- factor(cov_data$dgp, levels = rev(dgp_order))
    cov_data$Estimator <- factor(cov_data$Estimator, levels = estimator_levels)
    cov_data$coverage_gap <- cov_data$coverage - 0.95
    cov_data$coverage_label <- ifelse(
      is.na(cov_data$coverage) | cov_data$valid_ci_rate <= 0,
      "--",
      sprintf("%.2f", cov_data$coverage)
    )
    p2 <- ggplot(
      cov_data,
      aes(x = Estimator, y = dgp, fill = coverage_gap)
    ) +
      geom_tile(color = "white", linewidth = 0.6) +
      geom_text(aes(label = coverage_label), size = 3) +
      scale_fill_gradient2(
        low = "#B2182B", mid = "#F7F7F7", high = "#2166AC",
        midpoint = 0, name = "Coverage - 0.95", na.value = "#E8E8E8"
      ) +
      labs(x = NULL, y = NULL) +
      theme_minimal(base_size = 9) +
      theme(
        panel.grid = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1),
        legend.position = "bottom"
      )
    ggsave(
      file.path(fig_dir, "coverage_heatmap.pdf"), p2,
      width = 7.2, height = 3.7
    )
  }

  diag_path <- file.path(
    repo_root, "simulation", "results",
    paste0("interval_diagnostics_", mode, "_summary_latest.rds")
  )
  if (file.exists(diag_path)) {
    diag <- readRDS(diag_path)
    if (!all(c("design_version", "k_design", "eta", "plugin_status") %in% names(diag)) ||
        any(diag$design_version != SIMULATION_DESIGN_VERSION)) {
      diag <- diag[FALSE, ]
    }
    diag <- diag[diag$kind == "oracle", ]
    if (nrow(diag) > 0) {
      diag$dgp <- factor(diag$dgp, levels = dgp_order)
      diag$Design <- ifelse(
        diag$k_design == "fraction=0.05",
        paste0("n = ", diag$n_total, ", k/n = 0.05"),
        paste0("n = ", diag$n_total, ", k = n^0.45")
      )
      diag$Design <- factor(
        diag$Design,
        levels = unique(diag$Design[order(diag$n_total, diag$k_design)])
      )
      bridge_plot <- rbind(
        data.frame(
          dgp = diag$dgp,
          Design = diag$Design,
          Target = "Exact expectile",
          coverage = diag$cover_exact
        ),
        data.frame(
          dgp = diag$dgp,
          Design = diag$Design,
          Target = "Bridge target",
          coverage = diag$cover_bridge
        )
      )
      bridge_plot$Target <- factor(
        bridge_plot$Target,
        levels = c("Exact expectile", "Bridge target")
      )
      p4 <- ggplot(
        bridge_plot,
        aes(x = dgp, y = coverage, color = Target, shape = Target)
      ) +
        geom_hline(
          yintercept = 0.95, linetype = "dashed",
          linewidth = 0.35, color = "grey35"
        ) +
        geom_point(
          position = position_dodge(width = 0.45),
          size = 2.4, alpha = 0.9
        ) +
        facet_wrap(~ Design, nrow = 1) +
        scale_color_manual(
          values = c("Exact expectile" = "#B2182B", "Bridge target" = "#2166AC")
        ) +
        coord_cartesian(ylim = c(0.55, 1.0)) +
        labs(x = NULL, y = "Empirical coverage", color = NULL, shape = NULL) +
        theme_minimal(base_size = 9) +
        theme(
          axis.text.x = element_text(angle = 30, hjust = 1),
          legend.position = "bottom",
          panel.grid.minor = element_blank()
        )
      ggsave(
        file.path(fig_dir, "bridge_target_diagnostic.pdf"), p4,
        width = 7.2, height = 4.1
      )
    }
  }
}

message("Wrote tables to ", tab_dir)
message("Wrote figures to ", fig_dir)
