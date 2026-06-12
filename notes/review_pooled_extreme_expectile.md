# Review: pooled extreme-expectile solution

**Document reviewed:** `source_audit_pooled_extreme_expectile.md`
**Problem posed:** machines share their subsample quantile (intermediate order statistic) and Hill estimator; assuming a common $\gamma>0$, pool that information into an extreme-expectile estimator.
**Sources:** Padoan–Stupfler, Bernoulli 2022 (PS22); Daouia–Padoan–Stupfler, *Optimal Pooling* (DPS); Davison–Padoan–Stupfler, JBES 2023 (DPS23).

---

## 1. Overall verdict

The mathematical core is **correct and well constructed**. The estimator

$$
\widehat\xi^{pool,\star}_{\tau_n}(\nu,\omega)
=(\widehat\gamma_n(\nu)^{-1}-1)^{-\widehat\gamma_n(\nu)}\,
\widehat q^\star_n(\tau_n\mid\omega)
$$

is the right answer to the question: it uses exactly the transmitted statistics $(n_j,k_j,\widehat\gamma_j,X_{n_j-k_j:n_j,j})$, it routes the hard probabilistic work through the already-proved DPS pooled-Weissman CLT, and the expectile-specific work is reduced to two genuinely new but tractable terms ($B_n$, $C_n$). I checked the load-bearing steps individually (Section 2 below); I found **no error that invalidates the theorem**. The exact decomposition $A_n(\omega)+B_n(\nu)-C_n$ is an identity, the rate comparison is sound, the $m=1$ reduction correctly recovers the DGS18/PS22 QB extrapolating-estimator limit $N(\lambda/(1-\rho),\gamma^2)$ at scale $\sqrt k/\ell_n$, and the $B_\omega,V_\omega,d_j$ constants match DPS Corollary 5 / Corollary 9 (arXiv numbering).

However, judged against what the professor handed you — *three* papers, of which the note really uses one and a half — the solution is **incomplete as a thesis answer** in several specific, fixable ways (Section 3): no oracle/benchmark comparison, no pre-pooling tests, no finite-sample inference layer in the spirit of PS22 Section 3, near-zero use of DPS23, and an unnecessarily conservative restriction on the bridge weights $\nu$. The write-up itself also needs heavy restructuring before it can become chapter prose (Section 4).

---

## 2. Correctness audit

### 2.1 Things I verified and confirm

1. **The identity.** $\log\widehat\xi-\log\xi_{\tau_n}=A_n(\omega)+B_n(\nu)-C_n$ with $C_n=\log\{\xi_{\tau_n}/(\psi(\gamma)Q(\tau_n))\}$ is exact. ✓
2. **Calculus of $g=\log\psi$.** $g'(x)=m(x)=(1-x)^{-1}-\log(x^{-1}-1)$ and $g''(x)=(1-x)^{-2}+(1-x)^{-1}+x^{-1}$ are both correct; the compact-event Taylor argument on $K_\varepsilon\subset(0,1)$ is the standard rigorous way to do this, and the root of $m$ at $\gamma\approx0.2178$ is numerically right. ✓
3. **Orders.** $s_{A,n}B_n(\nu)=O_P(1/\ell_n)\,(+O_P(1/(\ell_n\sqrt k)))=o_P(1)$ because $\ell_n\to\infty$; this is the same "Hill term dominates" mechanism as PS22 Theorem 2.4 and equation (7) there, so the conclusion is fully consistent with the single-sample literature. ✓
4. **$C_n$ ledger.** The DGS20 Proposition 1(i) ratio expansion, the constant $c(\gamma,\rho)$, the first-moment term $\gamma(\gamma^{-1}-1)^\gamma\,\mu/Q(1-p_n)$, and the log-conversion bound $|R^{log}_n|\le 2\Delta_n^2$ for $|\Delta_n|\le 1/2$ are all correct. The same expansion is, in fact, quoted inside PS22 (their display (11) in Section 3.2), so you can ground $C_n$ entirely in the packet your professor gave you — see 3.6.
5. **$\sqrt k\,A(1/p_n)\to0$ under $\rho<0$.** Correct conclusion, and the three-way fork in $\eta_n$ is the honest way to present the design choice. One technical nit: the step $A(1/p_n)/A(n/k)=r_n^\rho(1+o(1))$ with *both* arguments diverging is not the pointwise definition of regular variation; cite Potter bounds / uniform convergence (de Haan & Ferreira, Prop. B.1.9–B.1.10) to make it airtight. DPS do the same silently, but a thesis should not.
6. **Relative ↔ log conversions** in both directions ($\log(1+x_n)$ and $e^{L_n}-1$) at scale $\sqrt k/\ell_n$: correct, with the right $O_P(\ell_n/\sqrt k)$ remainders.
7. **Estimated-$\omega$ transfer.** Correct and genuinely "free": DPS Theorem 2 / Corollary 9 are already stated for random affine $\widehat\omega_n\to_P\omega$, so $A_n(\widehat\omega_n)$ needs no new proof. The list of admissible weight constructions (Var-allocation $k_j/k$; Section 2.2 / Corollary 1 plug-ins; Corollary 7 distributed AMSE plug-ins) matches the source.
8. **Plug-in studentisation and interval inversion.** The algebra of $T_n^{plug}$ and the multiplicative interval endpoints is correct (I re-derived the inversion; the $\mp$ placement in the exponents is right), and the conditional Slutsky argument is fine.
9. **Weight-criterion verdict.** Under $\eta_n\to0$, the first-order AMSE of the expectile estimator equals the DPS quantile criterion $(\omega^\top B_c)^2+\omega^\top V_c\omega$, so the optimal-$\omega$ formulas import verbatim; and the computation showing that the parked $\eta_n\to\eta>0$ branch produces a *different*, expectile-specific optimiser $\omega_\kappa$ is correct and is a nice observation worth keeping.

