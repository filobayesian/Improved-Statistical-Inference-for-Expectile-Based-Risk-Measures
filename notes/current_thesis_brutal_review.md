# Brutal review of `main.pdf`: pooled extreme-expectile thesis draft

**Review date:** 2026-06-06  
**Scope:** mathematical and source-use audit of the current thesis draft `main.pdf`, with special attention to whether the previous weight pathology has been repaired.  
**Method:** I rebuilt Chapter 3 from the exact estimator identity, checked the theorem assumptions against the proof obligations, compared the thesis implementation against the earlier source-audit layer, and rechecked the load-bearing claims against accessible source metadata/PDF snippets where available. Internal line references below refer to the extracted text file `/mnt/data/main.txt` generated from `main.pdf`; they may shift if the PDF is recompiled.

---

## Executive verdict

The previous fatal flaw in the notes — allowing arbitrary affine weights without boundedness or convergence — **has been fixed in the current thesis**. Theorem 3.2 now requires deterministic triangular weight sequences `ν_n, ω_n` with exact affine normalisation and finite-dimensional convergence. Since `m` is fixed, convergence implies boundedness. That is precisely the missing condition needed to make the pooled-Hill Taylor term controlled.

The mathematical core of Chapter 3 is now **narrow, conservative, and basically defensible**:

\[
\widehat\xi_{\tau_n}^{pool,\star}(\nu_n,\omega_n)
=
\psi(\widehat\gamma_n(\nu_n))\widehat q_n^\star(1-p_n\mid\omega_n),
\qquad p_n=1-\tau_n,
\]

with

\[
\log\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu_n,\omega_n)}{\xi_{\tau_n}}
=A_n(\omega_n)+B_n(\nu_n)-C_n.
\]

Under the common-marginal iid distributed setting, strict `ρ < 0`, the DPS Weissman regime, and the explicit bridge-rate condition

\[
\eta_n=\frac{\sqrt{k}}{\ell_n Q(1-p_n)}\to0,
\qquad \ell_n=\log\{k/(np_n)\},
\]

the theorem correctly concludes that the first-order limit is inherited from the pooled-Weissman component and depends on `ω`, not on `ν`.

That said, the thesis is **not submission-ready**. The mathematical theorem is repaired; the document is not. The abstract and introduction are still TODOs. A severe examiner would not view this as a complete thesis draft. In addition, a few technical statements need polishing to avoid giving a hostile reviewer easy targets: the `o(A)` notation should be changed to `o(|A|)`, the triangular-weight use of DPS Corollary 8 should be cited through the random-weight/estimated-weight stability result, and the proof should explicitly remind the reader where `ℓ_n → ∞` enters.

---

## Severity grading

### BLOCKER 1 — The thesis frame is absent

The abstract is literally `[TODO:]` and the introduction is also `[TODO:]`.

- Extracted text lines 13–16: abstract placeholder.
- Extracted text lines 59–65: introduction placeholder.

This is not a minor editorial issue. It prevents the thesis from stating:

1. the research question;
2. the contribution relative to Daouia--Padoan--Stupfler and Daouia--Girard--Stupfler;
3. the precise novelty of the two-weight expectile transfer;
4. the scope limitation to the finite-`m`, iid, common-marginal, `η_n → 0` regime;
5. why `ν` is not optimised while `ω` is.

A reviewer can reject the draft immediately on this basis, independently of whether Chapter 3 is mathematically correct.

### MAJOR 1 — The weight fix is implemented and should survive scrutiny

This is the main positive result of the audit.

The theorem now states:

\[
\nu_n^\top 1=1,\qquad \omega_n^\top 1=1,
\qquad \nu_n\to\nu,
\qquad \omega_n\to\omega,
\]

for deterministic weight sequences in fixed dimension. See extracted lines 893–899. This closes the previous counterexample where affine weights such as `(n,1-n,0,...)` would satisfy `ν_n^\top 1=1` but destroy the `O_P(k^{-1/2})` control of `\widehat\gamma_n(ν_n)-γ`.

The proof explicitly uses the repaired condition:

\[
\sqrt{k}\{\widehat\gamma_n(\nu_n)-\gamma\}
=
\nu_n^\top\sqrt{k}\{\widehat\gamma_n-\gamma 1\}=O_P(1),
\]

because `ν_n → ν`, hence `(ν_n)` is bounded. See extracted lines 977–984. This is the correct proof-level use of the fix.

**Verdict:** repaired.

### MAJOR 2 — Random weights are correctly restricted to the pooled-Weissman role

