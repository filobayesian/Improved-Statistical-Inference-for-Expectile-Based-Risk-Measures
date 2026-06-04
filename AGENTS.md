# AGENTS.md

Working context for Codex and any other AI assistant collaborating in this repository.

## What This Project Is

A Master's thesis, with LaTeX source and reproducible R simulation support, by Filippo Gombac on pooled inference for extreme expectile-based risk measures. The project extends the optimal-pooling / distributed-inference framework of Daouia, Padoan & Stupfler, *Optimal pooling and distributed inference for the tail index and extreme quantiles*, from extreme quantiles toward extreme expectiles.

Working title: *Improved Statistical Inference for Expectile-Based Risk Measures*.

The research is currently in a reset phase after supervisor feedback on 2026-06-03. Do not treat the existing Chapter 3/4 theory as settled. The new direction is to rebuild from first principles around the pooled extreme-expectile estimator
\[
  \widehat\xi_{\tau_n}^{pool,\star}
  =
  \psi(\widehat\gamma_n(\omega))\,
  \widehat q_n^\star(\tau_n\mid\omega),
\]
where `\widehat q_n^\star(\tau_n\mid\omega)` is the Daouia--Padoan--Stupfler geometrically pooled Weissman extreme-quantile estimator and `\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}` is the high-expectile / high-quantile asymptotic constant.

## Current Repository Status: Research Reset

As of 2026-06-04, the compiled thesis scaffold has been cleaned so it no longer presents the withdrawn pooled-intermediate route as a validated contribution. The old full draft still exists in git history and in generated/stale materials, but the live thesis files now mark the reset explicitly.

Current source-audit status: the `A_n` pooled Weissman component and the `B_n`
plug-in-`\psi` component of the exact decomposition have been validated at
scratch-note level in `notes/source_audit_pooled_extreme_expectile.md`. For
the finite-`m` iid/common-marginal distributed route, use
Daouia--Padoan--Stupfler Corollary 9 as the clean source statement for `A_n`;
use Theorem 2 plus the supplement proof only if Chapter 4 needs the broader
tail-homoskedastic or direct log-expansion route. For `B_n`, use the pooled
Hill CLT and the compact-event Taylor expansion
`B_n=m(\gamma)(\widehat\gamma_n(\omega)-\gamma)+O_P(k^{-1})`, keeping the
exceptional case `m(\gamma)=0` visible. This validates only the component
ledgers for `A_n` and `B_n`, not the final normalisation or theorem for
`A_n+B_n-C_n`.

The error is that the thesis was built around a standalone pooled intermediate QB expectile theory:
\[
  \widehat\xi_{\tau_n}^{pool}
  =
  \psi(\widehat\gamma^{pool})\,
  \widehat q^{pool}(\tau_n),
\]
treated as an intermediate-level target with its own CLT, its own two-weight variance formula, and its own closed-form variance-/AMSE-optimal expectile weights. This is not the path the supervisor wants, and it exposes the thesis to unnecessary and fragile derivations.

The live scaffold now has the following reset status:

- `thesis/chapters/01_introduction.tex` states the new direction without claiming a theorem.
- `thesis/chapters/03_pooled_intermediate.tex` is a withdrawal marker for the old intermediate route.
- `thesis/chapters/04_pooled_extreme.tex` contains only the working estimator, the exact log decomposition, and source-audit questions.
- `thesis/chapters/05_finite_sample.tex` freezes simulations pending a proved theorem.
- `thesis/main.tex` no longer compiles the obsolete proof and finite-sample diagnostic appendices.

### What Is Affected

- `thesis/chapters/01_introduction.tex`: the contribution list and research question must be rewritten only after the new theorem is derived.
- `thesis/chapters/03_pooled_intermediate.tex`: the pooled intermediate QB CLT, A/B estimator comparison, two-weight optimality results, AMSE closed form, CI, and expectile-homogeneity diagnostic should not be used as established thesis contributions.
- `thesis/chapters/04_pooled_extreme.tex`: keep it as a scaffold until the source audit and proof are complete. Do not add a normalisation, negligibility claim, theorem, weights, or interval before deriving them.
- Appendix proofs in `thesis/main.tex`: the old Chapter 3/4 proof appendix has been removed from the compiled draft. Individual algebraic ideas may be useful as scratch work, but do not cite them as validated results.
- `thesis/chapters/05_finite_sample.tex` and `simulation/`: the existing simulations were designed around the old estimator and old weight menu. They are not final evidence for the rebuilt thesis.
- Generated tables/figures under `thesis/tables/simulation/` and `thesis/figures/simulation/`: treat as stale until the new estimator and simulation design are settled.

