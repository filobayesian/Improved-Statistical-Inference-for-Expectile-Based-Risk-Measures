# AGENTS.md

Working context for Codex and any other AI assistant collaborating in this repository.

## What This Project Is

A Master's thesis, with LaTeX source and reproducible R simulation support, by Filippo Gombac on pooled inference for extreme expectile-based risk measures. The project extends the optimal-pooling / distributed-inference framework of Daouia, Padoan & Stupfler, *Optimal weighted pooling for inference about the tail index and extreme quantiles*, from extreme quantiles toward extreme expectiles.

Working title: *Improved Statistical Inference for Expectile-Based Risk Measures*.

The research is currently in a reset phase after supervisor feedback on 2026-06-03. Do not treat the old Chapter 3 route, old Chapter 4 route, or any result beyond the current Theorem 4.1 as settled. The new direction is to rebuild from first principles around the pooled extreme-expectile estimator. As of the 2026-06-05 two-weight design pivot, the active estimator class is
\[
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
  =
  \psi(\widehat\gamma_n(\nu))\,
  \widehat q_n^\star(\tau_n\mid\omega),
\]
where `\widehat q_n^\star(\tau_n\mid\omega)` is the Daouia--Padoan--Stupfler geometrically pooled Weissman extreme-quantile estimator, `\widehat\gamma_n(\nu)` is a separately pooled Hill estimator used only in the outer expectile bridge, and `\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}` is the high-expectile / high-quantile asymptotic constant. The previous one-weight estimator is the diagonal special case `\nu=\omega`, not the active unrestricted design.

## Current Repository Status: First Rebuilt Theorem And Two-Weight Pivot

As of 2026-06-05, the compiled thesis no longer presents the withdrawn
pooled-intermediate route as a validated contribution. The old full draft still
exists in git history and in generated/stale materials, but the live thesis
files now mark the reset explicitly and contain the first rebuilt theorem. A
new design issue has now been identified: the first theorem used the same
weight vector in the DPS pooled Weissman quantile and in the outer
`\psi(\widehat\gamma)` bridge. This equality is not forced by the first-order
theory and should no longer be treated as the active default.

Current source-audit status: the `A_n` pooled Weissman component, the `B_n`
plug-in-`\psi` component, and the `C_n` population bridge component of the
exact decomposition have been source-checked in
`notes/source_audit_pooled_extreme_expectile.md` against the local PDFs of
Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version, the
DPS supplement proof of Theorem 2, and Daouia--Girard--Stupfler (2020),
Proposition 1(i). The source check confirmed the finite-`m`
iid/common-marginal deterministic-weight route under
`\eta_n=\sqrt{k}/\{\ell_n Q(1-p_n)\}\to0`, provided the theorem carries the
source conventions on common continuous iid data, aggregate
`n=\sum_j n_j`, aggregate `k=\sum_j k_j`, and eventual upper-tail positivity
for log-Weissman expressions.

`thesis/chapters/04_pooled_extreme.tex` now contains Theorem 4.1, a generic
deterministic-weight CLT for the diagonal estimator
`\widehat\xi_{\tau_n}^{pool,\star}(\omega,\omega)` under `\eta_n\to0`,
together with a proof from the exact `A_n+B_n-C_n` decomposition. On the
pooled-Weissman benchmark scale `s_{A,n}=\sqrt{k}/\ell_n`, the theorem shows
that `A_n` carries the DPS stochastic component, `B_n` is lower order, and the
DGS population bridge `C_n` is lower order under the chosen `\eta_n\to0`
route. The finite nonzero branch `\eta_n\to\eta\in(0,\infty)` remains visible
only as a parked bridge-shift remark; it is not the current thesis route.

The two-weight pivot does not invalidate the first-order mathematical work, but
it changes the active research target. The decomposition should be rewritten as
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
`\eta_n\to0` route, the same Taylor argument should give
`(\sqrt{k}/\ell_n)B_n(\nu)=o_P(1)` for any deterministic admissible `\nu`.
Consequently the expected two-weight first-order limit depends on `\omega` but
not on `\nu`. This must be written and checked in the audit note before any
weight corollary is promoted.

