# Chapter 2 feedback only

Scope: this note reviews Chapter 2 as a background chapter. I am deliberately not auditing the new Chapter 3 contribution here, except where Chapter 2 states a tool that later chapters are expected to import. The goal is to make Chapter 2 accurate, modest, and safe as a summary of existing EVT / expectile / pooling machinery.

Overall assessment: Chapter 2 is a good structural background chapter, but it currently states several imported results too strongly and contains a few mathematical inaccuracies that an examiner could object to even if the contribution chapters are correct. The highest-risk issues are: left-tail integrability is missing from the expectile assumptions; the risk-measure sign convention is internally inconsistent; the LAWS-versus-QB variance comparison is reversed in places; the tail-homogeneity chi-square theorem ignores nonzero asymptotic bias; and the pooled-weight / plug-in statements need exact normalization and bias qualifications.

---

## Detailed issues

### 1. Right-tail regular variation does not by itself imply finite second moment

1. **Location:** Section 2.1, final paragraph before Section 2.2, thesis p. 6.
2. **Severity:** Critical.
3. **Problem:** The text says that imposing \(\gamma \in (0,1/2)\) guarantees that \(X\) has finite second moment. This is only true for the right tail / positive part under the stated right-tail regular variation condition. Since \(X\) is introduced as real-valued, the left tail is uncontrolled by Condition 2.2. One can have a Pareto-type right tail with \(\gamma<1/2\) and an arbitrarily heavy negative tail, so \(E[X^2]\) or even \(E|X|\) may be infinite.
4. **Why it matters:** Expectiles require at least first-moment integrability under the centered definition, and the second-order expectile expansion later assumes a lower-tail moment condition. An examiner can object that the chapter derives expectile properties from a right-tail condition that does not control the left tail.
5. **Suggested fix:** Replace the sentence by:

   > For the expectile CLTs used below we shall impose \(\gamma\in(0,1/2)\) together with a lower-tail moment condition, for example \(E|X_-|^{2+\delta}<\infty\). The restriction \(\gamma<1/2\) ensures that the positive tail has finite second moment; the separate lower-tail assumption controls the negative part.

---

### 2. Proposition 2.8 is missing the integrability needed for expectiles

1. **Location:** Proposition 2.8, Section 2.4.1, thesis p. 10.
2. **Severity:** Critical.
3. **Problem:** The proposition assumes only Condition 2.2 with \(\gamma\in(0,1)\). This controls \(E[X_+]\), but not \(E[X_-]\). The expectile \(\xi_\tau(X)\) is defined earlier under \(E|X|<\infty\), so the proposition as stated is not well-posed for arbitrary real-valued \(X\).
4. **Why it matters:** The expectile-quantile equivalence is one of the main background tools. If its assumptions are incomplete, all later citations to this result look unsafe.
5. **Suggested fix:** State:

   > Suppose \(X\) satisfies Condition 2.2 with \(\gamma\in(0,1)\) and \(E[X_-]<\infty\). Then ...

   For the second-order expansion that follows, keep the stronger condition:

   > If in addition Condition 2.3 holds with \(\gamma\in(0,1/2)\) and \(E|X_-|^{2+\delta}<\infty\), then ...

---

### 3. The role of \(\gamma<1/2\) is overstated

1. **Location:** Section 2.1 final paragraph and Section 2.4.1, thesis pp. 6 and 10.
2. **Severity:** Major.
3. **Problem:** The text suggests that \(\gamma<1/2\) is needed for the expectile-quantile equivalence itself. But Proposition 2.8 states the first-order equivalence for \(\gamma\in(0,1)\). The stronger \(\gamma<1/2\) is needed for the CLT-level results and finite second-moment regime, not for the first-order proportionality.
4. **Why it matters:** This blurs the distinction between first-order EVT facts and CLT assumptions. A background chapter should be precise about which results require which tail-index range.
5. **Suggested fix:** Add a sentence after Proposition 2.8:

   > The first-order equivalence requires \(\gamma<1\) together with the required first-moment integrability. The stronger restriction \(\gamma<1/2\) enters the intermediate expectile CLTs and the second-order expansion used for inference.

