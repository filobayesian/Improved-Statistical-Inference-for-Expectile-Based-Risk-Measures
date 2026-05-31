# Strict reviewer feedback on Sections 3.5--3.6 and relevant appendix proofs

## Scope reviewed

I reviewed the current source in:

- `03_pooled_intermediate.tex`, Section 3.5, `Variance- and AMSE-optimal weights`, approximately lines 889--1311.
- `03_pooled_intermediate.tex`, Section 3.6, `Estimated weights and confidence intervals`, approximately lines 1312--1631.
- `main.tex`, appendix proofs of Propositions 3.4--3.6 and Corollary 3.7, approximately lines 991--1602.

I did not verify compilation because the uploaded material does not include the full thesis source tree, preamble, bibliography, or all included chapters. The review below is therefore a mathematical and exposition audit of the available source, not a full build audit.

## Overall verdict

The mathematical spine of these sections is strong. The variance factorisation, the change of variables \((\omega_\gamma,\omega_q) \mapsto (u,\omega_q)\), the Lagrange multiplier solution for the general variance optimum, the AMSE stacked quadratic form, and the estimated-weight CI lift are largely correct. I did not find a fatal algebraic error in the displayed variance-optimal or AMSE-optimal formulae.

That said, I would not yet consider Sections 3.5--3.6 thesis-ready. The main problems are not the core algebra, but the gap between population formulae and feasible implementation, especially in the equal-fraction plug-in variance, the handling of the singular case \(m(\gamma)=0\), and the strength of several claims made by prose rather than by explicit hypotheses. These are fixable, but they should be fixed before submission.

## Highest-priority issues

### 1. The equal-fraction plug-in variance formula is ambiguous and can be inconsistent with the stated default weights

**Location:** `03_pooled_intermediate.tex`, lines 1338--1360 and 1555--1570.

You first define the canonical equal-fraction plug-in weight as
\[
\hat\omega_j^{\mathrm{Var}} = k_j/k.
\]
You then say that, equivalently, one may insert a consistent diagonal covariance plug-in into
\[
\hat V_c^{-1}\mathbf 1/(\mathbf 1^\top \hat V_c^{-1}\mathbf 1).
\]
Later, however, the practical CI paragraph gives the simplified plug-in variance as
\[
\hat\sigma^{\xi,2}
= \frac{(\hat m+\hat L^\star)^2+1}{\mathbf 1^\top \hat V_c^{-1}\mathbf 1}.
\]
This expression is the optimal-value formula associated with inverse-covariance weights. It is not, in finite samples, automatically the same as evaluating the variance formula at the earlier default vector \(k_j/k\):
\[
[(\hat m+\hat L^\star)^2+1]\,(k_1/k,\ldots,k_m/k)^\top \hat V_c (k_1/k,\ldots,k_m/k).
\]
The two agree exactly only under a specific covariance plug-in structure, for example \(\hat V_c\) proportional to \(\operatorname{diag}(k/k_j)\). They have the same limit under consistency, but the thesis currently slides between two finite-sample implementations without saying which interval is actually being proposed.

**Required fix:** Choose one implementation and state it explicitly.

A clean fix is:

- If the recommended implementation is \(\hat\omega_j=k_j/k\), define the CI variance by direct substitution into \eqref{eq:pool-int:sigma-xi}.
- If the recommended implementation is \(\hat\omega=\hat V_c^{-1}\mathbf 1/(\mathbf 1^\top\hat V_c^{-1}\mathbf 1)\), then do not call \(k_j/k\) the default finite-sample weight; call it the asymptotic or canonical simplified version.
- If you want both, state that the displayed denominator formula is exact only for the inverse-covariance plug-in, while the sample-size plug-in gives an asymptotically equivalent variance.

This is the most important implementation-level correction in Section 3.6.

### 2. The singular case \(m(\gamma)=0\) is acknowledged, but the feasible plug-in procedure does not safely handle it

**Location:** `03_pooled_intermediate.tex`, lines 1013--1042, 1119--1126, 1362--1390, 1423--1428, and 1572--1591; appendix `main.tex`, lines 1196--1220.