For the finite-`m` iid/common-marginal distributed route, use
Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version as the
clean source statement for `A_n`; use Theorem 2 plus the supplement proof if
Chapter 4 needs the broader tail-homoskedastic route or if the proof is written
directly on log scale. DPS Corollary 8 is a relative-error theorem, so if it is
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
scale under the chosen `\eta_n\to0` route. This validates the component ledgers,
the benchmark order comparison, and the Chapter 4 deterministic-weight theorem
route for the diagonal one-weight estimator. The next layer is not to promote
the one-weight DPS weight corollary. The next layer is to generalise the audit
and theorem statement to deterministic two-weight estimators
`(\nu,\omega)`.

The existing scratch weight-criterion check remains useful but must be
reinterpreted. It shows that, under `\eta_n\to0`, the first-order AMSE
criterion for the leading pooled-Weissman/geometric quantile weights is
`(\omega^\top B_c^{dist})^2+\omega^\top V_c^{dist}\omega`, up to the common
scale factor `\ell_n^2/k`. This imports DPS deterministic/oracle
variance-optimal and AMSE-optimal formulas for `\omega` only. It does not
choose the bridge-Hill weights `\nu`, and it does not justify calling
`\nu=\omega` optimal. In the two-weight route, `\nu` is first-order
unidentified unless a separate lower-order optimality theory is developed.
This also does not yet validate estimated plug-in weights, confidence
intervals, or simulation design.

The error is that the thesis was built around a standalone pooled intermediate QB expectile theory:
\[
  \widehat\xi_{\tau_n}^{pool}
  =
  \psi(\widehat\gamma^{pool})\,
  \widehat q^{pool}(\tau_n),
\]
treated as an intermediate-level target with its own CLT, its own two-weight variance formula, and its own closed-form variance-/AMSE-optimal expectile weights. This is not the path the supervisor wants, and it exposes the thesis to unnecessary and fragile derivations.

The live scaffold now has the following status:

- `thesis/chapters/01_introduction.tex` states Theorem 4.1 as the first rebuilt contribution and keeps weights, intervals, and simulations sequential.
- `thesis/chapters/03_pooled_intermediate.tex` is a withdrawal marker for the old intermediate route.
- `thesis/chapters/04_pooled_extreme.tex` contains the diagonal one-weight theorem, its proof, and a parked bridge-shift remark. It must be revised only after the two-weight audit is settled.
- `notes/source_audit_pooled_extreme_expectile.md` now records the deterministic/oracle DPS weight-criterion match for `\omega` under `\eta_n\to0`, and a scratch check identifying the hidden same-weight restriction. Promote the two-weight route there before editing theorem prose.
- `thesis/chapters/05_finite_sample.tex` freezes simulations pending theorem-driven choices of weights, centring, and standard errors.
- `thesis/main.tex` no longer compiles the obsolete proof and finite-sample diagnostic appendices.

### What Is Affected

- `thesis/chapters/01_introduction.tex`: the contribution framing currently reflects Theorem 4.1. It should not be broadened to the two-weight route until the audit note has a checked two-weight theorem statement and proof. Do not add weight, interval, or simulation claims until those layers are proved.
- `thesis/chapters/03_pooled_intermediate.tex`: the pooled intermediate QB CLT, A/B estimator comparison, two-weight optimality results, AMSE closed form, CI, and expectile-homogeneity diagnostic should not be used as established thesis contributions.
- `thesis/chapters/04_pooled_extreme.tex`: Theorem 4.1 is accepted thesis prose for the narrow diagonal deterministic-weight route, but the active research direction is now the two-weight estimator. Do not move weight corollaries into thesis prose before the two-weight theorem route is source-checked. Do not add intervals, random plug-in weights, simulations, or broader tail-homoskedastic target claims before they are separately source-grounded.
- Appendix proofs in `thesis/main.tex`: the old Chapter 3/4 proof appendix has been removed from the compiled draft. Individual algebraic ideas may be useful as scratch work, but do not cite them as validated results.
- `thesis/chapters/05_finite_sample.tex` and `simulation/`: the existing simulations were designed around the old estimator and old weight menu. They are not final evidence for the rebuilt thesis and should stay frozen until weight/standard-error choices are settled.
- Generated tables/figures under `thesis/tables/simulation/` and `thesis/figures/simulation/`: treat as stale until the new estimator and simulation design are settled.

### What To Keep

