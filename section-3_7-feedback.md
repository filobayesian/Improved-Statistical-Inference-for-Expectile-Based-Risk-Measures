# Section 3.7 and Appendix Proof Audit

**Scope reviewed:** `03_pooled_intermediate.tex`, Section 3.7 (`sec:pool-int:test`, lines 1707--1974), and the appendix proof of Theorem 3.9 in `main.tex` (`app:proofs:hom-test`, lines 1637--2007).

**Reviewer verdict:** the algebraic core of the section is mostly sound, especially the GLS quadratic-form derivation and the bias-collinearity argument. However, the section is **not yet thesis-ready** because it overstates what the proposed test validates and because the central chi-square calibration is easy to misread as valid under the whole common-marginal null. The theorem itself partially acknowledges the noncentral limit, but the surrounding prose weakens that precision.

## Major findings requiring revision

### 1. The test does not validate the common marginal assumption

**Location:** `03_pooled_intermediate.tex` lines 1710--1718, 1864--1866, 1923--1930.

The section motivates the statistic as a way to validate the chapter's common marginal assumption before pooling. This is too strong. The statistic tests dispersion of **per-sample high-expectile estimates at the chosen level**, on a root-`k` log scale. It cannot validate equality of the whole marginal distribution, and it does not directly test the common-`gamma` assumption except indirectly through the consequences of tail-index or tail-scale differences for the expectile target.

The theorem statement also says that the common-marginal null is “equivalently” the common-target centring

```tex
\bm\Xi_{n}^{\star}=\log\expectile{\tau_n}\bm 1.
```

This equivalence is false. A common marginal implies the common-target centring, but common target equality at one level does not imply a common marginal. Replace “equivalently” with “and hence” or “in particular.”

**Required correction:** reframe the test as a diagnostic for root-`k` homogeneity of the target high expectiles, not as validation of the common marginal model. A safer opening would be:

```tex
Although the chapter's main theory is developed under a common marginal F,
the statistic below should be read only as a diagnostic for root-k equality
of the high-expectile targets being pooled. It can reveal tail-scale or
tail-index incompatibilities that affect the expectile target, but failure
to reject does not validate equality of the full marginal distributions.
```

### 2. The central chi-square calibration is not valid under the full stated null

**Location:** `03_pooled_intermediate.tex` lines 1867--1915 and 1931--1946.

The theorem correctly derives the general limit

```tex
\Lambda_n^\xi \Rightarrow \chi^2_{m-1}(\delta),
```

where the noncentrality is the GLS projection of the asymptotic bias vector `\bm\beta`. Therefore, under the chapter's common-marginal model, the statistic is generally **noncentral** unless `\bm\beta` is collinear with `\bm 1`. A central `\chi^2_{m-1}` critical value has asymptotic size `\alpha` only in the two special cases listed later: undersmoothing or equal-fraction distributed inference.

The text is mathematically aware of this, but the section title, motivation, and discussion still make the test sound like a standard central chi-square test. That is risky for a thesis reader.

**Required correction:** split the result into two layers:

1. A theorem giving the general noncentral limit.
2. A corollary giving a valid central chi-square test only under `\delta=0`, especially under undersmoothing or equal effective sample fractions.

Also revise line 1928, where “non-rejection licenses the variance-optimal pooling recipes” is too strong. A test does not license a model; it only fails to find evidence against it at the chosen level. Use “does not contradict” or “is consistent with using.”

### 3. The formal null must be separated from the calibration assumptions

**Location:** `03_pooled_intermediate.tex` lines 1836--1858 and 1860--1915.

The section usefully introduces the root-`k` null

```tex
H_{0,k}^{\xi}:\quad
\sqrt{k}\,\min_{c\in\mathbb R}\|\bm\Xi_n^\star-c\bm 1\|\to0.
```

But the theorem then reverts to the common-marginal model as the null. These are not the same object. The theorem's CLT, covariance, and bias vector are derived under the common-marginal/common-tail setup; the diagnostic consistency statement is then added outside that model. This needs sharper separation.

**Required correction:** explicitly distinguish:

- the **model null** used to derive `\bm\beta` and `\bm\Sigma`;
- the **target-homogeneity null** `H_{0,k}^{\xi}`;
- the **central-calibration null** `H_{0,k}^{\xi}` plus `\bm\beta\in\mathrm{span}\{\bm 1\}` or a bias-removal/undersmoothing condition.

