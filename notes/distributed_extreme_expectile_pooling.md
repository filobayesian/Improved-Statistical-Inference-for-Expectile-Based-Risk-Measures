# Distributed Inference for Extreme Expectiles of Heavy-Tailed Data: Optimal Pooling of Hill and Quantile Statistics

**Setting.** Distributed (one-shot, communication-constrained) inference with a *fixed* number $m$ of machines holding independent and identically distributed data, as in Section 3 of Daouia, Padoan and Stupfler (2024) — hereafter **DPS**. Each machine communicates the statistics prescribed by the DPS heuristics: its subsample size, its effective sample size, its Hill estimator and its intermediate order statistic (plus, optionally, estimators of the second-order parameters for bias-aware procedures). **Target: an extreme expectile** $\xi_{1-p}$ with $p = p(n) \downarrow 0$, possibly $np = O(1)$.

**Scope of the proofs.** All results that are *new* (everything concerning expectiles in the distributed setting: Lemma 1, Theorems 1, 2, 5(i)–(iii), 6, Propositions 3, 10 and Corollaries 4, 7, 8, 9) are stated and **proved in full**. Results imported from the three reference papers and from classical extreme value theory are stated precisely as Propositions A–E with exact citations and are *not* reproved; this is the standard division of labour in a thesis chapter. No finite-sample simulation study is developed, as requested.

---

## 1. The problem

A sample of $n$ observations from a heavy-tailed distribution is scattered across $m$ machines (data centres, insurance branches, hospitals, …), machine $j$ holding $n_j$ observations
$$
X_{1,j},\ldots,X_{n_j,j} \overset{\text{i.i.d.}}{\sim} F, \qquad 1\le j\le m, \qquad n=\sum_{j=1}^m n_j,
$$
with full independence within and across machines and a *common* distribution function $F$. Raw data cannot be shared (privacy, bandwidth, storage). Following the communication heuristics of DPS (Sections 2.2–2.3 and 3 therein), machine $j$ transmits to the central machine **only** the vector
$$
T_j \;=\; \Big(n_j,\; k_j,\; \widehat{\gamma}_j(k_j),\; X_{n_j-k_j:n_j,j}\Big),
\qquad\text{optionally augmented by}\qquad \big(\widehat{\beta}_j,\widehat{\rho}_j\big),
$$
where $X_{1:n_j,j}\le\cdots\le X_{n_j:n_j,j}$ are the order statistics of the $j$-th subsample,
$$
\widehat{\gamma}_j(k_j) \;=\; \frac{1}{k_j}\sum_{i=1}^{k_j}\log\frac{X_{n_j-i+1:n_j,j}}{X_{n_j-k_j:n_j,j}}
$$
is the Hill (1975) estimator of the tail index computed on the top $k_j$ observations of machine $j$, $X_{n_j-k_j:n_j,j}$ is the corresponding intermediate order statistic, and $(\widehat{\beta}_j,\widehat{\rho}_j)$ are estimators of the second-order parameters (e.g. those of Gomes and Martins, as implemented in the `evt0` routines used by DPS).

**The question.** *How should the central machine pool the $T_j$ to estimate the extreme expectile $\xi_{1-p}$, and with which asymptotic guarantees and optimal weights?*

Recall (Newey and Powell, 1987) that the expectile of $F$ at level $\tau\in(0,1)$ is
$$
\xi_\tau \;=\; \arg\min_{\theta\in\mathbb{R}} \,\mathbb{E}\big[\eta_\tau(X-\theta)-\eta_\tau(X)\big],
\qquad \eta_\tau(u)=\big|\tau-\mathbb{1}\{u\le 0\}\big|\,u^2,
$$
which is well defined as soon as $\mathbb{E}|X|<\infty$, and is the unique solution of the first-order condition
$$
\tau \;=\; \frac{\mathbb{E}\big[|X-\xi_\tau|\,\mathbb{1}\{X\le \xi_\tau\}\big]}{\mathbb{E}|X-\xi_\tau|}.
$$
Expectiles are the only coherent law-invariant elicitable risk measures besides the mean, and unlike quantiles they depend on the whole tail; this motivates their use for tail risk assessment (Davison, Padoan and Stupfler, 2023; Padoan and Stupfler, 2022).

Two obstacles distinguish this problem from the extreme quantile problem solved by DPS:

1. **No expectile information is transmitted.** The protocol shares tail-index and quantile information only. Any asymmetric-least-squares (LAWS) estimation of expectiles requires access to the raw subsamples and is therefore *infeasible* under the protocol. The solution must be **quantile-based (QB)**: it must convert pooled quantile/tail-index information into expectile information.
2. **A genuine extreme level.** The target level $1-p$ satisfies $np=O(1)$ in the leading case, so $\xi_{1-p}$ lies beyond the range of every subsample and extrapolation is unavoidable; on top of the usual Weissman (1978) extrapolation error, the expectile–quantile relationship contributes additional bias terms that must be controlled.

**The solution in one sentence.** By the Bellini–Klar–Müller–Rosazza Gianin (2014) asymptotic proportionality $\xi_\tau/q_\tau\to(\gamma^{-1}-1)^{-\gamma}$ as $\tau\uparrow 1$, each machine's transmitted pair $(\widehat{\gamma}_j, X_{n_j-k_j:n_j,j})$ determines a Weissman-type extreme *expectile* estimator; pooling these **geometrically** with weights $\omega$ produces an estimator whose $\sqrt{k}/\log(k/(np))$-asymptotics are *entirely driven by the weighted pooled Hill estimator* $\widehat{\gamma}_n(\omega)=\sum_j\omega_j\widehat{\gamma}_j$, so that the whole DPS optimal-weighting theory (variance-optimal weights, oracle property, AMSE-optimal weights, bias reduction) transfers to extreme expectiles — with complete proofs given below.

---

## 2. Framework, communication protocol and assumptions

### 2.1 Notation

Throughout, $\overline{F}=1-F$ denotes the survival function, $U(t)=\inf\{x:\,\overline F(x)\le 1/t\}=q_{1-1/t}$ ($t>1$) the tail quantile function, and $q_\tau=U(1/(1-\tau))$ the quantile of level $\tau$. We write
$$
\varphi(s) \;:=\; (s^{-1}-1)^{-s},
\qquad
m(s) \;:=\; \frac{\mathrm{d}}{\mathrm{d}s}\log\varphi(s) \;=\; \frac{1}{1-s}-\log(s^{-1}-1),
\qquad s\in(0,1),
$$
for the *Bellini proportionality factor* and its log-derivative (the function $m$ is precisely the one appearing in the asymptotics of QB expectile estimators in Davison, Padoan and Stupfler, 2023, and Padoan and Stupfler, 2022). We abbreviate
$$
d_n := \frac{k}{np},\quad D_n := \log d_n,
\qquad
d_{n,j} := \frac{k_j}{n_j p},\quad D_{n,j} := \log d_{n,j},
$$
and write $\widehat\gamma_j := \widehat\gamma_j(k_j)$, $\widehat Q_j := X_{n_j-k_j:n_j,j}$. For weight vectors $\omega=(\omega_1,\ldots,\omega_m)^\top$ with $\sum_j\omega_j=1$ (negative entries allowed), the **weighted pooled Hill estimator** is $\widehat{\gamma}_n(\omega)=\sum_{j=1}^m \omega_j\widehat{\gamma}_j$ as in DPS, Section 2.2. All limits are as $n\to\infty$ and $\overset{P}{\to}$, $\overset{d}{\to}$ denote convergence in probability and in distribution.

### 2.2 Assumptions

**(A1) (Model.)** The $X_{i,j}$, $1\le i\le n_j$, $1\le j\le m$, are i.i.d. (within and across machines) with common continuous distribution function $F$ whose tail quantile function satisfies the second-order condition $\mathcal{C}_2(\gamma,\rho,A)$:
$$
\lim_{t\to\infty}\frac{1}{A(t)}\left[\frac{U(tx)}{U(t)}-x^{\gamma}\right] \;=\; x^{\gamma}\,\frac{x^{\rho}-1}{\rho}
\qquad\text{for all } x>0,
$$
where $\gamma\in(0,1)$, $\rho<0$, and $A$ has constant sign, $A(t)\to0$, $|A|$ regularly varying with index $\rho$. Moreover $\mathbb{E}|X_-|<\infty$, where $X_-=\min(X,0)$.

**(A2) (Subsample balance and intermediate sequences.)** $k_j=k_j(n)\to\infty$, $k_j/n_j\to0$ for each $j$; there are constants $b_j,c_j\in(0,\infty)$ (with $b_1=c_1=1$) such that
$$
\frac{n_1}{n_j}\to b_j,\qquad \frac{k_1}{k_j}\to c_j ;
$$
with $k:=\sum_{j=1}^m k_j$, one has $\sqrt{k}\,A(n/k)\to\lambda\in\mathbb{R}$.

**(A3) (Extreme level.)** $p=p(n)\to0$ with
$$
\frac{k}{np}\to\infty
\qquad\text{and}\qquad
\frac{\sqrt{k}}{\log(k/(np))}\to\infty .
$$

**(A4) (Tail magnitude.)** $\dfrac{\sqrt{k}}{U(n/k)}\to\mu\in[0,\infty)$.

### 2.3 Comments on the assumptions

**On (A1).** The professor's prescription "assume $\gamma>0$" must be sharpened for expectiles: the *existence* of $\xi_\tau$ requires a finite first moment, hence $\gamma<1$ together with $\mathbb{E}|X_-|<\infty$; and the proportionality constant $\varphi(\gamma)=(\gamma^{-1}-1)^{-\gamma}$ is only defined for $\gamma\in(0,1)$. The restriction $\gamma\in(0,1)$ is therefore *intrinsic to the expectile problem* and not an artifact of the method. The requirement $\rho<0$ is the same one made by DPS for their extreme quantile results (their Corollary 9) and guarantees that the Weissman extrapolation bias is of the order $O(|A(n_j/k_j)|)$. Note that, remarkably, **no restriction to $\gamma<1/2$ is needed**: the QB route works on all of $(0,1)$, whereas a LAWS-based route would require $\gamma<1/2$ for $\sqrt{k_j}$-asymptotics (cf. Theorem 3.1 of Davison, Padoan and Stupfler, 2023).

**On (A2).** This is exactly the fixed-$m$ distributed framework of DPS, Section 3: subsample sizes and effective sample sizes are asymptotically proportional. The condition $\sqrt{k}A(n/k)\to\lambda$ is the classical bias condition for the *combined* effective sample size $k$; Lemma 1 below shows it pins down all the machine-level biases. Note $k/n=\sum_j (k_j/n_j)(n_j/n)\to0$ automatically.

**On (A3).** The first part says $1-p$ is an extreme level relative to each machine ($p$ is eventually far smaller than every $k_j/n_j$, see Lemma 1(iv)); the second part is the standard condition ensuring that extrapolation does not destroy the convergence rate, identical to DPS, Corollary 9. The leading case $np=O(1)$ — the target is beyond all subsamples and beyond the combined sample — is allowed.

