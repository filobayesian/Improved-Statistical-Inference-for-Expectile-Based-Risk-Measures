# CLAUDE.md

Working context for Claude Code (and any other AI assistant) collaborating in this repository.

## What this project is

A **Master's thesis (LaTeX-only, no code)** by Filippo Gombac extending the optimal-pooling / distributed-inference framework of Daouia, Padoan & Stupfler (2021, arXiv:2111.03173) from the tail index and extreme **quantiles** to extreme **expectiles**, in the heavy-tailed regime ($\gamma > 0$; the moment condition $\gamma \in (0, 1/2)$ is in force for expectile-quantile equivalence).

Working title: *"Improved Statistical Inference for Expectile-Based Risk Measures."*

**Driving research question.** Given $m$ independent samples each contributing point estimates $(\hat\gamma_j, \hat Q_j(p_j))$ together with their joint asymptotic covariance, how should one combine these summary statistics to perform inference and Weissman-style extrapolation for an extreme expectile of the common underlying distribution?

## Repository layout

```
/
├── CLAUDE.md                                   # This file.
├── papers/                                     # Source literature (PDFs)
│   ├── Optimal Pooling.pdf                     # Paper 3 — framework being extended
│   ├── optimal pooling supp.pdf                # Paper 3 supplement
│   ├── Tail Risk Inference via Expectiles ...  # Paper 1 — extreme expectile theory
│   ├── ubes_a_2078332_sm7626.pdf               # Paper 1 supplement (JBES)
│   ├── BEJ1375.pdf                             # Paper 2 — multivariate expectiles
│   ├── bej1375supp.pdf                         # Paper 2 supplement
│   ├── jrsssb_78_3_505.pdf                     # Ehm-Gneiting-Jordan-Krüger (2016)
│   └── Extreme Value Theory ...                # de Haan & Ferreira (2006), textbook
└── thesis/
    ├── main.tex                                # Top-level document
    ├── preamble.tex                            # Packages, theorem envs, math macros
    ├── references.bib                          # Bibliography (biblatex/biber)
    ├── main.pdf                                # Build output (gitignored or check-in optional)
    └── chapters/
        ├── 01_introduction.tex                 # FULLY DRAFTED
        ├── 02_background.tex                   # §2.1, §2.2 drafted; §2.3–2.5 stubs
        ├── 03_pooled_intermediate.tex          # STUBS — main contribution
        ├── 04_pooled_extreme.tex               # STUBS — extrapolation
        └── 05_discussion.tex                   # STUBS
```

## Building the document

From `thesis/`:

```bash
latexmk -pdf main.tex          # build (handles biber and multiple passes)
latexmk -C                     # clean intermediate files
```

The MacTeX distribution at `/Library/TeX/texbin/` has `latexmk`, `pdflatex`, `biber`, `xelatex` already in PATH. After a build failure, latexmk may leave behind `*.bcf-SAVE-ERROR` / `*.bbl-SAVE-ERROR` files; `rm -f` them before retrying.

Every file under `thesis/chapters/` and `thesis/preamble.tex` carries a `% !TEX root = .../main.tex` magic comment, so any LaTeX-aware IDE (TeXShop, VS Code LaTeX Workshop, TeXstudio) compiles `main.tex` regardless of which file is active. **Do not try to compile `preamble.tex` or a chapter file standalone — they are fragments, not documents.**

## Scope (locked decisions, do not silently widen)

**In scope.**
- Univariate **iid** samples within each source, $m$ independent sources. Matches the distributed-inference setting of Paper 3.
- Heavy-tailed loss with extreme-value index $\gamma \in (0, 1/2)$.
- Pooling consumes **summary statistics** $(\hat\gamma_j, \hat Q_j(p_j))$ with their joint asymptotic covariance — **not** raw data.
- Inference + Weissman-style extrapolation for both intermediate and very-extreme expectile levels.

**Out of scope** (parked as "future work" in Chapter 5):
- Time-series dependence within each sample (that direction would lean on Paper 1 / Davison-Padoan-Stupfler 2023).
- Multivariate observations within each sample (that direction would lean on Paper 2 / Padoan-Stupfler 2022).
- Simulation studies or empirical applications. **No code is being written.**

