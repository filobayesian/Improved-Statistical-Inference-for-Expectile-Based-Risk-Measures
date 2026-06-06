# Source audit: pooled extreme-expectile decomposition

Status: Markdown research layer, not theorem prose. The first-order
deterministic two-weight route is now source-checked under the conservative
$\eta_n\to0$ design. This note records the exact decomposition, source inputs,
rate comparison, checked theorem candidate, resulting design decision, and the
first source-audited transfer check for DPS estimated weights in the
pooled-Weissman component. It also records the source-conditional plug-in
standardisation and the corresponding log-scale interval inversion. It does
not promote these results to thesis prose, run simulations, or construct a
lower-order criterion for the bridge-Hill weights.

Current first-order decision as of 2026-06-05: keep the deterministic theorem,
estimated-$\omega$ transfer, and plug-in inference corollary sequential. The
base theorem is deterministic: for every deterministic admissible pair
$(\nu,\omega)$, the $\eta_n\to0$ route gives the pooled-Weissman source-scale
limit $N(B_\omega,V_\omega)$. A transfer corollary may replace only the
pooled-Weissman weights $\omega$ by source-admissible DPS estimated weights
$\widehat\omega_n\to_P\omega$, because DPS already proves the corresponding
random-weight quantile result. The plug-in inference corollary then applies if
the selected DPS route provides consistent bias and variance objects. The
geometric pooled-Weissman weights $\omega$ remain visible and may use the DPS
variance and AMSE criteria when the source conditions justify the oracle or
plug-in objects. The outer bridge-Hill weights $\nu$ remain deterministic
throughout this first-order audit and are first-order unidentified. For
downstream practical inference, the bridge-Hill convention is now fixed as

$$
\nu=\nu_n^k
=
\left(\frac{k_1}{k},\ldots,\frac{k_m}{k}\right).
$$

This convention is deterministic once the intermediate thresholds are chosen
and allows $\omega$ to be replaced by DPS estimated variance- or AMSE-optimal
weights without making the bridge-Hill vector random. It is not an optimality
claim for $\nu$. Choosing $\nu$ optimally, or making $\nu$ random, would
require a new lower-order or compact-event audit, not an extension of the
present first-order result.

Current inference decision: when DPS source conditions provide consistent
plug-in centring and variance objects for the selected $\omega$ route, use
those plug-ins. This is a mathematical Slutsky/studentisation choice, not a new
estimator layer. Omitting the bias centring would require a separate
bias-negligibility condition such as the corresponding DPS undersmoothing
route; the plug-in route keeps the already admitted nonzero $B_\omega$ in the
theorem and estimates it directly.

Source-check status as of 2026-06-05: the $\eta_n\to0$ theorem route has been
checked against the local PDFs of Daouia--Padoan--Stupfler Corollary 8 in the
published Bernoulli version, the supplement proof of Theorem 2, and
Daouia--Girard--Stupfler (2020), Proposition 1(i). The subsequent
estimated-$\omega$ transfer layer has been checked against
Daouia--Padoan--Stupfler Theorem A.1 in the supplement, Section 2.2,
Corollary 1, Theorem 2, Corollary 6, Corollary 7, and Corollary 8 in the
published Bernoulli version. DPS Corollary 4 has been checked only as the
source's log-scale quantile-inference analogue; this note does not import its
interval formula directly. The expectile interval below is obtained by
inverting the transferred plug-in-centred expectile statistic. The theorem
route is
source-consistent after carrying forward the source conventions on continuity,
common iid data, aggregate $n$ and $k$, and eventual positivity of the upper
tail needed for the log-Weissman expressions. The first theorem has now been
moved into Chapter 4 as the diagonal special case. The checked Markdown layer
is the two-weight estimator below, where $\omega$ weights the DPS geometric
pooled Weissman quantile and $\nu$ weights only the outer bridge-Hill
estimator.

Chapter 4 has not yet been updated to this two-weight result. That is
deliberate: the thesis prose layer should wait until Filippo chooses to promote
the checked Markdown result.

## Object and exact identity

The active estimator class is

$$
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
=
\psi(\widehat\gamma_n(\nu))\,
\widehat q_n^\star(\tau_n\mid\omega),
\qquad
\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}.
$$

Here $\omega^\top\mathbf 1=1$ and $\nu^\top\mathbf 1=1$ are deterministic
admissible affine weights. The diagonal estimator already written in Chapter 4
is the special case $\nu=\omega$; it should not be read as the only
first-order admissible design. For downstream implementation and inference
design, use the fixed deterministic convention
$\nu_n^k=(k_1/k,\ldots,k_m/k)$.

Scope convention for this note: all sections through the deterministic
weight-criterion audit treat both $\nu$ and $\omega$ as deterministic
triangular weight sequences. Random weights appear only in the later
estimated-$\omega$ transfer section, and only in the DPS pooled-Weissman role.
The bridge-Hill vector $\nu$ is not random in the checked theorem or transfer
corollary. The practical transfer route fixes $\nu=\nu_n^k$ while allowing
$\omega$ to be source-admissibly estimated through DPS.

To match the notation of Daouia--Padoan--Stupfler's Weissman theorem, set
$p_n = 1-\tau_n$ only as a source-audit translation. Then
$\widehat q_n^\star(\tau_n\mid\omega)$ corresponds to their
$\widehat q_n^\star(1-p_n\mid\omega)$.

The load-bearing identity is

$$
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
= A_n(\omega)+B_n(\nu)-C_n,
$$

where

$$
A_n(\omega) =
\log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)},
$$

$$
B_n(\nu) =
\log\psi(\widehat\gamma_n(\nu))-\log\psi(\gamma),
$$

and

$$
C_n =
\log\frac{\xi_{\tau_n}}{\psi(\gamma)Q(\tau_n)}.
$$

For the least-action iid/distributed thesis route, $Q$ and $\xi$ should be
read as the common marginal population quantile and expectile. If the theorem
is stated under the more general tail-homoskedastic framework of
Daouia--Padoan--Stupfler, the target population must be specified separately.
All one-weight displays in the current Chapter 4 theorem are recovered from
this identity by setting $\nu=\omega$.

## First-order closure checklist

For the current iid/common-marginal, finite-$m$, first-order layer, the
research status is:

1. Estimator fixed: the active object is
   $\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)$, with separate
   deterministic admissible vectors $\nu$ and $\omega$.
2. Exact decomposition fixed:
   $A_n(\omega)+B_n(\nu)-C_n$ is an identity, not an asymptotic
   approximation.
3. Source inputs fixed: $A_n(\omega)$ uses DPS Corollary 8 in the published
   Bernoulli version, with relative-to-log conversion or the supplement proof;
   $B_n(\nu)$ uses the DPS pooled Hill CLT plus Taylor expansion of
   $\log\psi$; $C_n$ uses DGS 2020 Proposition 1(i) plus the elementary log
   conversion.
4. Rate route fixed for the first theorem: impose
   $\eta_n=\sqrt{k}/\{\ell_n Q(1-p_n)\}\to0$.
5. First-order conclusion fixed:
   $(\sqrt{k}/\ell_n)\log\{
   \widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)/\xi_{\tau_n}\}
   \Rightarrow N(B_\omega,V_\omega)$.
6. Weight-status split fixed: DPS deterministic/oracle weight criteria apply
   to $\omega$ only; $\nu$ is first-order unidentified.
7. Estimated-$\omega$ transfer fixed as a corollary, not a replacement for
   the deterministic theorem: if DPS source conditions give
   $\widehat\omega_n^\top\mathbf 1=1$ and
   $\widehat\omega_n\to_P\omega$, then the same first-order limit transfers
   to
   $\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)$ for
   deterministic admissible $\nu$.
8. Practical bridge convention fixed:
   $\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)$ for downstream inference work. This
   avoids the unaudited random choice $\nu=\widehat\omega_n$ and carries no
   optimality claim.
9. Plug-in inference route fixed conditionally on DPS consistency:
   source-admissible plug-in centring and variance objects for $\omega$ give a
   standard normal statistic and a log-scale multiplicative interval by
   inversion.
10. Parked layers fixed after this pass: thesis-prose promotion, simulations,
    broader tail-homoskedastic targets, and lower-order $\nu$ optimality remain
    outside the current closure.

## Checked source statements

| Term | Source | What the source gives | Important caveat |
|---|---|---|---|
| $A_n(\omega)$ | Daouia--Padoan--Stupfler, *Optimal weighted pooling for inference about the tail index and extreme quantiles*, Theorem 2, Section 2.3. Local files: `papers/Optimal Weighted Pooling Bernoulli 2024.pdf` and arXiv file `papers/Optimal Pooling.pdf`. | General finite-$m$ pooled weighted-geometric Weissman CLT for relative error. | Main statement is for relative error, not log-relative error. The pooled-quantile part also needs tail homoskedasticity $(H)$ if the margins are not literally common. |
| $A_n(\omega)$ common-marginal specialisation | Same paper, Corollary 8 in the published Bernoulli version, Section 3.3. | Common-marginal distributed version of the same relative-error CLT, with simplified bias and variance. | This is the cleanest source statement for the iid/common-marginal route. The arXiv file numbers this result as Corollary 9; the thesis bibliography cites the published version, so theorem prose should cite Corollary 8. |
| $A_n(\omega)$ log conversion | Same paper, supplement, proof of Theorem 2; Lemma B.2. Local file: `papers/optimal pooling supp.pdf`. | Shows the log Weissman error equals the dominant Hill term plus a lower-order log remainder. | This is a proof ingredient, not the headline theorem statement. In the common-marginal case the target-alignment term is exactly zero, so Lemma B.2 is only needed for the broader $(H)$ route. |
| $B_n(\nu)$ | Daouia--Padoan--Stupfler, Theorem 1, Section 2.1; Corollary 5 in the iid/common-marginal route. | Joint CLT for marginal Hill estimators and pooled Hill CLT under common $\gamma$, usable for any deterministic admissible bridge-Hill vector $\nu$. | Passing through $\log\psi$ is our Taylor step. This term is separate from the Hill errors already embedded in the Weissman component $A_n(\omega)$. |
| $C_n$ first order | Bellini et al. (2014), and Daouia--Girard--Stupfler (2019), Corollary 1 with $p=2$. Local file for DGS 2019: `papers/DGS2019.pdf`. | $\xi_\tau/Q(\tau) \to \psi(\gamma)$ for $0<\gamma<1$ with finite lower-tail first moment. | First order only; no rate for $C_n$. |
| $C_n$ second order | Daouia--Girard--Stupfler, *Tail expectile process and risk assessment*, Proposition 1(i). Local file: `papers/DGS2020.pdf`. | Ratio expansion for $\xi_\tau/Q(\tau)$ with second-order term and first-moment term. | It is a ratio expansion, not a log expansion. Logging adds an explicit deterministic square-order remainder whose scaled order must be checked later. |
| Single-sample sanity check / rate guide | Daouia--Girard--Stupfler (2018), Corollaries 3-4; Davison--Padoan--Stupfler (2023), Theorem 3.5. Local files: `papers/Daouia-Estimationtailrisk-2018.pdf`, `papers/Tail Risk Inference via Expectiles in Heavy-Tailed Time Series.pdf`. | Full extrapolated expectile CLTs in single-sample/time-series settings. DGS 2018 Corollary 3 reduces to the same QB extreme-expectile object when $m=1$. | Do not import these as the pooled theorem. Use DGS 2018 as an $m=1$ sanity check, with explicit translation because their $\tau_n$ is intermediate and their $\tau'_n$ is extreme. |

## Term 1: $A_n(\omega)$, pooled Weissman error

### Source theorem: general pooled-quantile route

Daouia--Padoan--Stupfler Theorem 2 applies to the weighted-geometric pooled
Weissman estimator

$$
\widehat q_n^\star(1-p\mid\omega)
=
\prod_{j=1}^m
\left[\widehat q_j^\star(1-p\mid k_j)\right]^{\omega_j},
$$

with

$$
\widehat q_j^\star(1-p\mid k_j)
=
\left(\frac{k_j}{n_jp}\right)^{\widehat\gamma_j(k_j)}
X_{n_j-k_j:n_j,j}.
$$

Let

$$
\ell_n=\log\frac{k}{np},
\qquad
\ell_{j,n}=\log\frac{k_j}{n_jp}.
$$

For any fixed $j$, under tail homoskedasticity $(H)$, the theorem states a CLT
for