**On (A4).** This condition controls the *expectile–quantile gap*: the relation $\xi_\tau \approx \varphi(\gamma)q_\tau$ has a remainder of order $1/q_\tau$ (Proposition D below), which after multiplication by $\sqrt{k_j}$ must remain bounded. It is the exact analogue, for the distributed/extreme setting, of the condition $\sqrt{n(1-\tau_n)}/q_{\tau_n}\to\lambda_2\in\mathbb{R}$ in Theorem 3.5 of Davison, Padoan and Stupfler (2023) and Theorem 2.4 of Padoan and Stupfler (2022). Interpretation: for a Pareto-type tail $U(t)\sim Ct^{\gamma}$, (A4) holds with $\mu=0$ as soon as $k=o\big(n^{2\gamma/(1+2\gamma)}\big)$, a mild undersmoothing requirement; the larger $\gamma$, the weaker the restriction. As the proofs show, neither $\mu$ nor the gap remainder appears in the limiting distribution: the extrapolation factor $D_n\to\infty$ *washes out* every $O(1)$ bias contribution, leaving only the Hill-type bias. This is the structural reason why the entire DPS weighting theory transfers verbatim to expectiles.

---

## 3. Preliminaries

### 3.1 Deterministic consequences of (A1)–(A4)

Define
$$
S_0:=\sum_{i=1}^m c_i^{-1},
\qquad
\kappa_j := c_j S_0,
\qquad
\pi_j := \frac{c_j^{-1}}{S_0},
\qquad
d_j := \frac{c_j}{b_j}\cdot\frac{S_0}{\sum_{i=1}^m b_i^{-1}},
\qquad
S_\alpha := \sum_{j=1}^m \frac{d_j^{\alpha}}{c_j} \;\;(\alpha\in\mathbb{R}).
$$
Note that $(\pi_j)_j$ is a probability vector and that $S_\alpha = S_0\sum_j \pi_j d_j^\alpha$; the notation is consistent at $\alpha=0$.

> **Lemma 1 (rates across machines).** *Under (A1)–(A4), for every $j\in\{1,\ldots,m\}$:*
>
> *(i) $k/k_j\to\kappa_j\in(0,\infty)$ and $n/n_j\to b_j\sum_i b_i^{-1}\in(0,\infty)$;*
>
> *(ii) $\dfrac{n_j/k_j}{n/k}\to d_j\in(0,\infty)$, and $\sum_{j=1}^m \pi_j d_j=1$;*
>
> *(iii) $\sqrt{k_j}\,A(n_j/k_j)\to\lambda_j:=\kappa_j^{-1/2} d_j^{\rho}\lambda$, and $\sqrt{k}\,A(n_j/k_j)\to d_j^{\rho}\lambda$;*
>
> *(iv) $d_{n,j}\to\infty$, $D_{n,j}/D_n\to1$ and $\sqrt{k_j}/D_{n,j}\to\infty$;*
>
> *(v) $\limsup_n \sqrt{k_j}/U(1/p)\le\lim_n \sqrt{k_j}/U(n_j/k_j)=\kappa_j^{-1/2}d_j^{-\gamma}\mu<\infty$;*
>
> *(vi) $\limsup_n \sqrt{k_j}\,|A(1/p)|<\infty$.*

**Proof.** *(i)* $k/k_j=\sum_i k_i/k_j\to\sum_i c_j/c_i=c_j S_0=\kappa_j$; similarly $n/n_j=\sum_i n_i/n_j\to b_j\sum_i b_i^{-1}$.

*(ii)* Write $\dfrac{n_j/k_j}{n/k}=\dfrac{n_j}{n}\cdot\dfrac{k}{k_j}\to \dfrac{1}{b_j\sum_i b_i^{-1}}\cdot c_jS_0=d_j$. Moreover
$\sum_j\pi_jd_j=\dfrac{1}{S_0}\sum_j\dfrac{d_j}{c_j}=\dfrac{1}{\sum_i b_i^{-1}}\sum_j b_j^{-1}=1$.

*(iii)* Since $|A|$ is regularly varying with index $\rho$ and $A$ has constant sign, the locally uniform convergence theorem for regularly varying functions (Bingham, Goldie and Teugels, 1987, Theorem 1.5.2; de Haan and Ferreira, 2006, Proposition B.1.4) yields $A(ts_t)/A(t)\to s^{\rho}$ whenever $s_t\to s\in(0,\infty)$. Taking $t=n/k$ and $s_t=(n_j/k_j)/(n/k)\to d_j$ by (ii) gives $A(n_j/k_j)/A(n/k)\to d_j^{\rho}$, whence by (A2)
$$
\sqrt{k_j}\,A(n_j/k_j)=\sqrt{\tfrac{k_j}{k}}\cdot\sqrt{k}A(n/k)\cdot\frac{A(n_j/k_j)}{A(n/k)}\longrightarrow \kappa_j^{-1/2}\,\lambda\, d_j^{\rho},
$$
and similarly $\sqrt{k}A(n_j/k_j)\to d_j^\rho\lambda$.

*(iv)* $d_{n,j}=d_n\cdot\dfrac{k_j\,n}{k\,n_j}$ and $\dfrac{k_jn}{kn_j}\to d_j^{-1}\in(0,\infty)$ by (i)–(ii), so $d_{n,j}\to\infty$ by (A3); moreover $D_{n,j}-D_n=\log\dfrac{k_jn}{kn_j}\to-\log d_j$ is bounded while $D_n\to\infty$, so $D_{n,j}/D_n\to1$. Finally $\sqrt{k_j}/D_{n,j}=\sqrt{k_j/k}\,(D_n/D_{n,j})\,\sqrt{k}/D_n\to\infty$ by (A3).

*(v)* For $n$ large, $1/p\ge n_j/k_j$ by (iv), and $U$ is nondecreasing, so $U(1/p)\ge U(n_j/k_j)$ eventually, whence the inequality. For the limit: $U$ is regularly varying with index $\gamma$ (a consequence of (A1)), so by the locally uniform convergence theorem again, $U(n_j/k_j)/U(n/k)\to d_j^{\gamma}$; then $\sqrt{k_j}/U(n_j/k_j)=\sqrt{k_j/k}\cdot\big(\sqrt{k}/U(n/k)\big)\cdot U(n/k)/U(n_j/k_j)\to\kappa_j^{-1/2}\mu\,d_j^{-\gamma}$ by (A4).

*(vi)* Since $|A|$ is regularly varying with index $\rho<0$, the Potter bounds (Bingham, Goldie and Teugels, 1987, Theorem 1.5.6; de Haan and Ferreira, 2006, Proposition B.1.9.5) give a $t_0$ with
$$
\frac{|A(tx)|}{|A(t)|}\le 2\,x^{\rho/2}\le 2 \qquad\text{for all } t\ge t_0,\ x\ge1 .
$$
Apply this with $t=n_j/k_j\to\infty$ and $tx=1/p$ (legitimate eventually, since $1/p\ge n_j/k_j$ by (iv)): $|A(1/p)|\le 2|A(n_j/k_j)|$ eventually, so $\limsup_n\sqrt{k_j}|A(1/p)|\le 2|\lambda_j|<\infty$ by (iii). $\blacksquare$

### 3.2 Imported results

The following are quoted with precise references; they are the only external ingredients.