### 2.2 Issues to fix (none fatal)

**(a) The restriction to deterministic $\nu$ is over-cautious, and the stated justification is wrong.**
The note repeatedly says that allowing a random bridge vector (e.g. $\nu=\widehat\omega_n$) "would require a new lower-order or compact-event audit." It would not. If $\widehat\nu_n^\top\mathbf 1=1$ and $\widehat\nu_n\to_P\nu$, DPS supplement Theorem A.1 — which you already invoke for $\omega$ — gives $\sqrt k\{\widehat\gamma_n(\widehat\nu_n)-\widehat\gamma_n(\nu)\}=o_P(1)$, hence $\widehat\gamma_n(\widehat\nu_n)-\gamma=O_P(k^{-1/2})$ and in particular consistency, which is *all* the compact-event Taylor argument consumes. So $B_n(\widehat\nu_n)=o_P(\ell_n/\sqrt k)$ by exactly the same two lines, and the theorem holds with both weight vectors random. Recommendation: state the theorem for $(\widehat\nu_n,\widehat\omega_n)$ both affine and converging in probability; this removes an artificial asymmetry, simplifies the prose enormously (no "two conventions" bookkeeping), and makes the natural diagonal choice $\nu=\omega=\widehat\omega_n^{(Var)}$ or $\widehat\omega_n^{(AMSE)}$ a literal corollary instead of an awkwardly parked case.

**(b) Relate $\eta_n\to0$ to the standard condition of the source papers.**
Every source result you lean on (DGS18 Cor. 3–4, PS22 Cor. 2.3/Thm 2.4, DPS23 Thm 3.5) imposes $\sqrt{k}\,q_{\tau_n}^{-1}\to\mu\in\mathbb R$ at the *intermediate* level. Since $Q(1-p_n)\ge q_{\tau_n}$ and $\ell_n\to\infty$, that standard condition already implies $\eta_n\to0$. You note the inequality once, buried in the "$m=1$ sanity check," but the theorem statement presents $\eta_n\to0$ as a free-standing exotic condition. Add a remark: *(i)* $\eta_n\to0$ is implied by, and strictly weaker than, the standard $\sqrt k\,q_{\tau_n}^{-1}=O(1)$; *(ii)* an interpretable sufficient condition — since $Q(1-p)=U(1/p)$ is regularly varying with index $\gamma$, for $p_n\asymp1/n$ and $k\asymp n^a$, $\eta_n\to0$ holds whenever $a<2\gamma$ (up to slowly varying factors). Right now a reader cannot tell whether the condition is mild or restrictive, or for which $\gamma$ it bites.

**(c) Say explicitly what happens to "assume $\gamma>0$."**
The professor's hypothesis is $\gamma>0$; your theorem assumes $0<\gamma<1$ plus $E|X^-|<\infty$. That is not a gap in your proof — it is forced, because for $\gamma\ge1$ the mean is infinite and the expectile target does not exist — but the thesis must say this in one sentence rather than silently strengthening the hypothesis. (Contrast with PS22, who flag the analogous $\gamma<1/2$ vs $\gamma<1$ distinction between LAWS and QB routes; here only the QB route exists, since the machines do not transmit enough to compute LAWS expectiles, which is itself worth one sentence of motivation.)

