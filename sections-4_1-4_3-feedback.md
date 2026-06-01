# Strict thesis-review feedback: Sections 4.1–4.3

**File reviewed:** `04_pooled_extreme.tex`  
**Scope:** Sections 4.1–4.3 only: Motivation, Extrapolation regime and input limit, and The pooled extrapolated expectile estimator. I used Chapters 2–3 only to check dependencies and notation. This is a source-level mathematical/content audit, not a full compile audit.

## Overall verdict

**Decision: major revision before this chapter is thesis-ready.**

The conceptual line is strong: Chapter 4 correctly positions very-extreme expectile estimation as a Weissman-type lift of the pooled intermediate estimator, and the estimator in Section 4.3 is largely the right object for the plug-in CLT. The text is also better than a sketch: it states the regime, records a joint input limit, and explains why unmatched extrapolation weights change the first-order limit.

However, the current version still reads as if several theorem hypotheses are “obviously inherited” when they need to be explicitly discharged. A strict examiner could challenge Section 4.2 on the plug-in CLT verification, the deterministic extrapolation-bias argument, and the positivity/log-domain conditions. These are fixable, but they are not cosmetic: they are the bridge between Chapter 3 and the main Chapter 4 theorem.

## What is working well

1. **The chapter motivation is mathematically coherent.** Section 4.1 correctly explains why the direct LAWS/QB estimators are not the target in the very-extreme regime and why the intermediate estimator should be used as the stable anchor.