- The repository layout, LaTeX infrastructure, macros, bibliography, build workflow, and simulation scaffolding.
- The background material on regular variation, Hill, Weissman, expectiles, the expectile--quantile asymptotic equivalence, and Daouia--Padoan--Stupfler optimal pooling, subject to source checking before any new use beyond Theorem 4.1.
- The source PDFs in `papers/`, especially:
  - `Optimal Pooling.pdf` and `optimal pooling supp.pdf`;
  - `Daouia-Estimationtailrisk-2018.pdf`;
  - `DGS2019.pdf`;
  - `DGS2020.pdf`;
  - `Tail Risk Inference via Expectiles in Heavy-Tailed Time Series.pdf`;
  - `ubes_a_2078332_sm7626.pdf`.
- The corrected facts already identified about `\psi`: it is not monotone on `(0,1)`, and `m(\gamma)=d\log\psi(\gamma)/d\gamma` vanishes near `0.2178`.
- The corrected second-order expectile--quantile constant, now source-checked for the Chapter 4 theorem route:
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

The pooled Weissman normalisation `\sqrt{k}/\ell_n` is now justified only for
the narrow diagonal Theorem 4.1 route under `\eta_n\to0`, as a conclusion of
the three-term decomposition. It is expected to survive the deterministic
two-weight generalisation because `B_n(\nu)` is lower order on that scale, but
this must be written and checked before being used as thesis prose. Do not
reuse the normalisation for broader routes, alternative estimators, lower-order
optimality, or simulation claims without rechecking the decomposition.

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

At the current first-order scale, the working hypothesis is that `\omega`
survives through `A_n(\omega)` and `\nu` vanishes through `B_n(\nu)`, but this
must be checked in the audit note. If `\nu` vanishes, say precisely that it is
first-order unidentified; do not fill that gap with an invented closed form. A
choice of `\nu` requires either an explicit convention or a separately proved
lower-order criterion.

### Path Of Least Action

Prefer the leanest defensible result. The less the thesis needs to prove, discuss, or numerically validate, the fewer opportunities there are for errors. Avoid side comparisons, alternative estimators, extra optimality criteria, or new tests unless they are necessary for the main theorem or explicitly requested.

The current least-action path has completed one diagonal estimator, one exact
decomposition, one source audit, one generic deterministic-weight theorem, and
one deterministic/oracle weight-criterion check for the DPS pooled-Weissman
weights. A hidden design restriction has now been identified: the diagonal
choice `\nu=\omega` is not forced by the first-order theorem. The next
least-action layer is therefore to generalise the estimator, decomposition, and
Theorem 4.1 route to deterministic two-weight vectors `(\nu,\omega)` before
any weight corollary is promoted.

### Current Conservative Design Choices

As of 2026-06-05, the agreed conservative research design is:

- Work first in the iid/common-marginal distributed setting. This avoids a separate expectile target-selection problem under tail homoskedastic but nonidentical margins.
- The main asymptotic theorem has now been proved first for the diagonal one-weight estimator with generic deterministic admissible weights, `\omega^\top\mathbf 1=1`. This includes meaningful deterministic distributed weights such as `k_j/k` and oracle deterministic population weights, but it hides the design choice `\nu=\omega`.
- The active research design is now the deterministic two-weight class
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)` with
  `\nu^\top\mathbf 1=1` and `\omega^\top\mathbf 1=1`. Here `\omega` weights
  the DPS geometrically pooled Weissman quantile, while `\nu` weights only the
  pooled Hill estimator inside the outer `\psi` bridge.
- Use the `\eta_n\to0` route for the first theorem:
  `\eta_n=\sqrt{k}/\{\ell_n Q(1-p_n)\}\to0`. The theorem should make clear
  that `p_n\to0` is only tail movement; the Weissman extreme extrapolation
  regime is `k/(np_n)\to\infty`, together with the DPS scale condition
  `\sqrt{k}/\ell_n\to\infty`, where `\ell_n=\log\{k/(np_n)\}`.
- Under `\eta_n\to0`, expect the first-order limit to depend on `\omega` but
  not on `\nu`. This implies that DPS deterministic/oracle variance and AMSE
  weights may be used only for `\omega`, not for `\nu`.
- Do not claim `\nu=\omega` is optimal. If the diagonal choice is retained, it
  must be described as a convention or special case. If `\nu` is to be chosen
  optimally, develop a separate lower-order AMSE theory first.
- Do not add estimated weights, confidence intervals, or simulations until the
  deterministic two-weight theorem and the `\omega`/`\nu` weight-status split
  are settled.
- Keep new mathematical scratch work in `notes/source_audit_pooled_extreme_expectile.md` or a new note before moving additional results into thesis prose.

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
  quantile weights `\omega`. Estimated plug-in weights and any optimality
  theory for the bridge-Hill weights `\nu` remain separate layers.

Proof work completed for Theorem 4.1:

- The thesis notation has been matched to the source notation, especially
  `p_n=1-\tau_n`, aggregate `k`, aggregate `n`, and the common target
  quantile/expectile.
- The exact log decomposition `A_n+B_n-C_n` is stated and used in Chapter 4.
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

New proof work required for the two-weight pivot:

- Rewrite the active estimator in the audit note as
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)`.
- Rewrite the exact decomposition as `A_n(\omega)+B_n(\nu)-C_n`.
- Check that the existing source statements and Taylor proof give
  `B_n(\nu)=m(\gamma)\{\widehat\gamma_n(\nu)-\gamma\}+O_P(k^{-1})` and
  `(\sqrt{k}/\ell_n)B_n(\nu)=o_P(1)` for deterministic admissible `\nu`.