**(d) Domain-of-definition events.** The log conversion $\log(1+x_n)$ tacitly needs $x_n>-1$ and $\widehat q^\star_n>0$; likewise $\psi(\widehat\gamma_n(\nu))$ needs $\widehat\gamma_n(\nu)\in(0,1)$, which you handle on $E_{n,\varepsilon}$. Do the same once for the positivity of the order statistics (your "$U(t)>0$ eventually" assumption gives $P(\min_j X_{n_j-k_j:n_j,j}>0)\to1$) and then state, in one place, that *all* expansions are on a single event of probability tending to one. Currently positivity is mentioned for the Hill logs but not threaded through the $A_n$ Taylor step.

**(e) Citation numbering risk.** The note maps the arXiv's Corollary 9 (pooled Weissman, distributed) to "Corollary 8 in the published Bernoulli version" and likewise Corollary 5 for the Hill input. The attached PDF is the arXiv v1, so I cannot verify the published numbering; you flag the discrepancy, which is good, but before submission re-check *every* corollary number, and Theorem A.1 / Lemma B.2 labels, against the published supplement — numbering shifts there too.

**(f) Minor.** The $A_n^{Hill}$ split into $\ell_n\{\widehat\gamma_n(\omega)-\gamma\}$ plus the $(\ell_{j,n}-\ell_n)$ correction asserts the correction is lower order "because $\ell_{j,n}/\ell_n\to1$"; note that $\ell_{j,n}-\ell_n=\log\{(k_j/k)(n/n_j)\}=O(1)$ under the proportionality assumptions, so the correction is $O_P(k^{-1/2})$, which is the cleaner statement (a ratio tending to 1 alone would not suffice).

---

## 3. Substantive gaps relative to the assignment

These are the points a referee — or your professor — will raise, roughly in order of importance.

### 3.1 No benchmark / oracle comparison
The defining rhetorical move of the DPS paper is comparing the distributed estimator to the **unfeasible benchmark** built on the combined sample (their Theorems 3, 4, Corollary 9-type statements). Your problem has an obvious benchmark: $\widetilde\xi^{\,\star,(Hill)}_{\tau_n}=\psi(\widehat\gamma^{(Hill)}_n(k))\,\widehat q^{\star,(Hill)}_n(1-p_n\mid k)$ computed on pooled data. Your decomposition makes the comparison almost free: under $\eta_n\to0$ the expectile estimator inherits the quantile component's asymptotics, so DPS Theorem 3 gives immediately that with $\nu=\omega=\widetilde\omega^{(Var)}_n=(k_j/k)$ and aligned sample fractions $k_j/n_j=(k/n)(1+O(k^{-1/2}))$, the pooled expectile estimator is $\sqrt k/\ell_n$-**asymptotically equivalent to the benchmark**, and DPS Theorem 4 gives the AMSE-dominance condition $|\lambda|>\lambda_0$ for the AMSE-optimal version. State both as corollaries. Without them the thesis answers "what is the limit law" but not "is pooling as good as having the data," which is the point of distributed inference.

### 3.2 No pre-pooling tests, despite the packet containing both
Pooling is only legitimate under common $\gamma$ (and, for a common expectile target, tail homoskedasticity). Both given papers hand you the tools, *computable from exactly the transmitted statistics*:

- DPS Corollary 3 / Remark 3: the tail-homogeneity deviance $\Lambda_n$, which under cross-machine independence collapses to the Pearson-type statistic $\sum_j k_j(\widehat\gamma_j-\widehat\gamma_n(\omega^{(Var)}))^2/\widehat\gamma_j^2$ — needs only $(\widehat\gamma_j,k_j)$.
- DPS Corollary 4: the homoskedasticity statistic $L_n(p)$ built from the marginal Weissman logs — needs only $(\widehat\gamma_j,k_j,n_j,X_{n_j-k_j:n_j,j})$.
- **The link you are missing:** PS22 Lemma A.6 / Section 3.3 shows $\lim\xi_{\tau,j}/\xi_{\tau,\ell}=1$ **iff** $\lim q_{\tau,j}/q_{\tau,\ell}=1$. Therefore DPS's quantile homoskedasticity test is *exactly* a test of equality of extreme expectiles across machines. One short lemma citing PS22 turns the DPS testing layer into an expectile-native pre-check for your pooled estimator. This is the single cheapest high-value addition available, and it ties papers 1 and 2 together — almost certainly part of why both were assigned.

