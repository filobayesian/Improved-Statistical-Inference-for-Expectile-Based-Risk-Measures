# Source audit: pooled extreme-expectile decomposition

Status: scratch research note, not theorem prose. This note records source
statements for the exact decomposition in Chapter 4 and lists the remaining
proof obligations. It intentionally does not choose a final normalisation,
state weights, construct intervals, or propose a simulation design.

## Object and exact identity

The working estimator is

$$
\widehat\xi_{\tau_n}^{pool,\star}
=
\psi(\widehat\gamma_n(\omega))\,
\widehat q_n^\star(\tau_n\mid\omega),
\qquad
\psi(\gamma)=(\gamma^{-1}-1)^{-\gamma}.
$$

To match the notation of Daouia--Padoan--Stupfler's Weissman theorem, set
$p_n = 1-\tau_n$ only as a source-audit translation. Then
$\widehat q_n^\star(\tau_n\mid\omega)$ corresponds to their
$\widehat q_n^\star(1-p_n\mid\omega)$.

The load-bearing identity is

$$
\log\frac{\widehat\xi_{\tau_n}^{pool,\star}}{\xi_{\tau_n}}
= A_n+B_n-C_n,
$$

where

$$
A_n =
\log\frac{\widehat q_n^\star(\tau_n\mid\omega)}{Q(\tau_n)},
$$

$$
B_n =
\log\psi(\widehat\gamma_n(\omega))-\log\psi(\gamma),
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

## Checked source statements

| Term | Source | What the source gives | Important caveat |
|---|---|---|---|
| $A_n$ | Daouia--Padoan--Stupfler, *Optimal weighted pooling for inference about the tail index and extreme quantiles*, Theorem 2, Section 2.3. Local file: `papers/Optimal Pooling.pdf`. | General finite-$m$ pooled weighted-geometric Weissman CLT for relative error. | Main statement is for relative error, not log-relative error. The pooled-quantile part also needs tail homoskedasticity $(H)$ if the margins are not literally common. |
| $A_n$ common-marginal specialisation | Same paper, Corollary 9, Section 3.3. | Common-marginal distributed version of the same relative-error CLT, with simplified bias and variance. | This is the cleanest source statement for the iid/common-marginal route. It still uses the Weissman source normalisation only for the quantile component. |
| $A_n$ log conversion | Same paper, supplement, proof of Theorem 2; Lemma B.2. Local file: `papers/optimal pooling supp.pdf`. | Shows the log Weissman error equals the dominant Hill term plus a lower-order log remainder. | This is a proof ingredient, not the headline theorem statement. In the common-marginal case the target-alignment term is exactly zero, so Lemma B.2 is only needed for the broader $(H)$ route. |
| $B_n$ | Daouia--Padoan--Stupfler, Theorem 1, Section 2.1. | Joint CLT for marginal Hill estimators and pooled Hill CLT under common $\gamma$. | Passing through $\log\psi$ is our Taylor step. |
| $C_n$ first order | Bellini et al. (2014), and Daouia--Girard--Stupfler (2019), Corollary 1 with $p=2$. Local file for DGS 2019: `papers/DGS2019.pdf`. | $\xi_\tau/Q(\tau) \to \psi(\gamma)$ for $0<\gamma<1$ with finite lower-tail first moment. | First order only; no rate for $C_n$. |
| $C_n$ second order | Daouia--Girard--Stupfler, *Tail expectile process and risk assessment*, Proposition 1(i). Local file: `papers/DGS2020.pdf`. | Ratio expansion for $\xi_\tau/Q(\tau)$ with second-order term and first-moment term. | It is a ratio expansion, not a log expansion. Logging requires a Taylor remainder check. |
| Context only | Daouia--Girard--Stupfler (2018), Corollaries 3-4; Davison--Padoan--Stupfler (2023), Theorem 3.5. Local files: `papers/Daouia-Estimationtailrisk-2018.pdf`, `papers/Tail Risk Inference via Expectiles in Heavy-Tailed Time Series.pdf`. | Full extrapolated expectile CLTs in single-sample/time-series settings. | Do not import these as the pooled theorem; use only as consistency checks for notation and rates. |

## Term 1: $A_n$, pooled Weissman error

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

For the first thesis theorem with deterministic weights, set
$\widehat\omega_n=\omega$. The displayed source normalisation is the
normalisation for the pooled Weissman quantile component only; it is not yet a
normalisation for the full expectile decomposition $A_n+B_n-C_n$.