The thesis now says estimated weights are introduced only in `ω`, while the bridge-Hill vector remains deterministic. See extracted lines 1156–1162. Corollary 3.5 requires random `\widehat\omega_n` to satisfy the DPS estimated-weight conditions, but keeps `ν_n` deterministic, exactly normalised, and convergent. See extracted lines 1172–1180.

The corollary then explicitly refuses the unaudited construction `ν=\widehat\omega_n`. See extracted lines 1228–1235.

This is exactly the right scope split:

- `ω` lives inside the DPS pooled-Weissman estimator, where DPS already has random-weight stability;
- `ν` lives inside the outer nonlinear map `ψ(\widehat γ)`, so making it random would require a separate Taylor/compactness audit.

**Verdict:** repaired.

### MAJOR 3 — The core theorem is mathematically salvageable under the stated narrow regime

Theorem 3.2 is now a clean deterministic two-weight theorem. The statement is narrow but coherent:

- fixed `m`;
- iid observations across and within machines from one common continuous loss distribution;
- common tail quantile `U(t)=Q(1-1/t)`;
- `C_2(γ,ρ,A)` with `0<γ<1` and strict `ρ<0`;
- `E X^- < ∞`;
- eventual upper-tail positivity `U(t)>0`;
- proportional sample and threshold sizes;
- `k→∞`, `k/n→0`, `√k A(n/k)→λ`;
- DPS Weissman regime `p_n→0`, `k/(np_n)→∞`, `√k/ℓ_n→∞`;
- bridge rate `η_n→0`.

See extracted lines 862–891.

Under these assumptions, the displayed limit

\[
\frac{\sqrt{k}}{\ell_n}
\log\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu_n,\omega_n)}{\xi_{\tau_n}}
\Rightarrow N(B_\omega,V_\omega)
\]

with

\[
B_\omega=\frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
\qquad
V_\omega=\gamma^2\left(\sum_{j=1}^m c_j^{-1}\right)
\left(\sum_{j=1}^m c_j\omega_j^2\right)
\]

is exactly the expected conclusion. See extracted lines 900–923.

**Verdict:** acceptable, subject to the edits below.

---

## First-principles reconstruction of the proof

### 1. Exact identity

The decomposition is algebraically correct:

\[
\log\frac{\widehat\xi}{\xi}
=
\log\frac{\widehat q}{Q}
+
\{\log\psi(\widehat\gamma(\nu))-\log\psi(\gamma)\}
-
\log\frac{\xi}{\psi(\gamma)Q}.
\]

The thesis proves this by inserting and subtracting `log Q(1-p_n)` and `log ψ(γ)`. See extracted lines 831–854.

There is no hidden approximation here. This is a genuine identity.

**Verdict:** correct.

### 2. `A_n(ω_n)`: pooled-Weissman component

The proof uses the common-marginal DPS pooled-Weissman theorem on relative-error scale and converts to log scale:

\[
x_n=\frac{\widehat q_n^\star(1-p_n\mid\omega_n)}{Q(1-p_n)}-1,
\qquad
\frac{\sqrt{k}}{\ell_n}x_n\Rightarrow N(B_\omega,V_\omega).
\]

Because `√k/ℓ_n→∞`, we have `x_n=O_P(ℓ_n/√k)=o_P(1)`. Then

\[
\log(1+x_n)=x_n+O_P(x_n^2),
\]

and

\[
\frac{\sqrt{k}}{\ell_n}\{\log(1+x_n)-x_n\}
=O_P\left(\frac{\ell_n}{\sqrt{k}}\right)=o_P(1).
\]

This is exactly the right conversion. See extracted lines 939–966.

**Reviewer nitpick:** the proof says Corollary 8 is applied to the deterministic triangular sequence `ω_n→ω`. That is fine if one routes it through Proposition 2.14 / DPS estimated-weight stability, because a deterministic convergent triangular sequence is a degenerate random sequence satisfying exact affine normalisation and convergence. To be maximally source-safe, replace the sentence at lines 939–940 by something like:

> By the random-weight version of the DPS pooled-Weissman theorem recalled in Proposition 2.14, applied to the deterministic exactly normalised sequence `ω_n→ω`, ...

This avoids any possible complaint that Corollary 8 was originally stated for fixed or estimated limiting weights rather than arbitrary triangular deterministic notation.

**Verdict:** correct, but cite the triangular-weight step more defensively.

### 3. `B_n(ν_n)`: nonlinear bridge-Hill term

This was the previous danger zone. The repaired proof now works.