Without this separation, the reader may incorrectly think that root-`k` target equality alone gives a central chi-square limit.

### 4. The theorem should state well-definedness and invertibility conditions explicitly

**Location:** `03_pooled_intermediate.tex` lines 1720--1738, 1814--1827, 1860--1864.

The statistic uses logarithms and `\hat{\bm\Sigma}_n^{-1}`. Earlier parts of the chapter discuss high-probability positivity of Weissman factors and the event on which Hill estimates lie in `(0,1)`, but Theorem 3.9 should restate the relevant condition or explicitly refer back to it.

At minimum, add:

```tex
Assume m\ge2 and that the local QB factors are positive and the local Hill
estimators entering \log\psifn lie in (0,1) with probability tending one.
Assume also that \hat{\bm\Sigma}_n is symmetric positive definite with
probability tending one and \hat{\bm\Sigma}_n\to_p\bm\Sigma.
```

The condition `m\ge2` is needed for the test to be nontrivial. For `m=1`, the deviance is identically zero and the nominal `\chi^2_{0}` limit is not a useful test.

### 5. The diagnostic statement outside the common-marginal model needs a stronger warning

**Location:** `03_pooled_intermediate.tex` lines 1898--1907 and `main.tex` lines 1957--2007.

The consistency statement under alternatives is acceptable as a fixed/separated-alternative result, but it does not give a valid size statement outside the common-marginal model. In heterogeneous-margin settings, the covariance plug-in in line 1816 is generally not guaranteed to estimate the true covariance of the per-sample log-expectile vector unless additional assumptions are imposed.

**Required correction:** add a sentence such as:

```tex
This alternative-side statement is only a divergence result. It does not
supply a central null calibration for heterogeneous margins satisfying
root-k target equality; such a calibration would require the corresponding
heterogeneous covariance and bias structure.
```

## Proof-level audit

### 6. The GLS quadratic-form proof is essentially correct

**Location:** `main.tex` lines 1793--1905.

The projection matrix

```tex
\bm P_n=\bm I-
\frac{\bm1\bm1^\top\hat{\bm\Sigma}_n^{-1}}
     {\bm1^\top\hat{\bm\Sigma}_n^{-1}\bm1}
```

is the correct GLS residual-maker, and the identity

```tex
\bm M
=\bm\Sigma^{-1}
-\frac{\bm\Sigma^{-1}\bm1\bm1^\top\bm\Sigma^{-1}}
      {\bm1^\top\bm\Sigma^{-1}\bm1}
```

is correct. The standardisation to an orthogonal projection of rank `m-1` is also correct, and the noncentrality formula follows.

Minor improvement: line 1843 says the “three cross terms” each reduce to the same matrix. Two are negative and one is positive, so rewrite this sentence to avoid sign ambiguity.

### 7. The per-sample-to-joint CLT aggregation should be justified more explicitly

**Location:** `main.tex` lines 1737--1753.

The argument says that the independent scalar limits aggregate to a joint Gaussian vector. This is true, but for proof completeness you should add one sentence invoking Cramér-Wold or convergence of product characteristic functions for independent triangular-array blocks.

Suggested insertion:

```tex
Joint convergence follows by the Cramer-Wold device: for any fixed vector
a, the linear combination is a sum of independent per-sample terms whose
characteristic functions factor, and the marginal limits identified in
\eqref{eq:app:hom:per-sample} therefore combine into the stated Gaussian
law.
```

### 8. The deterministic expectile--quantile gap proof should mention the moment-negligibility condition here too

**Location:** `main.tex` lines 1706--1716.

The proof uses the second-order expansion for the deterministic gap. That expansion in the main theorem also contains a moment term controlled by

```tex
\sqrt{k}/\Quant_X(\tau_n)\to0.
```

Since Step (i) here works on the `\sqrt{k_j}` scale, the required negligibility follows from `k_j\asymp k`, but the proof should say so. Add a phrase after line 1708:

```tex
The moment remainder is also o(k_j^{-1/2}) because k_j\asymp k and
\sqrt{k}/\Quant_X(\tau_n)\to0.
```

### 9. The consistency proof is correct but should be written on the high-probability positive-definite event

**Location:** `main.tex` lines 1984--2007.