The theorem also contains a local Weissman statement, without geometrically
pooling the quantile estimators, with $\ell_{j,n}$ in place of $\ell_n$. That
local statement is useful background but is not the object currently targeted
in Chapter 4.

### Source theorem: iid/common-marginal route

Section 3 of Daouia--Padoan--Stupfler specialises the framework to distributed
inference with all observations iid from a common distribution satisfying
$C_2(\gamma,\rho,A)$. Corollary 9 gives, under the conditions of Corollary 5 and
the extra Weissman conditions listed below,

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

For the finite-$m$ iid/common-marginal Corollary 9 route, this simplifies to:

- iid observations across and within machines, with common distribution
  satisfying $C_2(\gamma,\rho,A)$.
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

The main theorem and Corollary 9 are stated for relative error. Since
$A_n$ is a log-relative error, there are two validated source-grounded routes.

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
9.

Second, one may convert the headline relative-error theorem to log scale. The
source regime $\sqrt{k}/\ell_n\to\infty$ implies
$\ell_n/\sqrt{k}\to0$, so the relative error in Theorem 2 or Corollary 9 is
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
more aligned with the exact $A_n$ ledger; the relative-error route is shorter
if Chapter 4 only needs the marginal conclusion for $A_n$.

### Validation status for $A_n$

For the finite-$m$ iid/common-marginal setting, point 1 is validated as follows:

| Question | Answer for $A_n$ |
|---|---|
| Exact source statement | Use Daouia--Padoan--Stupfler Corollary 9 for the common-marginal distributed route; use Theorem 2 for the broader tail-homoskedastic route. |
| Source normalisation | $\sqrt{k}/\ell_n$ with $\ell_n=\log(k/(np))$, for the pooled Weissman quantile component. |
| Relative or log scale? | Headline source statement is relative error. The supplement proof gives a direct log expansion, and the source regime also permits a Taylor conversion from relative to log error. |
| Common-marginal target issue | No issue: $A_n^{target}=0$ exactly because $q_j=q=Q$. |
| Still not decided | Whether the final expectile theorem uses the same normalisation must wait until $B_n$ and $C_n$ are compared with $A_n$. |

## Term 2: $B_n$, the cost of estimating $\gamma$ inside $\psi$

### Source theorem

Daouia--Padoan--Stupfler Theorem 1 gives the general finite-$m$ pooled Hill
input. Under the marginal second-order conditions $C_2(\gamma_j,\rho_j,A_j)$,
the tail-copula condition $J(R)$, proportional sample and threshold sizes
$n_1/n_j\to b_j\in(0,\infty)$ and $k_1/k_j\to c_j\in(0,\infty)$, and the
Hill-bias calibration $\sqrt{k_j}A_j(n_j/k_j)\to\lambda_j$, their theorem
first gives the joint CLT for the marginal Hill estimators. Under the common
tail-index condition $\gamma_1=\cdots=\gamma_m=\gamma$, it then implies, for
any deterministic weight vector satisfying $\omega^\top1=1$,

$$
\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}
\Rightarrow
N(\omega^\top B_c,\omega^\top V_c\omega).
$$

This is the source statement for the random input to $B_n$. It does not require
the extra Weissman conditions: no tail homoskedasticity $(H)$, no strict
$\rho_j<0$ requirement beyond what is needed for the relevant bias calibration,
and no extreme-level $p$-regime. In the iid/common-marginal distributed route,
Daouia--Padoan--Stupfler Corollary 5 is the direct specialisation:

$$
\sqrt{k}\{\widehat\gamma_n(\omega)-\gamma\}
\Rightarrow
N\left(
  \frac{\lambda}{1-\rho}\sum_{j=1}^m d_j^\rho\omega_j,
  \gamma^2
  \left(\sum_{j=1}^m\frac1{c_j}\right)
  \left(\sum_{j=1}^m c_j\omega_j^2\right)
\right),
$$

with $d_j$ as in the $A_n$ audit. This common-marginal version is the cleanest
source for the first thesis route. Theorem 1 or Corollary 5 also gives

$$
\widehat\gamma_n(\omega)-\gamma=O_P(k^{-1/2})
\quad\text{and}\quad
\widehat\gamma_n(\omega)\xrightarrow{P}\gamma.
$$

### Compactness Inside $(0,1)$

For expectiles, the bridge requires $0<\gamma<1$. If the pooled estimator is
formed with fixed weights satisfying $\omega^\top 1=1$, consistency of the
local Hill estimators gives

