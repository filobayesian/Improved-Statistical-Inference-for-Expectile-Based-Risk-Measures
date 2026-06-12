# Future Directions Handoff

This note records the scoped follow-up items from the review of
`source_audit_pooled_extreme_expectile.md`. These are not changes to the core
estimator or the completed finite-sample design. They are thesis-polish and
future-direction items that can strengthen the exposition around the promoted
two-weight pooled extreme-expectile route.

The active estimator remains

$$
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
  =
  \psi(\widehat\gamma_n(\nu))\,
  \widehat q_n^\star(\tau_n\mid\omega),
$$

with the practical downstream bridge-Hill convention

$$
  \nu=\nu_n^k=(k_1/k,\ldots,k_m/k).
$$

The items below should not be used to replace that design by a random bridge
vector, to open a lower-order optimality theory for `\nu`, or to add new
simulation claims without a separate source and design audit.

## 1. Benchmark / Oracle Equivalence Remark

**Purpose.** Close the loop between the theory in Chapter 3 and the centralised
benchmark used in Chapter 4.

**Current status.** Chapter 3 already shows that the distributed
expectile estimator inherits the first-order law of the DPS pooled-Weissman
component. Chapter 4 already compares the estimator empirically against a
centralised benchmark. What is missing is a short explicit statement that DPS
benchmark equivalence for the quantile component transfers through the
expectile bridge.

**Safe formulation.** Do not argue merely that the distributed and centralised
estimators have the same marginal limit law. That would be too weak. The sound
argument is a direct comparison:

$$
\log\frac{
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
}{
  \widehat\xi_{\tau_n}^{cent,\star}
}
=
\log\frac{
  \widehat q_n^\star(1-p_n\mid\omega)
}{
  \widehat q_n^{cent,\star}(1-p_n)
}
+
\{g(\widehat\gamma_n(\nu))-g(\widehat\gamma_n^{cent})\},
$$

where \(g=\log\psi\). Under the DPS conditions that actually give first-order
benchmark equivalence for the pooled-Weissman quantile,

$$
\frac{\sqrt{k}}{\ell_n}
\log\frac{
  \widehat q_n^\star(1-p_n\mid\omega^{Var})
}{
  \widehat q_n^{cent,\star}(1-p_n)
}
=o_P(1).
$$

The bridge-Hill difference is lower order because both Hill estimators are
\(O_P(k^{-1/2})\) from \(\gamma\), so Taylor expansion gives

$$
g(\widehat\gamma_n(\nu))-g(\widehat\gamma_n^{cent})
=O_P(k^{-1/2}),
\qquad
\frac{\sqrt{k}}{\ell_n}
\{g(\widehat\gamma_n(\nu))-g(\widehat\gamma_n^{cent})\}
=o_P(1).
$$

Therefore, under the same DPS benchmark-equivalence conditions,

$$
\frac{\sqrt{k}}{\ell_n}
\log\frac{
  \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega^{Var})
}{
  \widehat\xi_{\tau_n}^{cent,\star}
}
=o_P(1).
$$

**Placement.** Add as a short remark or corollary after the deterministic
theorem / weight corollary in Chapter 3. Keep the conditions narrow: this is
for the DPS benchmark-equivalence setup, not for arbitrary weights or arbitrary
heterogeneous threshold designs.

## 2. Pre-Pooling Diagnostics

**Purpose.** Give an applied reader a way to check whether pooling is
reasonable before applying the estimator.

**Current status.** The live theorem works in the iid common-marginal setting,
so the pooling assumptions are imposed by design. In applications, however, one
would want diagnostics for common tail index and common tail scale before
pooling.

**DPS tail-index check.** DPS provide a tail-homogeneity statistic for testing
whether the machines share a common extreme-value index,

$$
  \gamma_1=\cdots=\gamma_m.
$$

In the independent distributed case this reduces to a Pearson-type dispersion
of the local Hill estimators around the pooled Hill estimate, using only
\((k_j,\widehat\gamma_j)\). If the local Hill estimates disagree too strongly,
the pooled estimator should not be interpreted as targeting a common tail.

**DPS tail-scale / homoskedasticity check.** DPS also provide a statistic based
on local Weissman log estimates to check whether the extreme quantile targets
are asymptotically equivalent across machines, i.e.

$$
  Q_j(1-p)/Q_\ell(1-p)\to1.
$$

This uses the same transmitted summaries already needed for the pooled
Weissman estimator: \((n_j,k_j,\widehat\gamma_j,X_{n_j-k_j:n_j,j})\).

**Expectile link.** PS22 Lemma A.6 / the corresponding expectile-equivalence
result links quantile and expectile target equality: high expectiles are
asymptotically equivalent across margins if and only if the corresponding high
quantiles are. Therefore the DPS tail-homoskedasticity check is also an
expectile-target equivalence diagnostic.

**Placement.** Add a short subsection or remark near the setup / scope
discussion. Frame this as a diagnostic layer for applications, not as an
additional theorem needed for the iid common-marginal result.

## 3. Theorem Polish Items

These edits do not change the estimator or theorem. They make the current
argument easier to defend.

### Explain the finite-mean range