The population theory correctly separates the case \(m(\gamma)\ne0\) from \(m(\gamma)=0\). The general variance-optimal formula for \(\omega_\gamma\) divides by \(m(\gamma)\), and Proposition 3.6 also uses \(m(\gamma)\ne0\) to make \(Q\), hence \(M\), positive definite.

The feasible plug-in paragraph, however, only says to seed \(\hat m\) from a preliminary Hill estimator. It does not specify what happens when \(\hat m\) is close to zero, or when \(\hat m=0\) exactly. Since the text later emphasizes CI validity at \(m(\gamma)=0\), this is not just a numerical detail: the general variance and AMSE plug-in formulae are not defined at the root.

**Required fix:** Add an explicit operational restriction and fallback. For example:

- For the general variance-optimal formula \eqref{eq:pool-int:var-opt-general-g}, assume \(|m(\gamma)|>\varepsilon\) for some fixed \(\varepsilon>0\), or define the plug-in only on the high-probability event \(|\hat m|>\varepsilon/2\).
- If \(|\hat m|\) is small, switch to the \(m(\gamma)=0\) single-vector solution
  \[
  \omega_q \propto (I+D^2)^{-1}V_c^{-1}\mathbf 1,
  \]
  with \(\omega_\gamma\) chosen as a canonical affine vector, for example \(k_j/k\) or \(V_c^{-1}\mathbf 1/(\mathbf 1^\top V_c^{-1}\mathbf 1)\).
- For AMSE, state clearly that the closed-form AMSE optimum is not claimed at \(m(\gamma)=0\), and that the CI corollary remains valid only for any externally supplied consistent affine weight pair.

Also change the phrase `At the boundary \(\gamma=\gamma^\star\)` around line 1584. This is not a boundary of the parameter space \((0,1/2)\); it is the interior zero of the derivative function \(m(\cdot)\). Use `At the zero` or `At the root`.

### 3. The continuity/denominator argument for plug-in weights is too compressed

**Location:** `03_pooled_intermediate.tex`, lines 1423--1436.

The paragraph says the optimum maps are continuous where denominators are bounded away from zero, and then says this holds whenever \(V_c\) and \(M\) are positive definite, with \(m(\gamma)\ne0\) for the general variance and AMSE formulae. This is directionally right, but as written it overstates the point.

Positive definiteness at the population value implies the relevant denominators are positive at the limit. It does not by itself define a uniform bounded-away-from-zero region unless you invoke a neighbourhood argument and show the plug-ins enter that neighbourhood with probability tending one. The proof should say this explicitly.

**Required fix:** Replace the current paragraph with a high-probability continuity statement of the form:

> Since the population denominators satisfy \(\mathbf 1^\top V_c^{-1}\mathbf 1>0\), \(\Delta>0\), and, when used, \(m(\gamma)\ne0\) and \(\det(A^\top M^{-1}A)>0\), continuity gives a neighbourhood of the population parameter on which the denominators remain non-zero. The assumed plug-in convergences imply that the estimated arguments lie in this neighbourhood with probability tending one. The continuous-mapping theorem then applies on that event.

This would make the feasibility argument rigorous rather than heuristic.

### 4. The bias-corrected CI remark is not formal enough for the claim it makes

**Location:** `03_pooled_intermediate.tex`, lines 1593--1618.

The remark says the bias-corrected interval inherits coverage provided \(\hat\mu^\xi\to\mu^\xi\). That is not quite sufficient as stated. You also need the same estimated-weight consistency, plug-in variance consistency, log-scale positivity, and high-probability well-definedness conditions used in Corollary 3.7. If the bias-corrected interval uses AMSE-optimal weights, you additionally need consistency of those weights under the second-order plug-ins.

**Required fix:** Either downgrade the passage to a heuristic implementation remark or state a short formal corollary. A precise version should define the log interval explicitly:
\[
\left[
\log\hat\xi_{\tau_n}^{\mathrm{pool}}
-\frac{\hat\mu^\xi}{\sqrt{k}}
\pm
z_{1-\alpha/2}\frac{\hat\sigma^\xi}{\sqrt{k}}
\right],
\]
and then list all required convergences:
\[
\hat\mu^\xi\to_p\mu^\xi,
\qquad
\hat\sigma^\xi\to_p\sigma^\xi>0,
\qquad
\hat\omega_\gamma\to_p\omega_\gamma,
\qquad
\hat\omega_q\to_p\omega_q.
\]
Without these extra hypotheses, the phrase `inherits the coverage` is too strong.

