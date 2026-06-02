# Strict review of Chapter 4: *Extrapolation to very-extreme expectile levels*

I reviewed the uploaded Chapter 4 file, together with the relevant context in Chapters 2--3 and the appendix proofs contained in `main(3).tex`. I focus here on mathematical correctness, internal coherence, and coherence with the cited results as they are stated or restated in the thesis. No `.bib` file or source PDFs of the cited papers were uploaded, so comments about cited works are based on the thesis's own restatement of those results and on their standard role in the extreme-value/expectile theory developed in the preceding chapters.

## Overall verdict

Chapter 4 is structurally strong and mostly mathematically correct **conditional on the plug-in extrapolation lemma**. The estimator definition, the matched-weight identity, the main CLT mechanism, the first-order optimal weights, the bias-correction argument, and the log-scale confidence intervals are internally coherent and fit naturally with Chapter 3.

However, I would not yet consider the chapter final. There is one major proof gap: the deterministic extrapolation-bias verification in Section 4.2 is too compressed for a diverging extrapolation ratio. There is also a scope/wording issue: the chapter sometimes sounds like it inherits the full generality of the pooled Weissman framework of Daouia--Padoan--Stupfler, whereas the actual Chapter 3 input CLT is proved only in the independent common-distribution distributed setting. These are fixable, but they should be fixed before you build further thesis material on Chapter 4.

---

## Major comments

### 1. The deterministic extrapolation-bias control is under-proved

**Location:** Chapter 4, lines 190--231, especially lines 213--221.

