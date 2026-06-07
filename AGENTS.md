# AGENTS.md

Working context for Codex and any other AI assistant collaborating in this repository.

## What This Project Is

A Master's thesis, with LaTeX source and reproducible R simulation support, by Filippo Gombac on pooled inference for extreme expectile-based risk measures. The project extends the optimal-pooling / distributed-inference framework of Daouia, Padoan & Stupfler, *Optimal weighted pooling for inference about the tail index and extreme quantiles*, from extreme quantiles toward extreme expectiles.

Working title: *Improved Statistical Inference for Expectile-Based Risk Measures*.

The research is currently in a reset phase after supervisor feedback on 2026-06-03. Do not treat the old Chapter 3 route, old Chapter 4 route, old Chapter 5 simulations, or any theorem prose removed from the live LaTeX draft as settled thesis content. The new direction is to rebuild from first principles around the pooled extreme-expectile estimator. As of the 2026-06-05 two-weight design pivot, the active estimator class is
\[
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
  =
  \psi(\widehat\gamma_n(\nu))\,
  \widehat q_n^\star(\tau_n\mid\omega),
\]
where `\widehat q_n^\star(\tau_n\mid\omega)` is the Daouia--Padoan--Stupfler geometrically pooled Weissman extreme-quantile estimator, `\widehat\gamma_n(\nu)` is a separately pooled Hill estimator used only in the outer expectile bridge, and `\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}` is the high-expectile / high-quantile asymptotic constant. The previous one-weight estimator is the diagonal special case `\nu=\omega`, not the active unrestricted design.

As of the 2026-06-05 inference-design decision, the practical bridge-Hill
convention for downstream inference is fixed as
`\nu_n^k=(k_1/k,\ldots,k_m/k)`. This keeps the outer bridge-Hill weight vector
deterministic while allowing the pooled-Weissman weight vector `\omega` to use
DPS deterministic/oracle or source-admissible estimated variance- and
AMSE-optimal weights. Do not describe `\nu_n^k` as optimal; it is a transparent
deterministic convention chosen precisely to avoid making random
`\nu=\widehat\omega_n`.

The plug-in inference route is now fixed conditionally on DPS source
consistency: when the selected DPS `\omega` construction provides consistent
plug-in centring and variance objects, use those objects. This gives a
Slutsky/studentised statistic and a log-scale multiplicative interval by
inversion. It is not a direct import of the DPS Corollary 4 quantile interval
formula, and it does not make `\nu` optimal or random.

## Current Repository Status: Promoted First-Order Thesis Prose And Final Simulation Run

As of 2026-06-07, the live compiled thesis has been reorganised after the
two-weight pivot. It now compiles:

- title/front matter, with `\todo{}` still in the Abstract;
- `thesis/chapters/01_introduction.tex`, still only the chapter heading,
  label, and `\todo{}`;
- `thesis/chapters/02_background.tex`, retained as the background chapter and
  expanded with source-level estimated-weight and plug-in-object statements;
- `thesis/chapters/03_pooled_extreme_expectiles.tex`, now the live
  main-theory chapter;
- `thesis/chapters/04_finite_sample_study.tex`, the current narrow
  finite-sample chapter for the promoted estimator and inference route,
  rewritten from a fresh final simulation run;
- bibliography via `\printbibliography`.

`thesis/main.tex` currently includes `chapters/01_introduction`,
`chapters/02_background`, `chapters/03_pooled_extreme_expectiles`, and
`chapters/04_finite_sample_study` before the bibliography. The current PDF is
written to `thesis/build/main.pdf` and was rebuilt successfully with
`latexmk -pdf -synctex=1 -interaction=nonstopmode main.tex`.

The withdrawn pooled-intermediate placeholder has been moved out of live
chapter source to `archive/pre_pivot/03_pooled_intermediate_placeholder.tex`.
The file `thesis/chapters/05_discussion.tex` remains an uncompiled future
placeholder with only a chapter title, label, and `\todo{}`.

Important: the deterministic two-weight theorem, the estimated-`\omega`
transfer corollary, and the plug-in studentisation/log-scale interval
corollary are now promoted to live `.tex` prose in
`thesis/chapters/03_pooled_extreme_expectiles.tex`. The old diagonal Chapter 4
theorem route remains historical draft/audit context only. The finite-sample
chapter is now a narrow thesis-ready current draft for the promoted estimator;
do not widen its claims beyond the compiled design and generated artifacts under
`thesis/generated/simulation/`.

As of 2026-06-07, the stale/smoke simulation results and stale Chapter 4 prose
from earlier runs have been superseded. The current simulation code design
version is
`two_weight_pooled_extreme_20260607_central_oracle_hetero_nu`. A fresh final
finite-sample run was completed with 55 scenarios and 5000 replications per
scenario, and a fresh final interval-diagnostic run was completed with 10
scenarios and 1500 replications per scenario. The current `latest` RDS files in
`simulation/results/` match the current design version, and
`simulation/render_results.R --final` regenerated the tables and figures under
`thesis/generated/simulation/`. The regenerated artifacts include the new
heterogeneous-threshold diagnostics
`nu_heterogeneous_sensitivity.tex` and
`omega_heterogeneous_sensitivity.tex`. The thesis was rebuilt successfully to
`thesis/build/main.pdf` with
`latexmk -pdf -synctex=1 -interaction=nonstopmode main.tex`.

Current Chapter 4 simulation interpretation:

- the main practical bridge-Hill convention remains
  `\nu_n^k=(k_1/k,\ldots,k_m/k)`, with other deterministic `\nu` choices used
  only as finite-sample sensitivity checks;
- the centralised benchmark interval uses the corresponding single-sample
  oracle DPS centring and variance objects with `m=1`;
- exact Pareto plug-in AMSE rows are treated as source-ineligible because the
  second-order bias coefficient is zero, so do not describe plug-in AMSE as an
  active distinct estimated AMSE route in exact Pareto designs;
- the main equal-threshold grid shows DPS variance weights are a stable
  baseline for `\omega`, while AMSE weights are almost indistinguishable from
  variance weights in that grid;
- the heterogeneous-threshold diagnostic is the proper finite-sample place to
  discuss whether AMSE weights can differ meaningfully from variance weights;
  it shows AMSE can matter, but is not uniformly superior or uniformly stable;
- first-order log-scale intervals under-cover in several finite-sample rows, so
  Chapter 4 should present interval results as diagnostics of the plug-in route,
  not as a claim of strong finite-sample calibration.

Current source-audit/prose status: the `A_n(\omega)` pooled Weissman component, the
`B_n(\nu)` plug-in-`\psi` component, and the `C_n` population bridge component
of the exact decomposition have been source-checked in
`notes/source_audit_pooled_extreme_expectile.md` against the local PDFs of
Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version, the
DPS supplement proof of Theorem 2, and Daouia--Girard--Stupfler (2020),
Proposition 1(i). The source check confirmed the finite-`m`
iid/common-marginal deterministic two-weight route under
`\eta_n=\sqrt{k}/\{\ell_n Q(1-p_n)\}\to0`, provided any future theorem prose
carries the source conventions on common continuous iid data, aggregate
`n=\sum_j n_j`, aggregate `k=\sum_j k_j`, and eventual upper-tail positivity
for log-Weissman expressions. The latest Markdown pass also source-checks the
DPS estimated-weight / plug-in transfer layer for the `\omega` role, using DPS
Theorem A.1 in the supplement, Section 2.2, Corollary 1, Theorem 2,
Corollary 6, Corollary 7, and Corollary 8. DPS Corollary 4 has been checked
only as the source's log-scale quantile-inference analogue; the audit note does
not import its interval formula directly. The expectile interval is instead
obtained by inverting the transferred plug-in-centred expectile statistic.
These checked results have now been promoted into polished thesis prose where
needed: the background chapter carries the source propositions for estimated
weights and plug-in objects, while the main-theory chapter carries the
deterministic theorem, estimated-`\omega` transfer, and conditional plug-in
inference corollary.

