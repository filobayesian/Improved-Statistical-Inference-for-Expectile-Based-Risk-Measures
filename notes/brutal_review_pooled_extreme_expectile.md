# Brutal review: pooled extreme-expectile decomposition

**Object reviewed:** `source_audit_pooled_extreme_expectile.md`  
**Review standard:** first-principles reconstruction, source matching, asymptotic order audit.  
**Verdict:** the core theorem route is probably salvageable, but the current notes are too permissive in their language around “admissible” weights and too relaxed in separating what is proved by the sources from what is proved by your own algebra. A thesis theorem can be made correct, but only if the hypotheses are tightened and the source attributions are sharpened.

---

## 1. Bottom-line verdict

The main deterministic two-weight conclusion under the conservative bridge condition

\[
\eta_n=\frac{\sqrt{k}}{\ell_n Q(1-p_n)}\to0,
\qquad
\ell_n=\log\frac{k}{np_n},
\]

is mathematically plausible and I do **not** find a contradiction in the central route:

\[
\frac{\sqrt{k}}{\ell_n}
\log\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}{\xi_{\tau_n}}
\Rightarrow N(B_\omega,V_\omega).
\]

But this statement is only valid after you impose real weight regularity. The phrase “for every deterministic admissible pair” is dangerous and, if “admissible” only means affine normalisation, false.

The clean theorem should be stated under fixed deterministic weights, or deterministic triangular weights with exact affine normalisation and convergence in finite dimension. Without that, you have an easy counterexample: choose unbounded affine weights such as \(\nu_n=(n,1-n,0,\ldots,0)\). Then \(\nu_n^\top\mathbf 1=1\), but the variance of \(\sqrt{k}\{\widehat\gamma_n(\nu_n)-\gamma\}\) explodes. Your proof of \(B_n(\nu)=o_P(\ell_n/\sqrt{k})\) collapses.

That is the main mathematical defect.

---

## 2. Rebuilt object and identity

The estimator is

\[
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
=
\psi(\widehat\gamma_n(\nu))\,
\widehat q_n^\star(\tau_n\mid\omega),
\qquad
\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}.
\]

The exact decomposition is correct:

\[
\log\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}{\xi_{\tau_n}}
=
A_n(\omega)+B_n(\nu)-C_n,
\]

where

\[
A_n(\omega)=\log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)},
\]

\[
B_n(\nu)=\log\psi(\widehat\gamma_n(\nu))-\log\psi(\gamma),
\]

and

\[
C_n=\log\frac{\xi_{\tau_n}}{\psi(\gamma)Q(\tau_n)}.
\]

This identity is not approximate. It is the right starting point. The subsequent problem is not the algebra; it is hypothesis hygiene and source discipline.

---

## 3. Source matching audit

### 3.1 DPS pooled-Weissman component

The published DPS route supports the pooled geometric Weissman quantile component under the common-marginal distributed setup. The accessible published-version text states the weighted geometric pooled Weissman estimator and its relative-error limit. In the common-marginal distributed result, Corollary 8 gives the limit

\[
\frac{\sqrt{k}}{\ell_n}
\left\{
\frac{\widehat q_n^\star(1-p\mid\widehat\omega_n)}{q(1-p)}-1
\right\}
\Rightarrow
N\left(
\frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
\gamma^2\left(\sum_{j=1}^m\frac1{c_j}\right)
\left(\sum_{j=1}^m c_j\omega_j^2\right)
\right),
\]

under the Corollary 5 assumptions plus \(\rho<0\), \(p\to0\), \(k/(np)\to\infty\), and \(\sqrt{k}/\log\{k/(np)\}\to\infty\).

**Source verdict:** your constants \(B_\omega\), \(V_\omega\), and \(d_j\) match DPS.

**But:** the source statement is on relative-error scale. The log version is your conversion unless you cite the supplement/proof. This is fine, but thesis prose must not say that Corollary 8 itself is a log theorem.

### 3.2 Relative-to-log conversion for \(A_n(\omega)\)

Let