$$
\widehat\gamma_n(\omega)\xrightarrow{P} \gamma.
$$

Thus, for any

$$
0<\varepsilon<\min(\gamma,1-\gamma),
$$

the event

$$
\widehat\gamma_n(\omega)\in[\gamma-\varepsilon,\gamma+\varepsilon]
\subset(0,1)
$$

has probability tending to one. The same argument works for estimated weights
if they are exactly normalised and converge to a deterministic admissible
weight vector, as in the source theorem.

Equivalently, with

$$
E_{n,\varepsilon}
=\left\{
  |\widehat\gamma_n(\omega)-\gamma|\le\varepsilon
 \right\},
$$

we have $P(E_{n,\varepsilon})\to1$ and, on this event, the whole line segment
between $\gamma$ and $\widehat\gamma_n(\omega)$ lies in the compact interval
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
B_n
=
m(\gamma)\{\widehat\gamma_n(\omega)-\gamma\}
+
R_n^\psi,
$$

where the Taylor remainder satisfies the explicit bound

$$
|R_n^\psi|
\le
\frac12 M_\varepsilon
\{\widehat\gamma_n(\omega)-\gamma\}^2.
$$

Together with the pooled Hill CLT,

$$
R_n^\psi=O_P(k^{-1}),
\qquad
B_n
=
m(\gamma)\{\widehat\gamma_n(\omega)-\gamma\}
+O_P(k^{-1}).
$$

This records only the intrinsic order of the $B_n$ pieces. It does not choose a
normalisation for the full sum $A_n+B_n-C_n$.

Special caution: $m(\gamma)$ vanishes near $\gamma=0.2178$. If the final
theorem includes a first-order contribution from $B_n$, that root may require
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
second-order population expansion. Under $E|Y^-|<\infty$,
$C_2(\gamma,\rho,A)$, and $0<\gamma<1$,

