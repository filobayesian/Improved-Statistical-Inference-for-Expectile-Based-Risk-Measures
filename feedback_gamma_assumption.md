# Feedback on the \(\gamma<1/2\) Assumption

## Executive verdict

Your thesis is **not completely wrong** because it assumes

\[
\gamma<1/2.
\]

That assumption is mathematically safe. It is a **stronger-than-necessary restriction** for the quantile-based plug-in route, not an invalid assumption.

The issue is one of **generality and interpretation**. If the thesis says, or strongly suggests, that \(\gamma<1/2\) is required for the expectile--quantile bridge or for the QB plug-in estimator, then that statement should be corrected.

The sharper distinction is:

\[
\boxed{\text{Expectile existence / expectile--quantile proportionality / QB route: } 0<\gamma<1,}
\]

subject to finite first-moment conditions, whereas

\[
\boxed{\text{Direct LAWS expectile estimation: typically } 0<\gamma<1/2,}
\]

or stricter under some dependence assumptions.

## Main correction

The condition \(\gamma<1/2\) is **not required** for the basic high-expectile/high-quantile proportionality. In the heavy-tailed case, the first-order bridge has the form

\[
\xi_\tau \sim \psi(\gamma) Q_X(\tau),
\qquad
\psi(\gamma)=\left(\gamma^{-1}-1\right)^{-\gamma},
\]

and the natural tail-index condition for this bridge is

\[
0<\gamma<1,
\]

with finite first-moment assumptions such as \(\mathbb E X^-<\infty\). The endpoint \(\gamma<1\) corresponds to finite mean in the heavy-tailed setting.

The restriction

\[
\gamma<1/2
\]

belongs mainly to **direct LAWS expectile estimators**, because those estimators involve tail averages and squared-loss behaviour. Their asymptotic theory often needs finite-variance-type control. This is why the direct LAWS asymptotic variance contains terms such as

\[
\frac{2\gamma^3}{1-2\gamma},
\]

which diverge as \(\gamma\uparrow1/2\).

## Important rate-condition correction

When discussing the QB plug-in route, the relevant CLT-scale condition should be written with \(\sqrt{k}\), not \(k\). The clean zero-limit version is

\[
\frac{\sqrt{k}}{Q_X(\tau_n)}\to0.
\]

More generally, one may allow

\[
\frac{\sqrt{k}}{Q_X(\tau_n)}\to\lambda_Q\in\mathbb R.
\]

Writing

\[
\frac{k}{Q_X(\tau_n)}\to0
\]

is stronger than necessary and is not the natural CLT-scale condition for the QB expectile estimator.

For the thesis, the safest version is to keep the zero-limit condition

\[
\frac{\sqrt{k}}{Q_X(\tau_n)}\to0,
\]

because it removes the explicit first-moment term from the limiting distribution. If a finite nonzero limit \(\lambda_Q\) is allowed, then the intermediate expectile CLT may acquire an additional deterministic bias term involving \(\mathbb E X\lambda_Q\). That extra term would need to be carried consistently through the theory.

## Consequence for the thesis

The current assumption

\[
\gamma\in(0,1/2)
\]

makes the results conservative. It does **not** make them false.

Your Chapter 4 estimator is a QB/Weissman-type plug-in estimator, not a direct LAWS estimator. Therefore, the natural expectile-side tail-index range for Chapter 4 is closer to

\[
\gamma\in(0,1),
\]

provided the other assumptions are retained: finite first moment, second-order regular variation, pooling assumptions, positivity/log-domain conditions, and the QB rate condition.

So the correct interpretation is:

> The thesis proves a valid result under \(\gamma<1/2\), but the QB-based contribution can likely be stated under the wider finite-mean range \(0<\gamma<1\). The \(\gamma<1/2\) restriction should not be presented as intrinsic to the expectile--quantile bridge or to the QB plug-in method.

## Where the thesis currently overrestricts

Based on the current source files, the relevant locations are:

1. **Chapter 2, expectile--quantile bridge**  
   The basic proportionality is already correctly stated under \(\gamma\in(0,1)\). This should be preserved.

2. **Chapter 2, QB CLT statement**  
   The QB theorem is currently stated under \(\gamma\in(0,1/2)\). This should be revised to \(\gamma\in(0,1)\), with the appropriate finite first-moment and rate conditions.

3. **Chapter 3, standing assumptions**  
   The pooled intermediate expectile theory currently imposes \(\gamma\in(0,1/2)\). Since the estimator is QB-based, this can likely be relaxed to \(\gamma\in(0,1)\), provided the QB rate condition is retained.

4. **Chapter 4, standing assumptions**  
   The pooled extreme expectile estimator is also QB-based. The assumption \(\gamma\in(0,1/2)\) is safe but overly restrictive. The natural assumption is \(\gamma\in(0,1)\), again with the condition

   \[
   \frac{\sqrt{k}}{Q_X(\tau_n)}\to0.
   \]