---

### 4. The \(\rho=0\) case is allowed but later formulas are undefined

1. **Location:** Condition 2.3 and equation (2.7), thesis pp. 6 and 10.
2. **Severity:** Critical.
3. **Problem:** Condition 2.3 allows \(\rho\le 0\) and gives the \(\rho=0\) convention for the second-order condition. But the constant

   \[
   c(\gamma,\rho)=\frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}
   +\frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho}
   \]

   is not defined at \(\rho=0\). Theorem 2.5 and Proposition 2.12 explicitly impose \(\rho<0\), but equation (2.7) does not.
4. **Why it matters:** As written, the second-order expectile expansion is undefined for a parameter value admitted by the standing second-order condition.
5. **Suggested fix:** Either impose \(\rho<0\) before equation (2.7), or define the continuous extension:

   \[
   c(\gamma,0)=\frac{1}{1-\gamma}-\log(\gamma^{-1}-1)=m(\gamma).
   \]

   Also define \(\Psi_0(y)=\log y\) wherever \(\Psi_\rho\) is used later.

---

### 5. Log-based EVT estimators require positivity, but \(X\) is introduced as real-valued

1. **Location:** Hill estimator (2.1), Weissman estimator (2.2), Sections 2.2.1-2.2.2, thesis pp. 6-7.
2. **Severity:** Critical.
3. **Problem:** The Hill estimator uses

   \[
   \log\left(X_{n-i+1:n}/X_{n-k:n}\right),
   \]

   and Weissman uses \(X_{n-k:n}\) multiplicatively. These are not finite-sample well-defined if the relevant upper order statistics are nonpositive. Chapter 2 starts with a real-valued loss \(X\), not a positive random variable.
4. **Why it matters:** Heavy right-tail regular variation implies the high order statistics are eventually positive with probability tending to one if \(U(t)\to\infty\), but the estimator definitions still need a convention. Otherwise an examiner can ask how the Hill estimator is defined for losses with negative observations.
5. **Suggested fix:** Add before (2.1):

   > Since \(U(t)\to\infty\) under Condition 2.2, the event \(X_{n-k:n}>0\) has probability tending to one for intermediate \(k\). All log-based tail estimators are understood on this event. Equivalently, one may assume the upper tail is eventually supported on \((0,\infty)\), or work after a deterministic shift that leaves the tail index unchanged.

---

### 6. The expectile strict convexity statement invokes \(\operatorname{Var}X\) although only \(E|X|<\infty\) is assumed

1. **Location:** Section 2.3.1, after definition (2.3), thesis p. 8.
2. **Severity:** Minor.
3. **Problem:** The text says the objective is strictly convex whenever \(\operatorname{Var}X>0\). But the section assumes only \(E|X|<\infty\), so \(\operatorname{Var}X\) may be infinite or undefined.
4. **Why it matters:** It is not fatal, but it is mathematically imprecise and avoidable.
5. **Suggested fix:** Replace with:

   > The objective is strictly convex, and hence the expectile is unique, whenever \(X\) is not almost surely constant.

---

### 7. Proposition 2.6 overstates strict monotonicity in \(\tau\)

1. **Location:** Proposition 2.6(vi), thesis p. 8.
2. **Severity:** Major.
3. **Problem:** The map \(\tau\mapsto \xi_\tau(X)\) is stated to be strictly increasing for every integrable \(X\). This is false for degenerate \(X\). If \(X=c\) almost surely, then \(\xi_\tau(X)=c\) for all \(\tau\).
4. **Why it matters:** This is a simple counterexample. It is exactly the sort of statement an examiner can use to question the care taken in the background chapter.
5. **Suggested fix:** Replace item (vi) with:

   > The map \(\tau\mapsto\xi_\tau(X)\) is nondecreasing in general, and strictly increasing when \(X\) is nondegenerate under the usual support conditions. Moreover \(\xi_\tau(X)\to\operatorname{ess\,inf}X\) as \(\tau\downarrow0\) and \(\xi_\tau(X)\to\operatorname{ess\,sup}X\) as \(\tau\uparrow1\), with infinite limits allowed.