> **Proposition A (Hill estimator; de Haan and Ferreira, 2006, Theorem 3.2.5).** *Let $Y_1,\ldots,Y_N$ be i.i.d. with tail quantile function satisfying $\mathcal{C}_2(\gamma,\rho,A)$, $\gamma>0$. If $K\to\infty$, $K/N\to0$ and $\sqrt{K}A(N/K)\to\lambda'\in\mathbb{R}$, then the Hill estimator $\widehat\gamma(K)$ built on the top $K$ order statistics satisfies*
> $$\sqrt{K}\big(\widehat\gamma(K)-\gamma\big)\overset{d}{\longrightarrow}\mathcal{N}\!\Big(\frac{\lambda'}{1-\rho},\,\gamma^2\Big).$$

> **Proposition B (intermediate order statistic; de Haan and Ferreira, 2006, Theorem 2.4.1 taken at $s=1$).** *In the setting of Proposition A,*
> $$\sqrt{K}\Big(\frac{Y_{N-K:N}}{U(N/K)}-1\Big)\overset{d}{\longrightarrow}\mathcal{N}(0,\gamma^2);
> \qquad\text{in particular}\qquad \frac{Y_{N-K:N}}{U(N/K)}-1=O_P\big(K^{-1/2}\big).$$

> **Proposition C (uniform second-order bound for $\log U$; de Haan and Ferreira, 2006, Theorem B.3.10 in its $\log U$ form, as used in the proof of their Theorem 4.3.8).** *Under $\mathcal{C}_2(\gamma,\rho,A)$ with $\rho<0$: for every $\varepsilon>0$ there is $t_0=t_0(\varepsilon)$ such that for all $t\ge t_0$ and $x\ge1$,*
> $$\left|\frac{\log U(tx)-\log U(t)-\gamma\log x}{A(t)}-\frac{x^{\rho}-1}{\rho}\right|\;\le\;\varepsilon\, x^{\rho+\varepsilon}.$$

> **Proposition D (expectile–quantile gap; Daouia, Girard and Stupfler, 2020, Proposition 1(i); see also Corollary 3.4 of Davison, Padoan and Stupfler, 2023, where exactly this form is used).** *Under (A1), as $\tau\uparrow1$,*
> $$\frac{\xi_\tau}{q_\tau}\;=\;\varphi(\gamma)\,\big(1+r(\tau)\big),
> \qquad
> r(\tau)=\gamma(\gamma^{-1}-1)^{\gamma}\,\frac{\mathbb{E}(X)}{q_\tau}\big(1+o(1)\big)
> +\left[\frac{(\gamma^{-1}-1)^{-\rho}}{1-\gamma-\rho}+\frac{(\gamma^{-1}-1)^{-\rho}-1}{\rho}\right]A\big((1-\tau)^{-1}\big)\big(1+o(1)\big).$$
> *In particular $r(\tau)=O\big(1/q_\tau\big)+O\big(|A((1-\tau)^{-1})|\big)\to0$. (Only this order statement is used in the proofs below.)*

> **Proposition E (oracle property of the variance-optimal pooled Hill estimator; DPS, Theorem 3).** *Under (A1)–(A2), let $\widehat\gamma_n^{\,\mathrm{or}}=\widehat\gamma_n^{\,\mathrm{or}}(k)$ denote the (unfeasible) Hill estimator computed from the top $k=\sum_jk_j$ order statistics of the combined $n$-sample, and let $\widetilde\omega^{(\mathrm{Var})}_n=(k_1/k,\ldots,k_m/k)^\top$. If*
> $$\frac{k_j}{n_j}=\frac{k}{n}\Big(1+O\big(k^{-1/2}\big)\Big)\quad\text{for all }j,$$
> *then $\sqrt{k}\big(\widehat\gamma_n(\widetilde\omega_n^{(\mathrm{Var})})-\widehat\gamma_n^{\,\mathrm{or}}\big)=o_P(1)$.*

**Remark 1 (well-definedness).** Heavy tails ($\gamma>0$) imply $U(t)\to\infty$, so $\widehat Q_j\overset{P}{\to}\infty$ and in particular $\widehat Q_j>0$ with probability tending to one: logarithms of the transmitted statistics are well defined eventually. Likewise, since $\widehat\gamma_j\overset{P}{\to}\gamma\in(0,1)$ (Proposition A), the event $\{\widehat\gamma_j\in(0,1)\ \forall j\}$ has probability tending to one; on its complement the estimators below may be defined arbitrarily (say, by truncating $\widehat\gamma_j$ to $[\epsilon,1-\epsilon]$). All asymptotic statements are unaffected. These conventions are used without further comment.

---

## 4. Construction of the pooled extreme expectile estimator

### 4.1 Machine-level estimators from the transmitted statistics

The transmitted pair $(\widehat\gamma_j,\widehat Q_j)$ determines the Weissman (1978) extreme *quantile* estimator of machine $j$,
$$
\widehat q^{\,*}_j(1-p) \;=\; \Big(\frac{k_j}{n_jp}\Big)^{\widehat\gamma_j}\,\widehat Q_j \;=\; d_{n,j}^{\,\widehat\gamma_j}\,X_{n_j-k_j:n_j,j},
$$
exactly as in DPS. The Bellini proportionality $\xi_\tau\sim\varphi(\gamma)\,q_\tau$ ($\tau\uparrow1$; Proposition D) suggests converting it into the **machine-level QB extrapolating expectile estimator**
$$
\boxed{\;\widehat\xi^{\,*}_j(1-p)\;=\;\varphi(\widehat\gamma_j)\;\Big(\frac{k_j}{n_jp}\Big)^{\widehat\gamma_j} X_{n_j-k_j:n_j,j}
\;=\;\big(\widehat\gamma_j^{-1}-1\big)^{-\widehat\gamma_j}\;\widehat q^{\,*}_j(1-p).\;}
$$
This is the one-sample estimator of Daouia, Girard and Stupfler (2018, 2020), studied at extreme levels in Davison, Padoan and Stupfler (2023, Section 3.3) and Padoan and Stupfler (2022, Section 2.3) — computed here *exclusively from the transmitted statistics* $T_j$.

### 4.2 Geometric pooling

For a weight vector $\omega$ with $\sum_j\omega_j=1$, the **pooled extreme expectile estimator** is the weighted *geometric* mean
$$
\boxed{\;\widehat\xi^{\,*}_n(1-p\,|\,\omega)\;=\;\prod_{j=1}^m\Big[\widehat\xi^{\,*}_j(1-p)\Big]^{\omega_j}.\;}
$$
Why geometric and not arithmetic? Both the Weissman factor $d_{n,j}^{\widehat\gamma_j}$ and the Bellini factor $\varphi(\widehat\gamma_j)$ are *exponential* in $\widehat\gamma_j$; on the $\log$ scale the estimator is exactly *linear* in the transmitted Hill estimators:
$$
\log \widehat\xi^{\,*}_n(1-p\,|\,\omega)
=\sum_{j=1}^m\omega_j\Big[\log\varphi(\widehat\gamma_j)+\widehat\gamma_j\,D_{n,j}+\log \widehat Q_j\Big].
$$
The dominating term is $\sum_j\omega_j\widehat\gamma_j D_{n,j}\approx \widehat\gamma_n(\omega)\,D_n$: geometric pooling puts the problem back on the *standard scale of the pooled Hill estimator* $\widehat\gamma_n(\omega)$, which is the precise mechanism exploited by DPS (Section 2.3) for quantiles; an arithmetic average would break this exact linearization (see Remark 5 in Section 8 below). The log scale is also the natural scale for inference about extreme tail quantities (Drees, 2003).

Theorem 2 below makes the heuristic rigorous: the $\sqrt{k}/D_n$-asymptotics of $\widehat\xi^{\,*}_n(1-p\,|\,\omega)$ coincide with those of $\widehat\gamma_n(\omega)$, so weight optimization for the *expectile* problem reduces *exactly* to weight optimization for the pooled Hill estimator.

---

## 5. Asymptotic theory

### 5.1 Machine-level (joint) asymptotics

> **Theorem 1 (marginal QB extreme expectile estimators, jointly across machines).** *Assume (A1)–(A4). Then, with $\lambda_j=\kappa_j^{-1/2}d_j^{\rho}\lambda$ as in Lemma 1(iii),*
> $$
> \left(\frac{\sqrt{k_j}}{D_{n,j}}\Big(\frac{\widehat\xi^{\,*}_j(1-p)}{\xi_{1-p}}-1\Big)\right)_{1\le j\le m}
> =\Big(\sqrt{k_j}\,\big(\widehat\gamma_j-\gamma\big)\Big)_{1\le j\le m}+o_P(1)
> \;\overset{d}{\longrightarrow}\;
> \mathcal{N}_m\!\left(\Big(\frac{\lambda_j}{1-\rho}\Big)_{1\le j\le m},\;\gamma^2 I_m\right).
> $$

**Proof.** Fix $j$ and abbreviate $t_j:=n_j/k_j$, so that $1/p=t_j\,d_{n,j}$ and $q_{1-p}=U(1/p)$. On the event of Remark 1 (probability $\to1$) we have the *exact* decomposition
$$
\log\widehat\xi^{\,*}_j(1-p)-\log\xi_{1-p}=T_1+T_2+T_3+T_4+T_5,
$$
with
$$
\begin{aligned}
T_1&=\log\varphi(\widehat\gamma_j)-\log\varphi(\gamma), &
T_2&=(\widehat\gamma_j-\gamma)\,D_{n,j}, &
T_3&=\log\frac{\widehat Q_j}{U(t_j)},\\[2pt]
T_4&=-\Big[\log U(t_jd_{n,j})-\log U(t_j)-\gamma D_{n,j}\Big], &
T_5&=\log\big(\varphi(\gamma)\,U(1/p)\big)-\log\xi_{1-p}, &&
\end{aligned}
$$
as is checked by direct cancellation (the terms $\pm\log U(t_j)$, $\pm\gamma D_{n,j}$, $\pm\log\varphi(\gamma)$ and $\pm\log U(1/p)$ all cancel, leaving $\log\varphi(\widehat\gamma_j)+\widehat\gamma_j D_{n,j}+\log\widehat Q_j-\log\xi_{1-p}$).

*Term $T_1$.* By Proposition A (applicable on machine $j$ with $N=n_j$, $K=k_j$, $\lambda'=\lambda_j$, thanks to Lemma 1(iii)), $\widehat\gamma_j-\gamma=O_P(k_j^{-1/2})$; in particular $\widehat\gamma_j\overset{P}{\to}\gamma$. Since $\log\varphi$ is continuously differentiable on $(0,1)$ with derivative $m$, the mean value theorem gives, on an event of probability tending to one, $T_1=m(\bar\gamma_j)(\widehat\gamma_j-\gamma)$ with $\bar\gamma_j$ between $\widehat\gamma_j$ and $\gamma$, and $m(\bar\gamma_j)\overset{P}{\to}m(\gamma)$ by continuity. Hence
$$
T_1=O_P\big(k_j^{-1/2}\big).
$$

*Term $T_3$.* By Proposition B on machine $j$, $\widehat Q_j/U(t_j)-1=O_P(k_j^{-1/2})=o_P(1)$, so $T_3=\log\big(1+O_P(k_j^{-1/2})\big)=O_P\big(k_j^{-1/2}\big)$.

*Term $T_4$.* Apply Proposition C with $\varepsilon\in(0,-\rho)$, $t=t_j\to\infty$ and $x=d_{n,j}\ge1$ (eventually, by Lemma 1(iv)):
$$
T_4=-A(t_j)\left[\frac{d_{n,j}^{\rho}-1}{\rho}+O\big(\varepsilon\, d_{n,j}^{\rho+\varepsilon}\big)\right]
=-A(t_j)\Big[-\frac{1}{\rho}+o(1)\Big]
=O\big(|A(t_j)|\big)=O\big(k_j^{-1/2}\big),
$$
the last two steps because $d_{n,j}\to\infty$ with $\rho+\varepsilon<0$, and because $\sqrt{k_j}A(t_j)\to\lambda_j$ (Lemma 1(iii)).

*Term $T_5$.* By Proposition D applied at $\tau=1-p\uparrow1$, $T_5=-\log\big(1+r(1-p)\big)$ with $r(1-p)\to0$, so $|T_5|\le2|r(1-p)|$ eventually, and
$$
\sqrt{k_j}\,|T_5|\;\le\;2\sqrt{k_j}\,\Big[O\big(1/U(1/p)\big)+O\big(|A(1/p)|\big)\Big]\;=\;O(1)
$$
by Lemma 1(v)–(vi). Thus $T_5=O(k_j^{-1/2})$.

*Collecting.* $\sqrt{k_j}\big[\log\widehat\xi^{\,*}_j(1-p)-\log\xi_{1-p}\big]=\sqrt{k_j}(\widehat\gamma_j-\gamma)\,D_{n,j}+O_P(1)$, and dividing by $D_{n,j}\to\infty$,
$$
\frac{\sqrt{k_j}}{D_{n,j}}\,\log\frac{\widehat\xi^{\,*}_j(1-p)}{\xi_{1-p}}=\sqrt{k_j}(\widehat\gamma_j-\gamma)+o_P(1).
\tag{5.1}
$$
The right-hand side is $O_P(1)$, and $D_{n,j}/\sqrt{k_j}\to0$ by Lemma 1(iv); hence $\log\big(\widehat\xi^{\,*}_j/\xi_{1-p}\big)=o_P(1)$, i.e. $\widehat\xi^{\,*}_j/\xi_{1-p}\overset{P}{\to}1$, and by $e^u-1=u(1+o(1))$ as $u\to0$, the relative error inherits the expansion (5.1):
$$
\frac{\sqrt{k_j}}{D_{n,j}}\Big(\frac{\widehat\xi^{\,*}_j(1-p)}{\xi_{1-p}}-1\Big)=\sqrt{k_j}(\widehat\gamma_j-\gamma)+o_P(1).
$$
Since $m$ is fixed, the vector statement holds with a vector $o_P(1)$. Finally, the data are independent across machines, so the statistics $(\widehat\gamma_j)_{1\le j\le m}$ are mutually independent; Proposition A on each machine and independence give the joint limit $\mathcal{N}_m\big((\lambda_j/(1-\rho))_j,\gamma^2I_m\big)$. $\blacksquare$

### 5.2 Pooled asymptotics with deterministic or random weights

> **Theorem 2 (pooled QB extreme expectile estimator).** *Assume (A1)–(A4). Let $\omega\in\mathbb{R}^m$ with $\sum_{j}\omega_j=1$ and let $\widehat\omega_n$ be a (possibly data-dependent) weight vector with $\sum_j\widehat\omega_{n,j}=1$ almost surely and $\widehat\omega_n\overset{P}{\to}\omega$. Then*
> $$
> \frac{\sqrt{k}}{D_n}\Big(\frac{\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)}{\xi_{1-p}}-1\Big)
> =\sqrt{k}\,\big(\widehat\gamma_n(\omega)-\gamma\big)+o_P(1)
> \;\overset{d}{\longrightarrow}\;
> \mathcal{N}\!\left(\frac{\lambda}{1-\rho}\sum_{j=1}^m\omega_j d_j^{\rho},\;\;\gamma^2\,S_0\sum_{j=1}^m c_j\omega_j^2\right).
> $$

**Proof.** *Step 1 (deterministic weights).* Using $\sum_j\omega_j=1$,
$$
\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*}_n(1-p\,|\,\omega)}{\xi_{1-p}}
=\sum_{j=1}^m\omega_j\,\frac{\sqrt{k}}{\sqrt{k_j}}\cdot\frac{D_{n,j}}{D_n}\cdot\frac{\sqrt{k_j}}{D_{n,j}}\log\frac{\widehat\xi^{\,*}_j(1-p)}{\xi_{1-p}} .
$$
By (5.1), $\dfrac{\sqrt{k_j}}{D_{n,j}}\log\dfrac{\widehat\xi^{\,*}_j}{\xi_{1-p}}=\sqrt{k_j}(\widehat\gamma_j-\gamma)+o_P(1)$; by Lemma 1, $\sqrt{k/k_j}\to\kappa_j^{1/2}<\infty$ and $D_{n,j}/D_n\to1$, so with $\varepsilon_{n,j}:=\sqrt{k/k_j}\,(D_{n,j}/D_n)-\sqrt{k/k_j}\to0$ deterministic and $\sqrt{k}(\widehat\gamma_j-\gamma)=\sqrt{k/k_j}\,\sqrt{k_j}(\widehat\gamma_j-\gamma)=O_P(1)$:
$$
\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*}_n(1-p\,|\,\omega)}{\xi_{1-p}}
=\sum_{j=1}^m\omega_j\,\sqrt{k}\,(\widehat\gamma_j-\gamma)+o_P(1)
=\sqrt{k}\,\big(\widehat\gamma_n(\omega)-\gamma\big)+o_P(1).
\tag{5.2}
$$