### What To Keep

- The repository layout, LaTeX infrastructure, macros, bibliography, build workflow, and simulation scaffolding.
- The background material on regular variation, Hill, Weissman, expectiles, the expectile--quantile asymptotic equivalence, and Daouia--Padoan--Stupfler optimal pooling, subject to source rechecking.
- The source PDFs in `papers/`, especially:
  - `Optimal Pooling.pdf` and `optimal pooling supp.pdf`;
  - `Daouia-Estimationtailrisk-2018.pdf`;
  - `DGS2019.pdf`;
  - `DGS2020.pdf`;
  - `Tail Risk Inference via Expectiles in Heavy-Tailed Time Series.pdf`;
  - `ubes_a_2078332_sm7626.pdf`.
- The corrected facts already identified about `\psi`: it is not monotone on `(0,1)`, and `m(\gamma)=d\log\psi(\gamma)/d\gamma` vanishes near `0.2178`.
- The corrected second-order expectile--quantile constant, pending source rechecking before reuse:
\[
  c(\gamma,\rho)
  =
  \frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}
  +
  \frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho}.
\]

### What Not To Keep As A Contribution

- Do not preserve the old thesis claim that Chapter 3 is a completed standalone pooled-intermediate-expectile theory.
- Do not preserve the old two-weight expectile variance/AMSE optimization as a main result unless it is independently rederived and explicitly requested.
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
as the object of analysis. Here the pooling is first Padoan's pooled extreme quantile, then the expectile--quantile asymptotic bridge is applied at the pooled level.
4. The supervisor suggested that relaxing the communication assumption to allow local QB expectiles and pooling through the asymptotic equivalence may be essentially the same informationally: a local QB expectile `\psi(\widehat\gamma_j)\widehat q_j^\star` contains no information beyond `(\widehat\gamma_j,\widehat q_j^\star)`, and vice versa when `\widehat\gamma_j` is known.
5. The supervisor had mixed feelings about simply asserting that the limiting distribution is the same as in Padoan's quantile-pooling theorem. It may be true by a speed argument, but it must be proved from the exact decomposition.
6. The supervisor speculated that expectiles might naturally be pooled arithmetically rather than geometrically, but did not elaborate. For now, do not add this as a moving part. Park it unless the main estimator forces a comparison.

## Guiding Research Principles

### First Principles, Not Retrofitting

Do not start from the old theorems and try to salvage them. Start from the estimator, write exact identities, and let the math determine the result. If a term vanishes, prove it. If it survives, keep it. If a rate condition is needed, state it precisely and check whether it is already in the source literature.

### No Hypothetical Control Terms

Keep the scaffold free of inferred or anticipated results. It is acceptable to define exact objects, such as the estimator and the algebraic decomposition terms. It is not acceptable to introduce a candidate scale, negligibility statement, bias term, weight formula, confidence interval, or simulation design before the source audit and proof justify it.

In particular, do not import the pooled Weissman normalisation `\sqrt{k}/\ell_n` into the new expectile theorem merely because it is plausible. The correct normalisation for the expectile estimator is a conclusion to derive from the three-term decomposition, not an input to the scaffold.

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

### Path Of Least Action

Prefer the leanest defensible result. The less the thesis needs to prove, discuss, or numerically validate, the fewer opportunities there are for errors. Avoid side comparisons, alternative estimators, extra optimality criteria, or new tests unless they are necessary for the main theorem or explicitly requested.

The current least-action path is one estimator, one exact decomposition, one component/source audit, one generic-weight theorem, and only then optimisation. Padoan weights are allowed only if the proved generic-weight theorem yields the same variance or AMSE criterion as Daouia--Padoan--Stupfler.

### Current Conservative Design Choices