$$
\frac{\sqrt{k}}{\ell_n}
\left(
  \frac{\widehat q_n^\star(1-p\mid\widehat\omega_n)}{q_j(1-p)}-1
\right).
$$

More precisely, if $\widehat\omega_n^\top 1=1$ and
$\widehat\omega_n\to_P\omega$, then

$$
\frac{\sqrt{k}}{\ell_n}
\left(
  \frac{\widehat q_n^\star(1-p\mid\widehat\omega_n)}{q_j(1-p)}-1
\right)
=
\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}
+o_P(1)
\Rightarrow
N(\omega^\top B_c,\omega^\top V_c\omega).
$$

For deterministic pooled-Weissman weights, set $\widehat\omega_n=\omega$. The
displayed source normalisation is the
normalisation for the pooled Weissman quantile component only; it is not yet a
normalisation for the full expectile decomposition
$A_n(\omega)+B_n(\nu)-C_n$.

The theorem also contains a local Weissman statement, without geometrically
pooling the quantile estimators, with $\ell_{j,n}$ in place of $\ell_n$. That
local statement is useful background but is not the object currently targeted
in Chapter 4.

### Source theorem: iid/common-marginal route

Section 3 of Daouia--Padoan--Stupfler specialises the framework to distributed
inference with all observations iid from a common distribution satisfying
$C_2(\gamma,\rho,A)$. In the published Bernoulli version, Corollary 8 gives,
under the conditions of Corollary 5 and the extra Weissman conditions listed
below,

$$
\frac{\sqrt{k}}{\ell_n}
\left(
  \frac{\widehat q_n^\star(1-p\mid\widehat\omega_n)}{q(1-p)}-1
\right)
=
\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}
+o_P(1)
\Rightarrow
N\left(
  \frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
  \gamma^2
  \left(\sum_{j=1}^m\frac1{c_j}\right)
  \left(\sum_{j=1}^m c_j\omega_j^2\right)
\right),
$$

where

$$
d_j=\frac{c_j}{b_j}\,
\frac{\sum_{i=1}^m c_i^{-1}}{\sum_{i=1}^m b_i^{-1}}.
$$

This is the most direct citation if the rebuilt thesis theorem is kept in the
finite-$m$ iid/common-marginal distributed setting. In this route
$q_j=q=Q$ for every $j$, so there is no target-alignment term and no need to
invoke tail homoskedasticity merely to align the population quantiles.

### Assumptions to carry forward

For the general Theorem 2 route, carry forward:

- Second-order regular variation $C_2(\gamma_j,\rho_j,A_j)$ for each margin.
- Tail-copula condition $J(R)$ for cross-sample extremal dependence.
- Effective sample sizes $k_j \to \infty$, $k_j/n_j \to 0$.
- Proportionality $n_1/n_j \to b_j \in (0,\infty)$ and
  $k_1/k_j \to c_j \in (0,\infty)$.
- Hill bias calibration $\sqrt{k_j} A_j(n_j/k_j) \to \lambda_j$.
- Common tail index $\gamma_1=\cdots=\gamma_m=\gamma$.
- Tail homoskedasticity $(H)$: $U_j(t)/U_l(t) \to 1$.
- Strict second-order parameters $\rho_j<0$ for the Weissman theorem.
- Extreme level regime $p=p(n)\to0$, $k/(np)\to\infty$, and
  $\sqrt{k}/\log(k/(np))\to\infty$.
- Weights with $\omega^\top 1=1$; for estimated weights, the source requires
  exact normalisation and convergence to a deterministic weight vector.

For the finite-$m$ iid/common-marginal Corollary 8 route, this simplifies to:

- iid observations across and within machines, with common continuous
  right-heavy-tailed distribution satisfying $C_2(\gamma,\rho,A)$.
- Eventual upper-tail positivity, equivalently $Q(1-1/t)=U(t)>0$ for all large
  $t$, so the Hill and Weissman logarithms are well defined with probability
  tending to one. This is implicit in the source log-Weissman setup and should
  be explicit in thesis theorem prose.
- Aggregate sizes $n=\sum_{j=1}^m n_j$ and $k=\sum_{j=1}^m k_j$.
- Proportionality $n_1/n_j\to b_j\in(0,\infty)$ and
  $k_1/k_j\to c_j\in(0,\infty)$.
- $k\to\infty$, $k/n\to0$, and $\sqrt{k}A(n/k)\to\lambda\in\mathbb R$.
- Strict $\rho<0$.
- Extreme level regime $p=p(n)\to0$, $k/(np)\to\infty$, and
  $\sqrt{k}/\ell_n\to\infty$.
- Weights with $\omega^\top1=1$; for estimated weights,
  $\widehat\omega_n^\top1=1$ and $\widehat\omega_n\to_P\omega$.

The active thesis route uses deterministic generic weights, so the estimated-weight
layer can be ignored at first by taking $\widehat\omega_n=\omega$.

### Relative error versus log-relative error

Daouia--Padoan--Stupfler Theorem 2 and Corollary 8 are stated for relative
error. Since
$A_n(\omega)$ is a log-relative error, there are two validated
source-grounded routes.

First, the supplement proof of Theorem 2 works directly with

$$
\log\frac{\widehat q_j^\star(1-p\mid k_j)}{q(1-p)}
$$

and obtains, after pooling and recentering at a fixed marginal target
$q_\ell(1-p)$ under $(H)$,

$$
\log\frac{\widehat q_n^\star(1-p\mid\omega)}{q_l(1-p)}
=
\ell_n\,
  \{\widehat\gamma_n(\omega)-\gamma\}
+O_P(k^{-1/2})
$$

for deterministic weights. With estimated weights the same display is read with
$\widehat\gamma_n(\widehat\omega_n)$ first, and Theorem 1 then replaces it by
the deterministic limiting weight version.

The proof decomposes the log error into:

- the common-log Hill component
  $\ell_n\{\widehat\gamma_n(\omega)-\gamma\}$;
- a local-log correction, controlled because
  $\ell_{j,n}/\ell_n\to1$;
- the intermediate-threshold order-statistic term, controlled as
  $O_P(k^{-1/2})$ in the finite-$m$ setting;
- the deterministic second-order tail approximation term, controlled by
  $C_2$ and $\rho_j<0$;
- the marginal target-alignment term, controlled under $(H)$ by supplement
  Lemma B.2.

In the common-marginal route, the last term is exactly zero because all
$q_j=q$. The remaining controls are precisely the ingredients behind Corollary
8.

Second, one may convert the headline relative-error theorem to log scale. The
source regime $\sqrt{k}/\ell_n\to\infty$ implies
$\ell_n/\sqrt{k}\to0$, so the relative error in Theorem 2 or Corollary 8 is
$o_P(1)$. Therefore

$$
\log(1+x_n)=x_n+O_P(x_n^2),
\qquad
x_n=
\frac{\widehat q_n^\star(1-p\mid\omega)}{q(1-p)}-1,
$$

and

$$
\frac{\sqrt{k}}{\ell_n}
\log\frac{\widehat q_n^\star(1-p\mid\omega)}{q(1-p)}
-
\frac{\sqrt{k}}{\ell_n}
\left(
  \frac{\widehat q_n^\star(1-p\mid\omega)}{q(1-p)}-1
\right)
=
O_P\left(\frac{\ell_n}{\sqrt{k}}\right)
=o_P(1).
$$

Thus the log and relative versions have the same source normalisation and the
same limit for the quantile component. The supplement route is stronger and
more aligned with the exact $A_n(\omega)$ ledger; the relative-error route is
shorter if Chapter 4 only needs the marginal conclusion for $A_n(\omega)$.

### Validation status for $A_n(\omega)$

For the finite-$m$ iid/common-marginal setting, point 1 is validated as follows:

| Question | Answer for $A_n(\omega)$ |
|---|---|
| Exact source statement | Use Daouia--Padoan--Stupfler Corollary 8 in the published Bernoulli version for the common-marginal distributed route; use Theorem 2 for the broader tail-homoskedastic route. |
| Source normalisation | $\sqrt{k}/\ell_n$ with $\ell_n=\log(k/(np))$, for the pooled Weissman quantile component. |
| Relative or log scale? | Headline source statement is relative error. The supplement proof gives a direct log expansion, and the source regime also permits a Taylor conversion from relative to log error. |
| Common-marginal target issue | No issue: $A_n^{target}=0$ exactly because $q_j=q=Q$. |
| Rate-audit role | The order comparison below treats $\sqrt{k}/\ell_n$ as the $A_n(\omega)$ source benchmark and then asks which additional conditions are needed before it can be used for the full expectile decomposition. |

### Single-sample sanity check: DGS 2018

Daouia--Girard--Stupfler (2018), Corollary 3, should be used as a sanity
check and rate guide, not as the proof of the pooled theorem. Their notation
uses $\tau_n$ for the intermediate level and $\tau'_n$ for the extreme level,
whereas this note uses $\tau_n$ for the extreme target. To avoid confusion,
write their levels here as

$$
\tau_n^{int}\quad\text{and}\quad \tau_n^{ext},
\qquad
k=n(1-\tau_n^{int}),
\qquad
p_n=1-\tau_n^{ext}.
$$

Their QB extrapolated extreme-expectile estimator in equation (11) is

$$
\widehat\xi_{\tau_n^{ext}}^\star
=
(\widehat\gamma^{-1}-1)^{-\widehat\gamma}
\widehat q_{\tau_n^{ext}}^\star,
$$

which matches the present estimator when $m=1$. Their Corollary 3 uses the
scale

$$
\frac{\sqrt{n(1-\tau_n^{int})}}
{\log\{(1-\tau_n^{int})/(1-\tau_n^{ext})\}}
=
\frac{\sqrt{k}}{\ell_n},
$$

and imposes, among other conditions,

$$
\sqrt{k}\,q_{\tau_n^{int}}^{-1}=O(1),
\qquad
\sqrt{k}\,A\{(1-\tau_n^{int})^{-1}\}=O(1),
\qquad
\frac{\sqrt{k}}{\ell_n}\to\infty.
$$

Since $q_{\tau_n^{ext}}\ge q_{\tau_n^{int}}$ for the extreme level, the first
of these conditions implies

$$
\eta_n
=
\frac{\sqrt{k}}{\ell_n Q(1-p_n)}
\le
\frac{\sqrt{k}}{\ell_n q_{\tau_n^{int}}}
\to0.
$$

This is consistent with the $\eta_n\to0$ branch and confirms that the $m=1$
reduction has the expected scale and stochastic limit. It does not choose the
pooled theorem design, which still has to follow from the exact
$A_n(\omega)+B_n(\nu)-C_n$ decomposition and the DPS pooled-Weissman input.

## Term 2: $B_n(\nu)$, the cost of estimating $\gamma$ inside $\psi$

### Source theorem

Daouia--Padoan--Stupfler Theorem 1 gives the general finite-$m$ pooled Hill
input. Under the marginal second-order conditions $C_2(\gamma_j,\rho_j,A_j)$,
the tail-copula condition $J(R)$, proportional sample and threshold sizes
$n_1/n_j\to b_j\in(0,\infty)$ and $k_1/k_j\to c_j\in(0,\infty)$, and the
Hill-bias calibration $\sqrt{k_j}A_j(n_j/k_j)\to\lambda_j$, their theorem
first gives the joint CLT for the marginal Hill estimators. Under the common
tail-index condition $\gamma_1=\cdots=\gamma_m=\gamma$, it then implies, for
any deterministic weight vector $v$ satisfying $v^\top1=1$,

$$
\sqrt{k}\{\widehat\gamma_n(v)-\gamma\}
\Rightarrow
N(v^\top B_c,v^\top V_cv).
$$

This is the source statement for the random input to $B_n(\nu)$ after setting
$v=\nu$. It does not require the extra Weissman conditions: no tail
homoskedasticity $(H)$, no strict $\rho_j<0$ requirement beyond what is needed
for the relevant bias calibration, and no extreme-level $p$-regime. In the
iid/common-marginal distributed route, Daouia--Padoan--Stupfler Corollary 5 is
the direct specialisation:

$$
\sqrt{k}\{\widehat\gamma_n(v)-\gamma\}
\Rightarrow
N\left(
  \frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho v_j,
  \gamma^2
  \left(\sum_{j=1}^m\frac1{c_j}\right)
  \left(\sum_{j=1}^m c_jv_j^2\right)
\right),
$$