*Step 2 (random weights).* Since $\sum_j(\widehat\omega_{n,j}-\omega_j)=0$,
$$
\log\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)-\log\widehat\xi^{\,*}_n(1-p\,|\,\omega)
=\sum_{j=1}^m(\widehat\omega_{n,j}-\omega_j)\Big[\log\widehat\xi^{\,*}_j(1-p)-\log\xi_{1-p}\Big].
$$
Each bracket is $O_P(D_{n,j}/\sqrt{k_j})=O_P(D_n/\sqrt{k})$ by (5.1) and Lemma 1, and $\widehat\omega_{n,j}-\omega_j=o_P(1)$; multiplying by $\sqrt{k}/D_n$ leaves $\sum_j o_P(1)O_P(1)=o_P(1)$. Combining with (5.2),
$$
\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)}{\xi_{1-p}}
=\sqrt{k}\,\big(\widehat\gamma_n(\omega)-\gamma\big)+o_P(1).
$$
As in the proof of Theorem 1, the left-hand side being $O_P(1)$ and $D_n/\sqrt{k}\to0$ imply $\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)/\xi_{1-p}\overset{P}{\to}1$, and the same expansion holds for the relative error.

*Step 3 (limit distribution of the pooled Hill estimator).* Write
$$
\sqrt{k}\,\big(\widehat\gamma_n(\omega)-\gamma\big)=\sum_{j=1}^m\omega_j\,\sqrt{\frac{k}{k_j}}\;\sqrt{k_j}\big(\widehat\gamma_j-\gamma\big).
$$
The $m$ summands are independent (independence across machines), $\sqrt{k/k_j}\to\kappa_j^{1/2}$, and $\sqrt{k_j}(\widehat\gamma_j-\gamma)\overset{d}{\to}\mathcal{N}(\lambda_j/(1-\rho),\gamma^2)$ by Proposition A and Lemma 1(iii). Hence
$$
\sqrt{k}\,\big(\widehat\gamma_n(\omega)-\gamma\big)\overset{d}{\longrightarrow}
\mathcal{N}\!\left(\sum_j\omega_j\,\kappa_j^{1/2}\,\frac{\lambda_j}{1-\rho},\;\gamma^2\sum_j\omega_j^2\,\kappa_j\right),
$$
and the parameters simplify via $\kappa_j^{1/2}\lambda_j=d_j^{\rho}\lambda$ and $\kappa_j=c_jS_0$:
$$
\text{bias}=\frac{\lambda}{1-\rho}\sum_j\omega_jd_j^{\rho},
\qquad
\text{variance}=\gamma^2\,S_0\sum_jc_j\omega_j^2. \qquad\blacksquare
$$

**Remark 2 (reduction principle).** Theorem 2 is the central structural fact: *to first order, estimating the extreme expectile in the distributed setting is exactly the problem of estimating $\gamma$ by weighted pooling.* The order statistics $\widehat Q_j$, the Bellini factors, the Weissman extrapolation bias and the expectile–quantile gap all contribute $O_P(\sqrt{k_j}^{-1})$ terms that the normalization $\sqrt{k}/D_n$ annihilates. Consequently the optimal-weight theory of DPS applies *verbatim*, as developed next — this is the expectile counterpart of their Corollary 9 for extreme quantiles.

---

## 6. Optimal pooling

By Theorem 2, the asymptotic bias and variance of $\dfrac{\sqrt{k}}{D_n}\Big(\dfrac{\widehat\xi^{\,*}_n(1-p|\omega)}{\xi_{1-p}}-1\Big)$ are
$$
\omega^\top B_c
\qquad\text{and}\qquad
\omega^\top V_c\,\omega,
\qquad\text{where}\quad
B_c:=\beta\,\big(d_1^{\rho},\ldots,d_m^{\rho}\big)^\top,\;\;
\beta:=\frac{\lambda}{1-\rho},\;\;
V_c:=\gamma^2 S_0\,\mathrm{diag}(c_1,\ldots,c_m),
$$
the same matrices as in DPS, Section 3. We optimize over $\mathcal{W}:=\{\omega\in\mathbb{R}^m:\;\mathbf{1}^\top\omega=1\}$.

### 6.1 Variance-optimal pooling

> **Proposition 3 (variance-optimal weights).** *The unique minimizer of $\omega\mapsto\omega^\top V_c\,\omega$ over $\mathcal{W}$ is*
> $$\omega^{(\mathrm{Var})}_j=\frac{c_j^{-1}}{S_0}=\pi_j,\qquad\text{with minimal variance}\qquad \big(\omega^{(\mathrm{Var})}\big)^\top V_c\,\omega^{(\mathrm{Var})}=\gamma^2 .$$
> *Moreover, the data-driven weights $\widetilde\omega^{(\mathrm{Var})}_n:=(k_1/k,\ldots,k_m/k)^\top$ — computable from the transmitted $T_j$ alone — satisfy $\widetilde\omega^{(\mathrm{Var})}_n\to\omega^{(\mathrm{Var})}$ (deterministically).*

**Proof.** By the Cauchy–Schwarz inequality, for any $\omega\in\mathcal{W}$,
$$
1=\Big(\sum_j\omega_j\Big)^2=\Big(\sum_j\big(\sqrt{c_j}\,\omega_j\big)\,c_j^{-1/2}\Big)^2
\le\Big(\sum_jc_j\omega_j^2\Big)\Big(\sum_jc_j^{-1}\Big)=S_0\sum_jc_j\omega_j^2,
$$
i.e. $\omega^\top V_c\,\omega=\gamma^2S_0\sum_jc_j\omega_j^2\ge\gamma^2$, with equality if and only if $\sqrt{c_j}\,\omega_j\propto c_j^{-1/2}$, i.e. $\omega_j\propto c_j^{-1}$; the constraint then forces $\omega_j=c_j^{-1}/S_0$. The last claim follows from $k_j/k\to\kappa_j^{-1}=(c_jS_0)^{-1}$ (Lemma 1(i)). $\blacksquare$

> **Corollary 4 (variance-optimal distributed extreme expectile estimator).** *Under (A1)–(A4),*
> $$
> \frac{\sqrt{k}}{D_n}\Big(\frac{\widehat\xi^{\,*}_n\big(1-p\,|\,\widetilde\omega^{(\mathrm{Var})}_n\big)}{\xi_{1-p}}-1\Big)
> \;\overset{d}{\longrightarrow}\;
> \mathcal{N}\!\left(\frac{\lambda}{1-\rho}\cdot\frac{S_\rho}{S_0},\;\gamma^2\right).
> $$

**Proof.** Theorem 2 with $\widehat\omega_n=\widetilde\omega^{(\mathrm{Var})}_n\to\omega^{(\mathrm{Var})}=(\pi_j)_j$: the bias is $\beta\sum_j\pi_jd_j^{\rho}=\beta S_\rho/S_0$ and the variance is $\gamma^2$ by Proposition 3. $\blacksquare$

### 6.2 The infeasible benchmark and the oracle property

The natural benchmark is the QB extreme expectile estimator one *would* compute if the $n$ observations could be combined, with effective sample size $k=\sum_jk_j$:
$$
\widehat\xi^{\,*,\mathrm{or}}_n(1-p):=\varphi\big(\widehat\gamma^{\,\mathrm{or}}_n\big)\Big(\frac{k}{np}\Big)^{\widehat\gamma^{\,\mathrm{or}}_n}X_{n-k:n},
$$
where $\widehat\gamma^{\,\mathrm{or}}_n=\widehat\gamma^{\,\mathrm{or}}_n(k)$ is the Hill estimator of the combined sample and $X_{n-k:n}$ its $(n-k)$-th order statistic.

> **Theorem 5 (benchmark and oracle property).** *Assume (A1)–(A4).*
>
> *(i) (Benchmark CLT.)* $\;\dfrac{\sqrt{k}}{D_n}\Big(\dfrac{\widehat\xi^{\,*,\mathrm{or}}_n(1-p)}{\xi_{1-p}}-1\Big)=\sqrt{k}\big(\widehat\gamma^{\,\mathrm{or}}_n-\gamma\big)+o_P(1)\overset{d}{\longrightarrow}\mathcal{N}\Big(\dfrac{\lambda}{1-\rho},\,\gamma^2\Big).$
>
> *(ii) (Bias comparison.) The variance-optimal distributed estimator of Corollary 4 attains the benchmark variance $\gamma^2$, and its absolute asymptotic bias dominates that of the benchmark:*
> $$\Big|\frac{\lambda}{1-\rho}\,\frac{S_\rho}{S_0}\Big|\;\ge\;\Big|\frac{\lambda}{1-\rho}\Big|,$$
> *with equality if and only if $\lambda=0$ or $d_j=1$ for all $j$ (asymptotically equal sample fractions $k_j/n_j$).*
>
> *(iii) (Full asymptotic equivalence.) If in addition $k_j/n_j=(k/n)\big(1+O(k^{-1/2})\big)$ for all $j$, then*
> $$\frac{\sqrt{k}}{D_n}\left(\frac{\widehat\xi^{\,*}_n\big(1-p\,|\,\widetilde\omega^{(\mathrm{Var})}_n\big)}{\widehat\xi^{\,*,\mathrm{or}}_n(1-p)}-1\right)=o_P(1),$$
> *i.e. the feasible distributed estimator is asymptotically indistinguishable, at the rate, from the infeasible benchmark.*

**Proof.** *(i)* Apply Theorem 1 with $m=1$ "machine" equal to the combined sample: the required conditions are $k\to\infty$, $k/n\to0$ (Lemma 1 / (A2)), $\sqrt{k}A(n/k)\to\lambda$ (A2), $k/(np)\to\infty$ and $\sqrt{k}/D_n\to\infty$ (A3), and $\sqrt{k}/U(n/k)\to\mu$ (A4) — all hold, with $d_1=c_1=1$, $\kappa_1=1$, $\lambda_1=\lambda$. Proposition A gives the limit.

*(ii)* The variance statement is Proposition 3. For the bias: since $x\mapsto x^{\rho}$ is convex on $(0,\infty)$ (as $\rho<0$) and $(\pi_j)_j$ is a probability vector with $\sum_j\pi_jd_j=1$ (Lemma 1(ii)), Jensen's inequality gives
$$
\frac{S_\rho}{S_0}=\sum_j\pi_j\,d_j^{\rho}\;\ge\;\Big(\sum_j\pi_jd_j\Big)^{\rho}=1 ,
$$
with equality if and only if the $d_j$ are all equal (strict convexity), which combined with $\sum_j\pi_jd_j=1$ forces $d_j\equiv1$. Multiplying both sides of $S_\rho/S_0\ge1$ by $|\beta|=|\lambda|/(1-\rho)$ proves the claim, with equality iff $\lambda=0$ or $d_j\equiv1$. Finally, $d_j\equiv1$ is exactly asymptotic equality of the sample fractions, since $d_j=\lim\,(k/n)\big/(k_j/n_j)$.