Let

\[
g(x)=\log\psi(x)=-x\log(x^{-1}-1).
\]

Then

\[
g'(x)=\frac{1}{1-x}-\log(x^{-1}-1),
\]

and

\[
g''(x)=\frac{1}{(1-x)^2}+\frac{1}{1-x}+\frac1x.
\]

The thesis states this correctly at extracted lines 968–975.

Since `ν_n→ν`, the sequence is bounded. The vector Hill CLT gives

\[
\sqrt{k}(\widehat\gamma_n-\gamma 1)=O_P(1),
\]

so

\[
\widehat\gamma_n(ν_n)-γ=O_P(k^{-1/2}).
\]

Because `0<γ<1`, the estimator lies in a compact subinterval of `(0,1)` with probability tending to one. Taylor gives

\[
B_n(ν_n)
=m(γ)(\widehat\gamma_n(ν_n)-γ)+O_P(k^{-1}).
\]

Then

\[
\frac{\sqrt{k}}{\ell_n}B_n(ν_n)
=
\frac{m(γ)}{\ell_n}\sqrt{k}\{\widehat\gamma_n(ν_n)-γ\}
+O_P\left(\frac{1}{\ell_n\sqrt{k}}\right)
=o_P(1),
\]

because `ℓ_n→∞`. See extracted lines 977–1001.

**Verdict:** correct. The weight fix is used in the right place.

**Minor edit:** after line 1000, add a parenthetical reminder: “Here `ℓ_n→∞` follows from `k/(np_n)→∞`.” This prevents a reviewer from searching backward.

### 4. `C_n`: population expectile--quantile bridge

The proof uses the second-order bridge expansion

\[
\frac{\xi_{\tau_n}}{\psi(γ)Q(1-p_n)}-1
= c(γ,ρ)A(1/p_n)+α_γ\mu Q(1-p_n)^{-1}
+o(|A(1/p_n)|)+o(Q(1-p_n)^{-1}),
\]

where

\[
α_γ=γ(γ^{-1}-1)^γ,
\qquad \mu=EX.
\]

See extracted lines 1003–1011. This is the right population ledger.

Then the proof logs:

\[
C_n=\log(1+\Delta_n)=\Delta_n+O(\Delta_n^2).
\]

See extracted lines 1013–1015. This is necessary because the DGS result is a ratio expansion, not a log expansion.

The rate checks are also right:

1. Since `ρ<0`, `A` is regularly varying with negative index and

   \[
   \frac{1/p_n}{n/k}=\frac{k}{np_n}\to∞,
   \]

   so

   \[
   A(1/p_n)/A(n/k)\to0.
   \]

   Combined with `√k A(n/k)→λ`, this gives

   \[
   \frac{\sqrt{k}}{\ell_n}A(1/p_n)→0.
   \]

   See extracted lines 1016–1034.

2. The bridge-rate condition is exactly

   \[
   \frac{\sqrt{k}}{\ell_n}Q(1-p_n)^{-1}→0.
   \]

   See extracted lines 1036–1040.

3. The square remainder is negligible because if `s_n |a_n|→0`, `s_n b_n→0`, and `|a_n|+b_n→0`, then

   \[
   s_n(|a_n|+b_n)^2
   =\{s_n(|a_n|+b_n)\}(|a_n|+b_n)→0.
   \]

   See extracted lines 1042–1049.

**Verdict:** correct.

**Minor edit:** in Section 2.4.1 equation (2.7), replace `o(A((1−τ)^{-1}))` by `o(|A((1−τ)^{-1})|)`. The proof later uses absolute value, and `A` is allowed to have constant negative sign. This is not a mathematical disaster, but it is a precision flaw that a severe reviewer can exploit.

### 5. Relative-error conclusion

The log limit gives

\[
L_n=\log(\widehat\xi/\xi)=O_P(\ell_n/\sqrt{k})=o_P(1).
\]

Then

\[
e^{L_n}-1=L_n+O_P(L_n^2),
\]

and the scaled difference is

\[
\frac{\sqrt{k}}{\ell_n}O_P(L_n^2)
=O_P(\ell_n/\sqrt{k})=o_P(1).
\]

See extracted lines 1058–1075.

**Verdict:** correct.

---

## Weight consequences and inference

### `ν` is correctly declared first-order unidentified

The thesis explicitly says the limit depends on `ω`, not `ν`, and that neither the diagonal convention `ν_n=ω_n` nor the practical convention

\[
ν_n^k=(k_1/k,\ldots,k_m/k)^\top
\]