If a task starts to drift into any of the above, surface it explicitly to Filippo before proceeding.

## Technical architecture (how the proof composes)

The thesis is a composition of three pre-existing pieces:

1. **Pooled inputs are jointly Gaussian.** Theorems 1 (Hill) and 2 (weighted-geometric Weissman) of Paper 3 give a joint $\sqrt{k}$-CLT for the per-sample estimators across $m$ samples with cross-sample covariance driven by the tail copula $R_{j,\ell}$. Because **our $m$ samples are independent**, $R_{j,\ell}\equiv 0$ across sources, so the cross-source blocks of $\Vc$ vanish and the joint covariance is block-diagonal with diagonal $\gamma^2/c_j$ (where $c_j = \lim k_j/k$). The variance-optimal weights then reduce to effective-sample-size weighting: $\omega^{\text{Var}}_j \propto k_j$.

2. **Plug-in CLT (the bridge).** *Proposition C.6 in the supplement to Paper 1* (Davison-Padoan-Stupfler 2023) is a generic technical lemma: **any** joint $\sqrt{n(1-\tau_n)}$-Gaussian limit of $(\hat\gamma, \overline\xi)$ lifts to a CLT for the Weissman-extrapolated expectile. Feeding the pooled Gaussian inputs from (1) through this proposition yields the pooled-expectile CLT for free. This is the single most important lemma in the thesis.

3. **Expectile-specific delta-method calculus.** The only expectile-specific computation is the delta method applied through $\psi(\gamma) = (\gamma^{-1}-1)^{-\gamma}$, with derivative factor $m(\gamma) = (1-\gamma)^{-1} - \log(\gamma^{-1}-1)$. The asymptotic equivalence $\xi_\tau / Q_X(\tau) \to \psi(\gamma)$ as $\tau \uparrow 1$ is from Proposition 1 of DGS (2019).

The iid substrate for extreme-expectile inference itself is Daouia-Girard-Stupfler (2018, *JRSS B* 80, 263–292); cited in the bib but the PDF is **not** in `/papers`.

## Notation conventions

Defaults follow Paper 3 (Daouia-Padoan-Stupfler 2021); expectile-specific symbols follow Paper 1 (Davison-Padoan-Stupfler 2023). The preamble defines:

| Macro | Renders as | Meaning |
|---|---|---|
| `\expectile{τ}` | $\xi_\tau$ | Population expectile at level $\tau$ |
| `\tildexpectile{τ}` | $\widetilde\xi_\tau$ | LAWS direct estimator |
| `\hatexpectile{τ}` | $\widehat\xi_\tau$ | QB plug-in estimator |
| `\psifn` | $\psi$ | Asymptotic-equivalence constant $(\gamma^{-1}-1)^{-\gamma}$ |
| `\Quant`, `\hatQuant` | $Q$, $\widehat Q$ | Quantile, estimator |
| `\Wei`, `\hatWei` | $q^\star$, $\widehat q^\star$ | Weissman estimator (the macro **already includes** the $\star$) |
| `\Vc`, `\Bc`, `\hatVc`, `\hatBc` | $\Vc$, $\Bc$, $\hatVc$, $\hatBc$ | Covariance / bias from Paper 3 and their estimators |
| `\Rjl` | $R_{j,\ell}$ | Tail copula between samples $j$ and $\ell$ |
| `\todist`, `\toprob`, `\toas` | $\todist$, $\toprob$, $\toas$ | Convergence in distribution / probability / a.s. |
| `\todo{…}` | red bold marker | Visible placeholder for unfinished content |

**Common pitfall.** Writing `\hatWei^\star` triggers a "Double superscript" fatal error because `\hatWei` already carries the $\star$. Use plain `\hatWei` for both intermediate and extreme levels — the level is encoded in the argument, not the symbol.

All theorem-like environments (`theorem`, `lemma`, `proposition`, `corollary`, `definition`, `assumption`, `condition`, `example`, `remark`) share a single counter that resets at each chapter (e.g. Theorem 2.1, Lemma 2.2, Theorem 3.1, ...).

## Verified bibliography (already in `references.bib`)