You need to prove or cite a result for the term
\[
\log\expectile{\tau_n'}-\log\expectile{\tau_n}-\gamma\ell_n,
\qquad
\ell_n=\log\frac{1-\tau_n}{1-\tau_n'},
\]
when the ratio
\[
y_n:=\frac{1-\tau_n}{1-\tau_n'}=e^{\ell_n}\to\infty.
\]
The decomposition in lines 192--210 is correct, but the justification in lines 213--221 is not yet rigorous enough.

The first bracket is
\[
\log\Quant_X(\tau_n')-\log\Quant_X(\tau_n)-\gamma\ell_n
=\log U(t_n y_n)-\log U(t_n)-\gamma\log y_n,
\]
where
\[
t_n=(1-\tau_n)^{-1},\qquad y_n=e^{\ell_n}.
\]
The second-order condition \(\mathcal C_2(\gamma,\rho,A)\), as stated in Chapter 2, gives convergence for fixed \(y\), locally uniformly on compact \(y\)-sets. Here \(y_n\to\infty\). Therefore the sentence “The first bracket is controlled by the second-order quantile expansion” is not by itself sufficient. Potter bounds for \(A\) help only after you have a sequential or uniform large-\(y\) bound of the form
\[
\log U(t_n y_n)-\log U(t_n)-\gamma\log y_n=O(A(t_n))
\]
under \(\rho<0\), or an equivalent lemma from de Haan--Ferreira / Weissman theory.

A clean fix is to insert a short lemma before Theorem 4.2. For example:

```tex
\begin{lemma}[Sequential deterministic extrapolation control]
Let \(t_n=(1-\tau_n)^{-1}\), \(y_n=(1-\tau_n)/(1-\tau_n')\), and suppose
\(y_n\to\infty\), \(t_n\to\infty\), \(\rho<0\), and
\(\sqrt{k}A(t_n)=O(1)\). If the second-order quantile condition is used in
its Weissman/sequential form
\[
  \log U(t_n y_n)-\log U(t_n)-\gamma\log y_n=O(A(t_n)),
\]
then
\[
  \frac{\sqrt{k}}{\ell_n}
  \{\log U(t_n y_n)-\log U(t_n)-\gamma\log y_n\}\to0 .
\]
Moreover, using the expectile--quantile expansion and Potter bounds for
\(A\in RV_\rho\),
\[
  \frac{\sqrt{k}}{\ell_n}
  \left[
  \log\frac{\expectile{\tau_n'}/\Quant_X(\tau_n')}
           {\expectile{\tau_n}/\Quant_X(\tau_n)}
  \right]\to0
\]
whenever \(\sqrt{k}/\Quant_X(\tau_n)\to0\).
\end{lemma}
```

Then prove it carefully. The proof should explicitly use
\[
A(t_n y_n)=O(A(t_n))
\]
for \(\rho<0\), and
\[
\Quant_X(\tau_n')\ge \Quant_X(\tau_n)
\]
eventually, so that the moment terms are bounded by order \(\Quant_X(\tau_n)^{-1}\). The final bound should be
\[
\frac{\sqrt{k}}{\ell_n}
\{\log\expectile{\tau_n'}-\log\expectile{\tau_n}-\gamma\ell_n\}
=O\!\left(\frac{\sqrt{k}A(t_n)}{\ell_n}\right)
+O\!\left(\frac{\sqrt{k}}{\ell_n\Quant_X(\tau_n)}\right)+o(1),
\]
which tends to zero under the stated assumptions.

Without this lemma or a precise citation, Section 4.2 does not fully verify the key high-level assumption of \(\Cref{prop:bg:plug-in-clt}\).

---

### 2. The scope should be stated as the independent common-distribution specialization

**Location:** lines 80--85, 717--727, 729--760, 871--873.

Chapter 4 says it keeps the setup of \(\Cref{sec:pool-int:setup}\). That setup is not the full general tail-copula pooling framework of Chapter 2; it is the independent common-distribution distributed setting. This matters because \(\Cref{prop:pool-int:joint-clt}\), which is the input to Chapter 4, uses cross-sample independence and the diagonal matrix \(\Vc\) in \(\Cref{eq:bg:V_c-diagonal}\).

The chapter is mathematically coherent under that specialization. But some prose is too broad. In particular, phrases such as “the exact expectile analogue of \(\Cref{thm:bg:pool-weissman}\)” should be qualified as:

```tex
in the independent common-distribution distributed specialization used in
\Cref{ch:pool-int}.
```

If you want Chapter 4 to cover the full Daouia--Padoan--Stupfler tail-copula setting, then \(\Cref{prop:pool-ext:input-clt}\) is not enough as currently justified. Under cross-sample tail dependence, the cross-covariance between a Hill component from sample \(j\) and a log-order-statistic component from sample \(\ell\) need not be represented by the simple \(\bm D^\star\Vc\) structure inherited from the independent-sample proof. You would need a new joint \((\hat\gamma,\log\hat q^\star)\) CLT under \(\mathcal J(\bm R)\), not just the pooled Hill CLT.

Recommended fix: add a sentence near the start of Section 4.2:

```tex
All results in this chapter are stated in the independent common-margin
distributed setting of \Cref{sec:pool-int:setup}; references to the pooled
Weissman theorem of \Cref{thm:bg:pool-weissman} are analogies within this
specialization, not extensions to the full tail-copula framework.
```

---

### 3. The comparison with the pooled Weissman quantile theorem needs a finite-log-rate alignment argument

**Location:** lines 717--727 and lines 753--757.

The analogy with \(\Cref{thm:bg:pool-weissman}\) is correct, but you should explicitly reconcile the log rates. The pooled Weissman quantile theorem in Chapter 2 uses a log-rate of the form
\[
\log\frac{k}{n p},
\qquad p=1-\tau_n'.
\]
Chapter 4 uses
\[
\ell_n=\log\frac{1-\tau_n}{1-\tau_n'}.
\]
Under the finite intermediate log-rate condition of Chapter 3,
\[
\log\frac{k}{n(1-\tau_n)}=O(1),
\]
so
\[
\log\frac{k}{n(1-\tau_n')}
=\ell_n+\log\frac{k}{n(1-\tau_n)}
=\ell_n+O(1).
\]
Since \(\ell_n\to\infty\), the difference is negligible in the extreme normalization. Add this calculation near the first claim that Chapter 4 is the expectile analogue of the pooled Weissman theorem. It will make the link to the cited quantile result mathematically precise.

---

### 4. \(\Cref{prop:pool-ext:input-clt}\) is correct, but its proof should make the log-to-ratio step more explicit

**Location:** lines 298--337.

The covariance formula
\[
s_{\gamma,\xi}(\bm\omega_\gamma,\bm\omega_q)
=
 m(\gamma)\bm\omega_\gamma^\top\Vc\bm\omega_\gamma
+\bm\omega_\gamma^\top\bm D^\star\Vc\bm\omega_q
\]
is correct under the Chapter 3 independent-sample covariance structure.

The final sentence of the proof says that passing from a centered log-ratio to a relative error does not change the limit because \(e^x-1=x+o(x)\). That is right, but because this proposition is the key input to \(\Cref{prop:bg:plug-in-clt}\), I recommend writing the actual step:
\[
R_n=
\log\frac{\hatexpectile{\tau_n}^{\mathrm{pool}}}{\expectile{\tau_n}}
=O_p(k^{-1/2}),
\]
so
\[
\sqrt{k}\left[
\left(\frac{\hatexpectile{\tau_n}^{\mathrm{pool}}}{\expectile{\tau_n}}-1\right)-R_n
\right]
=
\sqrt{k}\,O_p(R_n^2)=O_p(k^{-1/2})=o_p(1).
\]
This removes any ambiguity about whether the covariance with the Hill coordinate is preserved.

---

## Mathematical correctness of the main components

### Estimator definition and matched-weight identities

**Location:** lines 377--538.

The estimator
\[
\hatexpectile{\tau_n'}^{\mathrm{pool},\star}
(\bm\omega_\gamma,\bm\omega_q)
=
\left(\frac{1-\tau_n'}{1-\tau_n}\right)^{-\hat\gamma_n(\bm\omega_\gamma)}
\hatexpectile{\tau_n}^{\mathrm{pool}}
(\bm\omega_\gamma,\bm\omega_q)
\]
is the correct plug-in object for \(\Cref{prop:bg:plug-in-clt}\).

The matched-weight identity
\[
\hatexpectile{\tau_n'}^{\mathrm{pool},\star}(\bm\omega,\bm\omega)
=
\psifn(\hat\gamma_n(\bm\omega))\hatWei_n(\tau_n'\mid\bm\omega)
\]
is algebraically correct. The warning in lines 514--538 is important and correct: if \(\bm\omega_\gamma\ne\bm\omega_q\), replacing the extrapolation exponent by \(\hat\gamma_n(\bm\omega_q)\) changes the first-order extreme limit through
\[
\sqrt{k}\{\hat\gamma_n(\bm\omega_q)-\hat\gamma_n(\bm\omega_\gamma)\}.
\]
This is one of the strongest parts of the chapter because it prevents a tempting but false simplification.

### Main CLT

**Location:** lines 551--715.

The proof of \(\Cref{thm:pool-ext:main}\) is correct once the deterministic extrapolation-bias control is fully justified. The log decomposition
\[
\log\frac{\hatexpectile{\tau_n'}^{\mathrm{pool},\star}}{\expectile{\tau_n'}}
=
\ell_n\{\hat\gamma_n(\bm\omega_\gamma)-\gamma\}
+
\log\frac{\hatexpectile{\tau_n}^{\mathrm{pool}}}{\expectile{\tau_n}}
-
\{\log\expectile{\tau_n'}-\log\expectile{\tau_n}-\gamma\ell_n\}
\]
is the right decomposition. The second term is correctly shown to vanish under \(\sqrt{k}/\ell_n\) because it is \(O_p(k^{-1/2})\) and \(\ell_n\to\infty\). The first term gives exactly the pooled-Hill limit. The final log-to-relative-error conversion is also correct because \(\ell_n/\sqrt{k}\to0\).

The theorem's limit
\[
\mathcal N\left(\bm\omega_\gamma^\top\Bc,
\bm\omega_\gamma^\top\Vc\bm\omega_\gamma\right)
\]
is therefore mathematically consistent with both \(\Cref{prop:bg:plug-in-clt}\) and \(\Cref{thm:bg:pool-hill}\).

### Optimal weights

**Location:** lines 729--938.

The variance-optimal weight
\[
\bm\omega^{\mathrm{Var}}
=\frac{\Vc^{-1}\bm1}{\bm1^\top\Vc^{-1}\bm1}
\]
and the AMSE-optimal weight
\[
\bm\omega^{\mathrm{AMSE}}
=
\frac{(1+\Bc^\top\Vc^{-1}\Bc)\Vc^{-1}\bm1
-(\bm1^\top\Vc^{-1}\Bc)\Vc^{-1}\Bc}
{(1+\Bc^\top\Vc^{-1}\Bc)(\bm1^\top\Vc^{-1}\bm1)
-(\bm1^\top\Vc^{-1}\Bc)^2}
\]
are correct. The Sherman--Morrison proof is also correct. The minimum AMSE formula is correct:
\[
\frac{1+\Bc^\top\Vc^{-1}\Bc}
{(1+\Bc^\top\Vc^{-1}\Bc)(\bm1^\top\Vc^{-1}\bm1)
-(\bm1^\top\Vc^{-1}\Bc)^2}.
\]

The claim that \(\bm\omega_q\) is first-order unidentified is also correct. The finite-sample recommendation \(\bm\omega_q=\bm\omega_\gamma\) is reasonable, but you correctly present it as an implementation convention rather than a consequence of first-order optimality.

One suggested wording improvement: in line 753, replace “exactly the quadratic structure” by “the same first-order quadratic structure, in the present independent common-margin setting.” This avoids implying that the full dependent-tail-copula version has been proved in Chapter 4.

### Bias reduction

**Location:** lines 940--1171.

The bias-reduction construction is mathematically sound. Since the extreme-scale first-order bias is only
\[
\bm\omega_\gamma^\top\Bc,
\]
correcting only the extrapolation exponent is sufficient. The argument in lines 1012--1020 is correct:
changing \(\hat\gamma_n\) to \(\overline\gamma_n\) inside the intermediate \(\psifn\)-factor would alter the log estimator by order \(O_p(k^{-1/2})\), which is killed by the \(\sqrt{k}/\ell_n\) normalization.

The assumption
\[
\hatBc\toprob\Bc
\]
is appropriately identified as non-automatic under abstract \(\mathcal C_2\). The proof of the centered CLT is correct because
\[
\sqrt{k}\{\overline\gamma_n(\bm\omega_\gamma)-\gamma\}
=
\sqrt{k}\{\hat\gamma_n(\bm\omega_\gamma)-\gamma\}
-\bm\omega_\gamma^\top\hatBc
\]
shifts the limiting mean by \(-\bm\omega_\gamma^\top\Bc\) and adds no first-order variance term when \(\hatBc-\Bc=o_p(1)\).

Minor improvement: in \(\Cref{cor:pool-ext:bias-reduced-clt}\), repeat explicitly that the deterministic affine vectors satisfy
\[
\bm\omega_\gamma^\top\bm1=\bm\omega_q^\top\bm1=1.
\]
The word “affine” already implies this in your thesis, but the corollary would be clearer if it restated the constraint.

### Confidence intervals

**Location:** lines 1173--1431.

The log-scale confidence interval is correct. The radius
\[
r_{n,\star}=z_{1-\alpha/2}\ell_n
\sqrt{\frac{\hat{\bm\omega}_\gamma^\top\hat\Vc\hat{\bm\omega}_\gamma}{k}}
\]
matches the log-scale CLT. The interval is correctly restricted to centered cases: either \(\bm\omega_\gamma^\top\Bc=0\) or the bias-reduced estimator is used. The bias-centered interval in \(\Cref{rem:pool-ext:CI-bias-centred}\) is algebraically equivalent to using the exponent-corrected estimator, since
\[
\log\hatexpectile{\tau_n'}^{\mathrm{pool},\star,\mathrm{bc}}
=
\log\hatexpectile{\tau_n'}^{\mathrm{pool},\star}
-
\hat\mu_{\gamma,n}^\star\frac{\ell_n}{\sqrt{k}}.
\]
This section is coherent with Chapter 3's treatment of variance-only intervals versus bias-centered intervals.

One caveat to state more explicitly: consistency of \(\hat\Vc\) and \(\hat{\bm\omega}_\gamma\) is assumed, not proved here. If \(\hat{\bm\omega}_\gamma\) is constructed as an optimizer involving \(\hat\Vc\) and \(\hatBc\), the required convergence should be referenced back to the corresponding feasible-weight discussion in Chapter 3 or Chapter 2.

---

## Internal coherence

The chapter's internal flow is good:

1. Section 4.2 identifies the intermediate pooled estimator and checks the plug-in inputs.
2. Section 4.3 defines the extrapolated estimator and clarifies matched versus unmatched weights.
3. Section 4.4 applies the plug-in CLT.
4. Section 4.5 derives weights from the surviving Hill component.
5. Sections 4.6--4.7 handle bias correction and inference.

The most important internal coherence point is handled well: \(\bm\omega_q\) affects the finite-sample anchor but disappears from the first-order very-extreme limit. The chapter explains this consistently in the estimator section, theorem, optimal-weight section, bias-reduction section, and confidence-interval section.

The only internal coherence risk is that the deterministic ratio control is discussed before \(\Cref{prop:pool-ext:input-clt}\), but it is a load-bearing assumption for the main theorem. It deserves to be elevated from a paragraph to a named lemma or at least a displayed claim with proof.

---

## Coherence with previous chapters and cited works

### Coherence with Chapter 2

Chapter 4 correctly uses the following Chapter 2 results:

- \(\Cref{prop:bg:expectile-quantile}\) for the same-level expectile--quantile equivalence.
- \(\Cref{eq:bg:c-gamma-rho}\) for the second-order expectile--quantile gap.
- \(\Cref{prop:bg:plug-in-clt}\) as the abstract extrapolation theorem.
- \(\Cref{thm:bg:pool-hill}\) for the limiting law of the pooled Hill estimator.
- \(\Cref{prop:bg:optimal-weights}\) for the quadratic weight formulas.

The stricter assumption \(\rho<0\) is also coherent with Chapter 2's statement that very-extreme extrapolation requires the strict second-order case.

### Coherence with Chapter 3

Chapter 4 correctly builds on Chapter 3's intermediate estimator
\[
\hatexpectile{\tau_n}^{\mathrm{pool}}(\bm\omega_\gamma,\bm\omega_q)
=\psifn(\hat\gamma_n(\bm\omega_\gamma))\hatWei_n(\tau_n\mid\bm\omega_q).
\]
The input CLT in \(\Cref{prop:pool-ext:input-clt}\) is the right two-dimensional object for the plug-in theorem.

The chapter also correctly explains why Chapter 4's AMSE weights are not the Chapter 3 expectile AMSE weights: the Chapter 3 terms \(m(\gamma)\), \(\bm L^\star\), \(\Bc^\star\), and \(b^{\xi/\Quant}\) enter only through the intermediate anchor and vanish after division by \(\ell_n\).

### Coherence with Daouia--Padoan--Stupfler 2021

The use of their pooled Hill and pooled Weissman weight structure is coherent, but only after the scope qualification above. In their pooled Weissman quantile theorem, the target is an extreme quantile and the log rate is \(\log(k/(np))\). Chapter 4's target is an expectile and its plug-in log rate is \(\ell_n\). These are asymptotically equivalent under the finite-log intermediate anchoring, but the chapter should explicitly show this.

### Coherence with Daouia--Girard--Stupfler 2018/2020 and Davison--Padoan--Stupfler 2023

The use of the iid extreme-expectile extrapolation idea and the plug-in proposition is coherent. The cited plug-in proposition is exactly the right abstraction for Chapter 4. The only weakness is not the choice of cited theorem, but the local verification of its deterministic log-ratio assumption.

---

## Smaller comments and suggested edits

### A. Clarify “global” versus “local” very-extreme levels

**Location:** lines 154--157.

This paragraph is correct. You can make it slightly more explicit by deriving \(\alpha_j\): from \(n_1/n_j\to b_j\), fixed \(m\) implies
\[
\alpha_j=\lim\frac{n_j}{n}
=\frac{b_j^{-1}}{\sum_{i=1}^m b_i^{-1}}.
\]
Then
\[
n_j(1-\tau_n')\to\alpha_j c.
\]
This would make the local interpretation fully transparent.

### B. Avoid overusing “exact” where the statement is asymptotic

**Location:** lines 717--727.

The estimator identities in Section 4.3 are exact. The analogy with the pooled Weissman theorem is asymptotic. Consider replacing

```tex
\Cref{thm:pool-ext:main} is the exact expectile analogue of ...
```

by

```tex
\Cref{thm:pool-ext:main} is the first-order expectile analogue of ...
```

or

```tex
within the independent common-margin specialization, \Cref{thm:pool-ext:main}
has the same first-order structure as ...
```

### C. State positivity conventions once more for bias-corrected estimators

**Location:** lines 980--1021 and 1202--1247.

The positivity convention is already stated earlier and is mathematically adequate. Still, the bias-corrected estimator changes the exponent but keeps the same positive intermediate anchor. Add one sentence:

```tex
The correction does not introduce any new log-domain restriction, because the
base \((1-\tau_n')/(1-\tau_n)\) is deterministic and positive; the only
random positivity requirement remains that of the intermediate anchor.
```

### D. Notation \(m\) versus \(m(\gamma)\)

The thesis uses \(m\) both for the number of samples and for the derivative function \(m(\gamma)=d\log\psifn(\gamma)/d\gamma\). This is not a mathematical error, but in Chapter 4 both appear frequently. Consider renaming the derivative in the final thesis to something like \(\dot\ell_\psi(\gamma)\) or \(d_\psi(\gamma)\), unless the notation is already too entrenched.

---

## Required fixes before continuing

1. Add a rigorous lemma or citation for the deterministic ratio control in lines 190--231, covering the diverging ratio \(y_n=e^{\ell_n}\to\infty\).
2. Qualify the chapter's scope as the independent common-distribution distributed setting inherited from Chapter 3.
3. Add the finite-log-rate calculation linking \(\ell_n\) to the pooled Weissman quantile rate \(\log(k/(n(1-\tau_n')))\).
4. Restate affine constraints in the bias-reduced corollary and, where convenient, in estimated-weight statements.
5. Keep the matched-weight warning in lines 514--538; it is important and correct.

After these revisions, Chapter 4 should be mathematically coherent with the preceding chapters and with the cited extrapolation/pooling framework.