with $d_j$ as in the $A_n(\omega)$ audit. This common-marginal version is the
cleanest source for the first thesis route. Theorem 1 or Corollary 5 also gives

$$
\widehat\gamma_n(v)-\gamma=O_P(k^{-1/2})
\quad\text{and}\quad
\widehat\gamma_n(v)\to_P\gamma.
$$

### Compactness Inside $(0,1)$

For expectiles, the bridge requires $0<\gamma<1$. If the pooled estimator is
formed with fixed bridge-Hill weights satisfying $v^\top 1=1$, consistency of
the local Hill estimators gives

$$
\widehat\gamma_n(v)\to_P \gamma.
$$

Thus, for any

$$
0<\varepsilon<\min(\gamma,1-\gamma),
$$

the event

$$
\widehat\gamma_n(v)\in[\gamma-\varepsilon,\gamma+\varepsilon]
\subset(0,1)
$$

has probability tending to one. The same argument works for estimated weights
if they are exactly normalised and converge to a deterministic admissible
weight vector, as in the source theorem.

Equivalently, with

$$
E_{n,\varepsilon}
=\left\{
  |\widehat\gamma_n(v)-\gamma|\le\varepsilon
 \right\},
$$

we have $P(E_{n,\varepsilon})\to1$ and, on this event, the whole line segment
between $\gamma$ and $\widehat\gamma_n(v)$ lies in the compact interval
$K_\varepsilon=[\gamma-\varepsilon,\gamma+\varepsilon]\subset(0,1)$.
The Taylor statements below are therefore high-probability-event statements;
outside $E_{n,\varepsilon}$ no expansion is needed for the limiting argument.

### Taylor expansion

Let

$$
g(x)=\log\psi(x)=-x\log(x^{-1}-1).
$$

On any compact subinterval of $(0,1)$, $g$ is twice continuously
differentiable. Its first derivative is

$$
g'(x)=m(x)=\frac{1}{1-x}-\log(x^{-1}-1).
$$

Moreover,

$$
g''(x)=m'(x)
=
\frac{1}{(1-x)^2}
+
\frac{1}{1-x}
+
\frac{1}{x}.
$$

For the compact interval $K_\varepsilon$, define the finite constant

$$
M_\varepsilon=\sup_{x\in K_\varepsilon}|g''(x)|.
$$

Therefore, on $E_{n,\varepsilon}$,

$$
B_n(v)
=
m(\gamma)\{\widehat\gamma_n(v)-\gamma\}
+
R_n^\psi,
$$

where the Taylor remainder satisfies the explicit bound

$$
|R_n^\psi|
\le
\frac12 M_\varepsilon
\{\widehat\gamma_n(v)-\gamma\}^2.
$$

Together with the pooled Hill CLT,

$$
R_n^\psi=O_P(k^{-1}),
\qquad
B_n(v)
=
m(\gamma)\{\widehat\gamma_n(v)-\gamma\}
+O_P(k^{-1}).
$$

Setting $v=\nu$ gives the active bridge-Hill term. Setting $v=\omega$ gives the
diagonal Chapter 4 term. This records only the intrinsic order of the
$B_n(v)$ pieces. It does not choose a normalisation for the full sum
$A_n(\omega)+B_n(\nu)-C_n$.

Special caution: $m(\gamma)$ vanishes near $\gamma=0.2178$. If a later theorem
includes a first-order contribution from $B_n(v)$, that root may require
separate wording.

## Term 3: $C_n$, deterministic expectile-quantile bridge error

### First-order bridge

For $p=2$, Daouia--Girard--Stupfler (2019), Corollary 1, gives the expectile
case of the $L^p$-quantile equivalence:

$$
\frac{\xi_\tau}{Q(\tau)}
\to
\psi(\gamma)
=
(\gamma^{-1}-1)^{-\gamma}.
$$

The assumptions reduce to:

- first-order regular variation of the survival tail;
- finite lower-tail first moment;
- $0<\gamma<1$.

This confirms $C_n \to 0$, but it does not provide a usable rate.

### Second-order ratio expansion

Daouia--Girard--Stupfler (2020), Proposition 1(i), gives the needed
second-order population expansion. In their notation, the right tail is
Pareto-type with tail quantile

$$
U(t)=q_{1-t^{-1}},
$$

and the second-order condition $C_2(\gamma,\rho,A)$ is

$$
\lim_{t\to\infty}
\frac{1}{A(t)}
\left\{
  \frac{U(tx)}{U(t)}-x^\gamma
\right\}
=
x^\gamma\frac{x^\rho-1}{\rho},
\qquad x>0,
$$

where $\rho\le0$, $A(t)\to0$, $A$ has ultimately constant sign, and
$(x^\rho-1)/\rho$ is read as $\log x$ when $\rho=0$. Proposition 1(i)
assumes $E|Y^-|<\infty$ and $0<\gamma<1$; together these conditions imply that
$EY$ exists. The proposition does not require the strict monotonicity condition
that appeared in the earlier DGS expansion. For the common-marginal thesis
route, identify $Y$ with the common observation variable and set

$$
q_\tau=Q(\tau)=Q_0(1-p),
\qquad p=1-\tau.
$$

Then, as $\tau\to1$,

$$
\frac{\xi_\tau}{Q(\tau)}
=
\psi(\gamma)
\left[
  1
  + c(\gamma,\rho) A((1-\tau)^{-1})
  + \gamma(\gamma^{-1}-1)^\gamma
    \frac{E Y}{Q(\tau)}
  + o(|A((1-\tau)^{-1})|)
  + o(Q(\tau)^{-1})
\right],
$$

where

$$
c(\gamma,\rho)
=
\frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}
+
\frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho},
$$

with the second fraction read by continuity at $\rho=0$. At $\rho=0$, this
constant equals

$$
m(\gamma)=\frac{1}{1-\gamma}-\log(\gamma^{-1}-1).
$$

This source statement is a ratio expansion. With

$$
a_\tau=A((1-\tau)^{-1}),
\qquad
b_\tau=Q(\tau)^{-1},
$$

it implies

$$
\Delta_{\tau}
=
c(\gamma,\rho) A((1-\tau)^{-1})
+
\gamma(\gamma^{-1}-1)^\gamma E Y\, Q(\tau)^{-1}
+
o(|A((1-\tau)^{-1})|)
+
o(Q(\tau)^{-1}).
$$

Equivalently,

$$
\Delta_\tau
=
c(\gamma,\rho)a_\tau
+\gamma(\gamma^{-1}-1)^\gamma EY\,b_\tau
+o(|a_\tau|)
+o(b_\tau),
$$

and hence $\Delta_\tau=O(|a_\tau|+b_\tau)$. Since $A(t)\to0$ and
$Q(\tau)\to\infty$, $\Delta_\tau\to0$; for all sufficiently high $\tau$,
$|\Delta_\tau|\le1/2$ and the logarithm is well-defined. The exact $C_n$ term
therefore satisfies

$$
C_n
=
\log(1+\Delta_{\tau_n})
=
\Delta_{\tau_n}
+R_{\tau_n}^{log},
$$

where

$$
R_{\tau_n}^{log}
=
\log(1+\Delta_{\tau_n})-\Delta_{\tau_n}.
$$

Taylor's theorem gives the deterministic bound

$$
|R_{\tau_n}^{log}|
\le
2\Delta_{\tau_n}^2
=
O\left((|A(1/p_n)|+Q(1-p_n)^{-1})^2\right)
$$

once $|\Delta_{\tau_n}|\le1/2$. This is an order ledger, not a negligibility
claim. If a later candidate scale is called $s_n$, the order comparison must
check $s_nA(1/p_n)$, $s_nQ(1-p_n)^{-1}$, and

$$
s_n(|A(1/p_n)|+Q(1-p_n)^{-1})^2.
$$

Depending on the target-level regime, the last display may vanish, survive, or
force an additional rate condition. This note does not decide which case holds.

## Component ledger before any rate comparison

This section is a ground-up decomposition ledger. It deliberately does not
select a scale, call any component negligible, or identify a limiting
distribution. Its purpose is only to expose the exact pieces that later have to
be controlled.

### Common notation for the ledger

Let

$$
p_n = 1-\tau_n,
\qquad
\ell_{j,n}=\log\frac{k_j}{n_jp_n},
\qquad
\ell_n=\log\frac{k}{np_n}.
$$

Write

$$
Q_j(1-p)=U_j(1/p),
\qquad
x_{j,n}=X_{n_j-k_j:n_j,j},
\qquad
\widehat\gamma_j=\widehat\gamma_j(k_j).
$$

Let $Q_0(1-p_n)$ denote the population target used in $A_n(\omega)$. In the
iid/common-marginal route, $Q_0=Q_j$ for every $j$. In the more general
tail-homoskedastic route, $Q_0$ must be chosen explicitly, for example as one
fixed marginal target. The $A_n(\omega)$ displays use only the affine
constraint $\sum_j\omega_j=1$; the bridge-Hill displays use the analogous
constraint on the bridge vector.

### $A_n(\omega)$: exact pooled-Weissman log ledger

Starting from the definition of the geometric pooled Weissman estimator,

$$
A_n(\omega)
=
\sum_{j=1}^m \omega_j
\left\{
  \widehat\gamma_j \ell_{j,n}
  +\log x_{j,n}
  -\log Q_0(1-p_n)
\right\}.
$$

Add and subtract, inside each summand,

$$
\gamma\ell_{j,n},
\qquad
\log Q_j(1-k_j/n_j),
\qquad
\log Q_j(1-p_n).
$$

This gives the exact identity

$$
A_n(\omega)
=
A_n^{Hill}
+A_n^{thr}
+A_n^{tail}
+A_n^{target},
$$

where

$$
A_n^{Hill}
=
\sum_{j=1}^m \omega_j
  \ell_{j,n}(\widehat\gamma_j-\gamma),
$$

$$
A_n^{thr}
=
\sum_{j=1}^m \omega_j
\left\{
  \log x_{j,n}
  -\log Q_j(1-k_j/n_j)
\right\},
$$

$$
A_n^{tail}
=
\sum_{j=1}^m \omega_j
\left\{
  \log Q_j(1-k_j/n_j)
  +\gamma\ell_{j,n}
  -\log Q_j(1-p_n)
\right\},
$$

and

$$
A_n^{target}
=
\sum_{j=1}^m \omega_j
\left\{
  \log Q_j(1-p_n)
  -\log Q_0(1-p_n)
\right\}.
$$

Interpretation only:

- $A_n^{Hill}$ is the tail-index estimation component inside Weissman
  extrapolation.
- $A_n^{thr}$ is the random intermediate-threshold order-statistic component.
- $A_n^{tail}$ is the deterministic tail-regular-variation approximation
  error between the intermediate threshold and the extreme target level.
- $A_n^{target}$ is the marginal target-alignment component. It is exactly zero
  in the common-marginal setting; otherwise it is where tail homoskedasticity
  enters.

There is also an exact split of the Hill component:

$$
A_n^{Hill}
=
\ell_n\{\widehat\gamma_n(\omega)-\gamma\}
+
\sum_{j=1}^m\omega_j(\ell_{j,n}-\ell_n)
  (\widehat\gamma_j-\gamma).
$$

This split only identifies the common-log pooled-Hill piece and the
sample-proportion correction. It does not assert that either part dominates.

The source map for these four components, after validating point 1, is:

| Component | Source/control checked | Status for finite-$m$ common-marginal route |
|---|---|---|
| $A_n^{Hill}$ | Daouia--Padoan--Stupfler Theorem 1 and the proof of Theorem 2. | The common-log pooled-Hill piece is the source-dominant part for $A_n(\omega)$ under the Weissman source normalisation. The local-log correction is lower order because $\ell_{j,n}/\ell_n\to1$ and $\sqrt{k_j}(\widehat\gamma_j-\gamma)=O_P(1)$. |
| $A_n^{thr}$ | Intermediate order-statistic expansion used in the supplement proof of Theorem 2. | Controlled as part of the supplement's $O_P(k^{-1/2})$ log remainder when $m$ is fixed and $k_j/k$ has positive limits. |
| $A_n^{tail}$ | Second-order regular variation $C_2$ and supplement Lemma B.2/proof of Theorem 2. | The deterministic tail approximation is controlled by $\rho<0$, $k/(np)\to\infty$, and $\sqrt{k}A(n/k)=O(1)$ in the common-marginal route. It can be cited through Corollary 8/supplement unless Chapter 4 needs the component proof reproduced. |
| $A_n^{target}$ | Tail homoskedasticity $(H)$ and supplement Lemma B.2 for the broad route. | Exactly zero in the iid/common-marginal route. Under only $(H)$, Lemma B.2 gives the required marginal log-quantile alignment. |