2. **The estimator definition is basically correct.** The canonical estimator
   
   $$
   \widehat\xi_{\tau_n'}^{\mathrm{pool},\star}
   (\boldsymbol\omega_\gamma,\boldsymbol\omega_q)
   =
   \left(\frac{1-\tau_n'}{1-\tau_n}\right)^{-\widehat\gamma_n(\boldsymbol\omega_\gamma)}
   \widehat\xi_{\tau_n}^{\mathrm{pool}}(\boldsymbol\omega_\gamma,\boldsymbol\omega_q)
   $$
   
   is the right object for the plug-in theorem, because the extrapolation exponent must use the same pooled Hill input that appears in the plug-in pair.

3. **The matched-weight identity is a valuable contribution.** The explanation around `04_pooled_extreme.tex:309–341` usefully shows that, when weights are matched, the estimator reduces exactly to the QB plug-in applied to the pooled Weissman quantile at the very-extreme level.

4. **The unmatched-weight warning is important and correct.** The discussion at `04_pooled_extreme.tex:386–409` identifies a genuine first-order issue: replacing the extrapolation exponent by the Hill weighting inside `\hatWei_n(\tau_n'\mid\boldsymbol\omega_q)` changes the normalized limit unless the Hill weightings agree asymptotically.

## Blocking or major issues

### 1. The plug-in CLT hypotheses are not fully verified

**Location:** `04_pooled_extreme.tex:77–170`, `180–244`, `246–260`

Section 4.2 says that the remaining high-level conditions of `\Cref{prop:bg:plug-in-clt}` are supplied by Chapter 3. That is too compressed for a thesis proof. The plug-in proposition requires more than a joint CLT:

- `a_n \to \infty`, here `a_n = \sqrt{k}`;
- `n(1-\tau_n) \to \infty`;
- `n(1-\tau_n') \to c`;
- `(1-\tau_n')/(1-\tau_n) \to 0`;
- `a_n/\ell_n \to \infty`;
- `a_n A((1-\tau_n)^{-1}) \to \lambda_1`;
- `a_n/\Quant_X(\tau_n) \to \lambda_2`;
- `\mathbb P(\widehat\xi^I_{\tau_n}>0)\to1`;
- the deterministic log-ratio condition;
- the joint input representation for `(\widehat\gamma_n, \widehat\xi^I_{\tau_n})`.

You check some of these, but not all of them explicitly. In particular, the positivity of the intermediate pooled anchor is only implicit through the log-domain convention, and the plug-in theorem needs it as a hypothesis.

**Required fix:** Add a short “Verification of the plug-in hypotheses” paragraph or lemma before Proposition 4.1. It should explicitly list each hypothesis and point to the exact line/result that provides it. Do not leave the reader to reconstruct this from Chapters 2–3.

Suggested structure:

```tex
For the application of \Cref{prop:bg:plug-in-clt} we take
\(a_n=\sqrt{k}\),
\(\hat\gamma_n=\hat\gamma_n(\bm\omega_\gamma)\), and
\(\widehat\xi^I_{\tau_n}
=\hatexpectile{\tau_n}^{\mathrm{pool}}
(\bm\omega_\gamma,\bm\omega_q)\).
We verify the hypotheses as follows. Since \(k\to\infty\),
\(a_n\to\infty\). The finite-log condition
\(L_j(\tau_n)\to L_j^\star\), together with \(k_j\to\infty\)
and the proportionality of the \(n_j\)'s, implies
\(n(1-\tau_n)\to\infty\). Conditions ... are exactly
\eqref{eq:pool-ext:very-extreme-level} and
\eqref{eq:pool-ext:weissman-rate}. The convergence
\(\sqrt{k}A((1-\tau_n)^{-1})\to\Lambda^\bullet\) is
\eqref{eq:pool-int:Lambda-bullet}, and
\(\sqrt{k}/\Quant_X(\tau_n)\to0\) is
\eqref{eq:pool-ext:moment-rate}. Finally,
\(\Pr(\widehat\xi^I_{\tau_n}>0)\to1\) follows because
\(\hatWei_n(\tau_n\mid\bm\omega_q)>0\) and
\(\psifn(\hat\gamma_n(\bm\omega_\gamma))>0\) on the
high-probability log-domain event.
```

### 2. The deterministic extrapolation-bias control is under-explained

**Location:** `04_pooled_extreme.tex:142–170`

The paragraph verifying

$$
\frac{\sqrt{k}}{\ell_n}\left\{
\log\expectile{\tau_n'}-\log\expectile{\tau_n}-\gamma\ell_n
\right\}\to0
$$

is too quick. You say the `A`-term in the expectile–quantile expansion is

$$
O\left(\frac{\sqrt{k}A((1-\tau_n)^{-1})}{\ell_n}\right)=o(1),
$$

but the displayed deterministic ratio contains both a **quantile-ratio** term and an **expectile/quantile correction** term. A reader should not have to infer that the second-order quantile expansion is also being used.

**Required fix:** Either cite the background remark as the full verification and avoid a partial derivation, or give the actual decomposition. A defensible decomposition is:

$$
\begin{aligned}
&\log\expectile{\tau_n'}-\log\expectile{\tau_n}-\gamma\ell_n \\
&= \{\log\Quant_X(\tau_n')-\log\Quant_X(\tau_n)-\gamma\ell_n\} \\
&\quad + \{\log(\expectile{\tau_n'}/\Quant_X(\tau_n'))
        -\log(\expectile{\tau_n}/\Quant_X(\tau_n))\}.
\end{aligned}
$$

Then explain that the first brace is controlled by the second-order quantile expansion, while the second brace is controlled by the second-order expectile–quantile expansion. Since `\rho<0`, Potter bounds / the strict second-order condition keep the relevant `A`-terms of order `A((1-\tau_n)^{-1})` as `\tau_n'` moves further into the tail. After multiplication by `\sqrt{k}/\ell_n`, these vanish because `\sqrt{k}A((1-\tau_n)^{-1})=O(1)` and `\ell_n\to\infty`. The moment term is negligible by `\sqrt{k}/\Quant_X(\tau_n)\to0`.

The current paragraph is directionally right, but it is not rigorous enough for a thesis proof.

### 3. The assumption transfer from Chapter 3 is not self-contained enough

**Location:** `04_pooled_extreme.tex:77–110`

The text says the standing assumptions of Section 3.1 remain in force and then lists only some of them. This creates avoidable ambiguity. In particular, Section 4.2 should explicitly restate or cite the following assumptions:

- the second-order condition `\mathcal C_2(\gamma,\rho,A)`;
- eventual strict increase of `F` near the upper endpoint;
- the lower-tail moment condition;
- common marginal distribution, not merely common tail index;
- fixed `m` and proportional `n_j,k_j` growth;
- the finite-log intermediate condition;
- the strict strengthening `\rho<0`.

The phrase “The only strengthening relative to the intermediate chapter is ... `\rho<0`” is acceptable only if the inherited assumptions are fully visible. At present, it reads as if some conditions are being smuggled in through cross-references.

**Required fix:** Replace the opening of Section 4.2 with a compact assumption block. For example:

```tex
Throughout this chapter we keep the setup of \Cref{sec:pool-int:setup}:
independent samples with common marginal distribution \(F\), fixed \(m\),
proportional \((n_j,k_j)\), \(k_j\to\infty\), \(k_j/n_j\to0\),
the second-order condition \(\mathcal C_2(\gamma,\rho,A)\), eventual
strict increase of \(F\) near the upper endpoint, and the lower-tail
moment condition. For extrapolation we strengthen the second-order
index to \(\rho<0\).
```

Then continue with the finite-log and very-extreme conditions.

### 4. Proposition 4.1 is correct in spirit but proof-light

**Location:** `04_pooled_extreme.tex:180–244`

The proposition is useful, but the proof is too terse for a named result. It says “apply the same first-order delta method” and then jumps to the covariance. A reviewer will want to see the actual linearization.

**Required fix:** Add the displayed expansion

$$
\sqrt{k}\log\frac{
\hatexpectile{\tau_n}^{\mathrm{pool}}
(\bm\omega_\gamma,\bm\omega_q)}
{\expectile{\tau_n}}
=
 m(\gamma)\sqrt{k}\{\hat\gamma_n(\bm\omega_\gamma)-\gamma\}
+
\sqrt{k}\{\log\hatWei_n(\tau_n\mid\bm\omega_q)-\log\Quant_X(\tau_n)\}
+b^{\xi/\Quant}+o_p(1).
$$

From that line, the mean, variance, and cross-covariance become transparent. Then explicitly state that replacing the log-ratio by the relative error is justified by `e^x-1=x+o(x)` with `x=O_p(k^{-1/2})`, including for the covariance with the Hill component.

### 5. The role of `\boldsymbol\omega_q` at the extreme level needs earlier clarification

**Location:** `04_pooled_extreme.tex:265–298`, `386–409`

You correctly explain that `\boldsymbol\omega_q` remains in the finite-sample estimator but not in the first-order very-extreme limit. However, this point currently appears only indirectly. Since Proposition 4.1 already says the final plug-in limit will retain only the Hill component, the reader may ask why Section 4.3 still carries two weight vectors.

**Required fix:** Add one sentence immediately after the estimator definition:

```tex
Although \(\bm\omega_q\) affects the finite-sample anchor and the
intermediate-level component of the joint input limit, it will disappear
from the first-order very-extreme CLT after normalization by
\(\sqrt{k}/\ell_n\); it remains part of the definition because different
choices give different finite-sample estimators and higher-order terms.
```

This will prevent the two-weight construction from looking like unnecessary notation.

### 6. Positivity/log-domain events need to be made theorem-compatible

**Location:** `04_pooled_extreme.tex:90–99`, `294–298`, `343–384`

The text repeatedly says log expressions are understood on high-probability positivity events. That is fine for informal discussion, but the plug-in theorem requires positivity of the intermediate anchor with probability tending to one.

Also, Section 4.3 introduces geometric products with affine weights. Negative weights are allowed, so the log-scale interpretation is essential. You need to state precisely that the local factors are positive with probability tending to one and that arbitrary definitions on the complement do not affect the limit.

**Required fix:** Consolidate the log-domain convention once in Section 4.2 or at the start of Section 4.3, and explicitly connect it to `\Pr(\widehat\xi^I_{\tau_n}>0)\to1`.

### 7. The use of total `n` versus local `n_j` should be clarified

**Location:** `04_pooled_extreme.tex:112–140`

The very-extreme condition is stated as

$$
 n(1-\tau_n')\to c,
$$

where `n=\sum_j n_j`. This is consistent with the thesis setup, but because the estimator is built from local sample inputs, a reader may wonder what happens to `n_j(1-\tau_n')`.

Under the proportionality conditions, `n_j/n` has a positive limit, so

$$
 n_j(1-\tau_n') \to \alpha_j c
$$

for constants `\alpha_j\in(0,1)`. State this explicitly or add a parenthetical. It will make the local Weissman interpretation at `\tau_n'` cleaner.

## Section-by-section comments

### Section 4.1 — Motivation

**Strengths**

- The motivation correctly distinguishes intermediate estimation from very-extreme extrapolation.
- The communication protocol is consistent with Chapter 3: local Hill inputs and local Weissman quantile inputs, no raw observations, no LAWS scalar.
- The final paragraph gives the right roadmap for the chapter.

**Needed improvements**

1. The phrase “where the target lies beyond, or at the edge of, the range supported by the observed upper order statistics” is intuitive but imprecise. In the regime `n(1-\tau_n')\to c`, the expected number of exceedances is finite; the target is not always literally beyond the sample maximum. Replace with something like: “where only finitely many observations are expected beyond the target level, so direct intermediate-level asymptotics no longer apply.”

2. The claim that the final limit is “governed only by the tail-index component” is correct, but in Section 4.1 it is still a preview. Phrase it as a roadmap rather than a result already proven: “will be governed” or “the plug-in result will show.”

3. “Asymptotic covariance information needed for pooling” is vague. If the covariance is theoretical, say so; if it is estimated, say it is estimated later. Otherwise the communication protocol sounds heavier than the actual estimator definition.

### Section 4.2 — Extrapolation regime and input limit

**Strengths**

- The regime `\tau_n'\uparrow1`, `n(1-\tau_n')\to c`, `(1-\tau_n')/(1-\tau_n)\to0` is correctly stated.
- The log-rate `\ell_n` is correctly defined.
- The rate condition `\sqrt{k}/\ell_n\to\infty` is the right Weissman condition.
- The joint input proposition has the right covariance structure.

**Needed improvements**

1. Add the plug-in hypothesis checklist described above.

2. Expand the deterministic ratio control. The current derivation is too compressed and does not explicitly mention the second-order quantile-ratio term.

3. Make the proposition proof more explicit. Right now it is more of a proof sketch than a thesis-level proof.

4. State whether the proposition is for deterministic weights only. It currently says “any affine weight vectors,” which implies deterministic in context, but because Chapter 3 discusses estimated weights, this should be explicit. Add a sentence such as: “The statement is for deterministic weights; the estimated-weight version follows under the same exact-normalisation and consistency assumptions used in Chapter 3.”

5. Avoid redefining `\bm D^\star` without reminding the reader it is the same object as in Chapter 3. This is minor, but it helps notation continuity.

### Section 4.3 — The pooled extrapolated expectile estimator

**Strengths**

- The estimator definition is clean and mathematically natural.
- The equivalent exponential form is helpful.
- The matched-weight identity is exact and useful.
- The warning about unmatched weights is one of the best parts of the section.

**Needed improvements**

1. Clarify immediately why two weights remain even though only `\bm\omega_\gamma` determines the first-order very-extreme CLT.

2. Turn the local-QB comparison into a formal remark or proposition if you plan to use it later. The current prose is correct, but it contains a reusable result:

   $$
   \log\frac{
   \hatexpectile{\tau_n'}^{\mathrm{pool},\star}(\bm\omega,\bm\omega)}
   {\hatexpectile{\tau_n'}^{\mathrm{loc},\star}(\bm\omega)}
   =O_p(k^{-1}).
   $$

   This is strong enough to deserve a labelled remark if later sections rely on it.

3. The unmatched-weight warning should explicitly say which estimator is **not** being analyzed. A reader might naturally define

   $$
   \psifn(\hat\gamma_n(\bm\omega_\gamma))\hatWei_n(\tau_n'\mid\bm\omega_q),
   $$

   so you should label it as an “alternative but generally first-order different estimator,” not merely a non-equivalent rewrite.

4. The sentence “No adjusted quantile level is introduced” is good. Consider moving it slightly earlier or making it a short remark, because it preempts a common expectile/quantile-level confusion.

## Suggested priority checklist

### Must fix before supervisor review

- [ ] Add a formal verification paragraph for every hypothesis of `\Cref{prop:bg:plug-in-clt}`.
- [ ] Expand the deterministic extrapolation-bias control or explicitly defer to `\Cref{rem:bg:plugin-ratio-control}` with all conditions checked.
- [ ] Make positivity of the pooled intermediate anchor explicit.
- [ ] Strengthen the proof of Proposition 4.1 with the displayed linearization.
- [ ] Restate the inherited assumptions more self-containedly at the start of Section 4.2.

### Should fix for readability and examiner confidence

- [ ] Clarify the total-`n` versus local-`n_j` interpretation of the very-extreme level.
- [ ] Explain immediately why `\bm\omega_q` remains in the estimator but disappears from the first-order extreme CLT.
- [ ] Formalize the matched local-QB equivalence as a labelled remark if it will be cited later.
- [ ] Soften or sharpen the “beyond the range” wording in Section 4.1.

### Minor polish

- [ ] Use either `\tau_n^\prime` or `\tau_n'` consistently in prose and displays.
- [ ] Avoid repeating “the thesis-level version” too often; once is enough.
- [ ] Keep “affine weights” terminology, but remind the reader once that coordinates may be negative.

## Bottom line

Sections 4.1–4.3 are structurally promising and mostly aligned with the previous chapters. The main mathematical object is the right one. The weakness is not the estimator; it is the rigor of the bridge from the Chapter 3 intermediate CLT to the Chapter 4 plug-in extrapolation theorem. Strengthen the hypothesis verification, expand the deterministic bias control, and make the positivity/log-domain conditions theorem-ready. After those revisions, these sections should be able to support the main extrapolation theorem cleanly.