The promoted two-weight route, first audited in
`notes/source_audit_pooled_extreme_expectile.md` and now written in
`thesis/chapters/03_pooled_extreme_expectiles.tex`, uses the deterministic estimator
`\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)`. The active decomposition is
\[
  \log
  \frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
       {\xi_{\tau_n}}
  =
  A_n(\omega)+B_n(\nu)-C_n,
\]
where `A_n(\omega)` is the same DPS pooled-Weissman component, `C_n` is the
same population expectile--quantile bridge, and
`B_n(\nu)=\log\psi(\widehat\gamma_n(\nu))-\log\psi(\gamma)`. Under the current
`\eta_n\to0` route, the compact-event Taylor argument gives
`(\sqrt{k}/\ell_n)B_n(\nu)=o_P(1)` for any deterministic admissible `\nu`.
Consequently the promoted two-weight first-order limit depends on `\omega`
but not on `\nu`:
`\frac{\sqrt{k}}{\ell_n}\log\{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)/\xi_{\tau_n}\}
\Rightarrow N(B_\omega,V_\omega)`.

The promoted source-admissible random-`\omega` result is a transfer
corollary, not a replacement for the deterministic base theorem:
\[
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)
  =
  \psi(\widehat\gamma_n(\nu))\,
  \widehat q_n^\star(\tau_n\mid\widehat\omega_n),
\]
where `\nu` remains deterministic admissible and, for the practical downstream
route, is fixed at the threshold-allocation convention
`\nu_n^k=(k_1/k,\ldots,k_m/k)`. The conditions
`\widehat\omega_n^\top\mathbf 1=1`, `\widehat\omega_n\to_P\omega` are the
DPS random-weight conditions. DPS already covers
`A_n(\widehat\omega_n)` for the pooled Weissman component; the exact expectile
decomposition adds only the already checked lower-order `B_n(\nu)` and `C_n`
terms under `\eta_n\to0`. Therefore
`\frac{\sqrt{k}}{\ell_n}\log\{
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)/\xi_{\tau_n}\}
\Rightarrow N(B_\omega,V_\omega)`. Plug-in centring and variance objects
`\widehat B_{\widehat\omega,n}` and `\widehat V_{\widehat\omega,n}` transfer
if the DPS source conditions give their consistency, yielding the studentised
statistic
`\{(\sqrt{k}/\ell_n)\log(\widehat\xi/\xi)-\widehat B_{\widehat\omega,n}\}/
\sqrt{\widehat V_{\widehat\omega,n}}\Rightarrow N(0,1)`. This is a
first-order `\omega` transfer only; it does not optimise `\nu`. The practical
convention is `\nu=\nu_n^k`, not `\nu=\widehat\omega_n`. Random bridge-Hill
weights remain outside the checked result and would need a separate
compact-event/order audit for `B_n(\nu)`.

For the finite-`m` iid/common-marginal distributed route, use
Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version as the
clean source statement for `A_n`; use Theorem 2 plus the supplement proof if
the main-theory chapter needs the broader tail-homoskedastic route or if the
proof is written directly on log scale. DPS Corollary 8 is a relative-error theorem, so if it is
cited as the main source statement, explicitly convert it to log scale through
`x_n=O_P(\ell_n/\sqrt{k})=o_P(1)` and
`\log(1+x_n)=x_n+O_P(x_n^2)`. For `B_n(\nu)`, use the pooled Hill CLT and the
compact-event Taylor expansion
`B_n(\nu)=m(\gamma)(\widehat\gamma_n(\nu)-\gamma)+O_P(k^{-1})`, keeping the
exceptional case `m(\gamma)=0` visible, but note that it is first-order
negligible on the pooled-Weissman benchmark scale because `\ell_n\to\infty`.
For `C_n`, use Daouia--Girard--Stupfler (2020), Proposition 1(i), for the
source-studied ratio error
`\Delta_n=\xi_{\tau_n}/\{\psi(\gamma)Q(1-p_n)\}-1`, then apply only the
elementary log step `C_n=\log(1+\Delta_n)=\Delta_n+R_n^{log}`. The log
remainder is a square-order ledger item; it is controlled on the benchmark
scale under the chosen `\eta_n\to0` route. This validates the component
ledgers, the benchmark order comparison, and the promoted deterministic
two-weight theorem in the live main-theory chapter. The sequential hierarchy
is important and is now the live thesis structure: first state/prove the
deterministic `(\nu,\omega)` theorem; only afterward add the source-admissible
estimated-`\omega` transfer as a corollary; and only then add the conditional
plug-in inference corollary. The next layer is not to promote a one-weight DPS
weight corollary, and it is not to start a lower-order `\nu`-optimality theory
by default.

The checked weight-criterion layer shows that, under `\eta_n\to0`, the
first-order AMSE criterion for the leading pooled-Weissman/geometric quantile
weights is `(\omega^\top B_c^{dist})^2+\omega^\top V_c^{dist}\omega`, up to
the common scale factor `\ell_n^2/k`. This imports DPS deterministic/oracle
variance-optimal and AMSE-optimal formulas for `\omega` only. The subsequent
estimated-weight audit shows that source-admissible DPS estimated weights also
transfer for `\omega`, including plug-in `B_\omega` and `V_\omega` objects
when DPS consistency assumptions hold. This does not choose the bridge-Hill
weights `\nu`, and it does not justify calling `\nu=\omega` optimal. In the
two-weight route, `\nu` is first-order unidentified unless a separate
lower-order optimality theory is developed. The current research decision is
to keep the thesis at this first-order layer by default, not to open
lower-order `\nu`-optimality unless Filippo explicitly asks for it, and to use
the deterministic convention `\nu_n^k=(k_1/k,\ldots,k_m/k)` for downstream
inference work. The plug-in centring and variance route is now mathematically
settled conditionally on DPS consistency, and the narrow finite-sample study
has been regenerated and rewritten around that route. The next open layer is
not to reprove estimated `\omega` transfer, choose `\nu`, choose a new
centring philosophy, or redesign Chapter 4 by default; it is to polish
surrounding thesis prose such as the Introduction and eventual Discussion.

The error is that the thesis was built around a standalone pooled intermediate QB expectile theory:
\[
  \widehat\xi_{\tau_n}^{pool}
  =
  \psi(\widehat\gamma^{pool})\,
  \widehat q^{pool}(\tau_n),
\]
treated as an intermediate-level target with its own CLT, its own two-weight variance formula, and its own closed-form variance-/AMSE-optimal expectile weights. This is not the path the supervisor wants, and it exposes the thesis to unnecessary and fragile derivations.

The live thesis now has the following status:

- `thesis/chapters/01_introduction.tex` is blank thesis prose with `\todo{}`.
- `thesis/chapters/02_background.tex` is substantive and compiled; it now
  includes estimated-weight and plug-in-object propositions supporting the
  promoted main-theory corollaries.
- `archive/pre_pivot/03_pooled_intermediate_placeholder.tex` is the archived
  withdrawn pooled-intermediate placeholder, not live thesis source.
