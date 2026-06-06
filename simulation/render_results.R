#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
mode <- if ("--final" %in% args) {
  "final"
} else if ("--pilot" %in% args) {
  "pilot"
} else {
  "smoke"
}

repo_root <- normalizePath(getwd(), mustWork = TRUE)
if (!file.exists(file.path(repo_root, "simulation", "run_simulation.R"))) {
  repo_root <- normalizePath(file.path(repo_root, ".."), mustWork = TRUE)
}

local_lib <- file.path(repo_root, "simulation", "Rlib")
if (dir.exists(local_lib)) {
  .libPaths(c(normalizePath(local_lib, mustWork = TRUE), .libPaths()))
}

summary_path <- file.path(
  repo_root, "simulation", "results",
  paste0("finite_sample_", mode, "_summary_latest.rds")
)
if (!file.exists(summary_path)) {
  stop("Missing summary file: ", summary_path,
       ". Run simulation/run_simulation.R first.", call. = FALSE)
}

summary <- readRDS(summary_path)
fig_dir <- file.path(repo_root, "thesis", "figures", "simulation")
tab_dir <- file.path(repo_root, "thesis", "tables", "simulation")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tab_dir, recursive = TRUE, showWarnings = FALSE)

fmt <- function(x, digits = 3) {
  ifelse(is.na(x), "--", formatC(x, digits = digits, format = "f"))
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

write_table <- function(path, header, rows, align) {
  con <- file(path, open = "w")
  on.exit(close(con), add = TRUE)
  writeLines(sprintf("\\begin{tabular}{%s}", align), con)
  writeLines("\\toprule", con)
  writeLines(header, con)
  writeLines("\\midrule", con)
  if (length(rows) == 0) {
    writeLines("No rows & -- & -- & -- & -- \\\\", con)
  } else {
    writeLines(rows, con)
  }
  writeLines("\\bottomrule", con)
  writeLines("\\end{tabular}", con)
}

main_rows <- summary[
  summary$k_fraction == 0.05 &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$estimator %in% c(
      "dps_variance", "dps_amse_plugin", "centralised"
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
      fmt(row$log_bias), fmt(row$log_rmse), fmt(row$valid_rate)
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
  summary$k_fraction == 0.05 &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong" &
    summary$estimator %in% c(
      "dps_variance", "dps_amse_plugin", "centralised"
    ),
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
      "%s & %d & %s & %s & %s & %s & %s \\\\",
      row$dgp, as.integer(row$m), esc(row$regime),
      estimator_label(row$estimator),
      fmt(row$coverage), fmt(row$ci_log_length),
      fmt(row$valid_ci_rate)
    ))
  }
}
write_table(
  file.path(tab_dir, "interval_summary.tex"),
  "DGP & $m$ & Regime & Estimator & Coverage & Log width & CI rate \\\\",
  interval_lines,
  "lrllrrr"
)

threshold_rows <- summary[
  summary$m == 10 &
    summary$regime == "strong" &
    summary$np_target == 5 &
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
      "%s & %s & %s & %s & %s \\\\",
      row$dgp, fmt(row$k_fraction, 2), estimator_label(row$estimator),
      fmt(row$log_rmse), fmt(row$coverage)
    ))
  }
}
write_table(
  file.path(tab_dir, "threshold_sensitivity.tex"),
  "DGP & $k_j/n_j$ & Estimator & Log RMSE & Coverage \\\\",
  threshold_lines,
  "lrlrr"
)

target_rows <- summary[
  summary$m == 10 &
    summary$regime == "strong" &
    summary$k_fraction == 0.05 &
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
      "%s & %s & %s & %s & %s \\\\",
      row$dgp, fmt(row$np_target, 0), estimator_label(row$estimator),
      fmt(row$log_rmse), fmt(row$coverage)
    ))
  }
}
write_table(
  file.path(tab_dir, "target_sensitivity.tex"),
  "DGP & $np$ & Estimator & Log RMSE & Coverage \\\\",
  target_lines,
  "lrlrr"
)

stability <- summary[
  summary$estimator %in% c("dps_amse_oracle", "dps_amse_plugin") &
    summary$k_fraction == 0.05 &
    summary$np_target == 5 &
    summary$m == 10 &
    summary$regime == "strong",
]
stability <- stability[order(
  stability$regime, stability$m, stability$dgp_key, stability$estimator
), ]
stability_lines <- character(0)
if (nrow(stability) > 0) {
  for (i in seq_len(nrow(stability))) {
    row <- stability[i, ]
    stability_lines <- c(stability_lines, sprintf(
      "%s & %d & %s & %s & %s & %s \\\\",
      row$dgp, as.integer(row$m), esc(row$regime),
      estimator_label(row$estimator),
      fmt(row$negative_weight_rate), fmt(row$avg_max_abs_weight)
    ))
  }
}
write_table(
  file.path(tab_dir, "weight_stability.tex"),
  "DGP & $m$ & Regime & Estimator & Neg. rate & Avg. max $|\\omega|$ \\\\",
  stability_lines,
  "lrllrr"
)