### $B_n(v)$: exact Taylor ledger

Let

$$
g(x)=\log\psi(x)=-x\log(x^{-1}-1),
\qquad
\overline\gamma_n(v)=\widehat\gamma_n(v),
\qquad
v^\top\mathbf 1=1.
$$

The exact term is

$$
B_n(v)=g(\overline\gamma_n(v))-g(\gamma).
$$

For any $0<\varepsilon<\min(\gamma,1-\gamma)$, define

$$
E_{n,\varepsilon}
=\{|\overline\gamma_n(v)-\gamma|\le\varepsilon\},
\qquad
K_\varepsilon=[\gamma-\varepsilon,\gamma+\varepsilon].
$$

The pooled Hill CLT gives $P(E_{n,\varepsilon})\to1$, and
$K_\varepsilon$ is a compact subset of $(0,1)$. On $E_{n,\varepsilon}$,
Taylor's formula gives

$$
B_n(v)
=
m(\gamma)(\overline\gamma_n(v)-\gamma)
+
R_n^\psi,
$$

where

$$
m(x)=g'(x)=\frac{1}{1-x}-\log(x^{-1}-1),
$$

and, for some intermediate value $\widetilde\gamma_n$ between $\gamma$ and
$\overline\gamma_n(v)$,

$$
R_n^\psi
=
\frac12 m'(\widetilde\gamma_n)
  (\overline\gamma_n(v)-\gamma)^2,
$$

with

$$
m'(x)
=
\frac{1}{(1-x)^2}
+
\frac{1}{1-x}
+
\frac{1}{x}.
$$

Since $m'$ is continuous on $K_\varepsilon$,

$$
M_\varepsilon=\sup_{x\in K_\varepsilon}|m'(x)|<\infty,
$$

and therefore, on $E_{n,\varepsilon}$,

$$
|R_n^\psi|
\le
\frac12 M_\varepsilon(\overline\gamma_n(v)-\gamma)^2.
$$

The same pooled Hill CLT gives

$$
\overline\gamma_n(v)-\gamma=O_P(k^{-1/2}),
\qquad
R_n^\psi=O_P(k^{-1}).
$$

Thus the validated ledger for $B_n(v)$ is

$$
B_n(v)
=
m(\gamma)(\overline\gamma_n(v)-\gamma)
+O_P(k^{-1}).
$$

If $m(\gamma)=0$, the linear part vanishes and this ledger only records
$B_n(v)=O_P(k^{-1})$. Whether that exceptional case matters depends on the
later order comparison with $A_n(\omega)$ and $C_n$. The active two-weight
route uses $v=\nu$; the diagonal Chapter 4 route uses $v=\omega$.

### $C_n$: sourced population-ratio ledger plus exact log remainder

Define the population ratio error

$$
\Delta_n
=
\frac{\xi_{\tau_n}}{\psi(\gamma)Q_0(1-p_n)}
-1.
$$

Then the exact log term is

$$
C_n=\log(1+\Delta_n).
$$

In the common-marginal setting, DGS 2020 Proposition 1(i) gives a sourced
asymptotic ledger for $\Delta_n$. Its assumptions, translated to the thesis
notation, are:

- $0<\gamma<1$;
- $E|X^-|<\infty$, so $EX$ exists under the Pareto-type right tail;
- $C_2(\gamma,\rho,A)$ for the common tail quantile $Q(1-1/t)=U(t)$, with
  $\rho\le0$, $A(t)\to0$, and $A$ ultimately of constant sign.

The Daouia--Padoan--Stupfler Weissman component later imposes the stricter
$\rho<0$ in the common-marginal route, but the DGS population-ratio expansion
itself allows $\rho=0$. With $\mu=E X$, write

$$
\Delta_n
=
\Delta_n^{SO}
+\Delta_n^{mean}
+\Delta_n^{DGS-rem},
$$

where

$$
\Delta_n^{SO}
=
c(\gamma,\rho)A(1/p_n),
$$

$$
\Delta_n^{mean}
=
\gamma(\gamma^{-1}-1)^\gamma
\frac{\mu}{Q_0(1-p_n)},
$$

and

$$
\Delta_n^{DGS-rem}
=
r_{A,n}A(1/p_n)
+
r_{Q,n}Q_0(1-p_n)^{-1},
\qquad
r_{A,n}\to0,\quad r_{Q,n}\to0.
$$

Because $A(1/p_n)\to0$ and $Q_0(1-p_n)\to\infty$,

$$
\Delta_n=O(|A(1/p_n)|+Q_0(1-p_n)^{-1})
\to0.
$$

The log conversion is another exact decomposition:

$$
C_n
=
\Delta_n
+
R_n^{log},
\qquad
R_n^{log}
=
\log(1+\Delta_n)-\Delta_n.
$$

Equivalently,

$$
C_n
=
\Delta_n^{SO}
+\Delta_n^{mean}
+\Delta_n^{DGS-rem}
+R_n^{log}.
$$

Once $|\Delta_n|\le1/2$, Taylor's theorem gives

$$
|R_n^{log}|
\le
2\Delta_n^2
=
O\left((|A(1/p_n)|+Q_0(1-p_n)^{-1})^2\right).
$$

No conclusion is made here about which of these pieces matters. The ledger only
separates the second-order tail term, the first-moment term, the DGS remainder,
and the new log-conversion remainder. The order comparison below checks the
two first-order deterministic pieces and the square-order log remainder
separately.

## Order comparison for $A_n(\omega)+B_n(\nu)-C_n$

Status: checked rate comparison for the current first-order route, not theorem
prose. This section works in the finite-$m$ iid/common-marginal distributed
route with deterministic admissible weights $\omega^\top 1=1$ and
$\nu^\top 1=1$. Its purpose is to compare the already-audited ledgers, not to
state final thesis prose.

### Benchmark scale and neutral rate notation

The pooled Weissman source result uses

$$
r_n=\frac{k}{np_n},
\qquad
\ell_n=\log r_n,
\qquad
s_{A,n}=\frac{\sqrt{k}}{\ell_n},
$$

with

$$
r_n\to\infty,
\qquad
\ell_n\to\infty,
\qquad
\frac{\sqrt{k}}{\ell_n}\to\infty.
$$

Here $s_{A,n}$ is only a benchmark inherited from the $A_n(\omega)$ source
theorem. It is not declared as the final normalisation for the complete
expectile decomposition.

For the population bridge terms, write

$$
a_n=A(1/p_n),
\qquad
b_n=Q_0(1-p_n)^{-1},
\qquad
\eta_n=s_{A,n}b_n
=\frac{\sqrt{k}}{\ell_n Q_0(1-p_n)}.
$$

Also set

$$
\alpha_\gamma=\gamma(\gamma^{-1}-1)^\gamma,
\qquad
\mu=EX.
$$

The DPS common-marginal Weissman route assumes $\rho<0$ and
$\sqrt{k}A(n/k)\to\lambda\in\mathbb R$. Since $A$ is regularly varying with
index $\rho$, and

$$
\frac{1/p_n}{n/k}=r_n\to\infty,
$$

we have

$$
\frac{A(1/p_n)}{A(n/k)}
=
r_n^\rho\{1+o(1)\}
\to0.
$$

Consequently,

$$
\sqrt{k}\,a_n
=
\sqrt{k}A(n/k)
\frac{A(1/p_n)}{A(n/k)}
\to0,
\qquad
s_{A,n}a_n
=
\frac{\sqrt{k}\,a_n}{\ell_n}
\to0.
$$

This conclusion uses the stricter DPS Weissman condition $\rho<0$. The DGS
population expansion alone allows $\rho=0$, but that broader case is not part
of the current least-action common-marginal route.

### Random terms: $A_n(\omega)$ versus $B_n(\nu)$

The audited $A_n(\omega)$ source statement gives, on log scale,

$$
A_n(\omega)
=
\ell_n\{\widehat\gamma_n(\omega)-\gamma\}
+o_P\left(\frac{\ell_n}{\sqrt{k}}\right),
$$

and therefore

$$
s_{A,n}A_n(\omega)
=
\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}
+o_P(1).
$$

The pooled Hill CLT supplies the non-degenerate stochastic order in the last
display.

For $B_n(\nu)$, the Taylor ledger gives

$$
B_n(\nu)
=
m(\gamma)\{\widehat\gamma_n(\nu)-\gamma\}
+O_P(k^{-1}).
$$

On the same benchmark scale,

$$
s_{A,n}B_n(\nu)
=
\frac{m(\gamma)}{\ell_n}
\sqrt{k}\{\widehat\gamma_n(\nu)-\gamma\}
+O_P\left(\frac{1}{\ell_n\sqrt{k}}\right)
=o_P(1),
$$

because $\ell_n\to\infty$. Thus the plug-in-$\psi$ stochastic term is lower
order than the Weissman extrapolation term on the pooled-quantile source
scale. If $m(\gamma)=0$, the conclusion is even stronger:

$$
s_{A,n}B_n(\nu)
=
O_P\left(\frac{1}{\ell_n\sqrt{k}}\right)
=o_P(1).
$$

The exceptional root of $m$ therefore remains visible in the algebra, but it
does not change the first-order order comparison whenever the $A_n(\omega)$
benchmark scale is the relevant scale.

### Population bridge term: $C_n$

The audited ledger is

$$
C_n
=
c(\gamma,\rho)a_n
+\alpha_\gamma\mu b_n
+r_{A,n}a_n
+r_{Q,n}b_n
+R_n^{log},
$$

where $r_{A,n}\to0$, $r_{Q,n}\to0$, and

$$
R_n^{log}
=
O\{(|a_n|+b_n)^2\}.
$$

The second-order tail bridge is automatically smaller than the $A_n(\omega)$
benchmark under the current DPS common-marginal assumptions:

$$
s_{A,n}c(\gamma,\rho)a_n\to0.
$$

The first-moment bridge is not decided by the DPS Weissman assumptions alone.
On the $A_n(\omega)$ benchmark scale,

$$
s_{A,n}\alpha_\gamma\mu b_n
=
\alpha_\gamma\mu\,\eta_n.
$$

Thus the next rate split is forced by the behaviour of

$$
\eta_n
=
\frac{\sqrt{k}}{\ell_n Q_0(1-p_n)}.
$$

No conclusion about the full decomposition should be made before this split is
recorded.

### Source-scale consequences by $\eta_n$ regime

The exact decomposition and the audited ledgers imply

$$
s_{A,n}\left(
  A_n(\omega)+B_n(\nu)-C_n
\right)
=
s_{A,n}A_n(\omega)
+o_P(1)
-s_{A,n}C_n.
$$

The $B_n(\nu)$ term has already been absorbed into $o_P(1)$ because
$s_{A,n}B_n(\nu)=o_P(1)$.

For $C_n$, the second-order bridge and its $r_{A,n}$ remainder are also already
absorbed:

$$
s_{A,n}c(\gamma,\rho)a_n\to0,
\qquad
s_{A,n}r_{A,n}a_n=o(1).
$$

The remaining pieces are

$$
s_{A,n}C_n
=
\alpha_\gamma\mu\,\eta_n
+r_{Q,n}\eta_n
+s_{A,n}R_n^{log}
+o(1),
$$

where the displayed $o(1)$ includes the second-order bridge pieces just noted.
The three relevant cases are therefore the following.

#### Case 1: $\eta_n\to0$

Then

$$
r_{Q,n}\eta_n=o(1),
$$

and, because $a_n\to0$, $b_n\to0$, $s_{A,n}a_n\to0$, and
$s_{A,n}b_n=\eta_n\to0$,

$$
s_{A,n}(|a_n|+b_n)^2\to0.
$$

Hence

$$
s_{A,n}C_n\to0.
$$

In this regime, the source-scale decomposition reduces to the pooled Weissman
component:

$$
s_{A,n}\left(
  A_n(\omega)+B_n(\nu)-C_n
\right)
=
s_{A,n}A_n(\omega)+o_P(1).
$$

This is the minimal-rate route if the thesis wants no retained deterministic
population-bridge shift on the pooled-Weissman source scale.