- `thesis/chapters/03_pooled_extreme_expectiles.tex` is compiled and contains the
  promoted two-weight estimator, exact decomposition lemma, deterministic
  theorem, deterministic/oracle `\omega` weight corollary, estimated-`\omega`
  transfer corollary, and plug-in inference corollary with proofs.
- `thesis/chapters/04_finite_sample_study.tex` is compiled and contains the
  current narrow finite-sample study for the promoted estimator and plug-in
  inference route, based on the fresh final simulation artifacts generated on
  2026-06-07.
- `thesis/chapters/05_discussion.tex` is an uncompiled placeholder.
- `notes/source_audit_pooled_extreme_expectile.md` records the active
  two-weight estimator, the exact `A_n(\omega)+B_n(\nu)-C_n` decomposition,
  the `B_n(\nu)` Taylor/order check, the checked deterministic two-weight
  theorem route, the deterministic/oracle DPS weight-criterion match for
  `\omega` only, the source-admissible estimated-`\omega` transfer, the
  principled plug-in standardisation and log-scale interval inversion, the
  fixed practical bridge convention `\nu_n^k=(k_1/k,\ldots,k_m/k)`, and the
  default decision not to open lower-order `\nu` optimality.
- `thesis/main.tex` compiles the Introduction, Background,
  `03_pooled_extreme_expectiles.tex`, and `04_finite_sample_study.tex` before
  the bibliography.

### What Is Affected

- `thesis/chapters/01_introduction.tex`: currently blank except for
  `\todo{}`. When rewriting it, align claims with the promoted main-theory
  results and the narrow Chapter 4 finite-sample findings. Avoid broader-scope
  claims beyond the theorem and regenerated simulation grid.
- `archive/pre_pivot/03_pooled_intermediate_placeholder.tex`: archived
  withdrawn placeholder. The
  pooled intermediate QB CLT, A/B estimator comparison, two-weight optimality
  results, AMSE closed form, CI, and expectile-homogeneity diagnostic should
  not be used as established thesis contributions.
- `thesis/chapters/03_pooled_extreme_expectiles.tex`: live compiled
  main-theory chapter.
  Preserve the current order: exact decomposition, deterministic two-weight
  theorem, `\omega` weight corollary, estimated-`\omega` transfer, then
  plug-in inference. Do not add simulations, broader tail-homoskedastic target
  claims, random `\nu`, or lower-order `\nu` optimality before those layers are
  separately source-grounded.
- Appendix proofs in `thesis/main.tex`: no appendix is currently compiled.
  Individual algebraic ideas from old drafts may be useful as scratch work,
  but do not cite them as validated results.
- `thesis/chapters/04_finite_sample_study.tex` and `simulation/`: the current
  compiled finite-sample study is narrow, post-pivot, and based on the fresh
  final 2026-06-07 run. Keep its claims tied to the promoted estimator,
  selected DPS `\omega` routes, plug-in objects, fixed bridge-Hill convention
  `\nu_n^k`, and the generated artifacts under `thesis/generated/simulation/`.
- Generated tables/figures under `thesis/generated/simulation/`: treat as
  rendered artifacts produced by `simulation/render_results.R`, not hand-written
  thesis prose.

### What To Keep

- The repository layout, LaTeX infrastructure, macros, bibliography, build workflow, and simulation scaffolding.
- The background material on regular variation, Hill, Weissman, expectiles, the expectile--quantile asymptotic equivalence, and Daouia--Padoan--Stupfler optimal pooling, subject to source checking before any new use in promoted theorem prose.
- The source PDFs in `papers/`, especially:
  - `Optimal Pooling.pdf` and `optimal pooling supp.pdf`;
  - `Daouia-Estimationtailrisk-2018.pdf`;
  - `DGS2019.pdf`;
  - `DGS2020.pdf`;
  - `Tail Risk Inference via Expectiles in Heavy-Tailed Time Series.pdf`;
  - `ubes_a_2078332_sm7626.pdf`.
- The corrected facts already identified about `\psi`: it is not monotone on `(0,1)`, and `m(\gamma)=d\log\psi(\gamma)/d\gamma` vanishes near `0.2178`.
- The corrected second-order expectile--quantile constant, now source-checked in the Markdown audit route:
\[
  c(\gamma,\rho)
  =
  \frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}
  +
  \frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho}.
\]

### What Not To Keep As A Contribution

- Do not preserve the old thesis claim that Chapter 3 is a completed standalone pooled-intermediate-expectile theory.
- Do not preserve the old pooled-intermediate two-weight expectile variance/AMSE optimization as a main result. The new two-weight route is different: `\omega` weights the DPS pooled Weissman quantile, while `\nu` weights only the outer bridge-Hill estimator. Any optimality theory for `\nu` must be derived from this new decomposition, not copied from the old Chapter 3 route.
- Do not keep the old claim that the intermediate case is the structural foundation of the extreme case.
- Do not develop arithmetic-vs-geometric expectile pooling unless it becomes necessary. It is currently a parked side question, not part of the least-action path.
- Do not widen to time series, multivariate expectiles, real data, or new methodology outside the rebuilt iid/distributed extreme-expectile target without explicit approval from Filippo.

## Supervisor Feedback To Use As Guide

Filippo met his supervisor on 2026-06-03. The feedback should guide all next work:

1. The current thesis has a huge setup error: it relies too heavily on a closed-form/asymptotic QB expression for expectiles at the intermediate level and then builds a large bespoke theory on top of it.
2. Do not make the closed-form intermediate expectile theory the main contribution. Follow the structure of Daouia--Padoan--Stupfler's optimal-pooling framework more closely.
3. The supervisor was fairly satisfied with the object
\[
  \widehat\xi_{\tau_n}^{pool,\star}
  =
  \psi(\widehat\gamma_n(\omega))\,
  \widehat q_n^\star(\tau_n\mid\omega)
\]
as the object of analysis. Here the pooling is first Padoan's pooled extreme quantile, then the expectile--quantile asymptotic bridge is applied at the pooled level. After the two-weight pivot, treat this supervisor-endorsed object as the diagonal/prototype case `\nu=\omega`, and make the restriction explicit rather than implicit.
4. The supervisor suggested that relaxing the communication assumption to allow local QB expectiles and pooling through the asymptotic equivalence may be essentially the same informationally: a local QB expectile `\psi(\widehat\gamma_j)\widehat q_j^\star` contains no information beyond `(\widehat\gamma_j,\widehat q_j^\star)`, and vice versa when `\widehat\gamma_j` is known.
5. The supervisor had mixed feelings about simply asserting that the limiting distribution is the same as in Padoan's quantile-pooling theorem. It may be true by a speed argument, but it must be proved from the exact decomposition.
6. The supervisor speculated that expectiles might naturally be pooled arithmetically rather than geometrically, but did not elaborate. For now, do not add this as a moving part. Park it unless the main estimator forces a comparison.

## Guiding Research Principles

### First Principles, Not Retrofitting

Do not start from the old theorems and try to salvage them. Start from the estimator, write exact identities, and let the math determine the result. If a term vanishes, prove it. If it survives, keep it. If a rate condition is needed, state it precisely and check whether it is already in the source literature.

### No Hypothetical Control Terms

Keep the thesis free of inferred or anticipated results. It is acceptable to
define exact objects, such as the estimator and the algebraic decomposition
terms. It is not acceptable to introduce a new scale, negligibility statement,
bias term, weight formula, confidence interval, or simulation design before the
source audit and proof justify that specific layer.