- Restate the first-order theorem candidate for deterministic admissible
  `(\nu,\omega)` and verify that the limit remains `N(B_\omega,V_\omega)`.
- Reclassify the existing DPS weight formulas as first-order formulas for
  `\omega` only.
- Decide explicitly whether the thesis will stop at "any deterministic
  admissible `\nu`" plus a practical convention, or whether it will develop a
  lower-order AMSE criterion to choose `\nu`.
- If developing optimality for `\nu`, first audit the additional mathematics:
  a joint expansion for the leading `A_n(\omega)` term and the bridge-Hill
  `B_n(\nu)` term, cross-covariances, sharper `A_n` and `C_n` remainder
  controls at the `k^{-1/2}` scale, and a precise admissible class for `\nu`.

## Immediate Next Step

The active thesis result is Theorem 4.1 in
`thesis/chapters/04_pooled_extreme.tex`; the active audit trail is
`notes/source_audit_pooled_extreme_expectile.md`.

The immediate next task is to make the two-weight route precise in
`notes/source_audit_pooled_extreme_expectile.md`, not to draft a one-weight
corollary. Promote the current scratch observation into an active design audit:
define `\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)`, prove the exact
`A_n(\omega)+B_n(\nu)-C_n` decomposition, check the order of `B_n(\nu)`, and
state the deterministic two-weight theorem candidate under `\eta_n\to0`.

Only after that theorem is source-checked should the weight layer be revisited.
At first order, DPS variance- and AMSE-optimal weights apply to `\omega` only;
`\nu` remains deterministic admissible and first-order unidentified. Do not add
estimated plug-in weights, confidence intervals, simulations, or a
lower-order optimality theory for `\nu` until that extra layer is deliberately
audited.

## Full Research Plan

### Phase 0: Freeze The Old Contribution Claims

This phase is complete for the current scaffold. Do not reintroduce old
contribution claims while editing. `notes/source_audit_pooled_extreme_expectile.md`
is the audit trail for the rebuilt theorem and should remain the scratch area
for additional derivations before they move into polished thesis prose.

Completed deliverable:

- exact diagonal estimator definition;
- estimator provenance: Padoan pooled Weissman quantile plus DGS/Bellini expectile--quantile bridge;
- exact log decomposition;
- neutral term notation, e.g. `A_n+B_n-C_n`;
- source-audit table for each term, including theorem/proposition number, assumptions, and normalisation;
- component ledger for the exact pieces of `A_n`, `B_n`, and `C_n`;
- benchmark order comparison for `A_n+B_n-C_n`;
- a source-check verdict for the deterministic-weight theorem route;
- Theorem 4.1 in Chapter 4;
- a deterministic/oracle DPS weight-criterion check under `\eta_n\to0`,
  recorded in the audit note;
- no estimated weights, intervals, or simulation design.

New deliverable for the two-weight pivot:

- active two-weight estimator definition
  `\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)`;
- exact two-weight decomposition `A_n(\omega)+B_n(\nu)-C_n`;
- source-check of the `B_n(\nu)` Taylor and pooled-Hill order comparison;
- theorem candidate showing the first-order limit depends on `\omega` only;
- a clear status statement that DPS weights optimise `\omega`, while `\nu`
  is not first-order identified.