#### Case 2: $\eta_n\to\eta\in(0,\infty)$

The same remainder controls still hold:

$$
r_{Q,n}\eta_n=o(1),
\qquad
s_{A,n}(|a_n|+b_n)^2\to0.
$$

The first-moment bridge now survives:

$$
s_{A,n}C_n
\to
\alpha_\gamma\mu\,\eta.
$$

Because $C_n$ enters the exact decomposition with a minus sign, the
source-scale log estimator error has the same stochastic $A_n(\omega)$
component but a deterministic shift

$$
-\alpha_\gamma\mu\,\eta.
$$

This branch is mathematically visible from the decomposition. It is not the
same theorem design as the no-bridge-bias route: it changes the centring or
bias ledger, although the shift is deterministic and weight-independent.

If $\eta_n$ is bounded but does not converge, the same calculation gives

$$
s_{A,n}C_n
=
\alpha_\gamma\mu\,\eta_n+o(1).
$$

That supports only a sequence-centred statement or subsequential statements,
not a single uncentred weak limit.

#### Case 3: $\eta_n\to\infty$

On the uncentred pooled-Weissman source scale, the first-moment bridge is
larger than the source stochastic component unless $\alpha_\gamma\mu=0$:

$$
s_{A,n}\alpha_\gamma\mu b_n
=
\alpha_\gamma\mu\,\eta_n.
$$

The present DGS ledger is not enough to recover a centred source-scale CLT
after subtracting this deterministic sequence. Such a route would require at
least the extra conditions

$$
r_{Q,n}\eta_n\to0,
\qquad
s_{A,n}(|a_n|+b_n)^2\to0.
$$

Since the second display is equivalent, given $s_{A,n}a_n\to0$, to requiring

$$
\eta_n b_n\to0,
$$

the missing controls are not automatic from the currently cited source
statements.

There is also a bridge-dominated deterministic scale. Because
$s_{A,n}a_n\to0$ and $\eta_n\to\infty$ imply

$$
\frac{a_n}{b_n}
=
\frac{s_{A,n}a_n}{\eta_n}
\to0,
$$

we have, on the scale $b_n^{-1}=Q_0(1-p_n)$,

$$
b_n^{-1}A_n(\omega)=o_P(1),
\qquad
b_n^{-1}B_n(\nu)=o_P(1),
\qquad
b_n^{-1}C_n\to\alpha_\gamma\mu.
$$

Thus

$$
b_n^{-1}\left(
  A_n(\omega)+B_n(\nu)-C_n
\right)
\to
-\alpha_\gamma\mu
$$

deterministically, subject to the same common-marginal assumptions and
$\alpha_\gamma\mu$ being the leading bridge constant. This is not a useful
pooled-Weissman inference theorem, but it shows what the decomposition says
when the population bridge is allowed to dominate.

### Rate-audit summary

Relative to the pooled-Weissman benchmark $s_{A,n}=\sqrt{k}/\ell_n$:

| Piece | Scaled order before choosing $\eta_n$ | What the decomposition permits |
|---|---|---|
| $A_n(\omega)$ | $s_{A,n}A_n(\omega)=\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}+o_P(1)$ | Non-degenerate pooled-Weissman source component; this is where $\omega$ remains visible. |
| $B_n(\nu)$ | $s_{A,n}B_n(\nu)=o_P(1)$ | Plug-in $\psi$ cost is lower order on the $A_n(\omega)$ source scale for any deterministic admissible $\nu$. |
| $c(\gamma,\rho)A(1/p_n)$ in $C_n$ | $o(1)$ | Second-order expectile-quantile bridge is lower order under the DPS $\rho<0$ route. |
| $\alpha_\gamma\mu/Q_0(1-p_n)$ in $C_n$ | $\alpha_\gamma\mu\,\eta_n$ | This is the only audited first-order competitor to $A_n(\omega)$ on the source scale. |
| DGS $o(Q^{-1})$ remainder in $C_n$ | $r_{Q,n}\eta_n$ | Automatic if $\eta_n$ is bounded; needs extra control if $\eta_n\to\infty$. |
| $R_n^{log}$ | $O\{s_{A,n}(|a_n|+b_n)^2\}$ | Automatic if $\eta_n$ is bounded; if $\eta_n\to\infty$, a sufficient extra condition is $\eta_n b_n\to0$. |

The decomposition therefore leaves two source-scale theorem routes visible:

1. Impose $\eta_n\to0$ to retain only the pooled-Weissman source component.
2. Allow $\eta_n\to\eta\in(0,\infty)$ and carry the deterministic shift
   $-\alpha_\gamma\mu\eta$ in the log-error centring or bias ledger.

The first route is the leanest if the thesis wants to preserve the DPS
variance and AMSE criterion without adding an expectile-specific bridge-bias
term. The second route is available algebraically but changes the bias ledger.
The $\eta_n\to\infty$ route is not source-scale theorem-ready unless a sharper
DGS remainder statement or additional rate assumptions are deliberately
introduced.

## Checked deterministic two-weight theorem under $\eta_n\to0$

Status: checked research-layer theorem candidate. This is the theorem-shaped
statement to promote when the thesis leaves the Markdown audit layer. It is
not yet Chapter 4 prose.

### Statement

Work in the finite-$m$ iid/common-marginal distributed setting. Let the data
points within and across machines be iid from a common continuous
right-heavy-tailed distribution $F$ with tail quantile
$Q(1-1/t)=U(t)$ satisfying $C_2(\gamma,\rho,A)$, with
$0<\gamma<1$ and $\rho<0$. Assume $E|X^-|<\infty$ and $U(t)>0$ for all large
$t$. Set

$$
n=\sum_{j=1}^m n_j,
\qquad
k=\sum_{j=1}^m k_j.
$$

Let the sample and threshold sizes satisfy the proportionality conditions

$$
\frac{n_1}{n_j}\to b_j\in(0,\infty),
\qquad
\frac{k_1}{k_j}\to c_j\in(0,\infty),
$$

and assume the DPS common-marginal Hill and Weissman conditions

$$
k\to\infty,
\qquad
\frac{k}{n}\to0,
\qquad
\sqrt{k}A(n/k)\to\lambda\in\mathbb R.
$$

Let $p_n=1-\tau_n$ denote the target tail probability and set

$$
\ell_n=\log\frac{k}{np_n}.
$$

Assume the DPS Weissman extreme extrapolation regime

$$
p_n\to0,
\qquad
\frac{k}{np_n}\to\infty,
\qquad
\frac{\sqrt{k}}{\ell_n}\to\infty,
$$

and impose the additional expectile-bridge rate condition

$$
\eta_n
=
\frac{\sqrt{k}}{\ell_n Q(1-p_n)}
\to0.
$$

Let $\omega,\nu\in\mathbb R^m$ be deterministic and admissible, with
$\omega^\top\mathbf 1=1$ and $\nu^\top\mathbf 1=1$. Define

$$
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)
=
\psi(\widehat\gamma_n(\nu))\,
\widehat q_n^\star(\tau_n\mid\omega),
\qquad
\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}.
$$

Then, on log-relative scale,

$$
\frac{\sqrt{k}}{\ell_n}
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
\Rightarrow
N\left(
  B_\omega,
  V_\omega
\right),
$$

where

$$
B_\omega
=
\frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
\qquad
V_\omega
=
\gamma^2
\left(\sum_{j=1}^m\frac1{c_j}\right)
\left(\sum_{j=1}^m c_j\omega_j^2\right),
$$

with

$$
d_j
=
\frac{c_j}{b_j}\,
\frac{\sum_{i=1}^m c_i^{-1}}{\sum_{i=1}^m b_i^{-1}}.
$$

Since $\sqrt{k}/\ell_n\to\infty$, the log error is $o_P(1)$. Therefore the
same first-order limit also holds for relative error:

$$
\frac{\sqrt{k}}{\ell_n}
\left(
  \frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
       {\xi_{\tau_n}}-1
\right)
\Rightarrow
N(B_\omega,V_\omega).
$$

The first-order limit depends on the pooled-Weissman/geometric quantile
weights $\omega$ and not on the outer bridge-Hill weights $\nu$.

### Proof draft

Start from the exact identity

$$
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
=
A_n(\omega)+B_n(\nu)-C_n.
$$

For $A_n(\omega)$, DPS Corollary 8 in the published Bernoulli version gives the
common-marginal pooled Weissman source result. With

$$
x_n
=
\frac{\widehat q_n^\star(1-p_n\mid\omega)}{Q(1-p_n)}
-1,
$$

and deterministic $\omega$, that source result gives

$$
\frac{\sqrt{k}}{\ell_n}x_n
\Rightarrow
N(B_\omega,V_\omega).
$$

Thus $x_n=O_P(\ell_n/\sqrt{k})=o_P(1)$ because
$\sqrt{k}/\ell_n\to\infty$. Since

$$
\log(1+x_n)=x_n+O_P(x_n^2),
$$

we have

$$
\frac{\sqrt{k}}{\ell_n}
\{\log(1+x_n)-x_n\}
=
O_P\left(\frac{\ell_n}{\sqrt{k}}\right)
=o_P(1).
$$

Therefore

$$
\frac{\sqrt{k}}{\ell_n}A_n(\omega)
=
\frac{\sqrt{k}}{\ell_n}x_n+o_P(1)
\Rightarrow
N(B_\omega,V_\omega).
$$

Equivalently, this log conclusion may be read from the DPS supplement's direct
log expansion. The displayed Taylor step records the conversion needed if only
the published relative-error statement is cited.

For $B_n(\nu)$, the compact-event Taylor ledger gives

$$
B_n(\nu)
=
m(\gamma)\{\widehat\gamma_n(\nu)-\gamma\}
+O_P(k^{-1}),
$$

with $\widehat\gamma_n(\nu)-\gamma=O_P(k^{-1/2})$. Hence

$$
\frac{\sqrt{k}}{\ell_n}B_n(\nu)
=
\frac{m(\gamma)}{\ell_n}
\sqrt{k}\{\widehat\gamma_n(\nu)-\gamma\}
+O_P\left(\frac{1}{\ell_n\sqrt{k}}\right)
=o_P(1),
$$

because $\ell_n\to\infty$. If $m(\gamma)=0$, the same conclusion follows from
the quadratic remainder alone.

For $C_n$, write

$$
a_n=A(1/p_n),
\qquad
b_n=Q(1-p_n)^{-1},
\qquad
\alpha_\gamma=\gamma(\gamma^{-1}-1)^\gamma,
\qquad
\mu=EX.
$$

The DGS 2020 Proposition 1(i) ratio expansion plus the elementary log step
give the following log ledger. This is not quoted as a source log theorem; it
comes from applying $\log(1+\Delta_n)=\Delta_n+R_n^{log}$ to the sourced ratio
expansion:

$$
C_n
=
c(\gamma,\rho)a_n
+\alpha_\gamma\mu b_n
+r_{A,n}a_n
+r_{Q,n}b_n
+R_n^{log},
$$

where $r_{A,n}\to0$, $r_{Q,n}\to0$, and

$$
R_n^{log}
=
O\{(|a_n|+b_n)^2\}.
$$

The DPS condition $\rho<0$, regular variation of $A$, and
$k/(np_n)\to\infty$ imply

$$
\frac{\sqrt{k}}{\ell_n}a_n\to0.
$$

The imposed bridge-rate condition gives

$$
\frac{\sqrt{k}}{\ell_n}b_n=\eta_n\to0.
$$

Consequently,

$$
\frac{\sqrt{k}}{\ell_n}r_{A,n}a_n=o(1),
\qquad
\frac{\sqrt{k}}{\ell_n}r_{Q,n}b_n=r_{Q,n}\eta_n=o(1),
$$

and

$$
\frac{\sqrt{k}}{\ell_n}(|a_n|+b_n)^2\to0.
$$

Therefore

$$
\frac{\sqrt{k}}{\ell_n}C_n\to0.
$$

Combining the three displays gives

$$
\frac{\sqrt{k}}{\ell_n}
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
=
\frac{\sqrt{k}}{\ell_n}A_n(\omega)+o_P(1),
$$

and Slutsky's theorem gives the stated log-relative limit.

For the relative-error version, let

$$
L_n
=
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}.
$$

The log-limit gives $L_n=O_P(\ell_n/\sqrt{k})=o_P(1)$. Taylor's formula gives