The pooled Weissman normalisation `\sqrt{k}/\ell_n` is justified in the
Markdown audit note and promoted main-theory chapter for the deterministic
two-weight theorem and source-admissible estimated-`\omega` transfer under
`\eta_n\to0`, as a conclusion of the exact decomposition. Do not reuse the
normalisation for broader routes, alternative estimators, lower-order
optimality, estimated `\nu`, final intervals, or simulation claims without
rechecking the decomposition.

### Ground Every Step In Previous Work

The rebuilt thesis should be a careful composition of existing results, not a large invention of new machinery. Use:

- Daouia--Padoan--Stupfler for pooled Hill and geometrically pooled Weissman extreme-quantile theory.
- Daouia--Girard--Stupfler and Davison--Padoan--Stupfler for the expectile--quantile asymptotic bridge and its second-order remainder.
- de Haan--Ferreira only for standard EVT inputs that the cited papers invoke or that are unavoidable.

When in doubt, extract the exact source statement from the PDFs and record the page/theorem/proposition before using it.

### Sequential Research

Proceed in small mathematical steps. Do not assume the desired theorem and fill in a proof afterward. The sequence is:

1. define the estimator and record its provenance;
2. decompose it exactly;
3. introduce only neutral notation for the exact terms;
4. identify the exact source results relevant to each term, including assumptions and normalisations;
5. derive which terms contribute and what scale is justified;
6. only then state the theorem, weights, intervals, and simulations.

### Two-Weight Pivot Discipline

For the two-weight route, stay results-agnostic. Do not assume that the
diagonal choice `\nu=\omega` is right, and do not assume that a useful
optimality theory for `\nu` exists. Start from the exact estimator
`\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)`, prove the exact decomposition,
and let the order comparison decide what is visible at the current scale.

At the current first-order scale, the audit note now checks that `\omega`
survives through `A_n(\omega)` and `\nu` vanishes through `B_n(\nu)`. Say
precisely that `\nu` is first-order unidentified; do not fill that gap with an
invented closed form. A choice of `\nu` requires either an explicit convention
or a separately proved lower-order criterion.

### Path Of Least Action

Prefer the leanest defensible result. The less the thesis needs to prove, discuss, or numerically validate, the fewer opportunities there are for errors. Avoid side comparisons, alternative estimators, extra optimality criteria, or new tests unless they are necessary for the main theorem or explicitly requested.

The current least-action path has completed the source audit and promoted the
first-order thesis layer: the deterministic two-weight theorem under
`\eta_n\to0`, the source-admissible estimated-`\omega` transfer corollary under
the DPS random-weight conditions, and the plug-in-centred studentisation with
log-scale multiplicative interval when DPS consistency provides the required
plug-in objects. A hidden design restriction has now been resolved: the
diagonal choice `\nu=\omega` is not forced by the first-order theorem. The
weight `\omega` is first-order optimisable and may be DPS-estimated under
source conditions, while `\nu` remains deterministic and first-order
unidentified. Do not open random `\nu` or lower-order `\nu` optimality by
default. The finite-sample study has now been run and rewritten around the
promoted estimator and inference route; the next thesis work should polish the
surrounding prose, especially the Introduction and eventual Discussion.

### Current Conservative Design Choices

As of 2026-06-05, the agreed conservative research design is:

- Work first in the iid/common-marginal distributed setting. This avoids a separate expectile target-selection problem under tail homoskedastic but nonidentical margins.
- The diagonal one-weight estimator with generic deterministic admissible weights, `\omega^\top\mathbf 1=1`, was proved in the removed Chapter 4 draft and remains useful as audit/history context. It includes meaningful deterministic distributed weights such as `k_j/k` and oracle deterministic population weights, but it hides the design choice `\nu=\omega`.
- The active research design is now the deterministic two-weight class
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)` with
  `\nu^\top\mathbf 1=1` and `\omega^\top\mathbf 1=1`. Here `\omega` weights
  the DPS geometrically pooled Weissman quantile, while `\nu` weights only the
  pooled Hill estimator inside the outer `\psi` bridge.
- For downstream practical inference, fix the bridge-Hill convention
  `\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)`. This is deterministic once the
  intermediate thresholds are chosen and keeps `\nu` separate from estimated
  optimal `\omega`. It is not an optimality result.
- Keep deterministic and random weights sequential. The base theorem uses
  deterministic admissible `(\nu,\omega)`. Random weights enter only later as
  a source-admissible DPS transfer corollary replacing `\omega` by
  `\widehat\omega_n` in the pooled-Weissman component. This sequence is
  standard in DPS, but it is conditional on exact affine normalisation and
  convergence in probability of the estimated weights.
- Use the `\eta_n\to0` route for the first theorem:
  `\eta_n=\sqrt{k}/\{\ell_n Q(1-p_n)\}\to0`. In theorem prose, keep clear
  that `p_n\to0` is only tail movement; the Weissman extreme extrapolation
  regime is `k/(np_n)\to\infty`, together with the DPS scale condition
  `\sqrt{k}/\ell_n\to\infty`, where `\ell_n=\log\{k/(np_n)\}`.
- Under `\eta_n\to0`, the checked first-order limit depends on `\omega` but
  not on `\nu`. This implies that DPS deterministic/oracle variance and AMSE
  weights may be used only for `\omega`, not for `\nu`.
- Do not claim any `\nu` choice is optimal. The chosen practical convention is
  `\nu=\nu_n^k`; the diagonal choice `\nu=\omega` remains only a deterministic
  prototype/special case when `\omega` is deterministic. If Filippo explicitly
  asks for an optimal `\nu`, develop a separate lower-order AMSE theory first.
- The DPS plug-in layer for `\omega` has now been checked at first order:
  estimated variance-optimal weights, estimated AMSE-optimal weights, and
  estimated bias/variance objects transfer when the corresponding DPS source
  consistency conditions hold. This transfer applies to `\omega` only and is
  a corollary after the deterministic base theorem. The associated
  plug-in-centred statistic and log-scale interval inversion are mathematically
  justified conditionally on those same consistency inputs.
- Do not make `\nu` random, including by setting `\nu=\widehat\omega_n`,
  without a separate audit of the compact-event Taylor expansion and order of
  `B_n(\nu)` for the proposed random bridge-Hill convention.
- Do not add simulation claims from the first-order calculation alone.
  The current Chapter 4 claims must be tied to the fresh final simulation
  artifacts and not inferred directly from the theorem. Any new simulation
  claim requires a corresponding regenerated artifact and, if it changes the
  design, a fresh design-version check.
- Keep mathematical research work in `notes/source_audit_pooled_extreme_expectile.md`
  or a new note before moving additional result layers into thesis prose.

### Imported Results Versus New Proof Work

The rebuilt theorem is a careful composition of imported results plus a small
amount of stitching. Be explicit about which is which when extending it.

Directly importable, subject to notation matching and assumption checking:

- Daouia--Padoan--Stupfler pooled Hill CLT for
  `\widehat\gamma_n(v)-\gamma` for any deterministic admissible vector `v`;
  use it with `v=\omega` inside the DPS Weissman source component and with
  `v=\nu` inside the outer bridge term.
- Daouia--Padoan--Stupfler pooled Weissman theorem for the pooled quantile term `A_n`. In the finite-`m` iid/common-marginal route, this is now source-audited through Corollary 8 in the published Bernoulli version; the supplement's log-scale expansion remains the detailed proof source if the thesis needs to work directly on log scale.
- Bellini / Daouia--Girard--Stupfler first-order expectile--quantile bridge `\xi_\tau/Q(\tau)\to\psi(\gamma)`.
- Daouia--Girard--Stupfler (2020), Proposition 1(i), for the second-order
  population ratio expansion of
  `\Delta_\tau=\xi_\tau/\{\psi(\gamma)Q(\tau)\}-1`. In thesis notation this
  yields the two leading deterministic pieces
  `c(\gamma,\rho)A((1-\tau)^{-1})` and
  `\gamma(\gamma^{-1}-1)^\gamma EX/Q(\tau)`, plus
  `o(|A((1-\tau)^{-1})|)+o(Q(\tau)^{-1})`. Do not introduce a new
  `d(\gamma)` shorthand for the mean coefficient, because DPS already uses
  `d_j` elsewhere.
- Daouia--Padoan--Stupfler deterministic/oracle variance- and AMSE-optimal
  weights under `\eta_n\to0` only for the leading pooled-Weissman/geometric
  quantile weights `\omega`.
- Daouia--Padoan--Stupfler estimated-weight and plug-in inference machinery for
  `\omega`, as source-audited in the Markdown note. If DPS proves
  `\widehat\omega_n\to_P\omega`,
  `\widehat B_{\widehat\omega,n}\to_P B_\omega`, and
  `\widehat V_{\widehat\omega,n}\to_P V_\omega` under its conditions, then the
  expectile estimator inherits the same first-order plug-in limit because
  `A_n(\widehat\omega_n)` is source-covered and the additional `B_n(\nu)` and
  `C_n` terms remain negligible under `\eta_n\to0`. This remains an optional
  `\omega` transfer statement only. The plug-in-centred statistic and the
  log-scale multiplicative interval are obtained by Slutsky and inversion of
  the transferred expectile CLT; they are not a direct import of DPS Corollary
  4's quantile interval formula.
- Any optimality theory for the bridge-Hill weights `\nu` remains a separate
  lower-order layer.

Proof work completed in the Markdown audit and promoted where relevant in the
live main-theory chapter:

- The thesis notation has been matched to the source notation, especially
  `p_n=1-\tau_n`, aggregate `k`, aggregate `n`, and the common target
  quantile/expectile.
- The exact diagonal log decomposition `A_n+B_n-C_n` was stated in the removed
  Chapter 4 draft and remains recorded in the audit context.
- The exact two-weight log decomposition
  `A_n(\omega)+B_n(\nu)-C_n` is stated in the audit note and in the live
  decomposition lemma.
- The pooled Weissman component cites DPS Corollary 8 and converts the
  published relative-error result to log scale via
  `x_n=O_P(\ell_n/\sqrt{k})=o_P(1)` and
  `\log(1+x_n)=x_n+O_P(x_n^2)`.
- The sourced DGS ratio expansion is converted into the log term through
  `C_n=\log(1+\Delta_n)=\Delta_n+R_n^{log}`, with the square-order log
  remainder controlled under `\eta_n\to0`.
- The `\eta_n\to\eta\in(0,\infty)` branch is parked as a bridge-shift remark,
  not used as the first theorem route.
- The deterministic/oracle DPS weight-criterion check is recorded in
  `notes/source_audit_pooled_extreme_expectile.md`: under `\eta_n\to0`, the
  first-order criterion for `\omega` is
  `(\omega^\top B_c^{dist})^2+\omega^\top V_c^{dist}\omega`. This criterion
  does not choose `\nu`.
- The deterministic two-weight theorem is recorded in the audit note and
  promoted in `thesis/chapters/03_pooled_extreme_expectiles.tex`: for deterministic
  admissible `(\nu,\omega)`, the first-order limit remains
  `N(B_\omega,V_\omega)` and is independent of `\nu`.
- The source-admissible estimated-`\omega` transfer is recorded in the audit
  note as a corollary after the deterministic theorem: for deterministic
  admissible `\nu` and
  `\widehat\omega_n^\top\mathbf 1=1`, `\widehat\omega_n\to_P\omega`, the
  first-order limit remains `N(B_\omega,V_\omega)`. Consistent DPS plug-in
  `B_\omega` and `V_\omega` objects transfer by Slutsky.
- The conditional plug-in inference corollary is recorded in the audit note:
  for the practical route
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu_n^k,\widehat\omega_n)`, if
  `\widehat B_{\widehat\omega,n}\to_P B_\omega`,
  `\widehat V_{\widehat\omega,n}\to_P V_\omega`, and `V_\omega>0`, then the
  plug-in-centred statistic is asymptotically standard normal and the
  log-scale multiplicative interval follows by inversion.
- The latest housekeeping pass in
  `notes/source_audit_pooled_extreme_expectile.md` makes the sequentiality
  explicit: deterministic `(\nu,\omega)` theorem first; optional estimated
  `\omega` transfer second; conditional plug-in inference third; random `\nu`
  remains unaudited.

Remaining choices after the promoted two-weight, estimated-`\omega`, and
plug-in inference layer:

- Default research decision: stop the main theorem at "any deterministic
  admissible `\nu`" at first order. The base theorem uses deterministic
  `(\nu,\omega)`. A separate optional corollary may use source-admissible
  DPS-estimated `\omega`; `\nu` remains deterministic and first-order
  unidentified, with no `\nu` optimality claim. For downstream inference, use
  the deterministic convention `\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)`.
- The inference route is fixed conditionally on DPS consistency: use the DPS
  plug-in centring and variance objects for the selected `\omega` route when
  they are source-consistent. A no-bias or undersmoothing route would be a
  different assumption layer and should not be introduced by default.
- Optional finite-sample sensitivity checks may compare other deterministic
  `\nu` choices such as `\nu=\omega` or equal weights, but the main practical
  route should use `\nu_n^k` and no `\nu` choice should be described as
  optimal. Chapter 4 now includes deterministic `\nu` sensitivity, including a
  heterogeneous-threshold diagnostic where `k_j/n_j` differs across machines.
- The next prose-sensitive edit is likely the Introduction: update it only
  around the promoted theorem/corollary sequence and the narrow regenerated
  Chapter 4 findings. Do not turn the finite-sample diagnostics into broader
  methodological claims.
- If Filippo explicitly wants optimality for `\nu`, first audit the additional
  mathematics:
  a joint expansion for the leading `A_n(\omega)` term and the bridge-Hill
  `B_n(\nu)` term, cross-covariances, sharper `A_n` and `C_n` remainder
  controls at the `k^{-1/2}` scale, and a precise admissible class for `\nu`.

## Immediate Next Step

The active compiled thesis is `thesis/main.tex` with
`chapters/01_introduction`, `chapters/02_background`,
`chapters/03_pooled_extreme_expectiles`, `chapters/04_finite_sample_study`,
and the bibliography. The active audit trail remains
`notes/source_audit_pooled_extreme_expectile.md`.

The immediate next research step is no longer to promote the first-order
result, reorganise the thesis directory, or run the first final simulation:
those have been done. The next unresolved prose task is to rewrite the
Introduction around the promoted theorem/corollary sequence and the narrow
finite-sample chapter. The remaining uncompiled chapter placeholder is
`05_discussion.tex`.