\[
x_n=rac{\widehat q_n^\star(1-p_n\mid\omega)}{Q(1-p_n)}-1.
\]

DPS gives

\[
\frac{\sqrt{k}}{\ell_n}x_n=O_P(1),
\]

so

\[
x_n=O_P\left(\frac{\ell_n}{\sqrt{k}}\right)=o_P(1)
\]

because \(\sqrt{k}/\ell_n\to\infty\). Therefore

\[
\log(1+x_n)=x_n+O_P(x_n^2),
\]

and

\[
\frac{\sqrt{k}}{\ell_n}\{\log(1+x_n)-x_n\}
=O_P\left(\frac{\ell_n}{\sqrt{k}}\right)
=o_P(1).
\]

This part is correct.

### 3.3 \(B_n(\nu)\): Taylor expansion

Define

\[
g(x)=\log\psi(x)=-x\log(x^{-1}-1).
\]

The derivatives are correct:

\[
g'(x)=\frac{1}{1-x}-\log(x^{-1}-1),
\]

\[
g''(x)=\frac{1}{(1-x)^2}+\frac{1}{1-x}+\frac1x.
\]

On a compact subinterval of \((0,1)\), Taylor gives

\[
B_n(\nu)
=
g'(\gamma)\{\widehat\gamma_n(\nu)-\gamma\}
+O_P\left(\{\widehat\gamma_n(\nu)-\gamma\}^2\right).
\]

If \(\nu\) is fixed or bounded/convergent deterministic, the pooled Hill CLT gives

\[
\widehat\gamma_n(\nu)-\gamma=O_P(k^{-1/2}),
\]

and hence

\[
\frac{\sqrt{k}}{\ell_n}B_n(\nu)=o_P(1).
\]

**Source verdict:** the calculus is correct. The source use is correct only for weights that satisfy the regularity required for the pooled Hill CLT. Affine normalisation alone is not sufficient.

### 3.4 \(C_n\): population expectile-quantile bridge

The DGS Proposition 1(i) expansion supports the ratio

\[
\frac{\xi_\tau}{Q(\tau)}
=
\psi(\gamma)
\left[
1
+c(\gamma,\rho)A((1-\tau)^{-1})
+\gamma(\gamma^{-1}-1)^\gamma\frac{EX}{Q(\tau)}
+o(|A((1-\tau)^{-1})|)
+o(Q(\tau)^{-1})
\right].
\]

Your constant

\[
c(\gamma,\rho)
=
\frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}
+
\frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho}
\]

is correct, with the continuous interpretation at \(\rho=0\). At \(\rho=0\), the limit is

\[
\frac{1}{1-\gamma}-\log(\gamma^{-1}-1),
\]