$$
e^{L_n}-1=L_n+O_P(L_n^2),
$$

and hence

$$
\frac{\sqrt{k}}{\ell_n}
\left\{
  \left(
    \frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
         {\xi_{\tau_n}}-1
  \right)
  -L_n
\right\}
=
O_P\left(\frac{\ell_n}{\sqrt{k}}\right)
=o_P(1).
$$

The log-relative and relative-error limits are therefore identical.

### Design implication for the closed first-order layer

Under $\eta_n\to0$, the complete two-weight expectile estimator has the same
first-order source-scale bias and variance as the DPS pooled Weissman quantile
component. Therefore deterministic/oracle DPS variance and AMSE criteria can
only be imported for $\omega$. The bridge-Hill vector $\nu$ is
first-order unidentified by this theorem candidate. The diagonal estimator
$\nu=\omega$ remains available as a convention or special case, but the
first-order theorem does not select it.

## Structural design audit: two different weight roles

Status: checked notation and estimator-design audit for the two-weight pivot.
This section separates the weights that are structurally part of the DPS
pooled-Weissman estimator from the weights used only in the outer
expectile-bridge Hill estimator.

There are two different meanings of "Hill weights" in the current notation.

First, the pooled Weissman estimator itself is

$$
\widehat q_n^\star(1-p_n\mid\omega)
=
\prod_{j=1}^m
\left\{
  X_{n_j-k_j:n_j,j}
  \left(\frac{k_j}{n_jp_n}\right)^{\widehat\gamma_j(k_j)}
\right\}^{\omega_j}.
$$

Here the geometric quantile weights $\omega_j$ necessarily also weight the
local Hill errors inside the Weissman extrapolation. Indeed the exact ledger
contains

$$
A_n^{Hill}
=
\sum_{j=1}^m\omega_j\ell_{j,n}
  \{\widehat\gamma_j(k_j)-\gamma\}.
$$

This is not an extra assumption made by the expectile bridge; it is part of the
DPS pooled-Weissman estimator. If one wanted a different weight vector inside
the Weissman exponent while keeping geometric quantile weights $\omega$, that
would be a different estimator and DPS Corollary 8 would no longer apply
directly without a fresh source audit or proof.

Second, the diagonal Chapter 4 expectile estimator uses the same $\omega$ in
the outer bridge factor,

$$
\psi(\widehat\gamma_n(\omega))\,
\widehat q_n^\star(1-p_n\mid\omega).
$$

This same-weight choice is stronger than is needed for the current
$\eta_n\to0$ theorem. The active two-weight estimator and proof are stated once
in the preceding theorem-candidate section. This design audit records only the
interpretation: the existing one-weight notation implicitly sets
$\nu=\omega$, but this is a diagonal convention rather than a first-order
necessity for the outer $\psi$ plug-in.

Design implication: deterministic/oracle DPS variance and AMSE weights can only
be claimed for the pooled-Weissman/geometric quantile weights $\omega$. The
outer bridge-Hill weights $\nu$ are first-order unidentified by the current
theorem route; choosing or estimating them would be a separate, lower-order
design layer. The thesis should either state the deterministic two-weight
result, or explicitly label the diagonal estimator as the convention
$\nu=\omega$. It should not call $\nu$ variance- or AMSE-optimal on the basis
of this first-order route.

## Checked deterministic DPS weight criterion

Status: checked first-order weight-status layer. This section decides whether
the deterministic/oracle DPS weight criteria match the leading
pooled-Weissman/geometric quantile weights $\omega$ in the two-weight theorem
candidate. It does not choose $\nu$ and does not introduce estimated plug-in
weights, confidence intervals, or simulations.

### Source criterion in DPS

The generic pooling result in Daouia--Padoan--Stupfler Theorem 1, and its
supplementary Theorem A.1, is the source for the weight formulas. If

$$
\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}
\Rightarrow
N(\omega^\top B_c,\omega^\top V_c\omega),
\qquad
\omega^\top\mathbf 1=1,
$$

then the DPS variance criterion is

$$
\omega^\top V_c\omega,
$$

and the DPS AMSE criterion is

$$
(\omega^\top B_c)^2+\omega^\top V_c\omega.
$$

The unique variance-optimal weights, when $V_c$ is positive definite, are

$$
\omega^{Var}
=
\frac{V_c^{-1}\mathbf 1}{\mathbf 1^\top V_c^{-1}\mathbf 1}.
$$

The unique AMSE-optimal weights are

$$
\omega^{AMSE}
=
\frac{
  (1+B_c^\top V_c^{-1}B_c)V_c^{-1}\mathbf 1
  -
  (\mathbf 1^\top V_c^{-1}B_c)V_c^{-1}B_c
}{
  (1+B_c^\top V_c^{-1}B_c)(\mathbf 1^\top V_c^{-1}\mathbf 1)
  -
  (\mathbf 1^\top V_c^{-1}B_c)^2
}.
$$

These formulas are copied as source formulas only for deterministic/oracle
objects. The estimated-weight layer in DPS is separate and is not imported
here.

### Criterion implied by the two-weight theorem candidate

The two-weight theorem candidate gives, on the pooled-Weissman benchmark scale

$$
s_n=\frac{\sqrt{k}}{\ell_n},
$$

the limit

$$
s_n
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
\Rightarrow
N(B_\omega,V_\omega),
$$

where

$$
B_\omega
=
\frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
\qquad
V_\omega
=
\gamma^2
\left(\sum_{j=1}^m c_j^{-1}\right)
\left(\sum_{j=1}^m c_j\omega_j^2\right).
$$

Define the common-marginal DPS vectors

$$
B_c^{dist}
=
\frac{\lambda}{1-\rho}
\begin{pmatrix}
d_1^\rho\\
\vdots\\
d_m^\rho
\end{pmatrix},
\qquad
V_c^{dist}
=
\gamma^2
\left(\sum_{i=1}^m c_i^{-1}\right)
\operatorname{diag}(c_1,\ldots,c_m).
$$

Then

$$
B_\omega=\omega^\top B_c^{dist},
\qquad
V_\omega=\omega^\top V_c^{dist}\omega.
$$

This is exactly the bias and variance criterion in DPS Corollary 5 for the
pooled Hill estimator and DPS Corollary 8 for the common-marginal pooled
Weissman estimator. The match is for $\omega$ only.

For log-relative error,

$$
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
=
\frac{1}{s_n}Z_n(\omega),
\qquad
Z_n(\omega)\Rightarrow N(B_\omega,V_\omega).
$$

Therefore the first-order scaled MSE criterion is

$$
\operatorname{AMSE}_{log}(\omega)
=
B_\omega^2+V_\omega
=
(\omega^\top B_c^{dist})^2
+\omega^\top V_c^{dist}\omega.
$$

The unscaled log-error MSE only multiplies this by
$s_n^{-2}=\ell_n^2/k$, which is independent of $\omega$. The relative-error
version has the same first-order criterion because the theorem already proves
that log-relative and relative-error limits agree on the same scale.

Verdict: under the $\eta_n\to0$ route, the deterministic/oracle DPS variance
and AMSE objectives match exactly for $\omega$. There is no first-order
expectile-specific weight formula for $\omega$ to derive at this layer, and
there is no first-order criterion for $\nu$.

### Resulting deterministic/oracle formulas

For the iid/common-marginal independent distributed route, $V_c^{dist}$ is
diagonal and positive definite. The variance-optimal $\omega$ weights reduce to

$$
\omega_j^{Var}
=
\frac{c_j^{-1}}{\sum_{i=1}^m c_i^{-1}},
\qquad j=1,\ldots,m.
$$

Since $c_j=\lim k_1/k_j$, this is the limit of the deterministic finite-sample
allocation weights

$$
\widetilde\omega_{j,n}^{Var}
=
\frac{k_j}{k}.
$$

The AMSE-optimal deterministic/oracle $\omega$ weights are the DPS formula with
$B_c=B_c^{dist}$ and $V_c=V_c^{dist}$:

$$
\omega^{AMSE}
=
\frac{
  (1+(B_c^{dist})^\top (V_c^{dist})^{-1}B_c^{dist})
  (V_c^{dist})^{-1}\mathbf 1
  -
  (\mathbf 1^\top (V_c^{dist})^{-1}B_c^{dist})
  (V_c^{dist})^{-1}B_c^{dist}
}{
  (1+(B_c^{dist})^\top (V_c^{dist})^{-1}B_c^{dist})
  (\mathbf 1^\top (V_c^{dist})^{-1}\mathbf 1)
  -
  (\mathbf 1^\top (V_c^{dist})^{-1}B_c^{dist})^2
}.
$$

Two useful special cases:

- If $\lambda=0$, then $B_c^{dist}=0$ and AMSE-optimal weights equal
  variance-optimal weights.
- If the threshold fractions are asymptotically aligned so that
  $k_j/n_j=(k/n)(1+o(1))$, then $d_j\to1$, so $B_c^{dist}$ is proportional
  to $\mathbf 1$; under the affine constraint $\omega^\top\mathbf 1=1$, the
  bias is weight-independent and the AMSE-optimal weights again reduce to
  variance-optimal weights.

### What breaks in the parked bridge-shift branch

If the parked route $\eta_n\to\eta\in(0,\infty)$ were kept, the same
decomposition would give the shifted limit

$$
s_n
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
\Rightarrow
N(B_\omega-\kappa,V_\omega),
\qquad
\kappa=\gamma(\gamma^{-1}-1)^\gamma \mu\,\eta,
\qquad
\mu=\mathbb E X.
$$

The variance criterion would remain $V_\omega$, so the variance-optimal
weights would be unchanged. The AMSE criterion, however, would become

$$
(B_\omega-\kappa)^2+V_\omega,
$$

which is not the DPS criterion unless $\kappa=0$ or a degenerate cancellation
occurs. Algebraically, with

$$
M=V_c^{dist}+B_c^{dist}(B_c^{dist})^\top,
\qquad
a=\mathbf 1^\top M^{-1}\mathbf 1,
\qquad
b=\mathbf 1^\top M^{-1}B_c^{dist},
$$

the shifted-AMSE optimizer would solve

$$
\omega_\kappa
=
\frac{1-\kappa b}{a}M^{-1}\mathbf 1
+\kappa M^{-1}B_c^{dist}.
$$

At $\kappa=0$, this collapses to the DPS AMSE optimizer. For
$\kappa\ne0$, it is a different, expectile-specific formula. This is the main
reason the $\eta_n\to0$ theorem route is the only one that permits a clean DPS
AMSE-weight corollary for $\omega$.

### Weight-criterion conclusion

The deterministic/oracle weight layer is source-consistent under the current
two-weight $\eta_n\to0$ theorem candidate, but only for $\omega$:

1. variance-optimal $\omega$ weights import directly from DPS;
2. AMSE-optimal deterministic/oracle $\omega$ weights import directly from DPS
   because the bridge term is lower order under $\eta_n\to0$;
3. $\nu$ is first-order unidentified and has no variance/AMSE-optimal formula
   in this audit;
4. estimated plug-in $\omega$ weights are a separate transfer layer, checked
   next; plug-in standardisation is checked after that transfer layer, while
   simulations and lower-order $\nu$ choices remain separate after that.

## Source audit: estimated DPS weights and plug-in $\omega$ transfer

Status: checked first-order transfer corollary for random DPS
pooled-Weissman weights. This is not a new base theorem and it is not obtained
by informally inserting random weights into the deterministic proof. The source
input is that DPS already proves the pooled-Weissman theorem for affine random
weights $\widehat\omega_n\to_P\omega$. This section only opens the
$\omega$ role in $\widehat q_n^\star(\tau_n\mid\omega)$. The bridge-Hill
vector $\nu$ remains deterministic admissible and first-order unidentified. For
practical use with estimated optimal $\omega$, set
$\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)$. No estimated-$\nu$ or $\nu$-optimality
statement is made.

### DPS source statements for random weights

There are three distinct source inputs.

First, Daouia--Padoan--Stupfler Theorem A.1 in the supplement gives the
generic pooling principle for estimated weights. If
$\widehat\omega_n^\top\mathbf 1=1$ and
$\widehat\omega_n\to_P\omega$, then replacing $\omega$ by
$\widehat\omega_n$ changes the pooled estimator only by a lower-order term on
the source scale. In the Hill setting this gives

$$
\sqrt{k}
\{\widehat\gamma_n(\widehat\omega_n)
  -\widehat\gamma_n(\omega)\}