At first order, DPS variance- and AMSE-optimal weights apply to `\omega` only,
including source-admissible estimated weights. The practical route should use
`\nu_n^k` for the bridge-Hill estimator so that estimated optimal `\omega`
can be used without making `\nu` random. Simulations may later explore
additional finite-sample sensitivity to `\nu`, but the current Chapter 4
already includes the baseline deterministic `\nu` sensitivity and the
heterogeneous-threshold diagnostic. No simulation should be used to claim an
optimal `\nu` without a separately proved lower-order theory.

When extending the promoted main-theory chapter, preserve this order:
deterministic two-weight theorem first; estimated-`\omega` transfer corollary
second; conditional plug-in standardisation and log-scale interval inversion
third, using the fixed `\nu_n^k` bridge convention unless Filippo explicitly
reopens that decision.

## Full Research Plan

### Phase 0: Freeze The Old Contribution Claims

This phase is complete for the current scaffold. Do not reintroduce old
contribution claims while editing. `notes/source_audit_pooled_extreme_expectile.md`
is the audit trail for the rebuilt theorem and should remain the Markdown
research layer for additional derivations before they move into polished
thesis prose.

Completed deliverable:

- exact diagonal estimator definition;
- estimator provenance: Padoan pooled Weissman quantile plus DGS/Bellini expectile--quantile bridge;
- exact diagonal log decomposition;
- neutral term notation, e.g. `A_n+B_n-C_n`;
- source-audit table for each term, including theorem/proposition number, assumptions, and normalisation;
- component ledger for the exact pieces of `A_n`, `B_n`, and `C_n`;
- benchmark order comparison for `A_n+B_n-C_n`;
- a source-check verdict for the deterministic-weight theorem route;
- diagonal theorem draft removed from the live LaTeX scaffold and retained
  only through git history/audit context;
- a deterministic/oracle DPS weight-criterion check under `\eta_n\to0`,
  recorded in the audit note;
- a source-admissible estimated-`\omega` transfer check, principled plug-in
  standardisation, and log-scale interval inversion, recorded in the audit
  note and now promoted to thesis prose;
- no simulation design.

Completed deliverable for the two-weight pivot:

- active two-weight estimator definition
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)`;
- exact two-weight decomposition `A_n(\omega)+B_n(\nu)-C_n`;
- source-check of the `B_n(\nu)` Taylor and pooled-Hill order comparison;
- theorem showing the first-order limit depends on `\omega` only;
- a clear status statement that DPS weights optimise `\omega`, while `\nu`
  is not first-order identified.
- source-admissible estimated-`\omega` transfer for deterministic admissible
  `\nu`, including the condition
  `\widehat\omega_n^\top\mathbf 1=1`,
  `\widehat\omega_n\to_P\omega`, recorded as a transfer corollary rather
  than the base theorem and now promoted to thesis prose.
- conditional plug-in inference for the practical estimator
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu_n^k,\widehat\omega_n)`, using
  source-consistent DPS plug-in centring and variance objects when available.

Remaining deliverable before moving beyond first-order theory:

- no further first-order Markdown proof work is required for the deterministic
  two-weight route, source-admissible estimated-`\omega` transfer, or
  conditional plug-in inference under `\eta_n\to0`;
- the finite-sample simulation design around the promoted estimator, selected
  DPS `\omega` route, plug-in objects, and fixed `\nu_n^k` convention has been
  implemented and run for Chapter 4;
- next, rewrite the surrounding thesis prose, especially the Introduction and
  eventual Discussion;
- if the promoted main-theory chapter is extended, keep the deterministic
  two-weight route first, followed by the separate source-admissible
  estimated-`\omega` corollary and plug-in inference corollary.

### Phase 1: Notation Reset

Separate clearly:

- the intermediate threshold used inside Weissman estimators, usually governed by `k_j`;
- the very-extreme expectile target level, currently denoted generically by `\tau_n`;
- the geometric pooled-Weissman/quantile weights `\omega`;
- the outer bridge-Hill weights `\nu`;
- any logarithmic normaliser that appears in a source theorem.

Avoid using the same symbol for both an intermediate anchor and a very-extreme
target. The old draft blurred this distinction. For the removed diagonal
theorem draft, the checked deterministic two-weight audit, the checked
source-admissible estimated-`\omega` transfer, and the checked conditional
plug-in inference corollary, the justified normalising scale is
`\sqrt{k}/\ell_n` under `\eta_n\to0`; do not assume the same scale for broader
routes, lower-order criteria, estimated `\nu`, simulations, or alternative
estimators. Avoid reusing `\omega` for the outer bridge-Hill estimator unless
explicitly specialising to the diagonal case.

### Phase 2: Source Audit

Completed in the audit layer and promoted to thesis prose for the
deterministic two-weight theorem, the source-admissible estimated-`\omega`
transfer, and the conditional plug-in inference corollary.
Re-read and extract exact source statements again before adding any new layer,
especially lower-order `\nu` optimality, new simulation designs, estimated
`\nu`, or broader target settings. The checked sources for the theorem route
are:

1. Daouia--Padoan--Stupfler pooled Hill CLT.
2. Daouia--Padoan--Stupfler weighted-geometric pooled Weissman theorem.
3. DGS / Bellini / Davison--Padoan--Stupfler expectile--quantile asymptotic equivalence:
\[
  \xi_\tau / Q(\tau) \to \psi(\gamma).
\]
4. The strongest available second-order ratio expansion that can be converted
   by elementary Taylor calculus into a ledger for
\[
  \log \frac{\xi_\tau}{\psi(\gamma)Q(\tau)}.
\]
5. Daouia--Padoan--Stupfler variance- and AMSE-optimal deterministic/oracle
   weights for the leading pooled-Weissman/geometric quantile weights
   `\omega`, source-checked in the audit note for the `\eta_n\to0` route.
6. Daouia--Padoan--Stupfler estimated-weight and plug-in machinery for
   source-admissible `\widehat\omega_n`, source-checked in the audit note for
   the `\eta_n\to0` route.
7. Slutsky/inversion for the transferred plug-in-centred expectile statistic;
   DPS Corollary 4 is only a log-scale quantile-inference analogue, not the
   source of the expectile interval formula.
8. For any proposed optimality theory for `\nu`, source-check or derive the
   needed lower-order joint expansion before writing formulas.

Record theorem/proposition numbers and assumptions. Do not rely on memory.

### Phase 3: Main Exact Decomposition

For the active two-weight route,
\[
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
  =
  \psi(\widehat\gamma_n(\nu))\,
  \widehat q_n^\star(\tau_n\mid\omega),
\]
write
\[
  \log\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
           {\xi_{\tau_n}}
  =
  \log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)}
  +
  \{\log\psi(\widehat\gamma_n(\nu))-\log\psi(\gamma)\}
  -
  \log\frac{\xi_{\tau_n}}{\psi(\gamma)Q(\tau_n)}.
\]

This identity is now checked in the audit note and stated in the live
decomposition lemma. The removed Chapter 4 draft identity was the diagonal
special case `\nu=\omega`.

### Phase 4: Source-Audit Questions For The Three Terms

Completed in the audit layer for the removed diagonal theorem draft, the
deterministic two-weight audit, and the source-admissible estimated-`\omega`
transfer.
For any future route, do not start by choosing a scale. First name the exact terms
\[
  A_n(\omega)
  =
  \log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)},
  \qquad
  B_n(\nu)
  =
  \log\psi(\widehat\gamma_n(\nu))-\log\psi(\gamma),
  \qquad
  C_n
  =
  \log\frac{\xi_{\tau_n}}{\psi(\gamma)Q(\tau_n)}.
\]
Then answer the following questions.