As of 2026-06-04, the agreed conservative research design is:

- Work first in the iid/common-marginal distributed setting. This avoids a separate expectile target-selection problem under tail homoskedastic but nonidentical margins.
- Prove the main asymptotic theorem first for generic deterministic admissible weights, with `\omega^\top\mathbf 1=1`. This includes meaningful deterministic distributed weights such as `k_j/k` and oracle deterministic population weights. It excludes, for the first theorem, random plug-in weights estimated from the same data.
- Do not start with variance-optimal or AMSE-optimal weights. First prove the generic-weight theorem, then read off the variance and bias criterion, and only then import Daouia--Padoan--Stupfler weights if the criterion matches.
- Do not derive new expectile-specific closed-form weights unless the generic-weight theorem forces a different objective.
- Do not add estimated weights, confidence intervals, or simulations until the theorem and any justified weight corollary are settled.
- Keep all mathematical scratch work in `notes/source_audit_pooled_extreme_expectile.md` until the theorem is derived. Do not move theorem prose into Chapter 4 while the component ledger and order comparison are still being worked out.

### Imported Results Versus New Proof Work

The rebuilt theorem should be a careful composition of imported results plus a small amount of stitching. Be explicit about which is which.

Directly importable, subject to notation matching and assumption checking:

- Daouia--Padoan--Stupfler pooled Hill CLT for `\widehat\gamma_n(\omega)-\gamma`.
- Daouia--Padoan--Stupfler pooled Weissman theorem for the pooled quantile term `A_n`. In the finite-`m` iid/common-marginal route, this is now source-audited through Corollary 9; the supplement's log-scale expansion remains the detailed proof source if the thesis needs to work directly on log scale.
- Bellini / Daouia--Girard--Stupfler first-order expectile--quantile bridge `\xi_\tau/Q(\tau)\to\psi(\gamma)`.
- Daouia--Girard--Stupfler (2020), Proposition 1(i), for the second-order population ratio expansion of `\xi_\tau/(\psi(\gamma)Q(\tau))`.
- Daouia--Padoan--Stupfler variance- and AMSE-optimal weights only after the generic-weight theorem proves that their optimisation criterion is indeed the relevant one.

New proof work still required:

- Match the thesis notation exactly to the source notation, especially `p_n=1-\tau_n`, the intermediate thresholds `k_j`, and the target quantile/expectile.
- Prove and use the exact log decomposition `A_n+B_n-C_n`.
- Convert the DGS ratio expansion for `C_n` into a log expansion and control the log-conversion remainder.
- Only after the `C_n` component is validated alongside the completed `A_n` and `B_n` audits, compare their orders to determine the correct scale, centring, variance, and bias.

## Immediate Next Step

The active working artifact is `notes/source_audit_pooled_extreme_expectile.md`. It already contains the source audit and a component ledger for `A_n+B_n-C_n`.

The next task is to validate `C_n` in the common-marginal iid/distributed
setting. Confirm the exact Daouia--Girard--Stupfler (2020) Proposition 1(i)
assumptions in the thesis notation, convert the population ratio expansion for
`\xi_{\tau_n}/(\psi(\gamma)Q(\tau_n))` into a log expansion, and control the
log-conversion remainder. Only after `C_n` is validated should the note perform
the order comparison for `A_n+B_n-C_n`. Do not choose or state a final
normalisation, theorem, weights, confidence intervals, or simulation design
until the ledger shows which terms survive and which source assumptions justify
that conclusion.

## Full Research Plan

### Phase 0: Freeze The Old Contribution Claims

This phase is mostly complete in the live scaffold. Do not reintroduce old contribution claims while editing. The current working artifact is `notes/source_audit_pooled_extreme_expectile.md`; use it for scratch derivation outside the polished thesis flow and for discussing the rebuilt mathematical architecture with Filippo and, if needed, the supervisor.

Minimum deliverable:

- exact estimator definition;
- estimator provenance: Padoan pooled Weissman quantile plus DGS/Bellini expectile--quantile bridge;
- exact log decomposition;
- neutral term notation, e.g. `A_n+B_n-C_n`;
- source-audit table for each term, including theorem/proposition number, assumptions, and normalisation;
- component ledger for the exact pieces of `A_n`, `B_n`, and `C_n`, before rate comparison;
- a list of open proof obligations;
- no candidate scale, candidate theorem, weights, intervals, or simulation design unless already derived in the note.