which is the same derivative \(g'(\gamma)\).

The log conversion

\[
C_n=\log(1+\Delta_n)=\Delta_n+O(\Delta_n^2)
\]

is correct once \(\Delta_n\to0\). The square-order remainder was correctly not ignored before checking its scale.

### 3.5 Rate comparison for \(C_n\)

Let

\[
a_n=A(1/p_n),
\qquad
b_n=Q(1-p_n)^{-1},
\qquad
s_n=\frac{\sqrt{k}}{\ell_n}.
\]

Under \(\rho<0\), \(\sqrt{k}A(n/k)\to\lambda\), and \(k/(np_n)\to\infty\), regular variation gives

\[
\frac{A(1/p_n)}{A(n/k)}
=\left(\frac{k}{np_n}\right)^\rho\{1+o(1)\}	o0,
\]

so

\[
s_n a_n\to0.
\]

The first-moment bridge is

\[
s_n b_n=\eta_n.
\]

Therefore the extra condition \(\eta_n\to0\) is not cosmetic. It is the condition that removes the mean bridge. Without it, your theorem has a deterministic shift or no uncentred source-scale limit.

**Rate verdict:** the comparison is correct, but the theorem must present \(\eta_n\to0\) as an additional expectile-specific assumption, not as something inherited from DPS.

---

## 4. Blocking defects and required fixes

### Defect 1: “Admissible weights” is underdefined

The statement “for every deterministic admissible pair \((\nu,\omega)\)” is too broad. If admissible only means \(\nu^\top\mathbf1=\omega^\top\mathbf1=1\), the theorem is false.

**Counterexample:** take \(m\ge2\) and

\[
\nu_n=(n,1-n,0,\ldots,0).
\]

Then \(\nu_n^\top\mathbf1=1\), but \(\nu_n\) is unbounded. There is no fixed finite Gaussian limit for

\[
\sqrt{k}\{\widehat\gamma_n(\nu_n)-\gamma\},
\]

and the proof of

\[
\frac{\sqrt{k}}{\ell_n}B_n(\nu_n)=o_P(1)
\]

fails.

**Mandatory fix:** define deterministic admissibility as fixed weights or triangular weights satisfying

\[
\nu_n^\top\mathbf1=1,
\quad
\omega_n^\top\mathbf1=1,
\quad
\nu_n\to\nu,
\quad
\omega_n\to\omega
\]

in \(\mathbb R^m\), hence boundedness. If you want negative affine weights, say so explicitly and require boundedness. If you want convex weights, require non-negativity and the simplex condition.

### Defect 2: source attribution for the log version is too loose

The DPS headline theorem/corollary is relative-error scale. Your log-scale \(A_n\) limit is correct, but it is not literally the headline Corollary 8 statement.

**Mandatory fix:** write:

> DPS Corollary 8 gives the relative-error CLT. Since \(\ell_n/\sqrt{k}\to0\), a Taylor expansion gives the same limit on log scale. Alternatively, the supplement/proof of Theorem 2 gives the corresponding log expansion.

Do not cite Corollary 8 alone as a log theorem.

### Defect 3: the estimated-\(\omega\) transfer is conditional, not universal

The random-weight transfer is valid only when \(\widehat\omega_n^\top\mathbf1=1\) exactly and \(\widehat\omega_n\to_P\omega\), with the DPS source assumptions for the chosen estimator of the weights. That is not a generic plug-in claim.

**Mandatory fix:** every occurrence of “estimated optimal weights transfer” must carry the DPS consistency assumptions: second-order parameter estimability, covariance/bias plug-in consistency, exact normalisation, and convergence to a deterministic target.

### Defect 4: \(\nu\) cannot be silently made random

The proof you have only covers deterministic \(\nu\). You correctly say this in places, but the thesis implementation temptation is obvious: someone will set \(\nu=\widehat\omega_n\). That is not covered.

**Mandatory fix:** state that \(\nu=\widehat\omega_n\) is outside the theorem unless a separate compact-event and random-weight Taylor audit is supplied.

### Defect 5: broad tail-homoskedastic targets are not proved

The common-marginal route is clean. A broader route under DPS tail homoskedasticity is not automatically an expectile theorem. Tail homoskedasticity aligns high quantiles, but the expectile bridge includes distribution-level mean terms and target-population choices.

**Mandatory fix:** keep the thesis theorem common-marginal unless you add a separate target-selection proof for expectiles.

---

## 5. Non-blocking but important corrections

1. **Eventual positivity must be in the theorem.** Log-Hill/Weissman expressions require high-order statistics and population quantiles to be positive with probability tending to one. Do not leave this as a side remark.

2. **The DGS bridge source is a ratio theorem, not a log theorem.** Your notes handle this correctly. Thesis prose must preserve that separation.

3. **The root of \(g'(\gamma)\)** is approximately
   \[
   0.2178117057198001.
   \]
   Your \(0.2178\) warning is fine. It is irrelevant under \(\eta_n\to0\), but relevant if you later use a scale where \(B_n\) contributes.

4. **The plug-in interval inversion is algebraically correct.** Starting from
   \[
   \frac{s_n\log(\widehat\xi/\xi)-\widehat B}{\sqrt{\widehat V}},
   \]
   the interval
   \[
   \left[
   \widehat\xi\exp\left\{-s_n^{-1}(\widehat B+z\sqrt{\widehat V})\right\},
   \widehat\xi\exp\left\{-s_n^{-1}(\widehat B-z\sqrt{\widehat V})\right\}
   \right]
   \]
   is correct.

5. **Data-driven thresholds are not covered.** Your proof assumes deterministic intermediate thresholds with proportionality. If the practical thesis chooses \(k_j\) from data, a new argument is required.

---

## 6. Corrected theorem skeleton

A defensible theorem would read as follows.

Let \(m\) be fixed. Let observations across all machines be iid from a common continuous distribution with right-tail quantile \(U(t)=Q(1-1/t)\), satisfying \(C_2(\gamma,\rho,A)\), with \(0<\gamma<1\), \(\rho<0\), \(E|X^-|<\infty\), and \(U(t)>0\) for large \(t\). Let deterministic thresholds satisfy

\[
k\to\infty,
\qquad
k/n\to0,
\qquad
\frac{n_1}{n_j}\to b_j\in(0,\infty),
\qquad
\frac{k_1}{k_j}\to c_j\in(0,\infty),
\]

and

\[
\sqrt{k}A(n/k)\to\lambda\in\mathbb R.
\]

Let \(p_n=1-\tau_n\) satisfy

\[
p_n\to0,
\qquad
\frac{k}{np_n}\to\infty,
\qquad
\frac{\sqrt{k}}{\ell_n}\to\infty,
\qquad
\ell_n=\log\frac{k}{np_n},
\]

and impose

\[
\eta_n=\frac{\sqrt{k}}{\ell_n Q(1-p_n)}\to0.
\]

Let \(\omega_n\to\omega\) and \(\nu_n\to\nu\) be deterministic finite-dimensional weight sequences with exact affine normalisation. Then

\[
\frac{\sqrt{k}}{\ell_n}
\log\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu_n,\omega_n)}{\xi_{\tau_n}}
\Rightarrow
N(B_\omega,V_\omega),
\]