## Recommended textual changes

### 1. Replace any claim that \(\gamma<1/2\) is required for expectile--quantile equivalence

Use wording like:

```tex
The first-order expectile--quantile equivalence requires finite first
moments and, in the heavy-tailed case considered here, corresponds to
\(0<\gamma<1\). The stronger restriction \(0<\gamma<1/2\) is not needed
for this bridge; it is needed when invoking direct LAWS expectile CLTs
or finite-variance-type arguments.
```

### 2. Split the LAWS and QB regimes in Chapter 2

Use a structure like:

```tex
For direct LAWS expectile estimation, the usual asymptotic normality
requires \(0<\gamma<1/2\), together with the required lower-tail moment
condition.

For the quantile-based plug-in estimator, the natural tail-index range is
\(0<\gamma<1\), together with finite first-moment conditions and the
rate condition
\[
  \frac{\sqrt{n(1-\tau_n)}}{Q_X(\tau_n)}\to0,
\]
or the corresponding finite-limit version.
```

In the pooled notation with \(k=n(1-\tau_n)\), this becomes

\[
\frac{\sqrt{k}}{Q_X(\tau_n)}\to0.
\]

### 3. Revise the Chapter 3 and Chapter 4 standing assumptions

A suitable Chapter 4 assumption block would be:

```tex
The common margin satisfies \(\mathcal C_2(\gamma,\rho,A)\) with
\(0<\gamma<1\) and \(\rho<0\), is strictly increasing near its upper
endpoint, and satisfies \(\mathbb E X^-<\infty\). We impose
\[
  \frac{\sqrt{k}}{Q_X(\tau_n)}\to0,
\]
so that the first-moment term in the expectile--quantile expansion is
negligible. The stronger restriction \(0<\gamma<1/2\) is only needed
when direct LAWS estimators are invoked.
```

If you retain the stronger lower-tail moment condition

\[
\mathbb E|\min(X,0)|^{2+\delta}<\infty,
\]

say explicitly that it is stronger than necessary for the QB route but convenient for comparison with the direct LAWS literature.

### 4. Be careful with finite nonzero limits

If you choose to write

\[
\frac{\sqrt{k}}{Q_X(\tau_n)}\to\lambda_Q\in\mathbb R,
\]

then the proof and theorem statements should retain the corresponding deterministic bias term. For a clean thesis presentation, the zero-limit version

\[
\frac{\sqrt{k}}{Q_X(\tau_n)}\to0
\]

is preferable.

## Implications for simulations

You do **not** need to rerun the simulations solely because of this issue. Values such as

\[
\gamma=0.25
\qquad\text{and}\qquad
\gamma=1/3
\]

lie inside both regimes:

\[
(0,1/2)\subset(0,1).
\]

The simulation choices are therefore valid. What should change is the interpretation. Instead of saying that these choices are required by expectile theory, say that they lie in the LAWS-safe finite-variance subrange and are convenient for comparison with the standard LAWS/QB simulation literature.

A useful sentence would be:

```tex
The simulation design focuses on \(\gamma<1/2\), which is the finite-variance
subrange relevant for direct LAWS expectile estimators. The QB estimator,
however, is naturally defined and theoretically available over the wider
finite-mean range \(0<\gamma<1\), subject to the additional rate conditions
stated in the theory.
```

## Suggested change to the limitations/future-work discussion

Do not write that very heavy tails \(\gamma\ge1/2\) are outside the expectile--quantile equivalence. That would be false for \(\gamma\in[1/2,1)\).

Use instead:

```tex
This thesis focuses empirically on the finite-variance subrange
\(0<\gamma<1/2\), which is the natural range for comparison with direct
LAWS expectile estimators. Since the proposed estimator follows the
quantile-based plug-in route, extending the finite-sample study to heavier
finite-mean tails \(\gamma\in[1/2,1)\) would be a natural next step. In
that regime, the expectile--quantile bridge remains available, but the
standard LAWS finite-variance CLTs no longer apply in the same form.
```

## Bottom line

Your thesis is not wrong. It is **overrestrictive**.

The current theory under

\[
\gamma\in(0,1/2)
\]

is a valid special case. The sharper thesis-level statement is that the QB-based pooled expectile estimator should be supportable under

\[
\gamma\in(0,1),
\]

provided the finite first-moment, second-order, pooling, positivity, and QB rate assumptions are retained.

The main repair is textual and theorem-assumption-level, not a collapse of the argument. The most important edits are:

1. stop attributing \(\gamma<1/2\) to the expectile--quantile bridge;
2. assign \(\gamma<1/2\) specifically to LAWS/direct expectile estimation;
3. state the QB route under \(0<\gamma<1\);
4. use the correct QB rate condition \(\sqrt{k}/Q_X(\tau_n)\to0\), not \(k/Q_X(\tau_n)\to0\);
5. keep the zero-limit version unless you are prepared to carry an extra first-moment bias term.
