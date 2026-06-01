# Strict thesis-review feedback: Sections 4.6 and 4.7

**Scope audited:** `04_pooled_extreme(2).tex`, Section 4.6 “Bias-reduction” (`lines 940--1094`) and Section 4.7 “Asymptotic confidence intervals” (`lines 1096--1308`). I cross-checked the arguments against the stated Chapter 4 main theorem, the plug-in extrapolation proposition in Chapter 2, and the intermediate-level Chapter 3 notation. I did not run a full LaTeX compilation because the uploaded project tree is incomplete for compilation; this is a source-level mathematical and exposition audit.

## Overall verdict

The two sections are **mathematically plausible and mostly coherent** with the preceding Chapter 4 theorem. The central idea is sound: after very-extreme extrapolation and normalization by `sqrt(k)/ell_n`, the intermediate expectile anchor becomes first-order invisible, so bias reduction and confidence intervals reduce to the pooled-Hill component. The bias-reduced estimator in Section 4.6 and the log-scale confidence interval in Section 4.7 are therefore directionally correct.

However, I would **not sign off on these sections without revisions**. The main problems are not algebraic disasters, but thesis-level rigor issues: several assumptions are only implicit, the CI “default” language can mislead readers into using a non-centered interval outside the undersmoothing/bias-corrected regime, and the bias-centered CI remark duplicates the bias-reduced estimator without saying so. These issues are fixable, but they matter because Sections 4.6--4.7 are where theory becomes an implementable inference procedure.

## Blocking / major revisions

### 1. State the bias-reduced joint input explicitly, not only the final scalar CLT

**Location:** Section 4.6, especially `lines 998--1062`.

The proof of the bias-reduced corollary argues by repeating the log decomposition with `\overline\gamma_n` in place of `\hat\gamma_n`. This is probably correct, but too compressed for a thesis proof because the whole Chapter 4 mechanism is built around the plug-in proposition requiring a **joint input limit** for `(tail-index estimator, intermediate expectile estimator)`.

Add an explicit display before applying the log decomposition. For deterministic weights, something like:

```tex
\[
\sqrt{k}
\begin{pmatrix}
  \overline\gamma_n(\bm\omega_\gamma)-\gamma \\
  \hatexpectile{\tau_n}^{\mathrm{pool}}
    (\bm\omega_\gamma,\bm\omega_q)/\expectile{\tau_n}-1
\end{pmatrix}
\todist
\mathcal N\!\left(
\begin{pmatrix}
0 \\
\mu^\xi(\bm\omega_\gamma,\bm\omega_q)
\end{pmatrix},
\begin{pmatrix}
\bm\omega_\gamma^\top\Vc\bm\omega_\gamma &
 s_{\gamma,\xi}(\bm\omega_\gamma,\bm\omega_q) \\
 s_{\gamma,\xi}(\bm\omega_\gamma,\bm\omega_q) &
 \sigma^\xi(\bm\omega_\gamma,\bm\omega_q)^2
\end{pmatrix}
\right),
\]
```

with a sentence explaining that subtracting `\bm\omega_\gamma^\top \hat\Bc / \sqrt{k}` shifts only the first-coordinate mean because `\hat\Bc \toprob \Bc`; it does not change the covariance. Then the reader can see exactly why the plug-in extrapolation argument remains valid.

### 2. The estimated-weight bias correction needs a precise definition

**Location:** `lines 1021--1027`, `1055--1061`, and later the CI use at `lines 1162--1166`.

The deterministic bias-reduced estimator is defined clearly in `eq:pool-ext:bias-reduced-estimator`, but the estimated-weight version is only described verbally. For implementation and proof clarity, define it explicitly, for example:

```tex
\overline\gamma_n(\hat{\bm\omega}_\gamma)
=
\hat\gamma_n(\hat{\bm\omega}_\gamma)
-
\frac{\hat{\bm\omega}_\gamma^\top\hat\Bc}{\sqrt{k}},
```

and then define the estimated-weight bias-reduced expectile by substituting this quantity into the exponent while using the corresponding estimated-weight intermediate anchor. This avoids ambiguity about whether the correction uses the deterministic limit weight, the random feasible weight, or a separately projected affine weight.

### 3. The practical “default interval” language is too permissive

**Location:** Section 4.7, especially `lines 1298--1308`.

The final practical paragraph says the conservative default is to pair the CI with variance-optimal effective-sample-size weights and avoid estimating `\Bc`. This is dangerous as written. The variance-only interval has nominal coverage only under the centering condition `\bm\omega_\gamma^\top\Bc=0`, especially under undersmoothing, or after using the bias-reduced/bias-centered construction. Merely choosing variance-optimal weights and avoiding `\Bc` does **not** remove asymptotic bias.

Revise the paragraph so it explicitly says:

```tex
Under undersmoothing, or any calibration for which
\bm\omega_\gamma^\top\Bc=0, the default variance-only interval can be
paired with the variance-optimal effective-sample-size weights. Without
such centering, the variance-only interval is not asymptotically centered;
one must either use the bias-reduced estimator or the equivalent
bias-centered log interval.
```