### 3.3 The finite-sample inference layer of PS22 is ignored — and it is precisely about the terms you discard
PS22's central practical message (their Section 3.2 and Appendix) is that the "Hill-dominated" asymptotics — the very $N(B_\omega,V_\omega)$ structure your theorem ends with — give **poor finite-sample coverage**, and that accurate intervals require *(i)* the log scale (you have this), *(ii)* the first-moment bias correction $\widehat b_j\propto \overline X_n/\widehat q_{\tau_n}$ — which is exactly the $\alpha_\gamma\mu\,\eta_n$ term you send to zero — and *(iii)* a corrected variance of the form $(1,1/\log d_n)\,\Sigma\,(1,1/\log d_n)^\top$ retaining the $m(\gamma)$ contribution and the Hill/intermediate correlation — which is exactly your $B_n$ term and the cross-covariance you absorb into $o_P(1)$.

Two consequences:

1. **At second order, $\nu$ is identified.** Since $\sqrt k(\widehat\gamma_n(\omega)-\gamma,\widehat\gamma_n(\nu)-\gamma)$ is jointly Gaussian via DPS Theorem 1, the refined (pre-limit) variance of $s_{A,n}\log(\widehat\xi/\xi)$ is
   $\omega^\top V_c\omega+\tfrac{2m(\gamma)}{\ell_n}\,\omega^\top V_c\nu+\tfrac{m(\gamma)^2}{\ell_n^2}\,\nu^\top V_c\nu+\cdots$,
   so a PS22-style corrected interval *does* depend on $\nu$, and minimising the leading correction is a well-posed (and short) "lower-order $\nu$ criterion" — the very project the note declares parked without noticing that PS22 already contains its template. Note also that the diagonal $\nu=\omega$ reproduces, at $m=1$, precisely the $(m(\gamma)+\log d_n)^2$ factor of PS22's $V^{\star,QB}_n$, which is a strong argument for adopting $\nu=\omega$ as the default rather than $\nu=(k_j/k)$.
2. Even if you keep the first-order interval as the headline result, the thesis should offer the **bias-corrected variant**: replace the plug-in centring $\widehat B_{\widehat\omega,n}$ by $\widehat B_{\widehat\omega,n}+\alpha_{\widehat\gamma}\widehat\mu\,\widehat\eta_n$ with $\widehat\mu$ a pooled mean (each machine ships $\overline X_{n_j}$ — one extra scalar) and $\widehat\eta_n=\sqrt k/(\ell_n\widehat q^\star_n)$. PS22 report that this correction "often brings a very substantial improvement"; your simulations (when you run them) will almost certainly reproduce that.

### 3.4 The competing design is never discussed
A reader's first instinct for this problem is *pool the marginal expectile estimators*: $\prod_j[\psi(\widehat\gamma_j)\,\widehat q^\star_j(1-p_n\mid k_j)]^{\omega_j}$ (geometric), or its arithmetic mean. Your class does not contain the geometric version (weighted average of $g(\widehat\gamma_j)$ ≠ $g$ of the weighted average), but a two-line Taylor argument shows it is **first-order equivalent** to your estimator with $\nu=\omega$, since both bridge terms linearise to $m(\gamma)\sum_j\omega_j(\widehat\gamma_j-\gamma)$ at order $o_P(\ell_n/\sqrt k)$. State this, and dismiss arithmetic pooling by citing the DPS finding (their Section 5.1.1) that arithmetic pooling of Weissman-type estimators carries substantially larger bias and variance. Right now the thesis defends one design without acknowledging the obvious alternatives, which reads as an oversight rather than a choice.

### 3.5 Paper 3 (DPS23) is essentially unused
It appears only as an "$m=1$ sanity check." If the professor included it, the expected uses are:

- **Level selection.** DPS23 Section 5 builds $\widehat\tau'_n(\alpha_n)=1-(1-\alpha_n)\widehat\gamma/(1-\widehat\gamma)$ so the extreme expectile matches a prescribed VaR level — directly portable here with $\widehat\gamma=\widehat\gamma_n(\nu)$ (composite pooled estimator). This answers "which $\tau_n$" — a question every applied chapter must face — and costs one corollary (their Theorem 5.1 pattern, with your Theorem replacing their Theorem 3.5).
- **Serial dependence / filtering.** DPS Section 4 + DPS23 Section 6 share the same residual-filtering architecture (their conditions on $\max_i|\widehat\varepsilon_i-\varepsilon_i|/(1+|\varepsilon_i|)$). One paragraph noting that your theorem extends to filtered residuals under the DPS Theorem 8/9 conditions — because $A_n,B_n$ depend on the data only through residual-based Hill/order statistics — would integrate the third paper honestly. At minimum, add a "scope and extensions" subsection acknowledging that financial data motivates this and citing where the i.i.d. assumption enters your proof.