The distance argument is right, but it should explicitly restrict to the event where `\bm D_n=\hat{\bm\Sigma}_n^{-1}` is positive definite. The phrase “triangle inequality for `\|\cdot\|_{\bm D_n}`” only makes sense on that event.

A cleaner version is:

```tex
On the event \lambda_{\min}(\bm D_n)>\eta, define
S=\mathrm{span}\{\bm1\}. Then

d_{\bm D_n}(\hat\Xi_n,S)
\ge d_{\bm D_n}(\Xi_n^\star,S)-\|\hat\Xi_n-\Xi_n^\star\|_{\bm D_n}
\ge \sqrt{\lambda_{\min}(\bm D_n)}d(\Xi_n^\star,S)
    -\|\hat\Xi_n-\Xi_n^\star\|_{\bm D_n}.
```

This avoids the slightly unclear explanation involving the Rayleigh quotient at the `\bm D_n`-optimal `c`.

## Notation and presentation issues

### 10. Rename the Section 3.7 covariance matrix

**Location:** `03_pooled_intermediate.tex` lines 1755--1766.

The symbol `\bm\Sigma` was already used earlier for the 2-dimensional pooled input covariance `\bm\Sigma(\bm\omega_\gamma,\bm\omega_q)`. In Section 3.7 it is reused for the `m\times m` covariance of per-sample log-expectiles. This is not wrong locally, but it is easy to confuse.

Use a more specific symbol such as

```tex
\bm\Sigma_\Xi
```

and similarly `\hat{\bm\Sigma}_{\Xi,n}`.

### 11. Avoid the notation `\hat L_j^\star` for a deterministic finite-`n` log-rate

**Location:** `03_pooled_intermediate.tex` lines 1816--1823.

The quantity

```tex
\hat L_j^\star=\log(k_j/(n_j(1-\tau_n)))
```

is not an estimator of the limit; it is the finite-`n` deterministic log-rate `L_j(\tau_n)`. The hat and star together are misleading. Prefer `L_{j,n}` or simply `L_j(\tau_n)` in the plug-in covariance.

### 12. Replace “accept” and “licenses” with statistically precise language

**Location:** `03_pooled_intermediate.tex` lines 1928--1930 and 1968--1969.

Use “fail to reject” rather than “accept,” and avoid saying that non-rejection “licenses” pooling. Suggested wording:

```tex
A non-rejection is consistent with the pooling assumptions at the tested
level, while a rejection warns that the samples should not be pooled without
modelling heterogeneity.
```

### 13. Consider changing the section title

The current title, “A test of expectile-tail-homogeneity,” is acceptable but slightly vague. A more precise title would be:

```tex
A root-k diagnostic for high-expectile homogeneity
```

This better reflects the fact that the statistic is calibrated on the root-`k` log-expectile scale and is not a full test of common marginal distributions.

## What is strong and should be kept

- The covariance calculation in lines 1755--1783 is consistent with applying the row `(m(\gamma),1)` to the within-sample Hill/Weissman CLT.
- The noncentral chi-square derivation in the appendix is mathematically clean and uses the correct GLS residual projection.
- The condition `\bm\beta\in\mathrm{span}\{\bm1\}` is exactly the right centrality condition.
- The equal-fraction argument in `main.tex` lines 1917--1955 correctly uses the compatibility identity for `\Lambda^\bullet` to show that the bias vector becomes collinear.
- The consistency proof under separated alternatives has the right structure; it only needs sharper event handling and caveats about what it does not prove.

## Recommended restructuring

I recommend reorganising Section 3.7 as follows:

1. **Define the target diagnostic**: root-`k` equality of population log-expectiles, not common marginal equality.
2. **State the per-sample log-expectile CLT** with covariance `\bm\Sigma_\Xi` and bias `\bm\beta`.
3. **Theorem:** GLS statistic converges to `\chi^2_{m-1}(\delta)` under the common-marginal model.
4. **Corollary:** central `\chi^2_{m-1}` calibration is valid if `\delta=0`; list undersmoothing and equal-fraction distributed inference as sufficient conditions.
5. **Proposition or final paragraph:** divergence under separated alternatives, explicitly labelled as a consistency result, not a null calibration outside the common-marginal model.

## Bottom-line assessment

The section is close, but the current version blurs three distinct ideas: common marginality, high-expectile target equality, and central chi-square calibration. The proof can support the result once these are separated. Until then, the section risks overstating the diagnostic value of the test and the validity of the central chi-square rejection rule.