## Mathematical checks that look sound

### Variance factorisation and general variance optimum

The factorisation
\[
\sigma^{\xi,2}(\omega_\gamma,\omega_q)
= u^\top V_c u + \omega_q^\top V_c\omega_q,
\qquad
u = m(\gamma)\omega_\gamma + D\omega_q,
\]
with \(D=\operatorname{diag}(L^\star)\), is correct, assuming \(V_c\) and \(D\) commute as diagonal matrices. The appendix proof correctly transforms the constraints to
\[
u^\top\mathbf 1 - \omega_q^\top L^\star=m(\gamma),\qquad \omega_q^\top\mathbf 1=1.
\]
The Lagrange system and the resulting formulae for \(\omega_q^{\xi,\mathrm{Var}}\), \(\omega_\gamma^{\xi,\mathrm{Var}}\), and the minimum variance are algebraically consistent.

The departure formula
\[
\omega_q^{\xi,\mathrm{Var}}-\omega^{\mathrm{Var}}
=-\frac{m(\gamma)a+b}{\Delta}V_c^{-1}(L^\star-\bar L^\star\mathbf 1)
\]
is also consistent with the preceding closed form.

### AMSE quadratic form and closed form

The stacked representation
\[
\mathrm{AMSE}^\xi(w)
=(h^\top w+b^{\xi/Q})^2+w^\top Qw
=w^\top Mw+2b^{\xi/Q}h^\top w+(b^{\xi/Q})^2
\]
with \(M=Q+hh^\top\) is correct. The appendix proof correctly shows \(Q\) is positive definite when \(m(\gamma)\ne0\), because the map \(w\mapsto(u,\omega_q)\) is then a bijection. The closed form
\[
w^{\xi,\mathrm{AMSE}}
=M^{-1}\left[A(A^\top M^{-1}A)^{-1}
(\mathbf 1_2+b^{\xi/Q}A^\top M^{-1}h)-b^{\xi/Q}h\right]
\]
follows from the Lagrange equations.

A small improvement: in the appendix, after establishing positive definiteness of \(M\), explicitly state coercivity. Strict convexity on a closed affine set gives uniqueness, but coercivity is the reason a minimiser exists on the unbounded affine set.

### Estimated-weight CI lift

The estimated-weight lift in the proof of Corollary 3.7 is basically correct. The exact affine constraints are used in the right way: they cancel the deterministic centering terms \(\gamma\mathbf 1\) and \(\log Q_X(\tau_n)\mathbf 1\). This is the key step that lets mere consistency of the weights, with no rate, suffice.

The proof should keep emphasizing that exact normalisation is not cosmetic. If plug-in weights are numerically truncated, projected, or regularised, they must be re-normalised exactly for the current proof to apply as written.

## Medium-priority issues and suggested revisions

### 5. The undersmoothing argument should not be left to `inspection`

**Location:** `03_pooled_intermediate.tex`, lines 1471--1484; appendix `main.tex`, lines 1411--1418.

The conclusion is correct: if \(\sqrt{k_j}A(n_j/k_j)\to0\) for every \(j\), then \(B_c=0\), \(B_c^\star=0\), \(\Lambda^\bullet=0\), and \(b^{\xi/Q}=0\). But this is a central step in the CI section, so `inspection` is too casual.

Add one displayed line using the compatibility identity already established earlier:
\[
\Lambda^\bullet
=\sqrt{c_jS}\,\lambda_j e^{\rho L_j^\star}
\quad\text{for every }j.
\]
Then the implication \(\lambda_j=0\Rightarrow\Lambda^\bullet=0\) is immediate. This will make the CI assumptions self-contained and remove any possible doubt about the offset term \(b^{\xi/Q}\).