is an optimality result for `ν`. See extracted lines 1077–1089.

This is exactly the right conclusion. A first-order theorem that has no `ν` in the limit cannot justify a first-order optimal `ν`. Any claim of optimality for `ν` would need lower-order analysis.

**Verdict:** correct.

### First-order criteria for `ω` are correct

Since the theorem’s first-order mean and variance are

\[
B_\omega=\omega^\top B_c^{dist},
\qquad
V_\omega=\omega^\top V_c^{dist}\omega,
\]

the first-order AMSE criterion is

\[
(\omega^\top B_c^{dist})^2+\omega^\top V_c^{dist}\omega.
\]

See extracted lines 1092–1153. This is exactly the DPS criterion, now applied only to `ω`.

**Verdict:** correct.

### Estimated-`ω` transfer is properly scoped

Corollary 3.5 says random `\widehat\omega_n` may replace the deterministic pooled-Weissman weights if it satisfies the DPS estimated-weight conditions. The proof then applies the same relative-to-log conversion and uses the already-proved lower-order status of `B_n(ν_n)` and `C_n`. See extracted lines 1172–1226.

The final paragraph says this concerns `ω` only and excludes random `ν=\widehat\omega_n`. See extracted lines 1228–1235.

**Verdict:** correct.

### Plug-in interval is algebraically right and honestly conditional

Corollary 3.6 fixes

\[
ν_n=ν_n^k=(k_1/k,\ldots,k_m/k)^\top
\]

and uses plug-in estimates of the DPS bias and variance objects. It explicitly states that these consistency assumptions belong to the selected DPS plug-in route and are not consequences of the expectile decomposition alone. See extracted lines 1237–1263.

The interval inversion is also algebraically correct:

\[
T_n^{plug}=\frac{s_n\log(\widehat\xi^{plug}/\xi)-\widehat B}{\sqrt{\widehat V}}.
\]

Solving `|T_n^{plug}|≤z` gives

\[
\xi\in
\left[
\widehat\xi\exp\{-s_n^{-1}(\widehat B+z\sqrt{\widehat V})\},
\widehat\xi\exp\{-s_n^{-1}(\widehat B-z\sqrt{\widehat V})\}
\right],
\]

which matches the thesis. See extracted lines 1277–1344.

Remark 3.7 is also properly cautious: the interval is not a direct restatement of a DPS quantile interval; it is an inversion of the transferred expectile statistic and remains conditional on the chosen DPS construction providing consistent plug-in objects. See extracted lines 1346–1353.

**Verdict:** correct.

---

## Source-use audit

### DPS pooled-Weissman source

The thesis uses Daouia--Padoan--Stupfler (2024) as the source theory for pooled Hill and weighted geometric Weissman estimation. This is appropriate: the source article is exactly about optimal weighted pooling for tail-index and extreme-quantile inference, including weighted geometric pooling and optimal weights.

The current thesis is careful to use the **common-distribution distributed special case** in Chapter 3. This avoids the harder target-selection issue that would arise under mere tail homoskedasticity. See extracted lines 747–759.

**Source-use verdict:** acceptable.

**Precision edit:** in the proof of Theorem 3.2, route the triangular deterministic `ω_n` application through Proposition 2.14 or the random-weight statement, not only through a bare citation to Corollary 8.

### DGS expectile--quantile bridge source

The thesis correctly distinguishes:

1. first-order equivalence `ξ_τ/Q(τ)→ψ(γ)`;
2. second-order ratio expansion;
3. the additional log conversion needed for `C_n`.

This is important. The DGS expansion is not itself a log expansion. The thesis handles that at lines 1013–1015.

**Source-use verdict:** acceptable.

**Precision edit:** write little-o terms with absolute `A` where needed.

### Bellini/coherence/elicitability background

The background statements about expectiles as coherent risk measures for `τ≥1/2` and elicitable functionals are standard and cited. I did not find a damaging mismatch in this layer.

**Source-use verdict:** acceptable.

---

## Remaining mathematical vulnerabilities

### Vulnerability 1 — The theorem is intentionally narrow; do not oversell it

The main result is not a general pooled expectile theorem. It is a finite-`m`, iid, common-marginal, extreme-Weissman, `η_n→0` transfer theorem. If the abstract or introduction later says “heterogeneous distributed expectile inference” without qualification, that would be false.

Correct phrasing:

> In the finite-machine iid common-distribution setting, under a bridge-rate condition that makes the population expectile--quantile gap negligible on the pooled-Weissman scale, the first-order law of the proposed expectile estimator is inherited from the DPS pooled-Weissman estimator.