---

### 8. The risk-measure sign convention is internally inconsistent

1. **Location:** Chapter 2 opening and Section 2.3.3, thesis pp. 5 and 9.
2. **Severity:** Critical.
3. **Problem:** Chapter 2 begins with \(X\) as a real-valued random loss. Section 2.3.3 then defines \(\rho_\tau(X)=\xi_\tau(-X)\), interpreted as the expectile of the loss \(-X\) under a convention in which gains are positive. These are two different conventions: either \(X\) is a loss, or \(X\) is a financial position / gain.
4. **Why it matters:** Coherence, monotonicity, and signs of capital requirements depend on the convention. A background chapter should not silently switch conventions.
5. **Suggested fix:** Insert a convention paragraph at the start of Section 2.3.3:

   > In Sections 2.1-2.4 and in the contribution chapters, \(X\) denotes a loss and the high-level object is \(\xi_\tau(X)\). The coherence literature often writes risk measures on financial positions \(Y\), where larger \(Y\) is better; in that convention the corresponding capital requirement is \(\rho_\tau(Y)=\xi_\tau(-Y)\). The following theorem is stated in that position convention.

   Then be consistent: use \(Y\) in the coherence theorem if necessary, and return to loss notation afterward.

---

### 9. The 'only coherent and elicitable law-invariant risk measure' claim is overbroad

1. **Location:** Section 2.3.3, final paragraph, thesis p. 9.
2. **Severity:** Major.
3. **Problem:** The statement says that for \(\tau\in[1/2,1)\), the \(\tau\)-expectile is the only law-invariant risk measure that is both coherent and elicitable. This needs the precise class of risk measures and regularity/domain assumptions from Bellini et al. (2014). As written, it sounds universal.
4. **Why it matters:** This is a standard risk-measure-theory overclaim. It can be challenged immediately unless the assumptions of the characterization theorem are stated.
5. **Suggested fix:** Rewrite as:

   > Within the class of law-invariant monetary risk measures satisfying the regularity assumptions of Bellini et al. (2014, Theorem 14), expectiles are essentially the only examples that are both coherent and elicitable; under the appropriate sign convention, the coherent expectiles correspond to \(\tau\ge1/2\).

---

### 10. Elicitability is conflated with direct regulatory backtesting

1. **Location:** Section 2.3.3, thesis p. 9.
2. **Severity:** Minor.
3. **Problem:** The text says elicitability means expectile forecasts can be backtested directly. Elicitability guarantees the existence of strictly consistent scoring functions for comparative forecast evaluation. 'Backtesting directly' is acceptable informal language, but it is stronger and less precise.
4. **Why it matters:** In risk-management writing, 'backtesting' has regulatory connotations. An examiner may ask what exact backtesting procedure is meant.
5. **Suggested fix:** Replace with:

   > ... which means that competing expectile forecasts can be compared by empirical averages of a strictly consistent scoring function.

---

### 11. The Choquet representation section is too vague to be useful

1. **Location:** Section 2.3.4, thesis p. 9.
2. **Severity:** Style / Minor.
3. **Problem:** The section says Ehm et al. obtain a mixture representation, but gives no formula and says it is not used later.
4. **Why it matters:** Since Chapter 2 is meant to provide machinery used later, unused background should either be cut or made precise enough to justify inclusion.
5. **Suggested fix:** Either remove Section 2.3.4 entirely, or reduce it to one sentence in Section 2.3.3:

   > Ehm et al. (2016) also give a Choquet-type representation of expectile scoring functions; this representation is not used in the asymptotic arguments below.