- **Paper 1** — Davison, A. C., Padoan, S. A., & Stupfler, G. (2023). *Tail risk inference via expectiles in heavy-tailed time series.* JBES **41**(3), 876–889. DOI: 10.1080/07350015.2022.2078332.
- **Paper 2** — Padoan, S. A., & Stupfler, G. (2022). *Joint inference on extreme expectiles for multivariate heavy-tailed distributions.* Bernoulli **28**(2), 1021–1048. DOI: 10.3150/21-BEJ1375.
- **Paper 3** — Daouia, A., Padoan, S. A., & Stupfler, G. (2021). *Optimal pooling and distributed inference for the tail index and extreme quantiles.* arXiv:2111.03173. (Confirm journal acceptance and update the entry.)
- **iid substrate** — Daouia, A., Girard, S., & Stupfler, G. (2018). *Estimation of tail risk based on extreme expectiles.* JRSS B **80**(2), 263–292.
- Also: Newey-Powell (1987); Artzner-Delbaen-Eber-Heath (1999); Gneiting (2011); Bellini-Klar-Müller-Rosazza Gianin (2014); Ehm-Gneiting-Jordan-Krüger (2016); de Haan-Ferreira (2006); Hill (1975); Weissman (1978); DGS (2019) — *Bernoulli* M-quantiles; DGS (2020) — *Bernoulli* tail expectile process.

When adding new entries, prefer verified DOIs / journal volumes. Mark unverified pieces with a `% TODO verify` comment rather than inserting `\todo{}` inside a bib field (that breaks biber).

## State of the document (as of 2026-05-18)

| File | State |
|---|---|
| `01_introduction.tex` | Fully drafted (~4 pages): motivation, expectile inference, pooling, research question, six contributions, outline. |
| `02_background.tex` | §2.1 (regular variation, $\mathcal C_2(\gamma,\rho,A)$) and §2.2 (Hill + Weissman, with named theorems) fully drafted. §2.3 (expectile basics), §2.4 (iid baseline for extreme expectiles), §2.5 (pooling framework) are detailed `\todo{}` stubs. |
| `03_pooled_intermediate.tex` | All sections are detailed `\todo{}` stubs. **Main contribution.** |
| `04_pooled_extreme.tex` | All sections are detailed `\todo{}` stubs (Weissman-style extrapolation). |
| `05_discussion.tex` | All sections are detailed `\todo{}` stubs. |
| Appendix A (Proofs) | Stub. |
| Abstract | Stub. |
| Title page | Supervisor and institution are `\todo{}` placeholders — fill in before printing. |

Every `\todo{...}` in the source describes the *exact content* the section should contain (formulas, theorem statements, references to which paper supplies what). The macro renders in bold red, so unfinished material is obvious in the PDF.

The current build is 21 pages (mostly Chapter 1 + the drafted parts of Chapter 2 + section-level skeletons for the remaining chapters).

## Working conventions

1. **LaTeX only.** No simulation code, no R / Python. If the user asks for code, double-check before writing it.
2. **Edit existing stubs in place.** When fleshing out a section, replace the existing `\todo{...}` with content rather than appending; the stub describes the intended scope.
3. **Centralise notation.** When introducing a new symbol, check `preamble.tex` first. Add to the preamble (rather than redefine inline) if the symbol will be reused.
4. **Sanity-check the build.** After any non-trivial edit, run `latexmk -pdf main.tex` from `thesis/`. Watch for the `\hatWei^\star` double-superscript regression (the macro already includes the $\star$).
5. **Citations.** Add new entries to `references.bib` with verified DOIs. Never put `\todo{}` inside a `@article{...}` field — that breaks biber. Use a `% TODO verify` comment instead.
6. **Scope discipline.** Before extending a contribution into the time-series or multivariate setting, surface the scope decision to Filippo. Same for adding code or empirical work — both were declared out of scope.
7. **Match the paper's notation.** Default to Paper 3 conventions; defer to Paper 1 for expectile-specific symbols. If a conflict arises, note it and ask.

## What is *not* here

- Simulation / numerical-experiment code.
- A data directory or real-data application.
- An ONBOARDING.md — only one human is working in this repo.