Incorrect phrasing:

> We derive optimal pooled inference for extreme expectiles under heterogeneous heavy-tailed samples.

That broader claim is not proved.

### Vulnerability 2 — `η_n→0` is a real restriction, not a technicality

The bridge-rate condition removes the first-moment bridge term

\[
γ(γ^{-1}-1)^γ EX/Q(1-p_n).
\]

Without `η_n→0`, the source-scale limit would generally be shifted by a deterministic expectile-specific term. The thesis does not hide this, but the introduction/abstract must present it honestly.

Correct phrasing:

> The clean DPS weight transfer holds under `η_n→0`; if the mean bridge term is of source-scale order, the AMSE criterion changes.

Incorrect phrasing:

> The expectile bridge is always negligible.

### Vulnerability 3 — No empirical or simulation evidence

There is no simulation chapter and no numerical demonstration. Depending on degree requirements, this may be acceptable for a theory-only thesis, but the title says “Improved Statistical Inference,” and a severe reviewer will ask: improved relative to what, empirically?

If simulations are not added, the introduction must explicitly frame this as a theoretical transfer result, not an empirical performance claim.

### Vulnerability 4 — Plug-in inference is only as good as DPS plug-in consistency

The thesis is honest about this, but the point is important enough to repeat in the abstract/introduction. The expectile decomposition does not estimate `B_ω` or `V_ω`; it inherits them from the selected DPS route. If the selected route’s second-order/bias estimators are unstable, the theorem does not rescue finite-sample inference.

### Vulnerability 5 — Negative weights are allowed

The thesis says no non-negativity is imposed. That is mathematically fine because the estimators are positive with probability tending to one under eventual upper-tail positivity, so real powers are defined. But negative weights can behave badly in finite samples. If the thesis later gives practical recommendations, it should distinguish:

- oracle/unconstrained affine optimal weights;
- constrained/nonnegative weights for numerical stability.

Do not silently present unconstrained negative weights as automatically practical.

---

## Line-item corrections

1. **Abstract and Introduction:** fill them. This is mandatory.

2. **Theorem 3.2 proof, `A_n`:** replace “Corollary 8, applied to the exactly normalised deterministic sequence `ω_n→ω`” with “the random-weight version recalled in Proposition 2.14, applied to the deterministic sequence `ω_n`.” This is more source-defensive.

3. **Equation (2.7):** change `o(A((1−τ)^{-1}))` to `o(|A((1−τ)^{-1})|)`. The proof already uses `o(|a_n|)`.

4. **After equation (3.7):** explicitly state that `ℓ_n→∞` follows from `k/(np_n)→∞`.

5. **Chapter 3 opening:** keep the current common-marginal wording. Do not expand it to tail-homoskedastic populations unless a new target-population argument is supplied.

6. **Corollary 3.4:** consider adding one sentence: “All criteria in this corollary concern `ω`; the symbol `ν` does not enter because `B_n(ν)` is lower order under (3.3).” This makes the separation idiot-proof.

7. **Corollary 3.6:** add “on the high-probability event that all local Weissman estimators are positive” if you want the interval statement to be perfectly aligned with negative/unconstrained weights and real powers. The theorem already has `U(t)>0`, so this is a presentation issue, not a new assumption.

8. **Bibliography/source prose:** ensure theorem numbering is pinned to the published Bernoulli version. If the arXiv numbering differs, say so nowhere in theorem prose; cite the published numbering only.

---

## Final judgement

The current thesis has successfully implemented the weight fix. The old fatal theorem-language bug is gone.

The mathematical core of Chapter 3 is now viable:

- exact decomposition: correct;
- deterministic two-weight theorem: correct under stated assumptions;
- boundedness/convergence of weights: repaired;
- `ν` first-order unidentified: correctly stated;
- DPS criteria apply only to `ω`: correctly stated;
- estimated weights transfer only for `ω`: correctly stated;
- plug-in inference: algebraically correct and properly conditional.

The remaining problems are not of the same severity as the previous weight defect, but they still matter. The document is incomplete as a thesis because the abstract and introduction are missing. The proof also needs small source-defensive edits to avoid reviewer nitpicks.

**Brutal bottom line:** I would no longer reject Chapter 3 for a mathematical flaw in the weights. I would still reject the thesis draft as a thesis submission because the framing is absent and a few source-precision edits remain. Once the abstract/introduction are written and the small notation/citation fixes above are made, the core theorem should be defensible.