### 3.6 Self-containedness with respect to the assigned packet
$C_n$ is sourced from DGS19/DGS20, which are *not* in the packet. That is academically fine, but note that PS22 itself states the needed expansion (its display (11), citing DGS20 Prop. 1(i) and de Haan–Ferreira Thm 4.3.8), so you can present the bridge as "PS22 eq. (11), originating in DGS20" — anchoring every ingredient in the three given papers plus their explicit references. Similarly cite PS22 equation (7) as the single-sample prototype of your $A+B-C$ decomposition; your identity is its multivariate, two-weight generalisation, and saying so situates the contribution correctly.

---

## 4. Presentation

The note is a research lab-book, and as such it is admirably honest about what is checked vs. parked. But as the answer to the professor's question it has problems:

1. **The answer is buried.** The estimator, theorem, optimal weights, and interval are scattered across ~2,900 lines with the final statements appearing in a section called "Default next research decision." Restructure for the chapter as: setup & communication protocol (what each machine transmits: $n_j,k_j,\widehat\gamma_j,X_{n_j-k_j:n_j,j}$, optionally $\widehat\beta_j,\widehat\rho_j,\overline X_{n_j}$) → estimator → decomposition lemma → main theorem → optimal-weight corollary → benchmark-equivalence corollary → inference corollary → tests → extensions.
2. **Massive duplication.** The $B_n$ Taylor expansion appears in full twice; the $C_n$ ledger twice; the theorem constants four times; the "deterministic admissible" definition at least five times. Cut by ~60%.
3. **Private jargon.** "Least-action route," "ledger," "parked," "promoted," "source audit" — fine internally, but none of it can survive into the thesis. Likewise, statements of the form "this note does not decide which case holds" must become actual decisions in chapter prose.
4. **Notation clash with all three sources.** You use $\tau_n$ for the *extreme* level; every source uses $\tau_n$ intermediate and $\tau'_n$ extreme. You flag this, but flagging does not prevent referee confusion — just adopt the sources' convention ($\tau_n$, $\tau'_n$, $k=n(1-\tau_n)$ analog) and delete the translation table.
5. **State the theorem once, in full, with all conditions in the statement** (including $U(t)>0$ eventually and the positivity events), rather than distributing assumptions between "Assumptions to carry forward," the statement, and the verdict tables.

---

## 5. Priority checklist

1. **Must do:** benchmark-equivalence and AMSE-dominance corollaries (3.1); pre-pooling tests with the PS22 Lemma A.6 expectile-equivalence link (3.2); upgrade $\nu$ to random via Theorem A.1 and adopt a single default ($\nu=\omega$ recommended, see 3.3) (2.2a); explicit $0<\gamma<1$ discussion (2.2c); restructure per 4.1.
2. **Should do:** bias-corrected interval variant and the second-order $\nu$ remark grounded in PS22 §3.2 (3.3); relate $\eta_n\to0$ to $\sqrt k\,q_{\tau_n}^{-1}=O(1)$ and give the $a<2\gamma$ sufficient condition (2.2b); first-order equivalence with the pool-marginal-expectiles design and a remark against arithmetic pooling (3.4); Potter-bound citation (2.1.5); verify published numbering (2.2e).
3. **Nice to have:** DPS23 level-selection corollary and filtering extension paragraph (3.5); growing-$m$ remark (does $B_n$ stay $o_P$ under DPS condition (W)? — yes, since $\widehat\gamma_n(\omega)$ remains consistent, worth one sentence); simulations (already acknowledged as parked — design them around coverage with/without the bias correction, mirroring PS22 Figure 1 and DPS Figure 1).

**Bottom line:** the theorem is right, the proof strategy is the correct one given the sources, and the honesty about the $\eta_n$ regimes and the unidentified $\nu$ is genuinely good research hygiene. What separates this from a finished thesis chapter is not the probability theory — it is the comparative and inferential layers (benchmark, tests, finite-sample corrections) that the three assigned papers were plainly chosen to supply, plus a complete rewrite of the exposition.