*(iii)* The premise implies $(k/n)/(k_j/n_j)\to1$, i.e. $d_j=1$ for all $j$, so $\omega^{(\mathrm{Var})}=(\pi_j)_j$ and all conditions used so far stand. By (5.2)–Step 2 of the proof of Theorem 2 (with $\widehat\omega_n=\widetilde\omega^{(\mathrm{Var})}_n\to\omega^{(\mathrm{Var})}$) and by part (i),
$$
\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*}_n(1-p\,|\,\widetilde\omega^{(\mathrm{Var})}_n)}{\xi_{1-p}}
=\sqrt{k}\big(\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)-\gamma\big)+o_P(1),
\qquad
\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*,\mathrm{or}}_n(1-p)}{\xi_{1-p}}
=\sqrt{k}\big(\widehat\gamma^{\,\mathrm{or}}_n-\gamma\big)+o_P(1),
$$
where in the first display we replaced $\widehat\gamma_n(\omega^{(\mathrm{Var})})$ (delivered by Theorem 2's expansion) with $\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)$, which is legitimate at this order since $\sqrt{k}\big(\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)-\widehat\gamma_n(\omega^{(\mathrm{Var})})\big)=\sum_j(\widetilde\omega_{n,j}-\pi_j)\,\sqrt{k}(\widehat\gamma_j-\gamma)=o(1)\,O_P(1)=o_P(1)$ (deterministic weights $\widetilde\omega_{n,j}\to\pi_j$). Subtracting and invoking Proposition E,
$$
\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*}_n(1-p\,|\,\widetilde\omega^{(\mathrm{Var})}_n)}{\widehat\xi^{\,*,\mathrm{or}}_n(1-p)}
=\sqrt{k}\big(\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)-\widehat\gamma^{\,\mathrm{or}}_n\big)+o_P(1)=o_P(1).
$$
Both estimators are consistent for $\xi_{1-p}$ in relative terms (Theorem 2 and part (i)), so their ratio tends to $1$ in probability, and the $\log\mapsto$ relative-error conversion of the proof of Theorem 1 applies once more. $\blacksquare$

### 6.3 AMSE-optimal pooling

Define the **asymptotic mean squared error coefficient** of the pooled estimator with weights $\omega\in\mathcal{W}$ as the (squared bias + variance) of the limit law in Theorem 2:
$$
M(\omega):=\big(\omega^\top B_c\big)^2+\omega^\top V_c\,\omega,
\qquad\text{so that}\qquad
\mathrm{AMSE}\big(\widehat\xi^{\,*}_n(1-p|\omega)\big)=\frac{D_n^2}{k}\,M(\omega)\,\big(1+o(1)\big)
$$
in the usual asymptotic sense; the factor $D_n^2/k$ is common to all weight choices, so weights are compared through $M(\cdot)$. The benchmark coefficient is $M^{\mathrm{or}}:=\beta^2+\gamma^2$ by Theorem 5(i).

> **Theorem 6 (AMSE-optimal weights, value, and comparison with the benchmark).** *Assume (A1)–(A4), and recall $\beta=\lambda/(1-\rho)$, $S_\alpha=\sum_jd_j^{\alpha}/c_j$.*
>
> *(i) The map $M$ has a unique minimizer over $\mathcal{W}$, namely*
> $$
> \omega^{(\mathrm{AMSE})}
> =\frac{\big(1+B_c^\top V_c^{-1}B_c\big)V_c^{-1}\mathbf{1}-\big(\mathbf{1}^\top V_c^{-1}B_c\big)V_c^{-1}B_c}
> {\big(1+B_c^\top V_c^{-1}B_c\big)\big(\mathbf{1}^\top V_c^{-1}\mathbf{1}\big)-\big(\mathbf{1}^\top V_c^{-1}B_c\big)^2},
> \qquad\text{explicitly}\qquad
> \omega^{(\mathrm{AMSE})}_j=\frac{c_j^{-1}\Big[\gamma^2S_0+\beta^2S_{2\rho}-\beta^2S_\rho\,d_j^{\rho}\Big]}{\Delta},
> $$
> *where $\Delta:=\big(\gamma^2S_0+\beta^2S_{2\rho}\big)S_0-\beta^2S_\rho^2>0$, with optimal value*
> $$
> M^{*}:=M\big(\omega^{(\mathrm{AMSE})}\big)=\frac{\gamma^2S_0\big(\gamma^2S_0+\beta^2S_{2\rho}\big)}{\Delta}.
> $$
>
> *(ii) Suppose the $d_j$ are not all equal to $1$ (unbalanced design). Then*
> $$
> M^{*}\;\ge\;M^{\mathrm{or}}=\beta^2+\gamma^2
> \qquad\Longleftrightarrow\qquad
> |\lambda|\;\le\;\lambda_0:=\gamma(1-\rho)\sqrt{\frac{S_\rho^2-S_0^2}{S_0S_{2\rho}-S_\rho^2}}\;\in(0,\infty).
> $$
> *In particular, the AMSE-optimal distributed extreme expectile estimator strictly beats the infeasible benchmark in AMSE whenever the bias is large, $|\lambda|>\lambda_0$ — the exact expectile analogue of DPS, Theorem 4.*

**Proof.** *(i) Existence, uniqueness, first-order conditions.* $M(\omega)=\omega^\top\big(V_c+B_cB_c^\top\big)\omega$ with $V_c\succ0$ (as $\gamma,c_j,S_0>0$) and $B_cB_c^\top\succeq0$, so $M$ is strictly convex on $\mathbb{R}^m$ and has a unique minimizer on the affine set $\mathcal{W}$, characterized by the Lagrange condition
$$
2\big(\omega^\top B_c\big)B_c+2V_c\,\omega=\nu\,\mathbf{1},\qquad \mathbf{1}^\top\omega=1,
$$
for some $\nu\in\mathbb{R}$. Set $a:=\omega^\top B_c$. Solving the stationarity equation for $\omega$:
$$
\omega=\frac{\nu}{2}V_c^{-1}\mathbf{1}-a\,V_c^{-1}B_c.
\tag{6.1}
$$
Multiplying (6.1) by $B_c^\top$ gives $a=\frac{\nu}{2}\,\mathbf{1}^\top V_c^{-1}B_c-a\,B_c^\top V_c^{-1}B_c$, i.e.
$$
a=\frac{\nu}{2}\cdot\frac{\mathbf{1}^\top V_c^{-1}B_c}{1+B_c^\top V_c^{-1}B_c}.
\tag{6.2}
$$
Multiplying (6.1) by $\mathbf{1}^\top$ and using (6.2):
$$
1=\frac{\nu}{2}\left[\mathbf{1}^\top V_c^{-1}\mathbf{1}-\frac{\big(\mathbf{1}^\top V_c^{-1}B_c\big)^2}{1+B_c^\top V_c^{-1}B_c}\right]
\quad\Longrightarrow\quad
\frac{\nu}{2}=\frac{1+B_c^\top V_c^{-1}B_c}{\big(1+B_c^\top V_c^{-1}B_c\big)\big(\mathbf{1}^\top V_c^{-1}\mathbf{1}\big)-\big(\mathbf{1}^\top V_c^{-1}B_c\big)^2},
\tag{6.3}
$$
the denominator being strictly positive because, by the Cauchy–Schwarz inequality in the inner product $\langle u,v\rangle=u^\top V_c^{-1}v$,
$$
\big(\mathbf{1}^\top V_c^{-1}B_c\big)^2\le\big(\mathbf{1}^\top V_c^{-1}\mathbf{1}\big)\big(B_c^\top V_c^{-1}B_c\big)<\big(1+B_c^\top V_c^{-1}B_c\big)\big(\mathbf{1}^\top V_c^{-1}\mathbf{1}\big).
\tag{6.4}
$$
Substituting (6.2)–(6.3) into (6.1) gives the stated abstract formula. The optimal value: from the stationarity equation, $V_c\,\omega=\frac{\nu}{2}\mathbf{1}-aB_c$, so $\omega^\top V_c\,\omega=\frac{\nu}{2}\,\mathbf{1}^\top\omega-a\,\omega^\top B_c=\frac{\nu}{2}-a^2$ and
$$
M^{*}=a^2+\omega^\top V_c\,\omega=\frac{\nu}{2}.
\tag{6.5}
$$
*Explicit forms.* With $V_c^{-1}=(\gamma^2S_0)^{-1}\mathrm{diag}(c_1^{-1},\ldots,c_m^{-1})$ and $B_c=\beta(d_j^{\rho})_j$:
$$
\mathbf{1}^\top V_c^{-1}\mathbf{1}=\frac{1}{\gamma^2},\qquad
\mathbf{1}^\top V_c^{-1}B_c=\frac{\beta S_\rho}{\gamma^2S_0},\qquad
B_c^\top V_c^{-1}B_c=\frac{\beta^2S_{2\rho}}{\gamma^2S_0}.
$$
Then $1+B_c^\top V_c^{-1}B_c=\dfrac{\gamma^2S_0+\beta^2S_{2\rho}}{\gamma^2S_0}$, and the $j$-th coordinate of the numerator of $\omega^{(\mathrm{AMSE})}$ is
$$
\frac{\gamma^2S_0+\beta^2S_{2\rho}}{\gamma^2S_0}\cdot\frac{c_j^{-1}}{\gamma^2S_0}-\frac{\beta S_\rho}{\gamma^2S_0}\cdot\frac{\beta\,c_j^{-1}d_j^{\rho}}{\gamma^2S_0}
=\frac{c_j^{-1}}{\gamma^4S_0^2}\Big[\gamma^2S_0+\beta^2S_{2\rho}-\beta^2S_\rho d_j^{\rho}\Big],
$$
while the denominator equals
$$
\frac{\gamma^2S_0+\beta^2S_{2\rho}}{\gamma^2S_0}\cdot\frac{1}{\gamma^2}-\frac{\beta^2S_\rho^2}{\gamma^4S_0^2}
=\frac{\big(\gamma^2S_0+\beta^2S_{2\rho}\big)S_0-\beta^2S_\rho^2}{\gamma^4S_0^2}=\frac{\Delta}{\gamma^4S_0^2}.
$$
Dividing yields $\omega^{(\mathrm{AMSE})}_j=c_j^{-1}\big[\gamma^2S_0+\beta^2S_{2\rho}-\beta^2S_\rho d_j^{\rho}\big]/\Delta$; one checks $\sum_j\omega^{(\mathrm{AMSE})}_j=\big[S_0(\gamma^2S_0+\beta^2S_{2\rho})-\beta^2S_\rho^2\big]/\Delta=1$, and $\Delta>0$ restates (6.4) (or directly: $S_0S_{2\rho}\ge S_\rho^2$ by Cauchy–Schwarz, so $\Delta\ge\gamma^2S_0^2>0$). Finally, from (6.3) and (6.5),
$$
M^{*}=\frac{\nu}{2}
=\frac{(\gamma^2S_0+\beta^2S_{2\rho})/(\gamma^2S_0)}{\Delta/(\gamma^4S_0^2)}
=\frac{\gamma^2S_0\big(\gamma^2S_0+\beta^2S_{2\rho}\big)}{\Delta}.
$$
(Sanity check: if $\lambda=0$ then $\beta=0$, $M^{*}=\gamma^2=M(\omega^{(\mathrm{Var})})$ and $\omega^{(\mathrm{AMSE})}=\omega^{(\mathrm{Var})}$.)