This is a thesis-level inference section; the reader must not be left with the impression that “variance-optimal + no `\Bc` estimation” is automatically a valid confidence interval in the retained-bias regime.

### 4. The bias-centered interval remark duplicates the bias-reduced estimator; say so or merge them

**Location:** `lines 1162--1166` and `lines 1240--1271`.

The bias-centered interval in the remark is algebraically the same center as the interval based on the bias-reduced estimator, provided the same `\hat\Bc` and weights are used:

```tex
\log \hatexpectile{\tau_n'}^{\mathrm{pool},\star,\mathrm{bc}}
=
\log \hatexpectile{\tau_n'}^{\mathrm{pool},\star}
-
\hat{\bm\omega}_\gamma^\top\hat\Bc\,\frac{\ell_n}{\sqrt{k}}.
```

Currently the text presents these as if they are two separate procedures. Either merge the remark into the corollary as an “equivalent expression”, or add a sentence at the start of the remark:

```tex
For the minimal exponent correction in \eqref{eq:pool-ext:bias-reduced-estimator}, this bias-centered interval is algebraically identical to the variance-only interval centered at the bias-reduced estimator.
```

This would substantially improve clarity.

### 5. Correct the wording about variance and the extrapolation distance

**Location:** `lines 1104--1108` and `lines 1282--1291`.

The text says the remaining variance is “the pooled-Hill variance multiplied by the extrapolation distance `\ell_n`.” The formula shows the **standard error** is multiplied by `\ell_n`, while the log-scale variance is multiplied by `\ell_n^2/k`:

```tex
\mathrm{Var}\{\log \widehat\zeta_{\tau_n'}\}
\approx
\frac{\ell_n^2}{k}\,
\bm\omega_\gamma^\top\Vc\bm\omega_\gamma.
```

Replace the prose with “the standard error is the pooled-Hill standard error multiplied by `\ell_n`” or “the variance is scaled by `\ell_n^2/k`.” The current wording is imprecise enough to confuse readers.

## Moderate revisions

### 6. Section 4.6 should distinguish theorem-level bias reduction from feasible implementation

**Location:** `lines 959--964` and `lines 1071--1083`.

You assume a consistent estimator `\hat\Bc \toprob \Bc`, then later acknowledge that obtaining it requires a Hall-type or other second-order working model. That is good, but the distinction should be sharper. I recommend adding one sentence immediately after `eq:pool-ext:Bc-hat-consistency`:

```tex
The following result is therefore conditional on a feasible second-order bias-estimation step; under \mathcal C_2 alone, \eqref{eq:pool-ext:Bc-hat-consistency} is not automatic.
```

This protects you from the criticism that you have smuggled in a strong estimation assumption under the phrase “bias reduction.”

### 7. The proof of the CI corollary should handle the two estimator choices symmetrically

**Location:** `lines 1203--1238`.

The proof first writes the log-scale convergence for the uncorrected estimator, then says the bias-reduced construction gives the identical centered limit. This is acceptable but too compressed. Since the corollary defines `\widehat\zeta_{\tau_n'}` generically, write the proof directly in terms of `\widehat\zeta_{\tau_n'}` after establishing the two possible centered log limits:

```tex
In either of the two cases in the statement,
\[
\frac{\sqrt{k}}{\ell_n}
\{\log \widehat\zeta_{\tau_n'}-\log\expectile{\tau_n'}\}
\todist
\mathcal N(0,\bm\omega_\gamma^\top\Vc\bm\omega_\gamma).
\]
```

Then self-normalize. This makes the proof read as a proof of the actual corollary rather than a proof of one case plus a side remark.

### 8. The corollary should explicitly mention positivity of the interval center and target

**Location:** `lines 1153--1189`.

The log interval requires `\widehat\zeta_{\tau_n'}>0` and `\expectile{\tau_n'}>0` with probability tending to one. This is true under your construction and assumptions, but Section 4.7 should say it explicitly, as Chapter 3 did for its CI. Add a sentence before defining the interval:

```tex
Under the positivity convention of \Cref{sec:pool-ext:estimator} and the expectile--quantile equivalence, both \widehat\zeta_{\tau_n'} and \expectile{\tau_n'} are positive with probability tending to one.
```

For the bias-reduced estimator this is also true because only the exponent changes and the base is positive.

### 9. The notation for the bias term in the CI section could be more consistent

**Location:** `lines 1247--1253`.

You call the estimated bias `\hat\mu_{\gamma,n}^{\star}`. Since the target interval is for an expectile and the main theorem uses `\mu^{\xi,\star}`, a reader may wonder why the subscript is `\gamma`. This is not wrong—the surviving bias is the Hill/tail-index bias—but you should explain the notation or rename it to something like `\hat\mu_{\xi,n}^{\star}` / `\hat\mu_{\mathrm{ext},n}^{\xi}`. If you keep `\gamma`, add “the subscript emphasizes that only the Hill component remains at first order.”