The broad EVT assumption may start from common \(\gamma>0\), but the expectile
target is finite only in the finite-mean range. The theorem should explicitly
say that the expectile route therefore works under

$$
  0<\gamma<1
$$

together with the stated lower-tail moment condition.

### Interpret the bridge-rate condition

The condition

$$
  \eta_n
  =
  \frac{\sqrt{k}}{\ell_n Q(1-p_n)}
  \to0
$$

should be explained as the condition that makes the deterministic population
expectile-quantile bridge error negligible on the pooled-Weissman scale.

It is useful to add that this is consistent with standard single-sample QB
expectile conditions. For example, if a source condition gives
\(\sqrt{k}/q_{\tau_n}=O(1)\) at the intermediate level and
\(\ell_n\to\infty\), then \(\eta_n\to0\) follows for the more extreme target.

### Gather positivity and domain events

The proof uses logarithms and the map \(\psi(\widehat\gamma)\). State once that
all expansions are taken on a single event whose probability tends to one, on
which:

- the relevant high order statistics are positive;
- the local Weissman estimators are positive;
- the bridge-Hill estimator lies in a compact subinterval of \((0,1)\);
- the log and Taylor expansions are well-defined.

### Cite uniform convergence / Potter bounds

When comparing

$$
  A(1/p_n)/A(n/k),
$$

use the uniform convergence theorem or Potter bounds for regularly varying
functions, rather than an informal pointwise regular-variation argument.

### Recheck source numbering

Before submission, verify the theorem and corollary numbering against the
exact published DPS paper and supplement cited in the bibliography. In
particular, recheck the numbering for the pooled Hill result, pooled Weissman
result, random-weight theorem, and supplement lemmas, because arXiv and
published numbering may differ.

## 4. Random Bridge-Hill Weights: Fix The Justification

**Purpose.** Keep the conservative deterministic bridge convention without
giving a false reason for it.

**Current status.** The thesis fixes the practical bridge-Hill vector at

$$
  \nu_n^k=(k_1/k,\ldots,k_m/k),
$$

and allows estimated weights only in the pooled-Weissman role \(\omega\). This
is a valid and conservative design choice.

**Issue.** The restriction should not be justified by saying that random
\(\nu\) would require a substantial new compact-event audit. If
\(\widehat\nu_n^\top\mathbf 1=1\) and
\(\widehat\nu_n\to_P\nu\), DPS Theorem A.1 gives the corresponding pooled-Hill
stability. The same compact-event Taylor expansion for \(g=\log\psi\) would
then make

$$
  B_n(\widehat\nu_n)=o_P(\ell_n/\sqrt{k})
$$

on the first-order pooled-Weissman scale.

**Suggested wording.** Replace any strong exclusionary language with something
like:

> We keep \(\nu\) deterministic as a conservative implementation convention.
> A random-\(\nu\) extension should follow from the DPS random-weight
> stability result and the same compact-event Taylor argument, but this
> extension is not needed for the estimator or simulations studied here.

**Important boundary.** This remark should not be used to claim an optimal
random bridge-Hill vector, and it should not motivate switching the practical
default to \(\nu=\widehat\omega_n\). At first order, \(\nu\) remains
unidentified.

## 5. Undercoverage Interpretation

**Purpose.** Give the Chapter 4 interval undercoverage a sourced
interpretation rather than leaving it as an unexplained weakness.

**Current status.** Chapter 4 already reports that the first-order log-scale
plug-in intervals under-cover in several finite-sample rows, and it already
frames the intervals as diagnostics rather than as strong finite-sample
calibration claims.

**Interpretation.** This behaviour is consistent with the single-sample
evidence in PS22: Hill-dominated first-order extreme-expectile intervals can
be poorly calibrated in finite samples. The reason is exactly visible in the
current decomposition. The theorem sends \(B_n(\nu)\) and \(C_n\) to zero on
the \(\sqrt{k}/\ell_n\) scale, but the simulation diagnostics show that these
terms need not be numerically tiny at the sample sizes studied.

In finite samples, improved calibration may require retaining:

- a population bridge / mean-bias correction;
- the contribution of estimating \(\gamma\) through
  \(\psi(\widehat\gamma)\);
- the covariance between the Hill part and the quantile/intermediate part.

Those are precisely the kinds of corrections studied in the single-sample
PS22 inference layer.

**Minimal thesis addition.** Add one paragraph in Chapter 4 or the Discussion:

> The observed undercoverage is consistent with the single-sample findings of
> PS22, where first-order Hill-dominated extreme-expectile intervals can have
> poor finite-sample calibration. Their refined log-scale corrections retain
> bridge-bias and variance terms that are asymptotically negligible in the
> first-order theory but still visible at practical sample sizes. Extending
> that correction to the present distributed estimator would be a separate
> lower-order inference layer, and may require additional communicated
> summaries such as local means. The intervals here are therefore interpreted
> as diagnostics of the first-order plug-in route rather than as a claim of
> reliable finite-sample calibration.

**Boundary.** Do not add corrected variance theory, bias-corrected simulations,
or a new interval formula unless a separate source audit and simulation design
are carried out.