*(ii)* Since the $d_j$ are not all equal to $1$, and $\sum_j\pi_jd_j=1$ (Lemma 1(ii)), the $d_j$ — hence the $d_j^{\rho}$, as $\rho\ne0$ — are non-constant in $j$. Two strict inequalities follow:

- **Strict Cauchy–Schwarz:** $S_0S_{2\rho}-S_\rho^2>0$, because equality in $\big(\sum_jc_j^{-1}d_j^{\rho}\big)^2\le\big(\sum_jc_j^{-1}\big)\big(\sum_jc_j^{-1}d_j^{2\rho}\big)$ would force $d_j^{\rho}$ constant.
- **Strict Jensen** (as in Theorem 5(ii)): $S_\rho/S_0=\sum_j\pi_jd_j^{\rho}>\big(\sum_j\pi_jd_j\big)^{\rho}=1$, hence $S_\rho^2-S_0^2>0$.

Thus $\lambda_0\in(0,\infty)$ is well defined. Now compare $M^{*}$ with $M^{\mathrm{or}}=\beta^2+\gamma^2$, using $\Delta>0$:
$$
M^{*}\ge M^{\mathrm{or}}
\iff
\gamma^2S_0\big(\gamma^2S_0+\beta^2S_{2\rho}\big)\ge\big(\gamma^2+\beta^2\big)\Delta
\iff
\gamma^2\Big[S_0\big(\gamma^2S_0+\beta^2S_{2\rho}\big)-\Delta\Big]\ge\beta^2\Delta .
$$
But $S_0\big(\gamma^2S_0+\beta^2S_{2\rho}\big)-\Delta=\beta^2S_\rho^2$ by definition of $\Delta$, so the comparison reads $\gamma^2\beta^2S_\rho^2\ge\beta^2\Delta$. If $\beta=0$ (i.e. $\lambda=0$) this holds with equality, consistently with $0=|\lambda|\le\lambda_0$. If $\beta\ne0$, divide by $\beta^2>0$:
$$
M^{*}\ge M^{\mathrm{or}}
\iff
\gamma^2S_\rho^2\ge\Delta=\gamma^2S_0^2+\beta^2\big(S_0S_{2\rho}-S_\rho^2\big)
\iff
\beta^2\le\gamma^2\,\frac{S_\rho^2-S_0^2}{S_0S_{2\rho}-S_\rho^2}
\iff
|\lambda|\le\lambda_0,
$$
where the last step uses $\beta^2=\lambda^2/(1-\rho)^2$. $\blacksquare$

**Remark 3 (interpretation).** When $|\lambda|\le\lambda_0$ (small bias), the price of distribution under unbalanced designs is a (typically small) AMSE inflation even with optimal weights; when $|\lambda|>\lambda_0$ (large bias), the heterogeneity of the machine-level biases $\lambda_j\propto d_j^{\rho}$ becomes an *asset*: weighting can partially cancel bias against bias, and the feasible distributed estimator strictly improves on the infeasible benchmark — for expectiles exactly as DPS found for the tail index and extreme quantiles. In the balanced case $d_j\equiv1$ one has $S_\alpha=S_0$ for every $\alpha$, so all machine-level biases coincide with the benchmark bias; then $\Delta=(\gamma^2S_0+\beta^2S_0)S_0-\beta^2S_0^2=\gamma^2S_0^2$ and $M^{*}=\gamma^2S_0\cdot S_0(\gamma^2+\beta^2)/(\gamma^2S_0^2)=\gamma^2+\beta^2=M^{\mathrm{or}}$: with balanced designs nothing can beat (or lose to) the benchmark at first order, and the threshold phenomenon disappears.

### 6.4 Data-driven AMSE weights from the augmented protocol

The weights $\omega^{(\mathrm{AMSE})}$ involve $(\gamma,\beta',\rho)$-type quantities; following DPS, Section 3.2, the protocol is augmented so that machine $j$ also transmits second-order estimates $(\widehat\beta_j,\widehat\rho_j)$, and one assumes the Hall–Welsh-type representation
$$
\textbf{(A5)}\qquad A(t)=\gamma\,\beta'\,t^{\rho}\quad\text{for some }\beta'\ne0,
\qquad
\widehat\beta_j\overset{P}{\to}\beta',\qquad
(\widehat\rho_j-\rho)\log n_j=o_P(1),\quad 1\le j\le m .
$$
(These are the consistency requirements DPS impose; they are met, e.g., by the estimators of Gomes and Martins implemented in `evt0::mop`.) The central machine forms
$$
\widehat\beta_n=\sum_{j=1}^m\frac{n_j}{n}\widehat\beta_j,
\qquad
\widehat\rho_n=\sum_{j=1}^m\frac{n_j}{n}\widehat\rho_j,
\qquad
\widetilde\gamma_n=\widehat\gamma_n\big(\widetilde\omega^{(\mathrm{Var})}_n\big),
$$
$$
\widetilde B_{c,j}=\frac{\sqrt{k}\;\widetilde\gamma_n\,\widehat\beta_n}{1-\widehat\rho_n}\Big(\frac{n_j}{k_j}\Big)^{\widehat\rho_n},
\qquad
\widetilde V_c=k\,\widetilde\gamma_n^{\,2}\;\mathrm{diag}\Big(\frac{1}{k_1},\ldots,\frac{1}{k_m}\Big),
$$
and plugs $(\widetilde B_c,\widetilde V_c)$ into the abstract formula of Theorem 6(i) to obtain $\widetilde\omega^{(\mathrm{AMSE})}_n$. Everything is computable from $\{T_j,(\widehat\beta_j,\widehat\rho_j)\}_{j\le m}$.

> **Corollary 7 (feasible AMSE-optimal distributed estimator).** *Assume (A1)–(A5). Then $\widetilde\omega^{(\mathrm{AMSE})}_n\overset{P}{\to}\omega^{(\mathrm{AMSE})}$ and*
> $$
> \frac{\sqrt{k}}{D_n}\Big(\frac{\widehat\xi^{\,*}_n\big(1-p\,|\,\widetilde\omega^{(\mathrm{AMSE})}_n\big)}{\xi_{1-p}}-1\Big)
> \overset{d}{\longrightarrow}
> \mathcal{N}\Big(\big(\omega^{(\mathrm{AMSE})}\big)^\top B_c,\;\big(\omega^{(\mathrm{AMSE})}\big)^\top V_c\,\omega^{(\mathrm{AMSE})}\Big),
> $$
> *whose (squared bias + variance) equals the optimal value $M^{*}$ of Theorem 6.*

**Proof.** *Consistency of the plug-ins.* First, $\widetilde V_c\to V_c$: indeed $[\widetilde V_c]_{jj}=\widetilde\gamma_n^{\,2}\,k/k_j\overset{P}{\to}\gamma^2\kappa_j=\gamma^2S_0c_j=[V_c]_{jj}$, by Lemma 1(i) and $\widetilde\gamma_n\overset{P}{\to}\gamma$ (Theorem 2's Step 3 with $\omega=\omega^{(\mathrm{Var})}$, or simply Proposition A and Lemma 1).

Second, $\widetilde B_c\overset{P}{\to}B_c$. Under (A5), $\sqrt{k}A(n_j/k_j)=\sqrt{k}\,\gamma\beta'(n_j/k_j)^{\rho}\to d_j^{\rho}\lambda$ by Lemma 1(iii), so $B_{c,j}=\beta d_j^{\rho}=\lim_n \sqrt{k}\,\gamma\beta'(n_j/k_j)^{\rho}/(1-\rho)$ and it suffices to show
$$
R_{n,j}:=\frac{\widetilde B_{c,j}}{\sqrt{k}\,\gamma\beta'(n_j/k_j)^{\rho}/(1-\rho)}
=\frac{\widetilde\gamma_n\widehat\beta_n}{\gamma\beta'}\cdot\frac{1-\rho}{1-\widehat\rho_n}\cdot\Big(\frac{n_j}{k_j}\Big)^{\widehat\rho_n-\rho}
\overset{P}{\longrightarrow}1 .
$$
The first two factors tend to $1$ in probability since $\widetilde\gamma_n\overset{P}{\to}\gamma$, $\widehat\beta_n\overset{P}{\to}\beta'$ (convex combination of consistent estimators) and $\widehat\rho_n\overset{P}{\to}\rho$. For the third, $\big(\tfrac{n_j}{k_j}\big)^{\widehat\rho_n-\rho}=\exp\big[(\widehat\rho_n-\rho)\log(n_j/k_j)\big]$ and $0\le\log(n_j/k_j)\le\log n_j\le\log n$ eventually, while
$$
(\widehat\rho_n-\rho)\log n=\sum_{j=1}^m\frac{n_j}{n}\,(\widehat\rho_j-\rho)\log n_j\cdot\frac{\log n}{\log n_j}=o_P(1),
$$
because each $(\widehat\rho_j-\rho)\log n_j=o_P(1)$ by (A5) and $\log n/\log n_j\to1$ (indeed $\log n-\log n_j\to\log(b_j\sum_ib_i^{-1})$ is bounded while $\log n_j\to\infty$). Hence $R_{n,j}\overset{P}{\to}1$ and $\widetilde B_c\overset{P}{\to}B_c$.

*Consistency of the weights.* The map $(B,V)\mapsto\omega(B,V)$ given by the abstract formula of Theorem 6(i) is continuous at $(B_c,V_c)$: its denominator is $\big(1+B^\top V^{-1}B\big)\big(\mathbf{1}^\top V^{-1}\mathbf{1}\big)-\big(\mathbf{1}^\top V^{-1}B\big)^2$, which at $(B_c,V_c)$ is strictly positive by (6.4) — note this holds for *any* $B_c$, including $B_c=0$, so no extra condition on $\lambda$ or the $d_j$ is needed. By the continuous mapping theorem, $\widetilde\omega^{(\mathrm{AMSE})}_n\overset{P}{\to}\omega^{(\mathrm{AMSE})}$. Also $\mathbf{1}^\top\widetilde\omega^{(\mathrm{AMSE})}_n=1$ identically, by construction of the formula (it is normalized for every $(B,V)$ in its domain).

*Conclusion.* Apply Theorem 2 with $\widehat\omega_n=\widetilde\omega^{(\mathrm{AMSE})}_n$ and $\omega=\omega^{(\mathrm{AMSE})}$. $\blacksquare$

### 6.5 Bias-reduced pooled estimator

The bias $\omega^\top B_c$ of the limit law is *known up to consistently estimable quantities* once the augmented protocol is in force; since the error analysis lives on the $\log$ scale, the natural correction is multiplicative.

> **Corollary 8 (bias-reduced distributed extreme expectile estimator).** *Assume (A1)–(A5), and let $\widehat\omega_n\overset{P}{\to}\omega\in\mathcal{W}$ with $\mathbf{1}^\top\widehat\omega_n=1$. Define*
> $$
> \overline{\xi}^{\,*}_n(1-p\,|\,\widehat\omega_n)
> :=\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)\;
> \exp\!\Big(-\frac{D_n}{\sqrt{k}}\;\widehat\omega_n^\top\widetilde B_c\Big).
> $$
> *Then*
> $$
> \frac{\sqrt{k}}{D_n}\Big(\frac{\overline{\xi}^{\,*}_n(1-p\,|\,\widehat\omega_n)}{\xi_{1-p}}-1\Big)
> \overset{d}{\longrightarrow}
> \mathcal{N}\Big(0,\;\gamma^2S_0\sum_jc_j\omega_j^2\Big).
> $$
> *In particular, with $\widehat\omega_n=\widetilde\omega^{(\mathrm{Var})}_n$ the limit is $\mathcal{N}(0,\gamma^2)$: the distributed estimator attains the benchmark variance with no first-order bias.*

**Proof.** On the $\log$ scale,
$$
\frac{\sqrt{k}}{D_n}\log\frac{\overline{\xi}^{\,*}_n(1-p|\widehat\omega_n)}{\xi_{1-p}}
=\frac{\sqrt{k}}{D_n}\log\frac{\widehat\xi^{\,*}_n(1-p|\widehat\omega_n)}{\xi_{1-p}}-\widehat\omega_n^\top\widetilde B_c .
$$
By Theorem 2 (proof, Steps 1–2), the first term equals $\sqrt{k}\big(\widehat\gamma_n(\omega)-\gamma\big)+o_P(1)\overset{d}{\to}\mathcal{N}\big(\omega^\top B_c,\;\gamma^2S_0\sum_jc_j\omega_j^2\big)$; by Corollary 7's proof, $\widetilde B_c\overset{P}{\to}B_c$, so $\widehat\omega_n^\top\widetilde B_c\overset{P}{\to}\omega^\top B_c$. Slutsky's lemma gives the centred limit for the $\log$ ratio; the correction factor $\exp\big(-(D_n/\sqrt{k})\widehat\omega_n^\top\widetilde B_c\big)\overset{P}{\to}1$ (as $D_n/\sqrt{k}\to0$), so consistency in relative terms is preserved and the $\log\mapsto$ relative-error conversion of Theorem 1's proof applies. $\blacksquare$

---

## 7. Asymptotic confidence intervals

> **Corollary 9 (log-scale confidence intervals computable at the central machine).** *Assume (A1)–(A4), let $\widehat\omega_n\overset{P}{\to}\omega\in\mathcal{W}$ with $\mathbf{1}^\top\widehat\omega_n=1$, and define the variance estimator*
> $$
> \widehat\sigma_n^2:=\widehat\gamma_n\big(\widetilde\omega^{(\mathrm{Var})}_n\big)^2\;k\sum_{j=1}^m\frac{\widehat\omega_{n,j}^2}{k_j}
> \qquad\Big(\overset{P}{\longrightarrow}\;\gamma^2S_0\sum_jc_j\omega_j^2\Big).
> $$
> *Let $z_{1-\alpha/2}$ be the standard normal quantile and set, for a generic point estimator $\check\xi_n$,*
> $$
> \mathcal{I}_{n,1-\alpha}\big(\check\xi_n\big):=\left[\check\xi_n\,\exp\Big(-z_{1-\alpha/2}\,\frac{D_n}{\sqrt{k}}\,\widehat\sigma_n\Big),\;\;\check\xi_n\,\exp\Big(z_{1-\alpha/2}\,\frac{D_n}{\sqrt{k}}\,\widehat\sigma_n\Big)\right].
> $$
> *Then:*
>
> *(i) if $\lambda=0$,* $\;\mathbb{P}\big(\xi_{1-p}\in\mathcal{I}_{n,1-\alpha}(\widehat\xi^{\,*}_n(1-p|\widehat\omega_n))\big)\to1-\alpha$;
>
> *(ii) under (A5) and with arbitrary $\lambda\in\mathbb{R}$,* $\;\mathbb{P}\big(\xi_{1-p}\in\mathcal{I}_{n,1-\alpha}(\overline{\xi}^{\,*}_n(1-p|\widehat\omega_n))\big)\to1-\alpha$.
>
> *With $\widehat\omega_n=\widetilde\omega^{(\mathrm{Var})}_n$ one has $k\sum_j\widehat\omega_{n,j}^2/k_j=1$ exactly, so $\widehat\sigma_n=\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)$ and the interval has half-width $z_{1-\alpha/2}\,\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)\,\log(k/(np))/\sqrt{k}$ on the $\log$ scale — formally identical to the one-sample QB interval, with $k$ the combined effective sample size.*

**Proof.** *Variance consistency.* $k\sum_j\widehat\omega_{n,j}^2/k_j=\sum_j\widehat\omega_{n,j}^2\,(k/k_j)\overset{P}{\to}\sum_j\omega_j^2\kappa_j=S_0\sum_jc_j\omega_j^2$ by Lemma 1(i), and $\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)\overset{P}{\to}\gamma$; hence the stated limit, which is the variance in Theorem 2 (and Corollary 8).

