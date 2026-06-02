# AGENTS.md

Working context for Codex (and any other AI assistant) collaborating in this repository.

## What this project is

A **Master's thesis (LaTeX-only, no code)** by Filippo Gombac extending the optimal-pooling / distributed-inference framework of Daouia, Padoan & Stupfler (2021, arXiv:2111.03173) from the tail index and extreme **quantiles** to extreme **expectiles**, in the heavy-tailed regime ($\gamma > 0$; the moment condition $\gamma \in (0, 1/2)$ is in force for expectile-quantile equivalence).

Working title: *"Improved Statistical Inference for Expectile-Based Risk Measures."*

**Driving research question.** Given $m$ independent samples each sharing the **same primitives Paper 3 pools** — a local Hill estimator $\hat\gamma_j(k_j)$ and a local Weissman extreme-quantile estimator $\hat q^\star_j(p_n')$ — together with their joint asymptotic covariance, how should one combine these summary statistics to perform inference and Weissman-style extrapolation for an extreme **expectile** of the common underlying distribution?

## Repository layout

```
/
├── AGENTS.md                                   # This file.
├── notes.md                                    # Top-level scratchpad (informal, not part of the thesis).
├── notes/                                      # Per-proposition walkthroughs reviewed with Filippo. One file per proof (e.g. 3_2.md = Prop 3.1, 3_3.md = Prop 3.2). Each file contains: full statement, step-by-step proof, "validate together" flags, and a revision log capturing colleague-review corrections.
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
        ├── 02_background.tex                   # COMPLETED — background
        ├── 03_pooled_intermediate.tex          # COMPLETED — pooled intermediate contribution
        ├── 04_pooled_extreme.tex               # COMPLETED — pooled extreme extrapolation
        └── 05_discussion.tex                   # STUBS — discussion / future work
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
- Pooling consumes the **exact Paper 3 primitives**: each machine shares $(\hat\gamma_j(k_j),\,\hat q^\star_j(p_n'))$ with their joint asymptotic covariance — **no raw data, no expectile-specific primitives** crossing between machines. See "Architectural commitments (locked)" below.
- Inference + Weissman-style extrapolation for both intermediate and very-extreme expectile levels.

**Out of scope** (parked as "future work" in Chapter 5):
- Time-series dependence within each sample (that direction would lean on Paper 1 / Davison-Padoan-Stupfler 2023).
- Multivariate observations within each sample (that direction would lean on Paper 2 / Padoan-Stupfler 2022).
- Simulation studies or empirical applications. **No code is being written.**

If a task starts to drift into any of the above, surface it explicitly to Filippo before proceeding.

## Architectural commitments (locked)

These pin down the contract between chapters and were agreed on 2026-05-20. Do not silently revise — surface to Filippo first.

1. **Shared primitives are Paper 3's primitives, full stop.** Each machine shares $(\hat\gamma_j(k_j),\,\hat q^\star_j(p_n'))$ — its local Hill estimator and its local Weissman extreme-quantile estimator — together with the joint asymptotic covariance. **No** expectile-specific quantity (no local LAWS estimate, no local QB expectile) is communicated between machines. The intermediate-level order statistic $X_{n_j-k_j:n_j,\,j}$ is **already inside** $\hat q^\star_j$: given $(\hat\gamma_j,\hat q^\star_j,k_j,n_j,p_n')$ it is recoverable by one line of algebra, so it is *not* a third primitive.

2. **Per-machine expectile estimator is forced to QB plug-in (consequence, not choice).** Because the LAWS direct estimator would require sharing a different primitive, commitment (1) automatically restricts the per-machine expectile estimator to the QB plug-in $\widehat\xi_j(\tau)=\psifn(\hat\gamma_j)\,\hat Q_j(\tau)$. State this in the thesis as a derived consequence, not as an independent methodological decision to defend.

3. **What Papers 1 and 3 each supply (do not muddle these).** Paper 3 supplies the **pooling mechanism** (linear weights for $\hat\gamma$, weighted-geometric weights for $\hat q^\star$, variance-/AMSE-optimal weight formulas). Paper 1 — specifically Proposition C.6 of its supplement, plus the older DGS (2018, 2019) results — supplies the **expectile/quantile bridge** ($\xi_\tau/Q_X(\tau)\to\psifn(\gamma)$, the plug-in CLT). Paper 2 (multivariate expectiles) is *not* on the critical path; cite only if a side remark genuinely needs it.

4. **Intermediate case = degenerate limit of extreme case.** Following Paper 3's own structure, the pooled-intermediate-expectile result emerges as the no-extrapolation limit $\tau_n' \to \tau_{n_j}$ of the pooled-extreme-expectile theorem. There is no need for a separate intermediate-quantile primitive or a parallel proof.

5. **Chapter 3 vs Chapter 4 split is settled.** Keep Chapter 3 as the standalone pooled-intermediate theory and Chapter 4 as the Weissman-style very-extreme extrapolation chapter. Do not fold Chapter 3 into Chapter 4 unless Filippo explicitly asks for a structural rewrite.

## Technical architecture (how the proof composes)

The thesis is a composition of three pre-existing pieces, applied in the order **(1) → (3) → (2)**: Chapter 3 chains (1) into (3); Chapter 4 chains the Chapter 3 output into (2).

1. **Pooled inputs are jointly Gaussian.** Theorems 1 (Hill) and 2 (weighted-geometric Weissman) of Paper 3 give a joint $\sqrt{k}$-CLT for the per-sample estimators across $m$ samples with cross-sample covariance driven by the tail copula $R_{j,\ell}$. Because **our $m$ samples are independent**, $R_{j,\ell}\equiv 0$ across sources, so the cross-source blocks of $\Vc$ vanish and the joint covariance is block-diagonal with diagonal $\gamma^2/c_j$ (where $c_j = \lim k_j/k$). The variance-optimal weights then reduce to effective-sample-size weighting: $\omega^{\text{Var}}_j \propto k_j$. Chapter 3 verifies that these Paper-3-optimal weights remain optimal for the expectile target in the distributed-inference / equal-fraction regime after the delta method through $\psifn$; see `prop:pool-int:var-opt-distrib`.

2. **Plug-in CLT (the bridge — used in Chapter 4).** *Proposition C.6 in the supplement to Paper 1* (Davison-Padoan-Stupfler 2023) is a generic technical lemma: **any** joint $\sqrt{n(1-\tau_n)}$-Gaussian limit of $(\hat\gamma, \overline\xi)$ at intermediate level lifts to a CLT for the Weissman-extrapolated expectile at extreme level. Feeding the pooled intermediate-expectile Gaussian limit produced in Chapter 3 through this proposition yields the pooled extreme-expectile CLT essentially for free. This is the single most important lemma in the thesis.

3. **Expectile-specific delta-method calculus (used in Chapter 3).** The only expectile-specific computation is the delta method applied through $\psifn(\gamma) = (\gamma^{-1}-1)^{-\gamma}$, with derivative factor $m(\gamma) = (1-\gamma)^{-1} - \log(\gamma^{-1}-1)$. Applied to the pooled $(\hat\gamma^{\text{pool}},\hat Q^{\text{pool}})$ from piece (1), it produces a joint Gaussian limit for $(\hat\gamma^{\text{pool}},\widehat\xi^{\text{pool}}_{\tau_n})$ — exactly the input piece (2) consumes. The asymptotic equivalence $\xi_\tau / Q_X(\tau) \to \psifn(\gamma)$ as $\tau \uparrow 1$ is from Proposition 1 of DGS (2019).

The iid substrate for extreme-expectile inference itself is Daouia-Girard-Stupfler (2018, *JRSS B* 80, 263–292); the PDF is available in `/papers` as `Daouia-Estimationtailrisk-2018.pdf`.

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

## State of the document (as of 2026-06-02)

| File | State |
|---|---|
| `01_introduction.tex` | Fully drafted (~4 pages): motivation, expectile inference, pooling, research question, six contributions, outline. |
| `02_background.tex` | **Completed (~26 pages — all non-original material is in place).** §2.1 regular variation + $\mathcal C_2(\gamma,\rho,A)$; §2.2 Hill + Weissman with named theorems; §2.3 expectiles, properties, coherence + elicitability (Bellini-Klar-Müller-Rosazza Gianin 2014); §2.4 iid extreme expectile inference (DGS 2018) — asymptotic equivalence, LAWS + QB intermediate CLTs, Weissman-style extreme CLT, culminating in the **Proposition C.6 plug-in CLT** (Davison-Padoan-Stupfler 2023) that Chapter 3–4 cite verbatim; §2.5 the optimal pooling framework (Paper 3) — Theorem 1 (joint Hill CLT), Theorem 2 (geometric Weissman pooling), variance/AMSE-optimal weights, tail-homogeneity chi-square test, distributed-inference oracle corollary. |
| `03_pooled_intermediate.tex` | **Completed (~9 pages of new material).** §3.1 setup; §3.2 pooled QB expectile estimator with two weight vectors; §3.3 joint pooled $\sqrt{k}$-CLT (`prop:pool-int:joint-clt`) via Weissman decomposition + de Haan-Ferreira asymptotic independence — proposition statement carries the explicit form of the **limiting** pooled-Weissman bias vector $\Bc^\star$ (`eq:pool-int:Bcstar-def`; **note: no $\tau_n$ argument — it is a limit**), proof in Appendix §A.2; §3.4 main theorem `thm:pool-int:main` (pooled QB intermediate-expectile CLT) by delta method through $\log\psifn$; §3.5 weight optimality — three formal propositions: (i) `prop:pool-int:var-opt-distrib` (variance-optimum collapses to Paper 3's $\bm\omega^{\mathrm{Var}}$ under distributed inference); (ii) `prop:pool-int:var-opt-general` (variance-optimum in closed form via the $\Vc^{-1}$-Cauchy–Schwarz scalars $a, b, c, \Delta$, with explicit departure formula `eq:pool-int:var-opt-general-departure`); (iii) **`prop:pool-int:amse-opt`** (AMSE-optimum in closed form via stacked notation $\bm h, \bm Q, \bm M = \bm Q + \bm h\bm h^\top$; does *not* coincide with the Paper 3 AMSE-optimum even under distributed inference, because the expectile bias carries the composite vector $m(\gamma)\Bc + \Bc^\star$ plus the affine offset $b^{\xi/\Quant}$, both absent from the quantile-target AMSE). §3.6 plug-in CIs — three-tier feasibility (equal-fraction variance: only $\hatVc$; general variance: adds $\hat m$ via the preliminary effective-sample-size seed `eq:pool-int:plugin-m` that breaks the $\hat m \leftrightarrow \hat{\bm\omega}_\gamma$ circularity; AMSE: adds `eq:pool-int:plugin-amse` second-order consistencies $\hatBc, \hatBc^\star, \hat b^{\xi/\Quant}$) → `cor:pool-int:CI` (variance-only log-scale CI under the **undersmoothing calibration** `eq:pool-int:undersmoothing` $\sqrt{k_j}A(n_j/k_j)\to 0$ which forces $\mu^\xi = 0$) → `rem:pool-int:CI-bias-correction` (AMSE-regime bias-corrected variant). A dedicated paragraph notes that CI validity does **not** require $m(\gamma) \ne 0$ — that condition enters only in the optimal-weight closed forms. §3.7 expectile-tail-homogeneity test (`thm:pool-int:hom-test`, **fully drafted**): per-sample QB log-expectile vector $\hat{\bm\Xi}_n$, its joint $\sqrt{k}$-CLT (`eq:pool-int:test-clt`) with explicit diagonal covariance $\bm\Sigma=\mathrm{diag}((m(\gamma)+L_j^\star)^2+1)\Vc$ (`eq:pool-int:test-Sigma`) and mean $\bm\beta=m(\gamma)\Bc+\Bc^\star+b^{\xi/\Quant}\bm 1$ (`eq:pool-int:test-beta`), GLS deviance statistic `eq:pool-int:test-stat` with plug-in $\hat{\bm\Sigma}_n$ (`eq:pool-int:test-Sigma-hat`) → theorem gives **noncentral** $\chi^2_{m-1}(\delta)$ (`eq:pool-int:test-noncentral`, $\delta=\bm\beta^\top\bm\Sigma^{-1}\bm\beta-(\bm 1^\top\bm\Sigma^{-1}\bm\beta)^2/\bm 1^\top\bm\Sigma^{-1}\bm 1\ge 0$), collapsing to **central** $\chi^2_{m-1}$ iff $\bm\beta\in\mathrm{span}\{\bm 1\}$, which holds under (i) undersmoothing or (ii) equal-fraction distributed inference (where $\bm\beta=\beta_0\bm 1$). Proof in Appendix §A.7. The closing discussion corrects a subtlety: $\psifn$ is **not injective** on $(0,1/2)$ (it $\to 1$ at both endpoints), so under $(\mathcal H)$ the expectile null $H_0^\xi$ is *weaker* than the tail-index null $H_0$; the expectile test's complementary power appears when $(\mathcal H)$ fails (scale heterogeneity). |
| `04_pooled_extreme.tex` | **Completed (~16 pages of new material).** §4.1 motivation; §4.2 extrapolation regime and input limit, including deterministic very-extreme ratio control (`lem:pool-ext:det-ratio`) and the joint input CLT (`prop:pool-ext:input-clt`); §4.3 pooled extrapolated estimator (`eq:pool-ext:estimator`), matched-weight identities, and matched local-QB equivalence (`rem:pool-ext:matched-local-qb`); §4.4 main theorem `thm:pool-ext:main` (pooled Weissman extrapolation for very-extreme expectiles) by feeding the Chapter 3 input through `prop:bg:plug-in-clt`; §4.5 first-order variance-/AMSE-optimal Hill weights (`prop:pool-ext:optimal-weights`); §4.6 bias-reduced estimator and CLT (`cor:pool-ext:bias-reduced-clt`); §4.7 variance-only and bias-centred CIs (`cor:pool-ext:CI`, `rem:pool-ext:CI-bias-centred`). Proofs are written inside Chapter 4 rather than moved to Appendix A. |
| `05_discussion.tex` | All sections are detailed `\todo{}` stubs. |
| Appendix A (Proofs) | Seven full proofs: §A.1 (A-B-equiv), §A.2 (joint-clt), §A.3 (main-clt), §A.4 (covers both `var-opt-distrib` and `var-opt-general` — the equal-fraction case is the $\bm L^\star = L^\star\bm 1$ specialisation), §A.5 (amse-opt), §A.6 (`app:proofs:CI`, Cor 3.7), §A.7 (`app:proofs:hom-test`, Thm 3.9 — GLS covariance + noncentral $\chi^2$). Chapter 3 proofs complete. |
| Abstract | Stub. |
| Title page | Supervisor and institution are `\todo{}` placeholders — fill in before printing. |

Remaining `\todo{...}` markers are expected only in the abstract, title page, and Chapter 5 unless a new draft stub is intentionally added. Chapters 2–4 are considered completed and should not contain unfinished `\todo{...}` markers.

The current build is **91 pages**, ~910 KB. Chapters 2–4 are completed. Chapter 5 (discussion), the abstract, and title-page metadata remain to draft/fill. Appendix A (Proofs) carries seven full Chapter 3 proofs: §A.1 `app:proofs:A-B-equiv` discharges Prop 3.1 (the (A)–(B) $\sqrt{k}$-equivalence) via Taylor with Lagrange remainder + the proportionality condition $k_j \asymp k$; §A.2 `app:proofs:joint-clt` discharges Prop 3.2 (the joint pooled $\sqrt{k}$-CLT at intermediate level) in four steps — within-sample joint CLT (Hill + intermediate log-order statistic, dHF Theorem 2.4.8 + §5.1) → linear lift to (Hill, log-Weissman) via the Weissman log-decomposition with second-order control of the deterministic remainder $r_j(\tau_n) = -A(n_j/k_j)\Psi_\rho(e^{L_j^\star}) + o(A(n_j/k_j))$ → cross-sample independence and rescaling to $\sqrt{k}$ → linear pooling map $\bm A = \mathrm{diag}(\bm\omega_\gamma^\top, \bm\omega_q^\top)$; §A.3 `app:proofs:main-clt` discharges Thm 3.3 (the pooled QB intermediate-expectile CLT) by log-decomposition + Taylor linearisation of $\log\psifn$ + the second-order expectile–quantile expansion of DGS 2018 + delta method; §A.4 `app:proofs:var-opt-general` discharges Prop 3.5 (closed-form variance-optimal weights) via the $(\bm u, \bm\omega_q)$ change of variables, Lagrangian duality with the $2\times 2$ dual system $\binom{a+c\ -b}{-b\ \ a}\binom{\mu/2}{\nu/2}=\binom{m(\gamma)}{1}$, Cauchy–Schwarz for $\Delta > 0$, specialisation to distributed-inference, and the $m(\gamma)=0$ degenerate case; §A.5 `app:proofs:amse-opt` discharges Prop 3.6 (closed-form AMSE-optimal weights) via the stacked Lagrangian $\bm w = \bm M^{-1}[\tfrac{1}{2}\bm A\bm\nu - b^{\xi/\Quant}\bm h]$ with $\bm M = \bm Q + \bm h\bm h^\top$ positive definite under $m(\gamma)\ne 0$, plus block-by-block equivalence with the FOC system `eq:pool-int:amse-foc`; §A.6 `app:proofs:CI` discharges Cor 3.7 (variance-only log-scale CI) in four steps — log-scale recasting of Thm 3.3 → estimated-weight lift via the exact simplex identity $(\hat{\bm\omega} - \bm\omega)^\top \bm 1 = 0$ and Slutsky → self-normalisation through plug-in variance under undersmoothing → original-scale transport by strict monotonicity of $\exp$; §A.7 `app:proofs:hom-test` discharges Thm 3.9 (the expectile-tail-homogeneity test) in six steps — per-sample QB log-expectile CLT (single-sample specialisation of §A.3 through the row $(m(\gamma),1)$) → aggregation under independence + $\sqrt{k}$-rescaling yielding the diagonal covariance $\bm\Sigma$ and mean $\bm\beta=m(\gamma)\Bc+\Bc^\star+b^{\xi/\Quant}\bm 1$ → GLS reduction $\Lambda^\xi_n=\bm Y_n^\top\bm P_n^\top\hat{\bm\Sigma}_n^{-1}\bm P_n\bm Y_n$ with the standard GLS identity $\bm M=\bm\Sigma^{-1}-\bm\Sigma^{-1}\bm 1\bm 1^\top\bm\Sigma^{-1}/(\bm 1^\top\bm\Sigma^{-1}\bm 1)$ → standardisation to noncentral $\chi^2_{m-1}(\delta)$ via the rank-$(m-1)$ orthogonal projector $\tilde{\bm M}=\bm I-\bm v\bm v^\top/\|\bm v\|^2$, $\bm v=\bm\Sigma^{-1/2}\bm 1$ → the two regimes $\delta=0$ (undersmoothing; equal-fraction, where $\sqrt{c_jS}\lambda_j=\Lambda^\bullet e^{-\rho L^\star}$ is sample-free so $\bm\beta=\beta_0\bm 1$) → consistency under the alternative via the GLS-residual-minimisation bound. **All Chapter 3 proofs are complete; Chapter 4 proves its own results in the chapter body.**

**Bias bookkeeping — verified against DGS 2018 (do not regress; see `notes/3_4-issue.md`).** The intermediate-order statistic is $\sqrt{k}$-**unbiased**, so $b_j^Q = 0$ (DGS 2018 Thm 2 has quantile bias 0); the earlier §3.4 "cancellation" $b_1^Q+b^{\xi/\Quant}=0$ was false and is gone. The QB intermediate bias is DGS Thm 3's: with $b^Q=0$ and the standing moment condition `eq:pool-int:moment-rate` ($\sqrt{k}/Q_X(\tau_n)\to0$, killing the second DGS rate $\lambda_2$), the iid bias is $(\tfrac{m(\gamma)}{1-\rho}-c(\gamma,\rho))\lambda$ (`eq:pool-int:iid-bias`, matching corrected `thm:bg:qb-iid`). The **correct** second-order constant is $c(\gamma,\rho)=\frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}+\frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho}$, defined once in the background as `eq:bg:c-gamma-rho` (the old chapter form $\frac{(1-\gamma)^{-\rho}-\psi(\gamma)^\rho}{1-\gamma-\rho}$ was **wrong** — removed). Also corrected: the background's false "$\psi$ strictly increasing" claim — $\psi$ is U-shaped on $(0,1/2)$ (min $\psi(\gamma^\star)\approx0.757$ at $\gamma^\star\approx0.2178$ where $m(\gamma^\star)=0$), consistent with §3.7's non-injectivity remark. DGS 2018 is cited author-year (working-paper theorem numbers ≠ journal numbers).

Named theorems and propositions that downstream chapters reference (use `\Cref{...}` against these labels):
- `thm:bg:hill`, `thm:bg:weissman` — Hill and Weissman CLTs.
- `prop:bg:expectile-properties` — basic expectile properties.
- `thm:bg:expectile-coherence` — Bellini et al.'s coherence-iff-$\tau\ge1/2$.
- `prop:bg:expectile-quantile` — the $\psi(\gamma)$ asymptotic equivalence.
- `thm:bg:laws-iid`, `thm:bg:qb-iid`, `thm:bg:weissman-expectile-iid` — iid extreme-expectile CLTs.
- **`prop:bg:plug-in-clt`** — the plug-in CLT (Davison-Padoan-Stupfler 2023, Prop. C.6); the workhorse for Chapter 4.
- `thm:bg:pool-hill`, `thm:bg:pool-weissman` — Paper 3's joint Hill and Weissman CLTs.
- `prop:bg:optimal-weights` — variance- and AMSE-optimal weight formulas.
- `thm:bg:tail-homogeneity-test`, `cor:bg:pool-distrib-oracle` — testing and oracle equivalence under distributed inference.

Chapter 3 (new contributions):
- `prop:pool-int:A-B-equiv` — $\sqrt{k}$-asymptotic equivalence of the two candidate pooled QB estimators (A: pool inputs then plug in; B: plug in locally then geometric-pool). **Stated for fixed $m$ and deterministic $\bm\omega$**; raw log-ratio is $O_p(k^{-1})$, one order sharper than the CLT needs (random-$\bm\omega$ extension is a one-line Slutsky corollary). §3.2 adopts (A) as canonical by *parsimony* — direct lift of `thm:bg:qb-iid`. The earlier elaborate "Jensen-bias" proposition was dropped (sub-leading to the EVT bias control, hence outside the chapter's asymptotic order); the Jensen observation survives only as a footnote.
- `prop:pool-int:joint-clt` — joint pooled $\sqrt{k}$-Gaussian limit of $(\hat\gamma_n, \log\hatWei_n)$ at intermediate level (independent-samples specialization).
- **`thm:pool-int:main`** — pooled QB intermediate-expectile CLT, the main result of Chapter 3.
- `prop:pool-int:var-opt-distrib` — variance-optimal expectile-pooling weights coincide with Paper 3's quantile-pooling weights under distributed inference (sample-free $L^\star$).
- `prop:pool-int:var-opt-general` — closed-form variance-optimal weights when $\bm L^\star$ varies across samples, parametrised by $a=\bm 1^\top\Vc^{-1}\bm 1$, $b=\bm 1^\top\Vc^{-1}\bm L^\star$, $c=(\bm L^\star)^\top\Vc^{-1}\bm L^\star$, $\Delta=a^2+ac-b^2$; departure from Paper 3 along direction $\Vc^{-1}(\bm L^\star - \bar L^\star \bm 1)$ with scalar prefactor $(m(\gamma)a+b)/\Delta$.
- **`prop:pool-int:amse-opt`** — closed-form AMSE-optimal weights via stacked notation $\bm h=(m(\gamma)\Bc;\Bc^\star)$, $\bm Q$ (block Hessian), $\bm M=\bm Q+\bm h\bm h^\top$; **AMSE-optima do not coincide** with Paper 3 even under distributed inference, because the expectile bias carries the composite vector $m(\gamma)\Bc+\Bc^\star$ and the affine offset $b^{\xi/\Quant}$, both absent from the Paper 3 quantile-target AMSE.
- `cor:pool-int:CI` — feasible asymptotic confidence interval for $\xi_{\tau_n}$.
- `thm:pool-int:hom-test` — chi-square test of expectile-tail-homogeneity (analogue of Paper 3's tail-homogeneity test at the expectile level). Limit is **noncentral** $\chi^2_{m-1}(\delta)$ in general, **central** $\chi^2_{m-1}$ iff the asymptotic bias $\bm\beta\in\mathrm{span}\{\bm 1\}$ — guaranteed under undersmoothing or equal-fraction distributed inference, the same two regimes in which the chapter's CI/weights are used.

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