### Phase 1: Notation Reset

Separate clearly:

- the intermediate threshold used inside Weissman estimators, usually governed by `k_j`;
- the very-extreme expectile target level, currently denoted generically by `\tau_n`;
- any logarithmic normaliser that appears in a source theorem.

Avoid using the same symbol for both an intermediate anchor and a very-extreme target. The old draft blurred this distinction. Do not define a final normalising scale for the new expectile estimator until the source audit shows which source normalisations actually survive in the combined decomposition.

### Phase 2: Source Audit

Re-read and extract the exact source statements needed:

1. Daouia--Padoan--Stupfler pooled Hill CLT.
2. Daouia--Padoan--Stupfler weighted-geometric pooled Weissman theorem.
3. DGS / Bellini / Davison--Padoan--Stupfler expectile--quantile asymptotic equivalence:
\[
  \xi_\tau / Q(\tau) \to \psi(\gamma).
\]
4. The strongest available second-order expansion controlling
\[
  \log \frac{\xi_\tau}{\psi(\gamma)Q(\tau)}.
\]
5. Daouia--Padoan--Stupfler variance- and AMSE-optimal weights only after a theorem has identified the relevant variance or AMSE criterion.

Record theorem/proposition numbers and assumptions. Do not rely on memory.

### Phase 3: Main Exact Decomposition

For
\[
  \widehat\xi_{\tau_n}^{pool,\star}
  =
  \psi(\widehat\gamma_n(\omega))\,
  \widehat q_n^\star(\tau_n\mid\omega),
\]
write
\[
  \log\frac{\widehat\xi_{\tau_n}^{pool,\star}}{\xi_{\tau_n}}
  =
  \log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)}
  +
  \{\log\psi(\widehat\gamma_n(\omega))-\log\psi(\gamma)\}
  -
  \log\frac{\xi_{\tau_n}}{\psi(\gamma)Q(\tau_n)}.
\]

This identity is the central object. Everything follows from it.

### Phase 4: Source-Audit Questions For The Three Terms

Do not start this phase by choosing a scale. First name the exact terms
\[
  A_n
  =
  \log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)},
  \qquad
  B_n
  =
  \log\psi(\widehat\gamma_n(\omega))-\log\psi(\gamma),
  \qquad
  C_n
  =
  \log\frac{\xi_{\tau_n}}{\psi(\gamma)Q(\tau_n)}.
\]
Then answer the following questions.

Term 1 (`A_n`, source-audited for the finite-`m` iid/common-marginal route):

- Use Daouia--Padoan--Stupfler Corollary 9 as the clean common-marginal
  distributed statement for the pooled Weissman component.
- The headline source result is relative-error scale; the supplement gives the
  direct log expansion, and the source regime also permits relative-to-log
  Taylor conversion.
- The source normalisation is `\sqrt{k}/\ell_n`, with
  `\ell_n=\log(k/(np_n))`, for `A_n` only.
- In the common-marginal route, `A_n^{target}=0` exactly. Do not extend this
  conclusion to the broader tail-homoskedastic route without explicitly
  choosing the target population.

Term 2 (`B_n`, source-audited for the finite-`m` iid/common-marginal route):

- Use Daouia--Padoan--Stupfler Theorem 1 as the general pooled Hill CLT, and
  Corollary 5 as the clean iid/common-marginal distributed specialisation.
- The pooled Hill CLT gives
  `\widehat\gamma_n(\omega)-\gamma=O_P(k^{-1/2})` and
  `\widehat\gamma_n(\omega)\to_P\gamma`.
- For any `0<\varepsilon<\min(\gamma,1-\gamma)`, the event
  `|\widehat\gamma_n(\omega)-\gamma|\le\varepsilon` has probability tending to
  one and places the estimator in a compact subset of `(0,1)`.
- On that compact event, Taylor expansion of `g(x)=\log\psi(x)` gives
  `B_n=m(\gamma)(\widehat\gamma_n(\omega)-\gamma)+O_P(k^{-1})`.