*(i)* If $\lambda=0$, the bias $\beta\sum_j\omega_jd_j^{\rho}$ vanishes, so by Theorem 2 and Slutsky,
$$
Z_n:=\frac{\sqrt{k}}{D_n\,\widehat\sigma_n}\Big(\frac{\widehat\xi^{\,*}_n(1-p|\widehat\omega_n)}{\xi_{1-p}}-1\Big)\overset{d}{\longrightarrow}\mathcal{N}(0,1).
$$
Now $\xi_{1-p}\in\mathcal{I}_{n,1-\alpha}$ iff $\big|\log\big(\widehat\xi^{\,*}_n/\xi_{1-p}\big)\big|\le z_{1-\alpha/2}(D_n/\sqrt{k})\widehat\sigma_n$; since $\log(\widehat\xi^{\,*}_n/\xi_{1-p})=\big(\widehat\xi^{\,*}_n/\xi_{1-p}-1\big)(1+o_P(1))$ (consistency in relative terms, proof of Theorem 2), this event differs from $\{|Z_n|\le z_{1-\alpha/2}(1+o_P(1))\}$ by an asymptotically negligible amount, and its probability tends to $\mathbb{P}(|\mathcal{N}(0,1)|\le z_{1-\alpha/2})=1-\alpha$.

*(ii)* Identical argument with Corollary 8 in place of Theorem 2 (the limit is centred for any $\lambda$).

*Last claim.* With $\widehat\omega_{n,j}=k_j/k$: $k\sum_j(k_j/k)^2/k_j=\sum_jk_j/k=1$. $\blacksquare$

---

## 8. Equivalent designs, and why not the arithmetic mean

The central machine could organize the same transmitted information differently. Two natural competitors are
$$
\textbf{(E2)}\quad
\widehat\xi^{\,(2)}_n(1-p\,|\,\widehat\omega_n):=\varphi\big(\widehat\gamma_n(\widehat\omega_n)\big)\,\prod_{j=1}^m\big[\widehat q^{\,*}_j(1-p)\big]^{\widehat\omega_{n,j}}
$$
(pool the Weissman quantile estimators geometrically as in DPS, then apply the Bellini factor with the *pooled* Hill estimator), and
$$
\textbf{(E3)}\quad
\widehat\xi^{\,(3)}_n(1-p\,|\,\widehat\omega_n):=\varphi\big(\widehat\gamma_n(\widehat\omega_n)\big)\,\prod_{j=1}^m\Big[\Big(\frac{k_j}{n_jp}\Big)^{\widehat\gamma_n(\widehat\omega_n)}\widehat Q_j\Big]^{\widehat\omega_{n,j}}
$$
(use the pooled Hill estimator everywhere, including inside each machine's extrapolation — the analogue of DPS's "$\widehat q^{\,*}_j(1-p|k_j,\omega)$" design).

> **Proposition 10 (asymptotic equivalence of designs).** *Assume (A1)–(A4) and let $\widehat\omega_n\overset{P}{\to}\omega\in\mathcal{W}$, $\mathbf{1}^\top\widehat\omega_n=1$. Then, for $i\in\{2,3\}$,*
> $$
> \frac{\sqrt{k}}{D_n}\left(\frac{\widehat\xi^{\,(i)}_n(1-p\,|\,\widehat\omega_n)}{\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)}-1\right)=o_P(1),
> $$
> *so Theorems 2, 5, 6 and Corollaries 4, 7, 8, 9 hold verbatim for $\widehat\xi^{\,(2)}_n$ and $\widehat\xi^{\,(3)}_n$.*

**Proof.** Write $k_{\min}:=\min_jk_j$; by (A2), $k/k_{\min}=O(1)$.

*(E2).* On the $\log$ scale,
$$
\log\widehat\xi^{\,(2)}_n-\log\widehat\xi^{\,*}_n
=\log\varphi\big(\widehat\gamma_n(\widehat\omega_n)\big)-\sum_j\widehat\omega_{n,j}\log\varphi(\widehat\gamma_j).
$$
A second-order Taylor expansion of $\log\varphi$ around $\gamma$ (legitimate on an event of probability $\to1$, where all of $\widehat\gamma_j,\widehat\gamma_n(\widehat\omega_n)$ lie in a fixed compact subinterval of $(0,1)$ on which $(\log\varphi)''$ is bounded) gives
$$
\log\varphi(x)=\log\varphi(\gamma)+m(\gamma)(x-\gamma)+O\big((x-\gamma)^2\big)\quad\text{uniformly there},
$$
so, using $\sum_j\widehat\omega_{n,j}=1$ and $\widehat\gamma_n(\widehat\omega_n)=\sum_j\widehat\omega_{n,j}\widehat\gamma_j$,
$$
\log\widehat\xi^{\,(2)}_n-\log\widehat\xi^{\,*}_n
=m(\gamma)\Big[\widehat\gamma_n(\widehat\omega_n)-\sum_j\widehat\omega_{n,j}\widehat\gamma_j\Big]
+O_P\Big(\max_j(\widehat\gamma_j-\gamma)^2+\big(\widehat\gamma_n(\widehat\omega_n)-\gamma\big)^2\Big)
=0+O_P\big(k_{\min}^{-1}\big).
$$
Multiplying by $\sqrt{k}/D_n$: $O_P\big(\sqrt{k}/(k_{\min}D_n)\big)=O_P\big((k/k_{\min})\,k^{-1/2}D_n^{-1}\big)\cdot O(1)=o_P(1)$.

*(E3).* There is the additional term
$$
\sum_j\widehat\omega_{n,j}\big(\widehat\gamma_n(\widehat\omega_n)-\widehat\gamma_j\big)D_{n,j}
=D_n\underbrace{\sum_j\widehat\omega_{n,j}\big(\widehat\gamma_n(\widehat\omega_n)-\widehat\gamma_j\big)}_{=\;\widehat\gamma_n(\widehat\omega_n)-\widehat\gamma_n(\widehat\omega_n)\;=\;0}
+\sum_j\widehat\omega_{n,j}\big(\widehat\gamma_n(\widehat\omega_n)-\widehat\gamma_j\big)\,\delta_{n,j},
$$
with $\delta_{n,j}:=D_{n,j}-D_n\to-\log d_j$ bounded (Lemma 1(iv)). The first part vanishes *exactly* — this is the algebraic payoff of geometric pooling. The second is $O_P\big(k_{\min}^{-1/2}\big)$ since $\widehat\gamma_n(\widehat\omega_n)-\widehat\gamma_j=O_P(k_{\min}^{-1/2})$; multiplied by $\sqrt{k}/D_n$ it is $O_P\big(\sqrt{k/k_{\min}}/D_n\big)=o_P(1)$. Adding the (E2)-type Bellini-factor term, already shown to be negligible, completes the proof of the $\log$-scale equivalence; since both estimators are consistent in relative terms, the relative-error statement follows as before. $\blacksquare$