### 6. The phrase `precisely the equal-fraction case` is slightly too strong

**Location:** `03_pooled_intermediate.tex`, lines 924--928 and 1016--1024.

The algebraic collapse occurs when \(L^\star\) is a scalar multiple of \(\mathbf 1\). The equal-effective-sample-fraction condition is one sufficient and natural route to that collapse, and in your setup it is the main intended route. But the mathematical proposition itself only needs the limiting log-rate vector to be constant.

Suggested wording:

> ...with equality iff \(L^\star\) is a scalar multiple of \(\mathbf 1\). This is the limiting collapse induced by the equal-effective-sample-fraction condition used in the distributed-inference specialisation.

This is more precise and separates the algebraic condition from the modelling condition.

### 7. Positivity/log-scale assumptions should be stated explicitly in the CI corollary

**Location:** `03_pooled_intermediate.tex`, lines 1492--1539; appendix `main.tex`, lines 1386--1409 and 1587--1601.

The entire CI is on the log scale. The estimator is positive with high probability under the right-tail Weissman setup, and the population expectile is eventually positive by the expectile--quantile equivalence, but this should be stated. Otherwise a reader can object that \(\log\expectile_{\tau_n}\) and \(\log\hat\xi_{\tau_n}^{\mathrm{pool}}\) have not been explicitly justified.

Add a sentence such as:

> By the right-heavy-tailed setup and the expectile--quantile equivalence, \(\expectile_{\tau_n}>0\) eventually; the local Weissman factors and hence the pooled estimator are positive with probability tending one, so the log interval is well-defined on an event whose probability tends to one.

### 8. The AMSE plug-in discussion needs clearer separation between assumptions and implementable recipes

**Location:** `03_pooled_intermediate.tex`, lines 1392--1420.

This paragraph is honest that \(\hat B_c\), \(\hat B_c^\star\), and \(\hat b^{\xi/Q}\) are high-level assumptions without a second-order working model. Good. But the next paragraphs then treat AMSE plug-ins almost on the same footing as variance plug-ins.

I recommend adding a stronger warning:

> In the absence of a specified second-order model and estimators satisfying \eqref{eq:pool-int:plugin-amse}, the AMSE-optimal formula is an oracle or sensitivity-analysis device, not a fully feasible procedure.

That distinction matters for a thesis reader assessing what is practically contributed.

### 9. The discussion of finite-sample stability is too categorical

**Location:** `03_pooled_intermediate.tex`, lines 1445--1457 and 1619--1628.

The claim that second-order estimators `converge slowly enough` and are `substantially less stable` is plausible and well aligned with extreme-value practice, but it is broader than what you prove. Since this is a theory chapter, make the statement more conditional:

> Because second-order estimators are often unstable in finite samples, the variance-optimal plug-in is the conservative default unless the application supplies reliable second-order calibration.

This preserves the practical recommendation without overclaiming.

### 10. The phrase `variance degenerates` is misleading

**Location:** `03_pooled_intermediate.tex`, lines 1588--1591.

At \(m(\gamma)=0\), the variance does not degenerate to zero; the \(\gamma\)-block disappears and the variance reduces to the Weissman/log-rate component. Replace `degenerates to` with `reduces to`.

## Minor line-edit and presentation issues

1. **Avoid overloading `m`.** The text uses \(m\) both for the number of samples and for the derivative function \(m(\gamma)\). This is survivable but visually costly in Sections 3.5--3.6, where both objects appear constantly. Consider renaming the derivative to \(\dot\ell_\psi(\gamma)\), \(m_\psi(\gamma)\), or \(r(\gamma)\).

2. **Clarify `both quadratic forms are individually minimised`.** Around lines 919--923, this is heuristically true only after fixing the relevant affine sums. A stricter phrasing would be: `For a quadratic form \(x^\top V_cx\) under a constraint \(x^\top\mathbf 1=d\), the minimiser is proportional to \(V_c^{-1}\mathbf 1\).`

3. **Show one more line for the equal-fraction specialisation of \(\omega_\gamma\).** In the appendix, line 1190 says `A symmetric calculation gives`. Since \(\omega_\gamma\) is the more complicated formula, it would be better to show the one-line substitution. This is not mathematically necessary, but it improves reader confidence.