$$
\frac{\xi_\tau}{Q(\tau)}
=
\psi(\gamma)
\left[
  1
  + c(\gamma,\rho) A((1-\tau)^{-1})
  + \gamma(\gamma^{-1}-1)^\gamma
    \frac{E Y}{Q(\tau)}
  + o(A((1-\tau)^{-1}))
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

This source statement is a ratio expansion. It implies that

$$
C_n
=
\log(1+\Delta_{\tau_n}),
$$

with

$$
\Delta_{\tau}
=
c(\gamma,\rho) A((1-\tau)^{-1})
+
\gamma(\gamma^{-1}-1)^\gamma \frac{E Y}{Q(\tau)}
+
o(A((1-\tau)^{-1}))
+
o(Q(\tau)^{-1}).
$$

Since $A(t)\to0$ and $Q(\tau)\to\infty$, $\Delta_\tau\to0$; hence the log is
well-defined eventually. The thesis proof still has to check the Taylor
remainder

$$
\log(1+\Delta_{\tau_n})-\Delta_{\tau_n}
=O(\Delta_{\tau_n}^2)
$$

against the final scale. This note does not decide whether $C_n$ contributes
or vanishes.

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

Let $Q_0(1-p_n)$ denote the population target used in $A_n$. In the
iid/common-marginal route, $Q_0=Q_j$ for every $j$. In the more general
tail-homoskedastic route, $Q_0$ must be chosen explicitly, for example as one
fixed marginal target. All displays below use only the affine weight
constraint $\sum_j\omega_j=1$.

### $A_n$: exact pooled-Weissman log ledger

Starting from the definition of the geometric pooled Weissman estimator,

$$
A_n
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
A_n
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
| $A_n^{Hill}$ | Daouia--Padoan--Stupfler Theorem 1 and the proof of Theorem 2. | The common-log pooled-Hill piece is the source-dominant part for $A_n$ under the Weissman source normalisation. The local-log correction is lower order because $\ell_{j,n}/\ell_n\to1$ and $\sqrt{k_j}(\widehat\gamma_j-\gamma)=O_P(1)$. |
| $A_n^{thr}$ | Intermediate order-statistic expansion used in the supplement proof of Theorem 2. | Controlled as part of the supplement's $O_P(k^{-1/2})$ log remainder when $m$ is fixed and $k_j/k$ has positive limits. |
| $A_n^{tail}$ | Second-order regular variation $C_2$ and supplement Lemma B.2/proof of Theorem 2. | The deterministic tail approximation is controlled by $\rho<0$, $k/(np)\to\infty$, and $\sqrt{k}A(n/k)=O(1)$ in the common-marginal route. It can be cited through Corollary 9/supplement unless Chapter 4 needs the component proof reproduced. |
| $A_n^{target}$ | Tail homoskedasticity $(H)$ and supplement Lemma B.2 for the broad route. | Exactly zero in the iid/common-marginal route. Under only $(H)$, Lemma B.2 gives the required marginal log-quantile alignment. |

### $B_n$: exact Taylor ledger

Let

$$
g(x)=\log\psi(x)=-x\log(x^{-1}-1),
\qquad
\overline\gamma_n=\widehat\gamma_n(\omega).
$$

The exact term is

$$
B_n=g(\overline\gamma_n)-g(\gamma).
$$

For any $0<\varepsilon<\min(\gamma,1-\gamma)$, define

$$
E_{n,\varepsilon}
=\{|\overline\gamma_n-\gamma|\le\varepsilon\},
\qquad
K_\varepsilon=[\gamma-\varepsilon,\gamma+\varepsilon].
$$

The pooled Hill CLT gives $P(E_{n,\varepsilon})\to1$, and
$K_\varepsilon$ is a compact subset of $(0,1)$. On $E_{n,\varepsilon}$,
Taylor's formula gives

$$
B_n
=
m(\gamma)(\overline\gamma_n-\gamma)
+
R_n^\psi,
$$

where

$$
m(x)=g'(x)=\frac{1}{1-x}-\log(x^{-1}-1),
$$

and, for some intermediate value $\widetilde\gamma_n$ between $\gamma$ and
$\overline\gamma_n$,

$$
R_n^\psi
=
\frac12 m'(\widetilde\gamma_n)
  (\overline\gamma_n-\gamma)^2,
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
\frac12 M_\varepsilon(\overline\gamma_n-\gamma)^2.
$$

The same pooled Hill CLT gives

$$
\overline\gamma_n-\gamma=O_P(k^{-1/2}),
\qquad
R_n^\psi=O_P(k^{-1}).
$$

Thus the validated ledger for $B_n$ is

$$
B_n
=
m(\gamma)(\overline\gamma_n-\gamma)
+O_P(k^{-1}).
$$

If $m(\gamma)=0$, the linear part vanishes and this ledger only records
$B_n=O_P(k^{-1})$. Whether that exceptional case matters depends on the later
order comparison with $A_n$ and $C_n$.

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
asymptotic ledger for $\Delta_n$. With

$$
d(\gamma)=\gamma(\gamma^{-1}-1)^\gamma,
\qquad
\mu=E X,
$$

write

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
d(\gamma)\frac{\mu}{Q_0(1-p_n)},
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

No conclusion is made here about which of these pieces matters. The ledger only
separates the second-order tail term, the first-moment term, the DGS remainder,
and the new log-conversion remainder.

## Open proof obligations

1. Specify the target population before the theorem. The cleanest route is the
   iid/common-marginal distributed setting. A theorem under only tail
   homoskedasticity needs an additional target-selection argument for
   expectiles, not just quantiles.

2. $A_n$ is now validated against Daouia--Padoan--Stupfler for the
   finite-$m$ iid/common-marginal route. Before theorem prose, decide whether
   Chapter 4 cites Corollary 9 directly or cites Theorem 2 plus the supplement
   proof, and keep the broader tail-homoskedastic route separate.

3. For $A_n^{thr}$ and $A_n^{tail}$, decide whether to cite the DPS supplement
   proof of Theorem 2 as a package, or to reproduce the two component controls
   from standard EVT inputs.

4. $B_n$ is now validated as a compact-event Taylor expansion:
   $B_n=m(\gamma)\{\widehat\gamma_n(\omega)-\gamma\}+O_P(k^{-1})$, with the
   exceptional case $m(\gamma)=0$ visible. Do not infer its importance before
   the later scale comparison.

5. For $C_n$, confirm the DGS 2020 assumptions in the exact thesis setting and
   prove the log conversion by controlling $R_n^{log}$ after the relevant scale
   has been identified.

6. Only after the $C_n$ ledger has also been validated should the note compare
   orders and propose a normalisation for $A_n+B_n-C_n$.

7. Do not import Daouia--Padoan--Stupfler weights until the final theorem has
   identified the variance or AMSE criterion for the complete sum
   $A_n+B_n-C_n$.

8. Do not edit Chapter 4 into theorem prose until these obligations are
   resolved.