where

\[
B_\omega=\frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
\]

\[
V_\omega=
\gamma^2
\left(\sum_{j=1}^m\frac1{c_j}\right)
\left(\sum_{j=1}^m c_j\omega_j^2\right),
\]

and

\[
d_j=rac{c_j}{b_j}\frac{\sum_i c_i^{-1}}{\sum_i b_i^{-1}}.
\]

For fixed weights, drop the subscript \(n\). For estimated \(\omega_n\), replace the deterministic condition by the exact DPS condition \(\widehat\omega_n^\top\mathbf1=1\), \(\widehat\omega_n\to_P\omega\), and the corresponding DPS source assumptions. Keep \(\nu\) deterministic unless separately proved otherwise.

---

## 7. Final brutal assessment

Your decomposition is good. Your order comparison is mostly good. Your main \(\eta_n\to0\) theorem is probably right.

But the current notes are not thesis-safe as written. The phrase “admissible” is doing too much work, and if interpreted literally as only \(w^\top\mathbf1=1\), it makes the theorem false. The source citations also need sharpening: DPS Corollary 8 is a relative-error quantile result; your log result is a derived consequence or a supplement/proof consequence. The plug-in layer is conditional and should not be sold as automatically inherited for arbitrary selected weights.

The corrected thesis message should be:

- common-marginal only;
- fixed or convergent bounded deterministic \(\nu\);
- deterministic or DPS-admissible estimated \(\omega\);
- \(\eta_n\to0\) explicitly imposed;
- no first-order optimality claim for \(\nu\);
- no random \(\nu\) without a new proof;
- plug-in inference only under explicit DPS plug-in consistency.

If you make those repairs, I would not attack the central first-order theorem. Without those repairs, I would reject the theorem statement as overbroad.

---

## 8. Items I did not verify

I did not audit simulations, finite-sample implementation, actual Chapter 4 prose, or private local PDFs under the `papers/...` paths. I checked the uploaded Markdown and the publicly accessible source versions of the main cited results. If Chapter 4 contains a different estimator, different target, random thresholds, or random bridge weights, that chapter still needs a separate audit.