Term 1 (`A_n(\omega)`, source-audited for the finite-`m` iid/common-marginal route):

- Use Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version
  as the clean common-marginal distributed statement for the pooled Weissman
  component.
- The headline source result is relative-error scale; the supplement gives the
  direct log expansion, and the source regime also permits relative-to-log
  Taylor conversion.
- The source normalisation is `\sqrt{k}/\ell_n`, with
  `\ell_n=\log(k/(np_n))`, for `A_n(\omega)` only.
- In the common-marginal route, `A_n^{target}=0` exactly. Do not extend this
  conclusion to the broader tail-homoskedastic route without explicitly
  choosing the target population.

Term 2 (`B_n(\nu)`, source-checked for the two-weight route):

- Use Daouia--Padoan--Stupfler Theorem 1 as the general pooled Hill CLT, and
  Corollary 5 as the clean iid/common-marginal distributed specialisation.
- The pooled Hill CLT gives
  `\widehat\gamma_n(\nu)-\gamma=O_P(k^{-1/2})` and
  `\widehat\gamma_n(\nu)\to_P\gamma` for deterministic admissible `\nu`.
- For any `0<\varepsilon<\min(\gamma,1-\gamma)`, the event
  `|\widehat\gamma_n(\nu)-\gamma|\le\varepsilon` has probability tending to
  one and places the estimator in a compact subset of `(0,1)`.
- On that compact event, Taylor expansion of `g(x)=\log\psi(x)` gives
  `B_n(\nu)=m(\gamma)(\widehat\gamma_n(\nu)-\gamma)+O_P(k^{-1})`.
- Keep the exceptional case `m(\gamma)=0` visible. The completed order
  comparison shows that `B_n(\nu)` is lower order on the pooled-Weissman
  benchmark scale because `\ell_n\to\infty`.

Term 3 (`C_n`, source-audited for the finite-`m` iid/common-marginal route):

- Use Daouia--Girard--Stupfler (2020), Proposition 1(i), for the population
  ratio error `\Delta_n=\xi_{\tau_n}/\{\psi(\gamma)Q(1-p_n)\}-1`.
- The source expansion is a ratio expansion, not a log expansion. The log step
  is our elementary calculus stitching:
  `C_n=\log(1+\Delta_n)=\Delta_n+R_n^{log}`.
- The DGS assumptions are `E|X^-|<\infty`, `0<\gamma<1`, and
  `C_2(\gamma,\rho,A)` with `\rho\le0`; the DPS Weissman route may impose the
  stricter `\rho<0` separately.
- The leading deterministic pieces are
  `c(\gamma,\rho)A(1/p_n)` and
  `\gamma(\gamma^{-1}-1)^\gamma EX/Q(1-p_n)`, plus sourced little-`o`
  remainders.
- The log-conversion remainder is
  `O((|A(1/p_n)|+Q(1-p_n)^{-1})^2)`. This is a ledger item, not a
  negligibility claim.

The note has compared the diagonal and two-weight ledgers on the
pooled-Weissman benchmark scale, recorded the theorem-design fork, preserved
the source-checked diagonal route as history, and supplied the source audit
behind the now-promoted deterministic two-weight theorem,
estimated-`\omega` transfer, and conditional plug-in inference corollary. Keep
the `\eta_n\to\eta\in(0,\infty)` branch visible as a Markdown comparison, but
parked unless Filippo explicitly reopens it.

### Phase 5: Main Theorem

The main first-order theorem is now promoted to live `.tex` prose in
`thesis/chapters/03_pooled_extreme_expectiles.tex`. The previous diagonal first-route
theorem remains useful only as audit/history context: generic deterministic
admissible weights satisfying `\omega^\top\mathbf 1=1` in the finite-`m`
iid/common-marginal distributed setting under `\eta_n\to0`, with DPS
extreme-level assumptions `p_n\to0`, `k/(np_n)\to\infty`, and
`\sqrt{k}/\ell_n\to\infty`, where `\ell_n=\log\{k/(np_n)\}`.

The live theorem uses deterministic two-weight vectors `(\nu,\omega)`. Under
the same route,
`\frac{\sqrt{k}}{\ell_n}\log\{
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)/\xi_{\tau_n}\}`
has limit `N(B_\omega,V_\omega)`. The live chapter then adds the
source-admissible estimated-`\omega` transfer: for deterministic admissible
`\nu` and `\widehat\omega_n^\top\mathbf 1=1`,
`\widehat\omega_n\to_P\omega`, the same limit holds with
`\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)`. The limit depends
on the limiting `\omega` only. Finally, the live chapter adds conditional
plug-in inference for the practical estimator
`\widehat\xi_{\tau_n}^{pool,\star}(\nu_n^k,\widehat\omega_n)`: if DPS gives
source-consistent `\widehat B_{\widehat\omega,n}` and
`\widehat V_{\widehat\omega,n}`, the plug-in-centred statistic is
asymptotically standard normal and the log-scale multiplicative interval is
obtained by inversion.

The active first-order theorem work is closed. Future theorem work should be
treated as a new layer: lower-order `\nu` optimality, random `\nu`, broader
tail-homoskedastic targets, or alternative estimators all require fresh audit
before thesis prose.

### Phase 6: Weights And Intervals

Do not draft a one-weight corollary as if `\nu=\omega` were optimal. The
deterministic two-weight theorem, source-admissible estimated-`\omega`
transfer corollary, and conditional plug-in inference corollary are
source-checked in the audit note and promoted in the live main-theory chapter.
First-order status under `\eta_n\to0`: DPS variance-optimal and AMSE-optimal
deterministic/oracle or estimated weights apply to `\omega`, the
pooled-Weissman/geometric quantile weights, while `\nu` remains deterministic
admissible and first-order unidentified.

The default route is first-order and practical:

1. Use the checked DPS variance-/AMSE-optimal machinery for `\omega` only,
   including source-admissible estimated `\omega` when the DPS consistency
   conditions hold.
2. Use the fixed bridge-Hill convention
   `\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)` for final inference or simulations.
   Other deterministic `\nu` choices may appear only as sensitivity checks;
   none is optimal unless a separate lower-order theory proves it.
3. Use DPS plug-in centring and variance objects for the selected `\omega`
   route whenever the DPS source conditions give their consistency.
4. State confidence intervals only as the inversion of the checked
   plug-in-centred log-scale statistic already promoted in the main-theory
   chapter.
5. Design simulations only after the promoted estimator, selected DPS
   `\omega` route, plug-in objects, and `\nu_n^k` convention are fixed.

There remains a separate optional route:

Genuine two-weight optimality would allow `\nu\ne\omega` and derive a new
lower-order AMSE criterion if Filippo wants an optimal choice of `\nu`. This
requires additional mathematics: a joint expansion of the leading
`A_n(\omega)` term and the lower-order `B_n(\nu)` term, cross-covariance terms,
sharper `A_n` and `C_n` remainder controls at the `k^{-1/2}` scale, and a
precise admissible class for `\nu`. Do not open this route by default.

Estimated plug-in weights and plug-in inference objects for `\omega` are
validated at first order in the audit note and promoted in the live thesis.
They are still not a simulation design. Do not switch to undersmoothing/no-bias
centring unless Filippo explicitly reopens that route and the required
conditions are source-checked.

### Phase 7: Thesis Restructure

Expected lean structure:

1. Introduction: rewritten around pooled extreme expectiles through Padoan pooled Weissman plus expectile bridge.
2. Background: keep and tighten; remove overbuilt intermediate machinery.
3. Main theory: live promoted chapter defining the estimator, proving the theorem through the decomposition, then stating weights and plug-in intervals.
4. Simulation: live Chapter 4 now reports the regenerated narrow finite-sample
   study for the selected `\omega` routes, DPS plug-in objects, promoted
   log-scale interval, and fixed `\nu_n^k` convention.
5. Discussion: limitations and future work.

The old Chapter 3 has already been replaced by the new main-theory chapter.
Do not preserve old pre-pivot material merely because it is already written.

### Phase 8: Simulation Rebuild

This phase is complete for the current Chapter 4. The selected `\omega` route,
DPS plug-in objects, promoted log-scale interval, and fixed `\nu_n^k`
convention are stable for the current narrow finite-sample study, and the
fresh final run has been rendered into thesis artifacts.

Current simulation status:

- simulations use the first-order theorem, DPS estimated-`\omega` transfer, and
  plug-in inference corollary as their mathematical base;
- simulations use `\nu_n^k=(k_1/k,\ldots,k_m/k)` as the main bridge-Hill
  convention;
- deterministic alternatives for `\nu` appear only as finite-sample
  sensitivity analysis, not as evidence of a theoretically optimal `\nu`;
- `simulation/R/sim_functions.R` computes the promoted two-weight pooled
  extreme-expectile estimator and records the exact
  `A_n(\omega)+B_n(\nu)-C_n` decomposition diagnostics;
- exact Pareto plug-in AMSE is source-ineligible by design, while oracle AMSE
  collapses to the variance rule in exact Pareto cases;
- final Chapter 4 artifacts were produced by running smoke checks, final
  finite-sample simulations, final interval diagnostics, rendering tables and
  figures, and rebuilding LaTeX.

Future simulation-code edits should still begin with
`Rscript simulation/run_simulation.R --smoke`, followed by fresh final runs and
`simulation/render_results.R --final` only when the change affects final
artifacts or Filippo explicitly asks for a rerun.

## Repository Layout

```
/
├── AGENTS.md
├── notes/
│   └── source_audit_pooled_extreme_expectile.md
├── papers/
├── archive/
│   └── pre_pivot/
│       └── 03_pooled_intermediate_placeholder.tex
├── simulation/
│   ├── R/sim_functions.R
│   ├── run_simulation.R
│   ├── render_results.R
│   └── results/
└── thesis/
    ├── main.tex
    ├── preamble.tex
    ├── references.bib
    ├── latexmkrc
    ├── build/                    # ignored LaTeX output
    ├── generated/simulation/
    │   ├── figures/
    │   └── tables/
    └── chapters/
        ├── 01_introduction.tex
        ├── 02_background.tex
        ├── 03_pooled_extreme_expectiles.tex
        ├── 04_finite_sample_study.tex
        └── 05_discussion.tex
```

The live `thesis/chapters/` directory should contain only current thesis prose
or explicitly future chapter placeholders. Withdrawn or pre-pivot material
belongs under `archive/`.

## Building The Document

From `thesis/`:

```bash
latexmk -pdf main.tex
latexmk -C
```

The MacTeX distribution at `/Library/TeX/texbin/` has `latexmk`, `pdflatex`, `biber`, and `xelatex` in PATH. After a build failure, latexmk may leave behind `*.bcf-SAVE-ERROR` / `*.bbl-SAVE-ERROR` files; remove them before retrying.

Every file under `thesis/chapters/` and `thesis/preamble.tex` carries a `% !TEX root = .../main.tex` magic comment. Do not compile `preamble.tex` or chapter files standalone.

## Running The Simulation

From the repository root:

```bash
Rscript simulation/run_simulation.R --smoke
Rscript simulation/run_interval_diagnostics.R --smoke
Rscript simulation/run_simulation.R --pilot
Rscript simulation/run_simulation.R --final --cores=8
Rscript simulation/run_interval_diagnostics.R --final --cores=8
Rscript simulation/render_results.R --final
```

The current final Chapter 4 outputs were produced on 2026-06-07 with design
version `two_weight_pooled_extreme_20260607_central_oracle_hetero_nu`. Treat
older timestamped files and any smoke/pilot outputs as audit history only. For
simulation-code edits, run the smoke tests first. Run final simulations and
rendering only after the changed estimator/metrics are settled or Filippo
explicitly asks.

## Notation Conventions

Defaults follow Daouia--Padoan--Stupfler for pooled Hill and Weissman notation; expectile-specific symbols follow DGS / Davison--Padoan--Stupfler where appropriate.

| Macro | Meaning |
|---|---|
| `\expectile{τ}` | Population expectile `\xi_\tau` |
| `\tildexpectile{τ}` | LAWS direct estimator |
| `\hatexpectile{τ}` | Generic estimated expectile / QB plug-in where explicitly stated |
| `\psifn` | Expectile--quantile constant `\psi` |
| `\Quant`, `\hatQuant` | Quantile and quantile estimator |
| `\Wei`, `\hatWei` | Weissman estimator; the macro already includes the star |
| `\Vc`, `\Bc`, `\hatVc`, `\hatBc` | Padoan covariance/bias objects and estimators |
| `\Rjl` | Tail copula between samples |
| `\todist`, `\to_P`, `\toas` | Convergence symbols |
| `\todo{...}` | Visible placeholder |

Common pitfall: writing `\hatWei^\star` triggers a double-superscript error because `\hatWei` already carries the star. Use plain `\hatWei`; encode the level in the argument.

## Bibliography Guidance

Already present in `thesis/references.bib`:

- Davison, Padoan & Stupfler (2023), *Tail risk inference via expectiles in heavy-tailed time series*.
- Padoan & Stupfler (2022), *Joint inference on extreme expectiles for multivariate heavy-tailed distributions*.
- Daouia, Padoan & Stupfler, *Optimal weighted pooling for inference about the tail index and extreme quantiles*.
- Daouia, Girard & Stupfler (2018), *Estimation of tail risk based on extreme expectiles*.
- DGS (2019), DGS (2020), de Haan--Ferreira (2006), Hill (1975), Weissman (1978), and expectile/risk-measure background references.

When adding entries, prefer verified DOIs / journal volumes. Mark unverified pieces with a `% TODO verify` comment rather than inserting `\todo{}` inside a bib field.

## Working Conventions

1. Primary artifact is the thesis. Code changes are allowed for the reproducible finite-sample study under `simulation/`, plus generated tables/figures consumed by LaTeX.
2. Before adding new theorem layers, weights, intervals, or simulations, settle the supporting Markdown derivation/source audit. Do not polish around an unproved extension.
3. Edit existing stubs in place when drafting thesis prose, but do not preserve old sections whose mathematical role has collapsed.
4. Centralise notation. Check `thesis/preamble.tex` before adding symbols.
5. After non-trivial LaTeX edits or regenerated tables/figures, run `latexmk -pdf main.tex` from `thesis/`.
6. For simulation-code edits, run `Rscript simulation/run_simulation.R --smoke` first.
7. Keep scope narrow: iid/common-marginal/distributed setting unless Filippo explicitly approves a broader direction.
8. Prefer source-grounded theorem statements over original closed forms. Every new assumption should be traceable to a source theorem or to a clearly identified additional rate condition.

## What Is Not Here

- A complete final thesis: the Introduction remains a placeholder and the
  Discussion is still uncompiled.
- A real-data application.
- Time-series, multivariate, or dependent-data simulations.
- Production software beyond the narrow R simulation scripts.
