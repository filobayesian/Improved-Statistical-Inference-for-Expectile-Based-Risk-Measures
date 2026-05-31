# Thesis Review Report: Sections 3.1, 3.2 & Proposition 3.1 Proof

**Target:** Sections 3.1 (Setup and notation), 3.2 (The pooled QB expectile estimator), and Appendix A.1 (Proof of Proposition 3.1) [cite: 1].  
**Verdict:** Strong theoretical formulation with rigorous proof structures. Some minor notation inconsistencies and expositional opportunities were identified.

---

## 1. High-Level Assessment
The text introduces a pooled intermediate-level extreme-expectile estimator leveraging distributed inference [cite: 1]. The foundational theoretical work is highly rigorous. The transition from the baseline setup (3.1) to the estimator definitions (3.2), culminating in the asymptotic equivalence of the pooled estimators, is mathematically sound [cite: 1]. The decision to juxtapose the two valid estimators (A) and (B) and to formally prove their $\sqrt{k}$-equivalence before paring down to (A) is an excellent didactic choice [cite: 1]. 

---

## 2. Detailed Feedback: Section 3.1 (Setup and notation)

### **Strengths:**
* **Constraint Clarity:** The explicit note that $\gamma < 1/2$ corresponds to the finite-variance regime, which is strictly necessary for expectile central limit theorems, is well-placed and correctly formulated [cite: 1].
* **Moment Negligibility:** The justification for condition (3.3), $\frac{\sqrt{k}}{\Quant_{X}(\tau_{n})} \to 0$, is effectively contextualized as the multi-sample counterpart of the QB intermediate theorem requirement [cite: 1].
* **Distributed Computing Context:** The text astutely emphasizes that "no raw observation and no expectile-specific summary statistic crosses between machines" [cite: 1].

### **Critiques & Recommendations:**
* **Notation Inconsistency:** In the opening overview, the pooled weighted-geometric Weissman estimator is denoted as $\hat{Wei}_{n}(\,\cdot\,;\bm\omega_q)$ [cite: 1]. However, in Section 3.2, it is invoked as $\hat{Wei}_{n}(\tau_{n} \mid \bm\omega_q)$ [cite: 1]. Standardize whether you use a semicolon or a vertical bar to denote the conditioning on the weights.
* **Proportionality Conditions Reference:** You refer to "proportionality conditions (1.19)" as being in force [cite: 1]. While acceptable in a continuous thesis, ensure that the precise definition of $k_{j}/n_{j} \to 0$ and $k = \sum k_j$ [cite: 1] leaves no ambiguity about the assumed relationship between the diverging subset sizes. 
* **Elicitability Mention:** The text implies the intrinsic need for QB plug-ins due to the pooling protocol preventing LAWS [cite: 1]. It would be beneficial to add a half-sentence reminding the reader *why* LAWS would require sharing the intermediate expectile $\tilde{\xi}_{\tau_n, j}$ (due to the asymmetric least squares formulation).

---

## 3. Detailed Feedback: Section 3.2 (The pooled QB expectile estimator)

### **Strengths:**
* **Methodological Justification:** The reasoning for adopting construction (A) over (B)—namely, that (A) directly lifts the iid QB pipeline and uniquely supports a two-weight vector framework $(\bm\omega_{\gamma}, \bm\omega_{q})$—is highly persuasive [cite: 1].
* **High-Probability Event Definition:** Explicitly noting that the geometric products are interpreted on the log scale and properly arguing that $\Prob(\hat q^{\star}_{j} > 0) \to 1$ under right-heavy tails prevents a common reviewer trap regarding the domain of the logarithm [cite: 1].

### **Critiques & Recommendations:**
* **Proposition 3.1 Phrasing:** The proposition states: "In fact the unscaled log-ratio is itself $O_{p}(k^{-1})$, which is strictly stronger than the $o_{p}(k^{-1/2})$ statement required by the $\sqrt{k}$-CLT below" [cite: 1]. This is mathematically impeccable, but slightly dense. Consider expanding it slightly for readability: *"Since the unscaled log-ratio is $O_{p}(k^{-1})$, applying the $\sqrt{k}$ scaling yields $O_{p}(k^{-1/2}) = o_{p}(1)$, successfully satisfying the $\sqrt{k}$-CLT requirement."*
* **Weissman Interpolation/Extrapolation:** The discussion on the dual role of the per-sample Weissman estimator is insightful [cite: 1]. However, the phrase "Adopting the Weissman primitive uniformly... has two virtues" [cite: 1] feels slightly disjointed. Consider restructuring this paragraph to front-load the point that Weissman bridges the gap between varying local intermediate levels $\tau_{n_j}$ and the global target $\tau_n$ [cite: 1].

---

## 4. Detailed Feedback: Appendix A.1 (Proof of Proposition 3.1)

### **Strengths:**
* **Topological Rigor:** Validating the "Good event" $E_n \coloneqq \{\hat\gamma_j(k_j) \in (0, 1), \dots \}$ [cite: 1] prior to invoking the Taylor expansion demonstrates excellent rigor. Many authors blindly apply Taylor expansions to estimators that could theoretically jump out of the function's domain.
* **Derivative Calculation:** The computation of the derivatives of $\log \psifn(g)$ is flawless. The reduction of $m'(g)$ to $\frac{1}{(1 - g)^{2}} + \frac{1}{1 - g} + \frac{1}{g}$ [cite: 1] perfectly sets up the Lagrange remainder.
* **Algebraic Cancellation:** The logic used to cancel the linear terms in equation (A.4) by exploiting the definition of the linearly pooled Hill estimator $\hat\gamma_{n}(\bm\omega) = \sum_{j}\omega_{j}\hat\gamma_{j}(k_{j})$ [cite: 1] is elegant and clear.

### **Critiques & Recommendations:**
* **Big-O Calculus Detail:** You state: "each summand on the right-hand side is the product of an $O_{p}(1)$ factor... and an $O_{p}(k^{-1})$ factor... Since the sum on the right has $m + 1$ terms and $m$ is fixed, the right-hand side... is itself $O_{p}(k^{-1})$" [cite: 1]. This is completely correct [cite: 1]. To be completely bulletproof against pedantic reviewers, explicitly mention that the proportionality condition ($k_1/k_j \to c_j$) guarantees $k_j \asymp k$ [cite: 1], which is why $(\hat\gamma_j - \gamma)^2 = O_p(k_j^{-1})$ seamlessly translates to $O_p(k^{-1})$ uniformly across all $j$. You mention it earlier, but reiterating $k_j \asymp k$ exactly where the sum is bounded bounds the argument tightly.

---
**Final Recommendation:** Proceed with minor revisions. The work is structurally sound and mathematically accurate.