### Phase 1: Notation Reset

Separate clearly:

- the intermediate threshold used inside Weissman estimators, usually governed by `k_j`;
- the very-extreme expectile target level, currently denoted generically by `\tau_n`;
- the geometric pooled-Weissman/quantile weights `\omega`;
- the outer bridge-Hill weights `\nu`;
- any logarithmic normaliser that appears in a source theorem.

Avoid using the same symbol for both an intermediate anchor and a very-extreme
target. The old draft blurred this distinction. For Theorem 4.1 the justified
normalising scale is `\sqrt{k}/\ell_n` under `\eta_n\to0`; do not assume the
same scale for broader routes, lower-order criteria, or alternative
estimators. Avoid reusing `\omega` for the outer bridge-Hill estimator in new
scratch work unless explicitly specialising to the diagonal case.

### Phase 2: Source Audit

Completed for Theorem 4.1. Re-read and extract exact source statements again
before adding any new layer, especially weights, intervals, random weights, or
broader target settings. The checked sources for the theorem are:

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
6. For any proposed optimality theory for `\nu`, source-check or derive the
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

This identity is the central object for the next audit step. The existing
Chapter 4 identity is the diagonal special case `\nu=\omega`.

### Phase 4: Source-Audit Questions For The Three Terms

Completed for the diagonal Theorem 4.1. For the two-weight route, do not start
by choosing a scale. First name the exact terms
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

Term 1 (`A_n`, source-audited for the finite-`m` iid/common-marginal route):

- Use Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version
  as the clean common-marginal distributed statement for the pooled Weissman
  component.
- The headline source result is relative-error scale; the supplement gives the
  direct log expansion, and the source regime also permits relative-to-log
  Taylor conversion.
- The source normalisation is `\sqrt{k}/\ell_n`, with
  `\ell_n=\log(k/(np_n))`, for `A_n` only.
- In the common-marginal route, `A_n^{target}=0` exactly. Do not extend this
  conclusion to the broader tail-homoskedastic route without explicitly
  choosing the target population.

Term 2 (`B_n(\nu)`, to be source-checked for the two-weight route):

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
  comparison should show that `B_n(\nu)` is lower order on the pooled-Weissman
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

The note has compared the diagonal `A_n`, `B_n`, and `C_n` ledgers on the
pooled-Weissman benchmark scale, recorded the theorem-design fork, and supplied
the source-checked route now written as Theorem 4.1. The next note update must
redo this notation for `A_n(\omega)+B_n(\nu)-C_n`. Keep the
`\eta_n\to\eta\in(0,\infty)` branch visible as a scratch-note comparison and
Chapter 4 remark, but parked unless Filippo explicitly reopens it.

### Phase 5: Main Theorem

Completed for the diagonal first route. Chapter 4 now contains Theorem 4.1 for
generic deterministic admissible weights satisfying `\omega^\top\mathbf 1=1`
in the finite-`m` iid/common-marginal distributed setting under
`\eta_n\to0`. The theorem keeps the DPS extreme-level assumptions explicit:
`p_n\to0`, `k/(np_n)\to\infty`, and `\sqrt{k}/\ell_n\to\infty`, with
`\ell_n=\log\{k/(np_n)\}`. Its proof shows the relative-to-log conversion for
`A_n`, the Taylor negligibility of `B_n`, and the ratio-to-log conversion plus
rate controls for `C_n`.

The active theorem work is now to restate this result for deterministic
two-weight vectors `(\nu,\omega)`. Expected result, to be proved in the note
before thesis prose: under the same route,
`\frac{\sqrt{k}}{\ell_n}\log\{
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)/\xi_{\tau_n}\}`
has limit `N(B_\omega,V_\omega)`. The limit should depend on `\omega` only.

### Phase 6: Weights And Intervals

Current active phase after the two-weight pivot. Do not draft a one-weight
corollary until the deterministic two-weight theorem is source-checked.
Expected first-order status under `\eta_n\to0`: DPS variance-optimal and
AMSE-optimal deterministic/oracle weights apply to `\omega`, the
pooled-Weissman/geometric quantile weights, while `\nu` remains deterministic
admissible and first-order unidentified.

There are then two possible routes:

1. Diagonal convention: set `\nu=\omega` after the two-weight theorem is
   proved. This allows DPS weights to be used as a coherent one-vector
   implementation choice, but it must be described as a restriction/convention,
   not as a separate optimality result for the outer bridge-Hill estimator.
2. Genuine two-weight optimality: allow `\nu\ne\omega` and derive a new
   lower-order AMSE criterion if Filippo wants an optimal choice of `\nu`.
   This requires additional mathematics: a joint expansion of the leading
   `A_n(\omega)` term and the lower-order `B_n(\nu)` term, cross-covariance
   terms, sharper `A_n` and `C_n` remainder controls at the `k^{-1/2}` scale,
   and a precise admissible class for `\nu`.

Estimated plug-in weights are a separate layer. Add them only if the required
consistency argument is source-grounded and short; otherwise keep the result at
deterministic admissible weights and deterministic/oracle `\omega` corollaries.

Confidence intervals should follow only after the deterministic weight and
standard-error layer is settled. Bias-centering should be included only if the
retained theorem/corollary has a nonzero bias term and if the required bias
estimators are source-grounded.

### Phase 7: Thesis Restructure

Expected lean structure:

1. Introduction: rewritten around pooled extreme expectiles through Padoan pooled Weissman plus expectile bridge.
2. Background: keep and tighten; remove overbuilt intermediate machinery.
3. Main theory: define the estimator, use the decomposition to prove the theorem, then state weights and intervals if justified.
4. Simulation: redesign only after weights, centring, and standard errors are fixed.
5. Discussion: limitations and future work.

The old Chapter 3 should likely be deleted, shortened to a source/background note, or replaced by the new main-theory chapter. Do not preserve it merely because it is already written.

### Phase 8: Simulation Rebuild

Only after weights, centring, and standard errors are stable:

- update `simulation/R/sim_functions.R` to compute the new estimator;
- remove old estimator rows that correspond only to the obsolete two-weight intermediate theory;
- run `Rscript simulation/run_simulation.R --smoke`;
- run pilot/final only when Filippo asks or when the theorem-driven design is settled;
- regenerate tables/figures and rebuild LaTeX afterward.

## Repository Layout

```
/
├── AGENTS.md
├── notes/
│   └── source_audit_pooled_extreme_expectile.md
├── papers/
├── simulation/
│   ├── R/sim_functions.R
│   ├── run_simulation.R
│   ├── render_results.R
│   └── results/
└── thesis/
    ├── main.tex
    ├── preamble.tex
    ├── references.bib
    ├── figures/simulation/
    ├── tables/simulation/
    └── chapters/
        ├── 01_introduction.tex
        ├── 02_background.tex
        ├── 03_pooled_intermediate.tex
        ├── 04_pooled_extreme.tex
        ├── 05_finite_sample.tex
        └── 06_discussion.tex
```

The files are aligned only as a reset scaffold. Treat the layout as a workspace, not as a statement that the chapter structure is final.

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
Rscript simulation/run_simulation.R --pilot
Rscript simulation/run_simulation.R --final --cores=8
Rscript simulation/render_results.R --final
```

The existing simulation outputs were produced for the old design. Do not use them as final evidence for the rebuilt thesis. For simulation-code edits, run the smoke test first. Run pilot/final only after the new estimator and metrics are settled or Filippo explicitly asks.

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
| `\todist`, `\toprob`, `\toas` | Convergence symbols |
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
2. Before adding new theorem layers, weights, intervals, or simulations, settle the supporting scratch derivation/source audit. Do not polish around an unproved extension.
3. Edit existing stubs in place when drafting thesis prose, but do not preserve old sections whose mathematical role has collapsed.
4. Centralise notation. Check `thesis/preamble.tex` before adding symbols.
5. After non-trivial LaTeX edits or regenerated tables/figures, run `latexmk -pdf main.tex` from `thesis/`.
6. For simulation-code edits, run `Rscript simulation/run_simulation.R --smoke` first.
7. Keep scope narrow: iid/common-marginal/distributed setting unless Filippo explicitly approves a broader direction.
8. Prefer source-grounded theorem statements over original closed forms. Every new assumption should be traceable to a source theorem or to a clearly identified additional rate condition.

## What Is Not Here

- A validated final thesis structure after the 2026-06-03 reset.
- A real-data application.
- Time-series, multivariate, or dependent-data simulations.
- Production software beyond the narrow R simulation scripts.