4. **Use `root` rather than `boundary`.** As noted above, \(\gamma^\star\approx0.2178\) is an interior root of \(m\), not a boundary.

5. **State whether negative affine weights are allowed in the implemented CI.** Earlier sections allow affine, possibly negative, weights. Section 3.6 should remind the reader that the log-geometric form remains well-defined only because the local Weissman factors are positive; otherwise negative weights can look alarming in a risk-measure context.

6. **Be consistent about `estimated` versus deterministic weights.** The vector \((k_j/k)_j\) is deterministic once thresholds are fixed. Calling it `estimated` in the same breath as inverse-\(\hat V_c\) weights blurs the distinction.

## Appendix-specific assessment

### Proof of Propositions 3.4 and 3.5

This proof is the strongest part of the reviewed appendix. The change of variables, dual system, Cauchy--Schwarz argument, explicit formulae, departure identity, equal-fraction reduction, and \(m(\gamma)=0\) case all check out.

Recommended revisions:

- Remove extra blank spacing after the section heading.
- Replace the last phrase `along directions in \(\mathrm{span}\{\mathbf 1,L^\star,\ldots\}\)` with a more precise statement or delete it. The exact solution is already displayed; the span comment is vague and not needed.
- In the Cauchy--Schwarz equality discussion, simply say equality holds iff \(L^\star\in\mathrm{span}\{\mathbf 1\}\). The positivity of components of \(V_c^{-1}\mathbf 1\) is not the reason for equality.

### Proof of Proposition 3.6

The proof is algebraically correct. The positive-definiteness argument is valid under \(m(\gamma)\ne0\), and the closed form follows from the Lagrange system.

Recommended revisions:

- Add the word `coercive` after proving \(M\succ0\) to justify existence on the unbounded affine constraint set.
- After deriving the block FOC, explicitly state that \(\lambda_\gamma,\lambda_q\) are Lagrange multipliers, not the second-order bias-rate constants \(\lambda_j\). The notation is understandable but potentially confusing.

### Proof of Corollary 3.7

The proof is basically sound and uses the exact affine constraints correctly. The strongest part is the estimated-weight lift: subtracting the deterministic centering terms before applying \(o_p(1)\times O_p(1)\\) is exactly the right argument.

Recommended revisions:

- Add a high-probability event on which all logarithms and square roots are defined.
- In Step (iii), say explicitly that \(\hat\sigma^\xi>0\) with probability tending one before dividing by it.
- In Step (i), if you rely on the log-CLT from the proof of Theorem 3.3 rather than deriving it from the ratio CLT, keep the reference. If you want the corollary to be self-contained, add one sentence using \(\log(1+x)=x+o(x)\) when \(x=O_p(k^{-1/2})\).

## Suggested revision checklist

Before considering these sections final, I would make the following changes:

1. Decide whether the equal-fraction CI uses \(k_j/k\) weights or inverse-\(\hat V_c\) weights, and make the variance formula match that decision.
2. Add an explicit fallback or restriction for plug-in formulae when \(m(\gamma)\) or \(\hat m\) is near zero.
3. Rewrite the continuous-mapping paragraph for plug-in weights as a high-probability neighbourhood argument.
4. Formalise or soften the bias-corrected CI remark.
5. Add a displayed compatibility line proving undersmoothing implies \(\Lambda^\bullet=0\).
6. Add explicit log-positivity/well-definedness language to the CI corollary and appendix proof.
7. Replace `boundary` with `root` and `degenerates` with `reduces` near the \(m(\gamma)=0\) discussion.
8. Consider renaming the derivative function \(m(\gamma)\) to avoid collision with the number of samples.

## Bottom line

The core theory is credible. The variance and AMSE algebra is largely correct, and the appendix contains enough detail for a mathematically trained reader to follow the derivations. The main thesis risk is that Section 3.6 currently presents feasible inference more cleanly than the implementation details justify. Tightening the plug-in definitions, the \(m(\gamma)=0\) handling, and the CI assumptions would substantially improve both correctness and reader trust.