validity <- summary[
  summary$k_fraction == 0.05 &
    summary$np_target == 5 &
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
      fmt(1 - row$valid_rate), as.integer(row$valid_replications)
    ))
  }
}
write_table(
  file.path(tab_dir, "domain_validity.tex"),
  "DGP & $m$ & Regime & Estimator & Invalid rate & Valid reps \\\\",
  validity_lines,
  "lrllrr"
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
    summary$k_fraction == 0.05 &
      summary$np_target == 5 &
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
    summary$k_fraction == 0.05 &
      summary$np_target == 5 &
      summary$m == 10 &
      summary$regime == "strong" &
      summary$estimator %in% c(
        "centralised", "dps_variance", "dps_amse_plugin"
      ),
  ]
  if (nrow(cov_data) > 0) {
    cov_data$dgp <- factor(cov_data$dgp, levels = rev(dgp_order))
    cov_data$Estimator <- factor(
      estimator_label(cov_data$estimator),
      levels = estimator_label(c(
        "centralised", "dps_variance", "dps_amse_plugin"
      ))
    )
    cov_data$coverage_gap <- cov_data$coverage - 0.95
    p2 <- ggplot(
      cov_data,
      aes(x = Estimator, y = dgp, fill = coverage_gap)
    ) +
      geom_tile(color = "white", linewidth = 0.6) +
      geom_text(aes(label = sprintf("%.2f", coverage)), size = 3) +
      scale_fill_gradient2(
        low = "#B2182B", mid = "#F7F7F7", high = "#2166AC",
        midpoint = 0, name = "Coverage - 0.95"
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

  sens <- summary[
    summary$m == 10 &
      summary$regime == "strong" &
      summary$np_target == 5 &
      summary$estimator == "dps_variance",
  ]
  if (nrow(sens) > 0) {
    sens$dgp <- factor(sens$dgp, levels = dgp_order)
    trade <- rbind(
      data.frame(
        dgp = sens$dgp,
        k_fraction = sens$k_fraction,
        metric = "Log RMSE",
        value = sens$log_rmse
      ),
      data.frame(
        dgp = sens$dgp,
        k_fraction = sens$k_fraction,
        metric = "Coverage",
        value = sens$coverage
      )
    )
    trade$metric <- factor(trade$metric, levels = c("Log RMSE", "Coverage"))
    nominal <- data.frame(metric = factor("Coverage", levels = levels(trade$metric)))
    p3 <- ggplot(
      trade,
      aes(x = k_fraction, y = value, color = dgp, group = dgp)
    ) +
      geom_line(linewidth = 0.45) +
      geom_point(size = 1.8) +
      geom_hline(
        data = nominal, aes(yintercept = 0.95),
        linetype = "dashed", linewidth = 0.35, color = "grey35"
      ) +
      facet_wrap(~ metric, scales = "free_y", nrow = 1) +
      scale_x_continuous(
        breaks = sort(unique(trade$k_fraction)),
        labels = formatC(sort(unique(trade$k_fraction)), format = "f", digits = 2)
      ) +
      scale_color_manual(values = dgp_cols, drop = FALSE) +
      labs(
        x = "Local threshold fraction",
        y = NULL,
        color = "DGP"
      ) +
      theme_minimal(base_size = 9) +
      theme(
        legend.position = "bottom",
        panel.grid.minor = element_blank()
      )
    ggsave(
      file.path(fig_dir, "threshold_tradeoff.pdf"), p3,
      width = 7.2, height = 4.0
    )
  }

  diag_path <- file.path(
    repo_root, "simulation", "results",
    "interval_diagnostics_summary_latest.rds"
  )
  if (file.exists(diag_path)) {
    diag <- readRDS(diag_path)
    diag <- diag[diag$kind == "oracle", ]
    if (nrow(diag) > 0) {
      diag$dgp <- factor(diag$dgp, levels = dgp_order)
      diag$Design <- ifelse(
        diag$n_total >= 100000,
        "n = 100000, k/n = 0.01",
        "n = 10000, k/n = 0.05"
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