- Keep the exceptional case `m(\gamma)=0` visible. Do not decide whether `B_n`
  contributes or vanishes under the final theorem scale until after `C_n` is
  validated and the order comparison is performed.

Term 3:

- What exact expectile--quantile expansion applies to `C_n`?
- Is it a ratio expansion, log expansion, or something that must be logged?
- Which second-order and moment assumptions enter?
- On any proposed final normalisation, does `C_n` contribute or vanish? Prove, do not guess.

Only after the `C_n` answer is complete should the note propose a final normalisation for `A_n+B_n-C_n`.

### Phase 5: Main Theorem

Only after Phase 4 and the component-ledger order comparison, state the actual theorem. The first theorem should be for generic deterministic admissible weights satisfying `\omega^\top\mathbf 1=1`, in the iid/common-marginal distributed setting unless Filippo explicitly approves a broader setting. Do not present alternative outcomes as if they are already likely. The theorem should contain exactly the normalisation, centring, variance, bias, and assumptions that the source audit and proof justify.

### Phase 6: Weights And Intervals

Do not derive new expectile-specific closed-form weights unless Phase 5 forces them. Do not start Phase 5 by plugging in variance-optimal or AMSE-optimal weights.

If the proved generic-weight theorem has the same optimisation criterion as Daouia--Padoan--Stupfler, use their variance-optimal or AMSE-optimal weights directly as corollaries. Otherwise, do not import their weights by analogy.

Estimated plug-in weights are a separate layer. Add them only if the required consistency argument is source-grounded and short; otherwise keep the theorem at deterministic admissible weights and deterministic/oracle weight corollaries.

Confidence intervals should follow the main theorem. Bias-centering should be included only if the retained theorem has a nonzero bias term and if the required bias estimators are source-grounded.

### Phase 7: Thesis Restructure

Expected lean structure:

1. Introduction: rewritten around pooled extreme expectiles through Padoan pooled Weissman plus expectile bridge.
2. Background: keep and tighten; remove overbuilt intermediate machinery.
3. Main theory: define the estimator, use the decomposition to prove the theorem, then state weights and intervals if justified.
4. Simulation: redesign only after the main theorem is fixed.
5. Discussion: limitations and future work.

The old Chapter 3 should likely be deleted, shortened to a source/background note, or replaced by the new main-theory chapter. Do not preserve it merely because it is already written.

### Phase 8: Simulation Rebuild

Only after the theorem is stable:

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
- Daouia, Padoan & Stupfler, *Optimal pooling and distributed inference for the tail index and extreme quantiles*.
- Daouia, Girard & Stupfler (2018), *Estimation of tail risk based on extreme expectiles*.
- DGS (2019), DGS (2020), de Haan--Ferreira (2006), Hill (1975), Weissman (1978), and expectile/risk-measure background references.

When adding entries, prefer verified DOIs / journal volumes. Mark unverified pieces with a `% TODO verify` comment rather than inserting `\todo{}` inside a bib field.

## Working Conventions

1. Primary artifact is the thesis. Code changes are allowed for the reproducible finite-sample study under `simulation/`, plus generated tables/figures consumed by LaTeX.
2. Before rewriting thesis text, settle the source-audit research note. Do not polish around an unproved theorem.
3. Edit existing stubs in place when drafting thesis prose, but do not preserve old sections whose mathematical role has collapsed.
4. Centralise notation. Check `thesis/preamble.tex` before adding symbols.
5. After non-trivial LaTeX edits or regenerated tables/figures, run `latexmk -pdf main.tex` from `thesis/`.
6. For simulation-code edits, run `Rscript simulation/run_simulation.R --smoke` first.
7. Keep scope narrow: iid/common-marginal/distributed setting unless Filippo explicitly approves a broader direction.
8. Prefer source-grounded theorem statements over original closed forms. Every assumption in the new main theorem should be traceable to a source theorem or to a clearly identified additional rate condition.

## What Is Not Here

- A validated final thesis structure after the 2026-06-03 reset.
- A real-data application.
- Time-series, multivariate, or dependent-data simulations.
- Production software beyond the narrow R simulation scripts.