### 10. The AMSE/variance discussion after bias correction should mention estimated-bias uncertainty

**Location:** `lines 1085--1094`.

You correctly say that after bias correction the first-order objective becomes variance. This relies on `\hat\Bc-\Bc=o_p(1)` contributing no first-order uncertainty. Add a short sentence:

```tex
No additional first-order variance term appears from \hat\Bc because its estimation error enters the normalized log ratio as
-\bm\omega_\gamma^\top(\hat\Bc-\Bc)=o_p(1).
```

This anticipates an obvious examiner question.

## Minor revisions and presentation issues

1. **Line `943`:** say “on the `\sqrt{k}/\ell_n` scale” when introducing the retained bias. The phrase “the limit retains” is true but should name the normalization.

2. **Lines `988--995`:** the order calculation for replacing `\hat\gamma_n` inside `\psifn` is correct, but it assumes the Hill estimator stays in a compact subinterval of `(0,1)`. Add “on the same high-probability compact event used for the Taylor expansion of `\log\psifn`.”

3. **Lines `1000--1003`:** “Assume the hypotheses of the main theorem” is broad. For readability, repeat the crucial ones for this corollary: `\ell_n\to\infty`, `\sqrt{k}/\ell_n\to\infty`, positivity convention, and `\hat\Bc\toprob\Bc`.

4. **Lines `1167--1177`:** define the `\pm` interval as a set or bracketed interval. For example:
   ```tex
   I_{n,\star}^{\log}=[C_n-r_n,C_n+r_n].
   ```
   The current notation is common but informal for a theorem statement.

5. **Lines `1178--1185`:** good that you define the exponential image, but the notation `\exp(I)` should be clarified once as elementwise image of an interval.

6. **Lines `1240--1280`:** the remark is useful, but after the equivalence with the bias-reduced estimator is stated, it can be shortened. At present it partially repeats Section 4.6.

7. **Lines `1292--1296`:** the statement that there is no special restriction at `m(\gamma)=0` is good. Consider moving it slightly earlier, near the standard-error definition, because it reassures the reader before the corollary rather than after.

8. **Cross-references:** all labels referenced inside Sections 4.6--4.7 appear to exist in the uploaded sources, and I found no duplicate labels among the uploaded `.tex` files.

## Suggested replacement text for the most important practical paragraph

Replace the final paragraph of Section 4.7 with something closer to:

```tex
In the distributed common-distribution case, the natural variance-dominated
choice is to use the variance-optimal effective-sample-size weights of
\eqref{eq:pool-ext:var-opt-distrib}, together with the matched convention
\hat{\bm\omega}_q=\hat{\bm\omega}_\gamma for the point estimator. Under
undersmoothing, or more generally whenever the limiting centering condition
\bm\omega_\gamma^\top\Bc=0 holds, this yields the variance-only interval
\eqref{eq:pool-ext:CI-log} without estimating \Bc. Outside such a centered
calibration, the same variance-only interval is not asymptotically centered;
valid inference then requires either the bias-reduced estimator
\eqref{eq:pool-ext:bias-reduced-estimator} or, equivalently, the bias-centered
log interval \eqref{eq:pool-ext:CI-log-bias-centred}, both of which require a
consistent estimator of the Hill-bias vector.
```

## Suggested addition to Section 4.6 proof

Add this after defining the bias-reduced estimator and before the corollary proof, or at the beginning of the proof:

```tex
Because \hat\Bc\toprob\Bc,
\[
\sqrt{k}\{\overline\gamma_n(\bm\omega_\gamma)-\gamma\}
=
\sqrt{k}\{\hat\gamma_n(\bm\omega_\gamma)-\gamma\}
-\bm\omega_\gamma^\top\Bc+o_p(1).
\]
Hence the first coordinate of \Cref{prop:pool-ext:input-clt} is recentered,
while the second coordinate and the covariance matrix are unchanged. In
particular the joint input required by \Cref{prop:bg:plug-in-clt} remains
valid with a centered first component.
```

For the estimated-weight case, add the analogous sentence with `\hat{\bm\omega}_\gamma^\top\hat\Bc`.

## Strengths worth preserving

- The sections correctly exploit the key structural point of the chapter: the intermediate QB terms disappear at first order after division by `\ell_n`.
- The minimal correction—correcting only the extrapolation exponent—is elegant and mathematically justified on the very-extreme scale.
- The distinction between variance-optimal and AMSE-optimal weights after bias correction is conceptually correct.
- The log-scale CI is the right inferential object; it respects positivity and gives a natural multiplicative original-scale interval.
- The text appropriately warns that second-order bias estimation is unstable and model-dependent.

## Final recommendation

Revise before submission. I would classify the current Sections 4.6--4.7 as **promising but not yet examiner-proof**. The mathematical backbone is in place, but the implementation-facing statements need stricter centering conditions, the bias-reduced/bias-centered equivalence should be made explicit, and the proof should display the recentered joint input rather than relying on a compressed repetition of the previous log decomposition.