=o_P(1),
$$

and hence the same limit as the deterministic limiting weight $\omega$.

Second, DPS Theorem 2 and Corollary 8 already state the pooled Weissman result
with random weights. In the common-marginal distributed route, Corollary 8
assumes the conditions of Corollary 5, $\rho<0$, the Weissman extreme regime,
and weights satisfying

$$
\widehat\omega_n^\top\mathbf 1=1,
\qquad
\widehat\omega_n\to_P\omega.
$$

It then gives

$$
\frac{\sqrt{k}}{\ell_n}
\left(
  \frac{\widehat q_n^\star(1-p_n\mid\widehat\omega_n)}
       {q(1-p_n)}
  -1
\right)
\Rightarrow
N(B_\omega,V_\omega),
$$

with the same

$$
B_\omega
=
\frac{\lambda}{1-\rho}
\sum_{j=1}^m d_j^\rho\omega_j,
\qquad
V_\omega
=
\gamma^2
\left(\sum_{j=1}^m c_j^{-1}\right)
\left(\sum_{j=1}^m c_j\omega_j^2\right)
$$

as in the deterministic theorem candidate. Thus the random-weight
$A_n(\widehat\omega_n)$ term is source-covered directly; it does not need a
new expectile proof.

Third, DPS Section 2.2 and Corollary 1 give one route for constructing
estimated variance- and AMSE-optimal weights. They estimate the source bias and
covariance objects $B_c$ and $V_c$ by estimating the second-order parameters
and the tail-copula entries. The stated consistency assumptions include
$\rho_j<0$, the parametric second-order form
$A_j(t)=\gamma\beta_j t^{\rho_j}$, consistency of $\widehat\beta_j$, and

$$
(\widehat\rho_j-\rho_j)\log n_j=o_P(1).
$$

The supplement proof of Corollary 1 records the key conclusion:
$\widehat B_c\to_P B_c$, $\widehat V_c\to_P V_c$, and therefore
$\widehat\omega_n^{Var}\to_P\omega^{Var}$ and
$\widehat\omega_n^{AMSE}\to_P\omega^{AMSE}$. In the iid/common-marginal
distributed route, DPS Corollary 6 gives the variance-optimal allocation
weights

$$
\widetilde\omega_{j,n}^{Var}=\frac{k_j}{k},
$$

which are deterministic once the thresholds are chosen and converge to
$c_j^{-1}/\sum_i c_i^{-1}$. DPS Corollary 7 gives an AMSE plug-in route for
the distributed case under the common second-order form
$A(t)=\gamma\beta t^\rho$ and the same type of second-order estimator
consistency.

### Transfer theorem candidate for random $\omega$

Work in the same finite-$m$ iid/common-marginal route as the deterministic
two-weight theorem candidate. Keep all assumptions of the $\eta_n\to0$ theorem
candidate. Keep $\nu$ deterministic admissible; the downstream practical
choice is $\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)$. Let $\widehat\omega_n$ be any
DPS-admissible random pooled-Weissman weight vector such that

$$
\widehat\omega_n^\top\mathbf 1=1,
\qquad
\widehat\omega_n\to_P\omega.
$$

Define

$$
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)
=
\psi(\widehat\gamma_n(\nu))\,
\widehat q_n^\star(\tau_n\mid\widehat\omega_n).
$$

Then

$$
\frac{\sqrt{k}}{\ell_n}
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)}
     {\xi_{\tau_n}}
\Rightarrow
N(B_\omega,V_\omega).
$$

The same limit also holds on relative-error scale.

Proof. The exact identity remains

$$
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)}
     {\xi_{\tau_n}}
=
A_n(\widehat\omega_n)+B_n(\nu)-C_n.
$$

For $A_n(\widehat\omega_n)$, DPS Corollary 8 gives the random-weight relative
error result. With

$$
x_n(\widehat\omega_n)
=
\frac{\widehat q_n^\star(1-p_n\mid\widehat\omega_n)}
     {Q(1-p_n)}
-1,
$$

we have

$$
\frac{\sqrt{k}}{\ell_n}x_n(\widehat\omega_n)
\Rightarrow
N(B_\omega,V_\omega).
$$

Since $\sqrt{k}/\ell_n\to\infty$,
$x_n(\widehat\omega_n)=O_P(\ell_n/\sqrt{k})=o_P(1)$, and therefore

$$
\frac{\sqrt{k}}{\ell_n}
\left\{
  \log(1+x_n(\widehat\omega_n))-x_n(\widehat\omega_n)
\right\}
=
O_P\left(\frac{\ell_n}{\sqrt{k}}\right)
=o_P(1).
$$

Thus

$$
\frac{\sqrt{k}}{\ell_n}A_n(\widehat\omega_n)
\Rightarrow
N(B_\omega,V_\omega).
$$

The bridge-Hill term is unchanged because $\nu$ is deterministic. Corollary 5
gives $\widehat\gamma_n(\nu)-\gamma=O_P(k^{-1/2})$, so the compact-event
Taylor expansion gives

$$
\frac{\sqrt{k}}{\ell_n}B_n(\nu)=o_P(1).
$$

The population bridge term $C_n$ is also unchanged. The DGS ratio-to-log
ledger and the imposed condition

$$
\eta_n=\frac{\sqrt{k}}{\ell_n Q(1-p_n)}\to0
$$

give

$$
\frac{\sqrt{k}}{\ell_n}C_n\to0.
$$

Slutsky's theorem gives the log-relative limit. Since the log error is
$O_P(\ell_n/\sqrt{k})=o_P(1)$, the same exponential Taylor step used in the
deterministic theorem candidate gives the relative-error version.

### Which DPS estimated weights transfer

The transfer theorem applies to any DPS source-admissible
$\widehat\omega_n$ that converges to a deterministic affine vector. In
particular:

- the distributed variance allocation
  $\widetilde\omega_{j,n}^{Var}=k_j/k$ transfers as a deterministic triangular
  weight sequence, with limiting target
  $\omega_j^{Var}=c_j^{-1}/\sum_i c_i^{-1}$;
- the general estimated variance-optimal weights of DPS Section 2.2 and
  Corollary 1 transfer when the source assumptions give
  $\widehat\omega_n^{Var}\to_P\omega^{Var}$;
- the general estimated AMSE-optimal weights of DPS Section 2.2 and
  Corollary 1 transfer when the source assumptions give
  $\widehat\omega_n^{AMSE}\to_P\omega^{AMSE}$;
- the distributed AMSE plug-in weights of DPS Corollary 7 transfer under its
  additional common second-order parameter assumptions.

In every case, the transferred limit concerns $\omega$ only. It does not choose
$\nu$ by optimality; the practical convention is fixed separately as
$\nu=\nu_n^k$. If the thesis later fixes a random bridge-Hill convention, such
as $\nu=\widehat\omega_n$, that is a separate audit: one must recheck the
compact-event Taylor expansion for $B_n(\widehat\omega_n)$ and its order on
the pooled-Weissman scale. The present section deliberately keeps $\nu$
deterministic.

### Principled plug-in standardisation and interval inversion

Let

$$
s_n=\frac{\sqrt{k}}{\ell_n}.
$$

For the main practical route set

$$
\nu=\nu_n^k
=\left(\frac{k_1}{k},\ldots,\frac{k_m}{k}\right)
$$

and use a DPS-admissible selected pooled-Weissman weight
$\widehat\omega_n$, for instance an estimated variance-optimal or
AMSE-optimal DPS weight vector under the corresponding source assumptions.
Write

$$
\widehat\xi_{\tau_n}^{plug}
=
\widehat\xi_{\tau_n}^{pool,\star}(\nu_n^k,\widehat\omega_n).
$$

Suppose the same DPS source route supplies plug-in bias and variance objects,
evaluated at the selected $\widehat\omega_n$, such that

$$
\widehat B_{\widehat\omega,n}\to_P B_\omega,
\qquad
\widehat V_{\widehat\omega,n}\to_P V_\omega,
\qquad
V_\omega>0.
$$

In the common-marginal distributed notation above this is obtained, for
example, from DPS-consistent vector and matrix plug-ins through

$$
\widehat B_{\widehat\omega,n}
=
\widehat\omega_n^\top \widehat B_{c,n}^{dist},
\qquad
\widehat V_{\widehat\omega,n}
=
\widehat\omega_n^\top
  \widehat V_{c,n}^{dist}
  \widehat\omega_n,
$$

whenever
$\widehat B_{c,n}^{dist}\to_P B_c^{dist}$,
$\widehat V_{c,n}^{dist}\to_P V_c^{dist}$, and
$\widehat\omega_n\to_P\omega$. The general DPS Section 2.2 route is the
same statement with the corresponding $B_c$ and $V_c$ objects. In finite
dimension this is just the continuous mapping theorem; no expectile-specific
plug-in estimator is introduced.

Then

$$
T_n^{plug}
=
\frac{
  s_n
  \log\{
    \widehat\xi_{\tau_n}^{plug}/\xi_{\tau_n}
  \}
  -\widehat B_{\widehat\omega,n}
}{
  \sqrt{\widehat V_{\widehat\omega,n}}
}
\Rightarrow N(0,1).
$$

Proof. The transfer theorem gives

$$
s_n\log\{\widehat\xi_{\tau_n}^{plug}/\xi_{\tau_n}\}
\Rightarrow
N(B_\omega,V_\omega).
$$

The plug-in assumptions give
$\widehat B_{\widehat\omega,n}\to_P B_\omega$ and
$\widehat V_{\widehat\omega,n}\to_P V_\omega$. Since $V_\omega>0$,
$\widehat V_{\widehat\omega,n}>0$ with probability tending to one, and the
displayed standard normal limit follows by Slutsky's theorem. The additional
expectile pieces $B_n(\nu_n^k)$ and $C_n$ have already been shown to be
$o_P(s_n^{-1})$ under $\eta_n\to0$; all plug-in centring and variance objects
belong to the DPS pooled-Weissman component.

The resulting $(1-\alpha)$ log-scale plug-in interval is the inversion of
$|T_n^{plug}|\le z_{1-\alpha/2}$. On the high-probability event
$\widehat V_{\widehat\omega,n}>0$, define

$$
I_{n,1-\alpha}^{plug}
=
\biggl[
\widehat\xi_{\tau_n}^{plug}
\exp\biggl\{
-\frac{\ell_n}{\sqrt{k}}
\Bigl(
  \widehat B_{\widehat\omega,n}
  +z_{1-\alpha/2}\sqrt{\widehat V_{\widehat\omega,n}}
\Bigr)
\biggr\},
\,
\widehat\xi_{\tau_n}^{plug}
\exp\biggl\{
-\frac{\ell_n}{\sqrt{k}}
\Bigl(
  \widehat B_{\widehat\omega,n}
  -z_{1-\alpha/2}\sqrt{\widehat V_{\widehat\omega,n}}
\Bigr)
\biggr\}
\biggr].
$$

Then

$$
\Pr\{\xi_{\tau_n}\in I_{n,1-\alpha}^{plug}\}\to1-\alpha.
$$

This is not a direct import of the DPS Corollary 4 interval formula. DPS
Corollary 4 is a log-scale quantile interval under its own bias-negligible
testing setup. The expectile interval above is our inversion of the
source-transferred, plug-in-centred expectile statistic. The reason for using
the plug-in centring is principled: the first-order theorem allows
$B_\omega\ne0$, DPS supplies source-consistent estimates of the relevant
pooled-Weissman bias and variance objects, and the bridge terms are lower
order under $\eta_n\to0$.

This settles the mathematical first-order inference route in the Markdown
layer: use DPS plug-in centring and variance whenever the selected $\omega$
construction comes with the required source consistency. Thesis-prose
promotion, finite-sample implementation choices, and simulations remain later
steps; the bridge-Hill convention for the main practical route is fixed as
$\nu=\nu_n^k$.

### Transfer verdict

The estimated-$\omega$ transfer is source-consistent at first order under
$\eta_n\to0$. DPS already covers random pooled-Weissman weights
$\widehat\omega_n$ satisfying exact affine normalisation and convergence to a
deterministic $\omega$. The exact expectile decomposition then shows that the
additional plug-in-$\psi$ term with deterministic $\nu$ and the population
expectile--quantile bridge remain lower order. Consequently,

$$
\frac{\sqrt{k}}{\ell_n}
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)}
     {\xi_{\tau_n}}