---

### 12. The LAWS-versus-QB variance comparison is wrong

1. **Location:** Section 2.4.2, paragraph 'Comparison', thesis p. 11.
2. **Severity:** Critical.
3. **Problem:** The text says that the QB estimator has smaller variance for small \(\gamma\), while LAWS overtakes as \(\gamma\) approaches \(1/2\). This is reversed. The displayed variances are

   \[
   \sigma^2_{LAWS}(\gamma)=\frac{2\gamma^3}{1-2\gamma},
   \qquad
   \sigma^2_{QB}(\gamma)=\gamma^2(1+m(\gamma)^2).
   \]

   As \(\gamma\downarrow0\), \(\sigma^2_{LAWS}=O(\gamma^3)\), while \(\sigma^2_{QB}\) is of order \(\gamma^2\log^2(1/\gamma)\); LAWS is smaller. As \(\gamma\uparrow1/2\), \(\sigma^2_{LAWS}\to\infty\), while \(\sigma^2_{QB}\) remains finite; QB is smaller near \(1/2\). Solving the equality numerically gives a crossing around \(\gamma\approx0.2623\).
4. **Why it matters:** This is a concrete mathematical error in the background comparison. It does not directly invalidate the thesis contribution, but it weakens confidence in the asymptotic calculations.
5. **Suggested fix:** Replace the paragraph with:

   > The two variance formulas cross once in \((0,1/2)\), at approximately \(\gamma=0.2623\). For lighter heavy tails, i.e. small \(\gamma\), the LAWS variance is smaller. For sufficiently heavy tails and especially as \(\gamma\uparrow1/2\), the QB variance is smaller because the LAWS variance diverges. The thesis works with the QB construction not because it uniformly dominates LAWS, but because it composes directly with the pooled \((\widehat\gamma,\widehat Q)\) inputs.

---

### 13. 'The empirical quantile adds no bias' is imprecise

1. **Location:** Theorem 2.10 discussion, thesis p. 11.
2. **Severity:** Minor.
3. **Problem:** The text says the empirical quantile is \(\sqrt{n(1-\tau_n)}\)-unbiased. An order statistic is not exactly unbiased in the usual expectation sense. What is true is that its centered log-scale contribution has zero limiting mean at the CLT scale.
4. **Why it matters:** 'Unbiased' has a specific finite-sample meaning. Using it loosely invites objections.
5. **Suggested fix:** Replace with:

   > The empirical intermediate quantile contributes no asymptotic mean term at the \(\sqrt{n(1-\tau_n)}\) scale when centered at \(Q_X(\tau_n)\).

---

### 14. Theorem 2.11 says 'any consistent' intermediate estimator, which is too weak