**Remark 4 (one more variant).** The "strength-borrowing" *marginal* estimator $\widehat\xi^{\,*}_j(1-p\,|\,k_j,\omega):=\varphi(\widehat\gamma_n(\omega))\,d_{n,j}^{\widehat\gamma_n(\omega)}\widehat Q_j$, in which a single machine's extrapolation is driven by the pooled tail index, satisfies, by the very same decomposition as in Theorem 1 with $\widehat\gamma_j$ replaced by $\widehat\gamma_n(\omega)$ in terms $T_1$–$T_2$,
$$
\frac{\sqrt{k}}{D_{n,j}}\Big(\frac{\widehat\xi^{\,*}_j(1-p|k_j,\omega)}{\xi_{1-p}}-1\Big)=\sqrt{k}\big(\widehat\gamma_n(\omega)-\gamma\big)+o_P(1):
$$
each machine inherits the *pooled* rate $\sqrt{k}/D_n$ instead of its own $\sqrt{k_j}/D_{n,j}$ (the terms $T_3$–$T_5$ remain $O_P(k_j^{-1/2})=O_P(k^{-1/2})$). This mirrors DPS, Section 2.3.

**Remark 5 (arithmetic pooling).** The naive convex combination $\widecheck\xi_n(1-p|\omega):=\sum_j\omega_j\widehat\xi^{\,*}_j(1-p)$ (with $\omega_j\ge0$) satisfies the *identical* first-order theory: indeed, exactly,
$$
\frac{\widecheck\xi_n(1-p|\omega)}{\xi_{1-p}}-1=\sum_j\omega_j\Big(\frac{\widehat\xi^{\,*}_j(1-p)}{\xi_{1-p}}-1\Big),
$$
and Theorem 1 plus the rescaling argument of Theorem 2 give the same limit. The preference for geometric pooling is therefore *not* first-order asymptotic but structural and second-order: (a) only geometric pooling is exactly linear in the transmitted Hill estimators on the $\log$ scale, which is what makes the exact cancellation in Proposition 10(E3) and the multiplicative bias correction of Corollary 8 possible; (b) log-scale inference is the recommended scale for extreme value statistics (Drees, 2003); (c) empirically, DPS (Section 5.1.1) find that geometric pooling of Weissman-type estimators outperforms arithmetic pooling by a wide margin in bias and MSE — the same mechanism (a multiplicative, heavily right-skewed estimator) operates verbatim here, with the additional skewed factor $\varphi(\widehat\gamma_j)$.

---

## 9. Summary of the procedure

**Communication protocol (one-shot).**

*Machine $j$* ($1\le j\le m$): choose $k_j$; compute and transmit
$$
T_j=\big(n_j,\;k_j,\;\widehat\gamma_j(k_j),\;X_{n_j-k_j:n_j,j}\big)
\qquad\big[\text{augmented: also }(\widehat\beta_j,\widehat\rho_j)\big].
$$

*Central machine:*

1. **Weights.** Variance-optimal: $\widetilde\omega^{(\mathrm{Var})}_n=(k_1/k,\ldots,k_m/k)$. AMSE-optimal (augmented protocol): build $\widetilde B_c,\widetilde V_c$ as in Section 6.4 and plug into Theorem 6(i) to get $\widetilde\omega^{(\mathrm{AMSE})}_n$.
2. **Pooled tail index.** $\widehat\gamma_n(\widehat\omega_n)=\sum_j\widehat\omega_{n,j}\widehat\gamma_j$.
3. **Pooled extreme expectile.**
$$
\widehat\xi^{\,*}_n(1-p\,|\,\widehat\omega_n)=\prod_{j=1}^m\Big[\big(\widehat\gamma_j^{-1}-1\big)^{-\widehat\gamma_j}\Big(\frac{k_j}{n_jp}\Big)^{\widehat\gamma_j}X_{n_j-k_j:n_j,j}\Big]^{\widehat\omega_{n,j}}
$$
(or, equivalently to first order, designs (E2)/(E3) of Proposition 10).
4. **Bias correction (optional, augmented protocol).** Multiply by $\exp\big(-(D_n/\sqrt{k})\,\widehat\omega_n^\top\widetilde B_c\big)$ (Corollary 8).
5. **Confidence interval.** $\check\xi_n\exp\big(\pm z_{1-\alpha/2}\,\widehat\sigma_n\log(k/(np))/\sqrt{k}\big)$ with $\widehat\sigma_n$ of Corollary 9; with variance-optimal weights, $\widehat\sigma_n=\widehat\gamma_n(\widetilde\omega^{(\mathrm{Var})}_n)$.

**Guarantees.** Rate $\sqrt{k}/\log(k/(np))$ — the rate of the infeasible benchmark using all $n$ observations with effective sample size $k$ (Theorems 1–2); benchmark variance $\gamma^2$ attained by $\widetilde\omega^{(\mathrm{Var})}_n$, with full asymptotic equivalence to the benchmark under near-equal sample fractions (Theorem 5); AMSE-optimality with the explicit threshold $\lambda_0$ beyond which the distributed estimator strictly *beats* the benchmark (Theorem 6); valid bias-corrected Gaussian inference at the central machine (Corollaries 8–9).

---

## 10. Discussion and possible extensions

**(a) Why only the Hill bias survives at the extreme level.** At an *intermediate* expectile level, QB estimation carries three first-order bias sources: the Hill bias, the second-order quantile bias, and the expectile–quantile gap bias (the $\lambda_1$- and $\lambda_2$-terms of Corollary 3.4 in Davison, Padoan and Stupfler, 2023). At the *extreme* level, all error sources of size $O_P(k_j^{-1/2})$ are divided by the diverging extrapolation factor $D_{n,j}$; only the term $(\widehat\gamma_j-\gamma)D_{n,j}$ keeps its size. The whole geometry of the problem thus collapses onto the pooled Hill estimator (Remark 2), which is what makes the DPS weighting theory portable. Conditions (A4) and $\rho<0$ are exactly what is needed to certify that the discarded terms are $O_P(k_j^{-1/2})$ and not larger.

**(b) LAWS is infeasible here — but nothing is lost at first order.** Asymmetric-least-squares (LAWS) estimation of $\xi_{\tau}$ at intermediate levels requires the raw subsamples, which the protocol forbids. One could augment the protocol by letting machine $j$ also transmit its intermediate LAWS expectile $\widetilde\xi_{\tau_j,j}$ and pool $\widetilde\xi_{\tau_j,j}\,d_{n,j}^{\widehat\gamma_j}$ geometrically; under the additional conditions of Theorem 3.5 of Davison, Padoan and Stupfler (2023) (notably $\gamma<1/2$), the same limit theory would result, because LAWS-based and QB-based *extrapolating* estimators are asymptotically equivalent at extreme levels (Davison, Padoan and Stupfler, 2023, Theorem 3.5; Padoan and Stupfler, 2022, Theorem 2.4). The QB route adopted here is thus both the only one compatible with the DPS heuristics *and* costless in first-order efficiency — and it works on all of $\gamma\in(0,1)$ rather than $\gamma\in(0,1/2)$.

**(c) Composite levels.** A popular device selects the expectile level $\tau'_n(p)$ with $\xi_{\tau'_n(p)}=q_{1-p}$, estimated by $1-\widehat\tau'_n(p)=p\,\widehat\gamma_n/(1-\widehat\gamma_n)$. In the pure QB construction this device *collapses algebraically*: replacing $1-p$ by $1-\widehat\tau'_n(p)$ in $\widehat\xi^{\,*}_n$ reproduces exactly the pooled Weissman quantile estimator of DPS, since $\varphi(\widehat\gamma)\big[(\widehat\gamma^{-1}-1)^{-1}\big]^{-\widehat\gamma}=1$. Composite estimation is therefore already covered by DPS, Corollary 9, and adds nothing new in the QB world.

**(d) Choice of $p$, $k_j$ and practical remarks.** The theory allows $np$ bounded (even $np\to0$), the regime of typical interest, e.g. $p=1/n$. The conditions on $k_j$ are the usual one-sample ones imposed machine-by-machine, plus proportionality; the variance-optimal weights $k_j/k$ require no extra estimation, while AMSE weights need the augmented protocol. The interval of Corollary 9 is asymmetric around the point estimate on the natural scale — appropriate for a right-skewed extrapolating estimator.

**(e) Extensions.**
1. *Serial dependence within machines.* Replacing Propositions A–B by their time-series versions under mixing and a tail dependence condition (Davison, Padoan and Stupfler, 2023, Sections 2 and 6; DPS, Section 4.1) changes only the variance constants ($\gamma^2\rightsquigarrow\gamma^2(1+2\sum_{t\ge1}R(t))$-type factors per machine); the architecture of Theorems 1–2 (the reduction to the pooled tail index estimator) is untouched. Optimal weights then involve the machine-level long-run variances, which machines would additionally transmit.
2. *Growing number of machines.* DPS, Section 3.3, develop $m=m_n\to\infty$ for the tail index and quantiles; the reduction principle of Theorem 2 suggests the expectile analogue holds under their conditions plus uniform-in-$j$ versions of (A3)–(A4); the bookkeeping of the $o_P(1)$ terms (now $m_n$ of them) would require uniform bounds in Theorem 1, e.g. via the tail empirical process arguments of Chen, Li and Zhou (2021).
3. *Heterogeneous distributions.* DPS's general Sections 2.2–2.3 allow different marginals with a common $\gamma$. For expectiles, machine-specific proportionality constants $\varphi(\gamma)$ would coincide but the targets $\xi_{1-p,j}$ would differ through scale; a common target must then be defined (e.g. the expectile of a designated reference machine), and the bias bookkeeping of $T_5$ becomes machine-specific. This is a natural thesis follow-up.

---

## References

- Bellini, F., Klar, B., Müller, A., Rosazza Gianin, E. (2014). Generalized quantiles as risk measures. *Insurance: Mathematics and Economics* 54, 41–48.
- Bingham, N.H., Goldie, C.M., Teugels, J.L. (1987). *Regular Variation*. Cambridge University Press.
- Chen, L., Li, D., Zhou, C. (2021). Distributed inference for the extreme value index. *Biometrika* 109(1), 257–264.
- Daouia, A., Girard, S., Stupfler, G. (2018). Estimation of tail risk based on extreme expectiles. *Journal of the Royal Statistical Society: Series B* 80(2), 263–292.
- Daouia, A., Girard, S., Stupfler, G. (2020). Tail expectile process and risk assessment. *Bernoulli* 26(1), 531–556.
- Daouia, A., Padoan, S.A., Stupfler, G. (2024). Optimal weighted pooling for inference about the tail index and extreme quantiles. *Bernoulli* 30(2), 1287–1312. (arXiv:2111.03173.) **[DPS]**
- Davison, A.C., Padoan, S.A., Stupfler, G. (2023). Tail risk inference via expectiles in heavy-tailed time series. *Journal of Business & Economic Statistics* 41(3), 876–889.
- de Haan, L., Ferreira, A. (2006). *Extreme Value Theory: An Introduction*. Springer.
- Drees, H. (2003). Extreme quantile estimation for dependent data, with applications to finance. *Bernoulli* 9(4), 617–657.
- Hill, B.M. (1975). A simple general approach to inference about the tail of a distribution. *Annals of Statistics* 3(5), 1163–1174.
- Newey, W.K., Powell, J.L. (1987). Asymmetric least squares estimation and testing. *Econometrica* 55(4), 819–847.
- Padoan, S.A., Stupfler, G. (2022). Joint inference on extreme expectiles for multivariate heavy-tailed distributions. *Bernoulli* 28(2), 1021–1048.
- Weissman, I. (1978). Estimation of parameters and large quantiles based on the $k$ largest observations. *Journal of the American Statistical Association* 73(364), 812–815.