\Rightarrow N(B_\omega,V_\omega)
$$

for every deterministic admissible $\nu$ and every source-admissible estimated
DPS weight vector $\widehat\omega_n\to_P\omega$.

The checked conclusion is deliberately narrow:

1. estimated DPS weights transfer for $\omega$ only;
2. $\nu$ remains deterministic and first-order unidentified; the downstream
   convention is $\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)$;
3. plug-in $B_\omega$ and $V_\omega$ objects transfer if the DPS source
   conditions give their consistency;
4. the plug-in standardisation and log-scale interval inversion are valid
   conditionally on those DPS plug-in consistency inputs; simulations and
   thesis-prose promotion remain separate.

## Closed source-check verdict for the first-order layer

This pass checks the deterministic two-weight theorem candidate against the
exact local source statements and then checks the source-admissible
estimated-$\omega$ transfer. The conservative $\eta_n\to0$ route survives
these checks, with the following details to keep attached when Chapter 4 is
revised:

| Item | Source-check verdict |
|---|---|
| DPS common-marginal input | Corollary 8 in the published Bernoulli version is the right headline source. It is stated under Corollary 5's iid distributed setup, with common continuous right-heavy-tailed distribution satisfying $C_2(\gamma,\rho,A)$, aggregate $n=\sum_j n_j$, aggregate $k=\sum_j k_j$, $k/n\to0$, $\sqrt{k}A(n/k)\to\lambda$, $\rho<0$, $p\to0$, $k/(np)\to\infty$, and $\sqrt{k}/\log\{k/(np)\}\to\infty$. |
| DPS constants | The two-weight theorem candidate's $B_\omega$, $V_\omega$, and $d_j=(c_j/b_j)(\sum_i c_i^{-1})/(\sum_i b_i^{-1})$ match Corollaries 5 and 8. Deterministic $\omega$ weights are obtained by taking $\widehat\omega_n=\omega$ in the source statement. |
| Relative-to-log step for $A_n(\omega)$ | Corollary 8 is relative-error scale. Since the source regime gives $\ell_n/\sqrt{k}\to0$, the relative error is $o_P(1)$ and $\log(1+x_n)=x_n+O_P(x_n^2)$ yields the displayed log-scale limit. The supplement proof of Theorem 2 gives the same conclusion directly on log scale. |
| Positivity/log convention | DPS works with Hill and log-Weissman expressions. The thesis theorem should state or inherit eventual upper-tail positivity, $U(t)>0$ for large $t$, so the high order statistics and Weissman estimators are positive with probability tending to one. |
| $B_n(\nu)$ plug-in cost | Corollary 5 gives $\widehat\gamma_n(\nu)-\gamma=O_P(k^{-1/2})$ and consistency for any deterministic admissible $\nu$. The compact-event Taylor expansion of $g=\log\psi$ is elementary and valid because $0<\gamma<1$; on the pooled-Weissman scale it is $o_P(1)$ because $\ell_n\to\infty$. |
| DGS bridge input | DGS 2020 Proposition 1(i) assumes $E|X^-|<\infty$, $0<\gamma<1$, and $C_2(\gamma,\rho,A)$ with $\rho\le0$. It gives a ratio expansion for $\xi_\tau/Q(\tau)$, not a log expansion, and it explicitly removes the older strict-monotonicity requirement. The DPS route imposes the stricter $\rho<0$ separately. |
| Ratio-to-log step for $C_n$ | After setting $\Delta_n=\xi_{\tau_n}/\{\psi(\gamma)Q(1-p_n)\}-1$, DGS gives $\Delta_n=c(\gamma,\rho)A(1/p_n)+\gamma(\gamma^{-1}-1)^\gamma EX/Q(1-p_n)+o(|A(1/p_n)|)+o(Q(1-p_n)^{-1})$. Since $\Delta_n\to0$, $C_n=\log(1+\Delta_n)=\Delta_n+O(\Delta_n^2)$. |
| Rate comparison | Under $\rho<0$, $\sqrt{k}A(n/k)=O(1)$, and $k/(np_n)\to\infty$, regular variation gives $(\sqrt{k}/\ell_n)A(1/p_n)\to0$. The extra condition $\eta_n=\sqrt{k}/\{\ell_n Q(1-p_n)\}\to0$ removes the first-moment bridge and also controls the DGS $o(Q^{-1})$ and log-square remainders. |
| Estimated $\omega$ transfer | DPS Theorem A.1, Theorem 2, and Corollary 8 already allow random affine weights $\widehat\omega_n\to_P\omega$ in the pooled Hill and pooled Weissman components. The exact expectile decomposition adds only $B_n(\nu)=o_P(\ell_n/\sqrt{k})$ and $C_n=o(\ell_n/\sqrt{k})$ under $\eta_n\to0$, so the same first-order limit transfers to $\widehat\xi_{\tau_n}^{pool,\star}(\nu,\widehat\omega_n)$ for deterministic admissible $\nu$. |
| Plug-in standardisation | If the selected DPS source route gives $\widehat B_{\widehat\omega,n}\to_P B_\omega$ and $\widehat V_{\widehat\omega,n}\to_P V_\omega$ with $V_\omega>0$, then Slutsky gives the studentised expectile statistic. Inverting that log-scale statistic gives the multiplicative plug-in interval recorded above. This is not a direct import of the DPS Corollary 4 interval formula; it is the inversion of the transferred expectile CLT. |

Closed verdict for the current first-order Markdown layer: no source-level
contradiction was found in the deterministic two-weight route or in the
source-admissible estimated-$\omega$ transfer. The theorem candidate gives the
first-order limit $N(B_\omega,V_\omega)$ for every deterministic admissible
$\nu$, so $\nu$ is first-order unidentified. Deterministic/oracle DPS weight
criteria match under $\eta_n\to0$ for $\omega$ only, and DPS estimated weights
transfer for $\omega$ when the source consistency conditions hold. The
plug-in centring and variance route is mathematically closed conditionally on
the corresponding DPS consistency inputs. Broader tail-homoskedastic targets,
simulations, and any lower-order criterion for $\nu$ remain parked until each
layer is checked separately.

## Parked obligations after first-order closure

The deterministic two-weight, $\eta_n\to0$, first-order audit is closed in
Markdown. The items below are thesis-translation choices or future research
layers; they are not blockers for the current first-order result.

1. The current Chapter 4 diagonal theorem specifies the common-marginal target
   population.
   A broader theorem under only tail homoskedasticity would still need an
   additional target-selection argument for expectiles, not just quantiles.

2. $A_n(\omega)$ is now validated against Daouia--Padoan--Stupfler for the
   finite-$m$ iid/common-marginal route. Chapter 4 should keep Corollary 8 in
   the published Bernoulli version as the headline common-marginal source, or
   cite Theorem 2 plus the supplement proof if the chapter later needs the
   broader tail-homoskedastic or direct log-expansion route.

3. For $A_n^{thr}$ and $A_n^{tail}$, decide whether to cite the DPS supplement
   proof of Theorem 2 as a package, or to reproduce the two component controls
   from standard EVT inputs.

4. $B_n(\nu)$ is now validated as a compact-event Taylor expansion:
   $B_n(\nu)=m(\gamma)\{\widehat\gamma_n(\nu)-\gamma\}+O_P(k^{-1})$, with the
   exceptional case $m(\gamma)=0$ visible. The order comparison above shows
   that $B_n(\nu)$ is lower order on the pooled-Weissman benchmark scale for
   every deterministic admissible $\nu$ because $\ell_n\to\infty$.

5. $C_n$ is now validated as a source-grounded ratio-to-log ledger in the
   common-marginal setting. The order comparison above checks
   $A(1/p_n)$, $Q(1-p_n)^{-1}$, the DGS remainder, and the square-order
   log-conversion remainder.

6. Keep the checked source conventions attached to Chapter 4 and to any
   corollary: common continuous iid data, aggregate $n=\sum_j n_j$ and
   $k=\sum_j k_j$, $U(t)>0$ eventually for log expressions, and DGS's quantile
   convention, which does not require the old strict monotonicity assumption.

7. The order comparison above shows that, on the pooled-Weissman benchmark
   scale, $B_n(\nu)$ and the second-order $A(1/p_n)$ bridge are lower order,
   while the first-moment bridge is governed by
   $\eta_n=\sqrt{k}/\{\ell_n Q_0(1-p_n)\}$. The theorem-design fork is now
   explicit: $\eta_n\to0$ gives no retained population-bridge shift;
   $\eta_n\to\eta\in(0,\infty)$ retains the deterministic shift
   $-\alpha_\gamma\mu\eta$; and $\eta_n\to\infty$ needs sharper remainder
   control or a different, bridge-dominated interpretation.

8. The deterministic/oracle weight criterion check is now recorded above.
   Under $\eta_n\to0$, the DPS variance and AMSE objectives match exactly for
   $\omega$ only. The note does not choose $\nu$; a lower-order AMSE theory
   would be a separate project.

9. When Filippo decides to leave the Markdown research layer, the next thesis
   prose move is to revise Chapter 4 from the diagonal theorem to the
   deterministic two-weight theorem, or to state explicitly that the diagonal
   estimator is a convention $\nu=\omega$.

10. Estimated plug-in $\omega$ weights are now checked at first order through
    the DPS transfer route above. The plug-in centring and variance convention
    is also fixed conditionally on DPS consistency, giving the log-scale
    multiplicative interval in the standardisation section. Simulations and
    finite-sample implementation choices remain separate. The bridge-Hill
    $\nu$ convention is fixed as $\nu_n^k=(k_1/k,\ldots,k_m/k)$.

## Default next research decision

Do not open a lower-order optimality theory for $\nu$ by default. The current
least-action stopping point has a deterministic theorem, an optional
source-admissible transfer corollary, and a source-conditional plug-in
inference corollary.

Base deterministic theorem:

$$
\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega),
\quad
\nu^\top\mathbf 1=1,
\quad
\omega^\top\mathbf 1=1,
\quad
\nu,\omega\text{ deterministic},
\qquad
\eta_n\to0,
\qquad
\frac{\sqrt{k}}{\ell_n}
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu,\omega)}
     {\xi_{\tau_n}}
\Rightarrow N(B_\omega,V_\omega).
$$

Optional estimated-$\omega$ transfer corollary:

$$
\widehat\xi_{\tau_n}^{pool,\star}(\nu_n^k,\widehat\omega_n),
\quad
\nu_n^k=\left(\frac{k_1}{k},\ldots,\frac{k_m}{k}\right),
\quad
\widehat\omega_n^\top\mathbf 1=1,
\quad
\widehat\omega_n\to_P\omega,
\qquad
\eta_n\to0,
\qquad
\frac{\sqrt{k}}{\ell_n}
\log
\frac{\widehat\xi_{\tau_n}^{pool,\star}(\nu_n^k,\widehat\omega_n)}
     {\xi_{\tau_n}}
\Rightarrow N(B_\omega,V_\omega).
$$

Conditional plug-in inference corollary:

$$
\frac{
  \frac{\sqrt{k}}{\ell_n}
  \log
  \frac{\widehat\xi_{\tau_n}^{pool,\star}
        (\nu_n^k,\widehat\omega_n)}
       {\xi_{\tau_n}}
  -\widehat B_{\widehat\omega,n}
}{
  \sqrt{\widehat V_{\widehat\omega,n}}
}
\Rightarrow N(0,1),
\qquad
\widehat B_{\widehat\omega,n}\to_P B_\omega,
\quad
\widehat V_{\widehat\omega,n}\to_P V_\omega,
\quad
V_\omega>0.
$$

At this stopping point, $\omega$ is the only first-order optimisable weight
vector, and it may be deterministic/oracle or estimated through DPS under the
source consistency conditions. When the selected DPS route provides consistent
plug-in bias and variance objects, the corresponding log-scale multiplicative
interval is the principled inference object. The base theorem remains valid for
any deterministic admissible $\nu$, but the main practical route now fixes
$\nu=\nu_n^k=(k_1/k,\ldots,k_m/k)$ so that estimated optimal $\omega$ can be
used without making the bridge-Hill weights random. The diagonal
$\nu=\omega$ remains only a deterministic prototype/special case when
$\omega$ is deterministic. Any claim that one choice of $\nu$ is optimal
requires a new audit with a sharper scale, joint expansion, cross-covariance
control, and remainder bounds beyond this note.