1. **Location:** Section 2.4.3 and Theorem 2.11, thesis pp. 11-12.
2. **Severity:** Major.
3. **Problem:** The estimator \(\xi_{\tau_n}\) used as the intermediate anchor is described as 'any consistent intermediate-level estimator'. Mere consistency is not enough for the extrapolated CLT. One needs the intermediate estimator's error to be negligible after division by the diverging log factor, for example

   \[
   \sqrt{n(1-\tau_n)}\left(\widehat\xi_{\tau_n}/\xi_{\tau_n}-1\right)=O_p(1),
   \]

   or at least \(o_p(\log((1-\tau_n)/(1-\tau'_n)))\) on the corresponding scale.
4. **Why it matters:** The theorem is meant to summarize a known result. If stated with 'any consistent' estimator, it is mathematically too broad.
5. **Suggested fix:** Replace 'any consistent intermediate-level estimator' by:

   > any intermediate-level estimator satisfying a \(\sqrt{n(1-\tau_n)}\)-CLT, such as the LAWS or QB estimator under Theorems 2.9-2.10.

---

### 15. Proposition 2.12 should use visibly distinct notation for the estimator and the target

1. **Location:** Proposition 2.12, thesis pp. 12-13.
2. **Severity:** Major if the LaTeX source is genuinely ambiguous; Minor if only the PDF text extraction lost hats.
3. **Problem:** The proposition appears to say 'let \(\xi_{\tau_n}\) be an estimator of \(\xi_{\tau_n}\)' and then writes the ratio \(\xi_{\tau_n}/\xi_{\tau_n}-1\). If the rendered PDF clearly distinguishes hats/tilde symbols, this is only an extraction issue. If not, the notation is ambiguous.
4. **Why it matters:** Proposition 2.12 is described as the technical workhorse of the thesis. It must distinguish the population expectile from an arbitrary estimator without relying on context.
5. **Suggested fix:** Use a generic estimator symbol throughout:

   \[
   \widehat\xi_{\tau_n}^{\,I}
   \]

   for the intermediate-level anchor, and reserve \(\xi_{\tau_n}\) for the population expectile. State the input CLT as

   \[
   \sqrt{n(1-\tau_n)}
   \begin{pmatrix}
   \widehat\gamma_n-\gamma\\
   \widehat\xi_{\tau_n}^{\,I}/\xi_{\tau_n}-1
   \end{pmatrix}
   \Rightarrow
   \begin{pmatrix} \Gamma\\ \Delta \end{pmatrix}.
   \]

---

### 16. Proposition 2.12 is too specialized to the \(\sqrt{n(1-\tau_n)}\) scale

1. **Location:** Proposition 2.12, thesis pp. 12-13.
2. **Severity:** Major for modularity.
3. **Problem:** The proposition is introduced as an abstract plug-in lemma, but it is stated only for the scale \(\sqrt{n(1-\tau_n)}\). As a background tool, it would be cleaner and more reusable if stated with a generic sequence \(a_n\to\infty\).
4. **Why it matters:** Chapter 2 is supposed to provide tools for later chapters. A generic formulation prevents later scale mismatches and makes clear that the result is a plug-in principle, not tied to a particular estimator.
5. **Suggested fix:** State the lemma as:

   > Let \(a_n\to\infty\) and suppose
   > \[
   > a_n
   > \begin{pmatrix}
   > \widehat\gamma_n-\gamma\\
   > \widehat\xi_{\tau_n}^{I}/\xi_{\tau_n}-1
   > \end{pmatrix}
   > \Rightarrow
   > \begin{pmatrix}\Gamma\\\Delta\end{pmatrix}.
   > \]
   > If \(a_n/\log((1-\tau_n)/(1-\tau'_n))\to\infty\), \(a_n A((1-\tau_n)^{-1})=O(1)\), and the usual second-order conditions hold, then
   > \[
   > \frac{a_n}{\log((1-\tau_n)/(1-\tau'_n))}
   > \left(\widehat\xi^\star_{\tau'_n}/\xi_{\tau'_n}-1\right)
   > \Rightarrow \Gamma.
   > \]

---

### 17. Section 2.5.1 uses 'common marginal distribution function \(F_j\)' ambiguously

1. **Location:** Section 2.5.1, thesis p. 13.
2. **Severity:** Minor.
3. **Problem:** The text says the \(j\)-th sample has 'common marginal distribution function \(F_j\)'. In the general pooling framework, the marginals may be heterogeneous across \(j\). The intended meaning is probably that observations within sample \(j\) share the same marginal \(F_j\).
4. **Why it matters:** This is easy to misread because the same subsection later introduces a common-tail-index condition but not common marginals.
5. **Suggested fix:** Rewrite:

   > The \(j\)-th sample comprises iid observations with marginal distribution function \(F_j\), tail quantile function \(U_j\), and extreme-value index \(\gamma_j>0\).

---

### 18. Condition numbering is confusing around equation (2.13) and Condition 2.13

1. **Location:** Section 2.5.1, thesis pp. 13-14.
2. **Severity:** Style / Minor.
3. **Problem:** The common-tail-index equation is numbered (2.13), and the next displayed assumption is called Condition 2.13. This is not a formal LaTeX conflict because theorem and equation counters are separate, but it is visually confusing.
4. **Why it matters:** Background chapters should make imported assumptions easy to reference. A reader may confuse 'Condition 2.13' with equation (2.13).
5. **Suggested fix:** Rename the common-tail-index condition as \((H_\gamma)\) or leave it unnumbered:

   \[
   (H_\gamma)\qquad \gamma_1=\cdots=\gamma_m=\gamma.
   \]

   Then let 'Condition 2.13' be reserved for the tail-copula condition, or rename the latter as 'Condition 2.14'.

---

### 19. The tail-copula condition must visibly use survival functions

1. **Location:** Condition 2.13, thesis p. 14.
2. **Severity:** Major if the PDF/LaTeX lacks bars; Minor if this is only text extraction.
3. **Problem:** The parsed text reads \(F_j(X_j)\le x_j/s\), which would be a lower-tail event. For an upper-tail copula it should be \(\bar F_j(X_j)\le x_j/s\), or equivalently \(1-F_j(X_j)\le x_j/s\).
4. **Why it matters:** The entire pooling covariance structure depends on upper-tail dependence. A missing bar reverses the tail being studied.
5. **Suggested fix:** Check the rendered PDF and source. If necessary, write the condition explicitly as

   \[
   \lim_{s\to\infty}s\,P\{\bar F_j(X_j)\le x_j/s,\ \bar F_\ell(X_\ell)\le x_\ell/s\}=R_{j,\ell}(x_j,x_\ell).
   \]

   Add a reminder that \(\bar F_j=1-F_j\).

---

### 20. The common-scale bias vector \(B_c\) is not explicitly defined

1. **Location:** Theorem 2.14, thesis pp. 14-15.
2. **Severity:** Major.
3. **Problem:** The theorem introduces \(B_c\) and \(V_c\) on the common \(\sqrt{k}\) scale. It gives the diagonal entries of \(V_c\), but not the corresponding entries of \(B_c\). Since \(B_c\) is used later in optimal weights and tests, the background chapter should define it explicitly.
4. **Why it matters:** Readers need to know exactly how the per-sample bias \(\lambda_j/(1-\rho_j)\) changes when moving from \(\sqrt{k_j}\) to \(\sqrt{k}\).
5. **Suggested fix:** Add after the definition of \(V_c\):

   \[
   (B_c)_j=
   \sqrt{c_j\sum_{i=1}^m c_i^{-1}}\,\frac{\lambda_j}{1-\rho_j},
   \qquad j=1,\ldots,m,
   \]

   in the common-tail-index case, with the obvious \(\rho_j\)-dependent version if the \(\rho_j\) differ.

---

### 21. The estimated-weight equivalence needs exact simplex normalization

1. **Location:** End of Section 2.5.3, thesis p. 15.
2. **Severity:** Major.
3. **Problem:** The text says the plug-in pooled estimator is \(\sqrt{k}\)-asymptotically equivalent provided \(\widehat\omega\to_p\omega\). This is not sufficient unless the estimated weights satisfy \(\widehat\omega^\top1=1\) exactly, or the normalization error is \(o_p(k^{-1/2})\). Otherwise

   \[
   \sqrt{k}(\widehat\omega^\top1-1)\gamma
   \]

   can enter the limit.
4. **Why it matters:** This is a hidden regularity condition. It matters for both pooled Hill and any later plug-in construction using estimated weights.
5. **Suggested fix:** Replace the sentence with:

   > The plug-in estimator is \(\sqrt{k}\)-asymptotically equivalent to the fixed-weight version provided \(\widehat\omega^\top1=1\) exactly and \(\widehat\omega\to_p\omega\). If exact normalization is not imposed, require \(\sqrt{k}|\widehat\omega^\top1-1|\to_p0\).

---

### 22. The second-order parameter \(\beta_j\) is mentioned but not defined

1. **Location:** Section 2.5.3, final paragraph, thesis p. 15.
2. **Severity:** Minor / Major for polish.
3. **Problem:** The text says that practical estimators use \(\widehat\beta_j\) and \(\widehat\rho_j\), but \(\beta_j\) has not been introduced in Chapter 2. Condition 2.3 defines \(A_j\), not a \(\beta_j\).
4. **Why it matters:** Undefined symbols in a background chapter look unpolished and make the estimation discussion harder to follow.
5. **Suggested fix:** Either define \(\beta_j\) briefly, for example under an additional model \(A_j(t)\sim \beta_j t^{\rho_j}\), or remove \(\beta_j\) and write:

   > ... estimators of the second-order quantities entering \(A_j\) and \(\rho_j\) ...

---

### 23. Tail homoskedasticity is described too strongly as 'sharing the same extreme quantile'

1. **Location:** Condition 2.16 and surrounding paragraph, thesis p. 16.
2. **Severity:** Minor.
3. **Problem:** The condition \(U_j(t)/U_\ell(t)\to1\) says the tail quantile functions are asymptotically equivalent. It does not say the finite-sample or finite-level quantiles are exactly the same.
4. **Why it matters:** Precision matters because the pooled estimator is centered at \(q_j(1-p)\), and the theorem relies on asymptotic equivalence, not equality.
5. **Suggested fix:** Replace 'share the same extreme quantile' by:

   > have asymptotically equivalent extreme quantiles.

---

### 24. Theorem 2.18 gives a central chi-square limit despite possible nonzero bias

1. **Location:** Theorem 2.18, Section 2.5.5, thesis p. 17.
2. **Severity:** Critical.
3. **Problem:** Theorem 2.18 assumes the hypotheses of Theorem 2.14, which allow \(\sqrt{k_j}A_j(n_j/k_j)\to\lambda_j\ne0\). Under the common-tail-index null, the vector of Hill estimators can then have asymptotic mean \(B_c\). The GLS residual statistic has a central \(\chi^2_{m-1}\) limit only if the projected bias vanishes, for example if \(B_c\in\operatorname{span}(1)\), or under undersmoothing / bias correction. In general the limit is noncentral.
4. **Why it matters:** This is a false theorem statement as written. Since it is an imported result, the background chapter must reproduce its assumptions correctly.
5. **Suggested fix:** State the general version:

   \[
   \Lambda_n\Rightarrow \chi^2_{m-1}(\delta_\gamma),
   \]

   with

   \[
   \delta_\gamma
   =B_c^\top V_c^{-1}B_c
   -\frac{(1^\top V_c^{-1}B_c)^2}{1^\top V_c^{-1}1}.
   \]

   Then add:

   > The limit is central under undersmoothing \((B_c=0)\), after valid bias correction, or whenever \(B_c\) is collinear with \(1\).

   If the cited Daouia, Padoan, et al. corollary assumes undersmoothing, reproduce that assumption explicitly.

---

### 25. Theorem 2.18 says divergence under 'any alternative', which is too broad

1. **Location:** Theorem 2.18, thesis p. 17.
2. **Severity:** Major.
3. **Problem:** The theorem says \(\Lambda_n\to_p\infty\) under any alternative. This is true for fixed alternatives or alternatives separated from the null faster than \(k^{-1/2}\), but not for local alternatives of order \(k^{-1/2}\), where a noncentral chi-square limit is expected.
4. **Why it matters:** Hypothesis-testing asymptotics should distinguish fixed alternatives from contiguous alternatives.
5. **Suggested fix:** Replace with:

   > Under fixed alternatives, or more generally alternatives for which \(\sqrt{k}\min_c\|\gamma-c1\|\to\infty\), \(\Lambda_n\to_p\infty\). Under contiguous alternatives of order \(k^{-1/2}\), the limit is noncentral chi-square.

---

### 26. The confidence interval sentence after Theorem 2.18 needs a bias caveat

1. **Location:** End of Section 2.5.5, thesis p. 17.
2. **Severity:** Minor / Major if used later without correction.
3. **Problem:** The text says Proposition 2.15 furnishes confidence intervals for \(\gamma\) and log-scale confidence intervals for extreme quantiles. But if \(B_c\ne0\), variance-only intervals are not centered correctly unless one undersmooths or bias-corrects.
4. **Why it matters:** Confidence intervals are sensitive to asymptotic bias. Omitting the caveat may mislead readers about what is directly usable.
5. **Suggested fix:** Add:

   > These variance-only intervals are centered correctly under undersmoothing or after bias correction; otherwise the asymptotic bias term must be included in the centering.

---

### 27. Corollary 2.19 overstates 'no asymptotic price' without repeating its conditions

1. **Location:** Corollary 2.19 and following paragraph, thesis p. 17.
2. **Severity:** Minor.
3. **Problem:** The final sentence says the pooled estimators pay no asymptotic price for the distributed structure. This is true in the stated distributed-inference and equal-effective-fraction setting, with variance-optimal weights and the relevant regularity conditions. The sentence reads more general than the corollary.
4. **Why it matters:** This is a background claim that may be quoted later. It should not overstate the scope of the imported result.
5. **Suggested fix:** Rewrite:

   > Under the distributed-inference assumptions, equal effective sample fractions, and variance-optimal weighting, the pooled estimators pay no first-order asymptotic efficiency price relative to the infeasible pooled-sample benchmark.

---

### 28. Chapter 2 should more explicitly separate 'imported theorem' from 'thesis convention'

1. **Location:** Throughout Chapter 2, especially Sections 2.4-2.5.
2. **Severity:** Style / Major clarity.
3. **Problem:** The chapter is meant to be background, and it says nothing is original. But several statements are phrased as thesis-specific operational decisions: 'the thesis works under...', 'this is the workhorse...', 'we shall exploit...'. That is acceptable, but the distinction between imported theorem assumptions and later thesis specializations is sometimes blurred.
4. **Why it matters:** A background chapter should make it clear what is quoted from the literature and what is the author's simplification or specialization.
5. **Suggested fix:** Use a consistent pattern:

   > Literature result: [full assumptions and citation].
   > Thesis specialization: In Chapters 3-4 we will use the independent/common-marginal case, where ...

   This is especially useful in Sections 2.4.4 and 2.5.6.

---

## Ranked list of the most important Chapter 2 fixes

1. Add left-tail integrability to Proposition 2.8 and the surrounding discussion.
2. Correct the false statement that \(\gamma<1/2\) alone guarantees \(E[X^2]<\infty\) for real-valued \(X\).
3. Fix the risk-measure sign convention in Section 2.3.3.
4. Correct the LAWS-versus-QB variance comparison in Section 2.4.2.
5. Fix Theorem 2.18: central chi-square requires zero/projected-zero bias; otherwise the limit is noncentral.
6. Add positivity conventions for Hill/Weissman log estimators.
7. Define the \(\rho=0\) extension of \(c(\gamma,\rho)\), or exclude \(\rho=0\) from equation (2.7).
8. Make Proposition 2.12 notation unambiguous and preferably state it with a generic scale \(a_n\).
9. Explicitly define the common-scale bias vector \(B_c\) in Theorem 2.14.
10. Add exact simplex normalization to the estimated-weight equivalence in Section 2.5.3.

---

## Chapter 2 readiness assessment

Chapter 2 is structurally suitable as a background chapter: the sequence regular variation -> Hill/Weissman -> expectiles -> single-sample extreme expectiles -> optimal pooling is the right one. It is not yet submission-ready because several imported results are stated with incomplete or overly broad assumptions. Most repairs are local edits, but the following are non-negotiable before Chapter 2 can be safely used as the foundation for later chapters: fix integrability, sign convention, LAWS/QB variance comparison, Theorem 2.18 bias, and the \(\rho=0\) convention.
