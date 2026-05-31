# Feedback on Sections 3.1--3.2 and the Appendix Proof

**Scope reviewed.** I reviewed `03_pooled_intermediate.tex`, focusing on Section 3.1 (`Setup and notation`, lines 18--167), Section 3.2 (`The pooled QB expectile estimator`, lines 169--380), and the appendix proof of Proposition 3.1 in `main.tex` (lines 42--255). Line numbers below refer to the uploaded files.

## Overall verdict

The material is conceptually strong and mostly internally coherent: the chapter clearly motivates the QB route, separates the Hill and Weissman primitives, and gives a credible first-order equivalence argument for constructions (A) and (B). However, I would **not yet pass these sections as thesis-ready**. Several claims are currently overstated, one methodological assertion in Section 3.2 is mathematically too strong, and the appendix proof does not cover all claims stated in Proposition 3.1. The main fixes are not cosmetic; they affect the formal validity and precision of the exposition.

## Must-fix issues

### 1. Define the global asymptotic index `n` before using it

**Location:** `03_pooled_intermediate.tex`, lines 44, 103--107.

You repeatedly write “as `n \to \infty`” and assume `n(1-\tau_n) \to \infty`, but Section 3.1 does not define `n`. Since the chapter has samples of sizes `n_j`, a reader needs to know whether

\[
 n = \sum_{j=1}^m n_j,
\]

or whether `n` is merely a generic asymptotic index. This matters because later rate conditions use both `k = \sum_j k_j` and `n(1-\tau_n)`.

**Required fix.** Add a sentence near lines 40--55 such as:

```tex
Let n \coloneqq \sum_{j=1}^{m} n_j. All asymptotics are taken along a triangular array with fixed m, n_j \to \infty, k_j \to \infty, k_j/n_j \to 0, and k \coloneqq \sum_j k_j.
```

If `n` is not the total sample size, say so explicitly and adjust the intermediate-level condition accordingly.

### 2. The moment-negligibility condition is described as too mild

**Location:** `03_pooled_intermediate.tex`, lines 83--101.

The condition

\[
\frac{\sqrt{k}}{Q_X(\tau_n)} \to 0
\]

is not just a harmless heavy-tail regularity condition. Under the equal-fraction heuristic `1-\tau_n \asymp k/n` and regular variation `Q_X(\tau_n) \asymp (n/k)^\gamma`, it becomes roughly

\[
\frac{\sqrt{k}}{Q_X(\tau_n)} \asymp \frac{k^{1/2+\gamma}}{n^\gamma} \to 0.
\]

If `k = n^\beta`, this requires

\[
\beta < \frac{2\gamma}{1+2\gamma}.
\]

For example, at `\gamma = 1/4`, this requires `\beta < 1/3`; at `\gamma = 0.4`, it requires `\beta < 4/9`. That is a meaningful undersmoothing/rate restriction on `k`, not merely a mild consequence of heaviness of the tail.

**Required fix.** Replace the sentence “It is mild in the heavy-tailed regime...” with a more precise statement. For example:

```tex
This condition is an additional rate restriction linking the tail level and the effective sample size. Under the equal-fraction scaling 1-\tau_n \asymp k/n and Q_X(\tau_n) \asymp (n/k)^\gamma, it requires k^{1/2+\gamma}/n^\gamma \to 0, so it should be viewed as an undersmoothing-type condition rather than an automatic consequence of heavy-tailedness.
```

### 3. The claim that construction (B) has no two-weight analogue is overstated

**Location:** `03_pooled_intermediate.tex`, lines 188--195.

You write that once two weights are allowed, construction (B) “has no direct analogue” and that the two-weight machinery is “therefore necessarily (A)-only.” This is too strong. A natural two-weight componentwise-geometric analogue exists:

\[
\widetilde\xi_{\tau_n}^{(B_2)}(\bm\omega_\gamma,\bm\omega_q)
=
\left\{\prod_{j=1}^{m}\psi(\hat\gamma_j)^{\omega_{\gamma,j}}\right\}
\left\{\prod_{j=1}^{m}\hat q_j^\star(\tau_n\mid k_j)^{\omega_{q,j}}\right\}.
\]

Then

\[
\log\frac{\widehat\xi_{\tau_n}^{(A)}(\bm\omega_\gamma,\bm\omega_q)}
{\widetilde\xi_{\tau_n}^{(B_2)}(\bm\omega_\gamma,\bm\omega_q)}
=
\log\psi\!\left(\sum_j \omega_{\gamma,j}\hat\gamma_j\right)
-
\sum_j \omega_{\gamma,j}\log\psi(\hat\gamma_j),
\]

which is exactly the same type of Taylor remainder as in Proposition 3.1, now using `\bm\omega_\gamma`. For deterministic normalized weights, it is again `O_p(k^{-1})`.

The real distinction is not that no two-weight version of (B) exists. The distinction is that the original local-QB compression “one local expectile scalar per machine” does not preserve separate Hill and quantile weights.

**Required fix.** Rephrase the claim. A defensible version would be:

```tex
The literal local-QB construction (B), understood as first compressing each sample to one QB scalar and then pooling those scalars with a single weight vector, does not preserve separate Hill and Weissman weights. One can define a componentwise two-weight geometric variant, but it is asymptotically equivalent to (A) at the \sqrt{k} scale by the same Taylor argument. We therefore adopt (A) because it is algebraically simpler and directly exposes the two primitive weight vectors.
```

This fix would make the section mathematically safer while preserving your choice of (A).

### 4. Proposition 3.1 states an estimated-weight extension that the appendix proof does not prove

**Location:** statement in `03_pooled_intermediate.tex`, lines 288--292; proof in `main.tex`, lines 42--255.

The appendix proof is explicitly for a **deterministic** weight vector; see `main.tex`, lines 46--50. It never proves the random-weight extension stated in Proposition 3.1.

The extension is probably true under the stated consistency condition, but it needs to be proved or removed from the proposition. In particular, for random weights `\hat{\bm\omega}` with exact normalization, you need to use `\hat{\bm\omega}=O_p(1)` and repeat the Taylor expansion conditionally/on a joint high-probability event. If exact normalization is relaxed, an additional first-order term appears.

Let `f(g)=\log\psi(g)`, `\delta_j=\hat\gamma_j-\gamma`, and `s_n=\hat{\bm\omega}^\top\bm 1`. A Taylor expansion gives the schematic form

\[
 f\!\left(\sum_j \hat\omega_j\hat\gamma_j\right)
 - \sum_j \hat\omega_j f(\hat\gamma_j)
 =
 (s_n-1)\{\gamma f'(\gamma)-f(\gamma)\}
 + O_p(k^{-1})
 + o_p(k^{-1/2}),
\]

provided `\hat{\bm\omega}=O_p(1)` and `\hat\gamma_j-\gamma=O_p(k^{-1/2})`. Thus exact normalization gives the `O_p(k^{-1})` claim; approximate normalization gives only the `o_p(k^{-1/2})` claim when

\[
\sqrt{k}\,|s_n-1| \to_p 0.
\]

**Required fix.** Add a final paragraph or lemma to `app:proofs:A-B-equiv` proving the estimated-weight extension. Alternatively, remove the estimated-weight sentence from Proposition 3.1 and defer it to the confidence-interval section where Slutsky arguments are already discussed.

### 5. Section 3.2 says the Weissman factor is identical even when the displayed (A) has two weights

**Location:** `03_pooled_intermediate.tex`, lines 259--263.

The sentence “The Weissman factor is identical in the two formulae” is only true when construction (A) is evaluated at matched single weights, i.e.

\[
(\bm\omega_\gamma,\bm\omega_q)=(\bm\omega,\bm\omega).
\]

As written, (A) has two weights and (B) has one. The sentence can therefore be misread as claiming identity between `\hatWei_n(\tau_n\mid\bm\omega_q)` and `\hatWei_n(\tau_n\mid\bm\omega)` for arbitrary weights.

**Required fix.** Change the sentence to something like:

```tex
When construction (A) is restricted to matched weights (\bm\omega_\gamma,\bm\omega_q)=(\bm\omega,\bm\omega), the Weissman factor is identical in (A) and (B); the only remaining difference is whether \log\psi is applied after linear pooling of the Hill estimators or before geometric pooling.
```

## Major issues to address

### 6. The setup says “common marginal distribution,” but the surrounding language suggests only tail homogeneity

**Location:** `03_pooled_intermediate.tex`, lines 21--24 and 40--44.

You assume all samples have the same marginal distribution `F`, not merely a common tail index. That is a much stronger condition than tail homogeneity. It is also stronger than what a reader may expect from “multi-study evidence synthesis” or from a later test of tail homogeneity.

**Required fix.** Decide which assumption is intended:

- If you truly need a common marginal `F`, keep it, but stop describing the setting as merely tail-homogeneous. Say “common-distribution distributed inference” or “iid-across-machines after splitting.”
- If common `\gamma` is enough for the pooling theory, weaken the assumption and define sample-specific `F_j`, `Q_j`, and expectile targets. Then the target cannot be a single common `\xi_{\tau_n}` unless further alignment assumptions are added.

At minimum, add one sentence explaining why the common-marginal assumption is deliberate and what would break under merely common `\gamma`.

### 7. The “we restate assumptions” promise is not fulfilled

**Location:** `03_pooled_intermediate.tex`, lines 32--38 and 53--55.

You say that you restate the assumptions used throughout, but then you refer to `\eqref{eq:bg:pool-rates}` without restating it. Later results use constants such as `c_j`, `\Vc`, and bias vectors inherited from the background chapter. A reader reviewing Chapter 3 in isolation cannot verify rates or dimensions.

**Required fix.** Restate the exact proportionality assumptions in Section 3.1, even if briefly. For example:

```tex
We assume k_1/k_j \to c_j \in (0,\infty), j=1,\ldots,m, and [state the corresponding n_j condition if used]. Consequently k_j \asymp k and \sqrt{k/k_j}\to [explicit constant].
```

This would also make the appendix proof easier to audit, because `main.tex`, lines 181--187, uses `k_j \asymp k` directly.

### 8. The statement “only expectile estimator” is too categorical

**Location:** `03_pooled_intermediate.tex`, lines 125--148.

The claim that QB is “the only expectile estimator” constructible from the communicated primitives is rhetorically effective but mathematically too broad. One could construct many artificial transformations from `\hat\gamma_j` and `\hat q_j^\star`. What you mean is narrower: among the two thesis estimators under comparison, LAWS is unavailable under the communication protocol, while QB is available.

**Required fix.** Replace “the only expectile estimator” with something like:

```tex
the only one of the thesis' two intermediate-expectile constructions that can be assembled from the communicated pooling primitives is the QB plug-in...
```

This avoids an unnecessary universal claim.

### 9. Positivity/log-domain conditions should cover both Weissman and `\psi(\hat\gamma)` factors

**Location:** `03_pooled_intermediate.tex`, lines 223--231 and 247--258; appendix proof `main.tex`, lines 92--122.

Section 3.2 correctly discusses positivity of local Weissman factors, but construction (B) also contains powers of `\psi(\hat\gamma_j)`, and the proof relies on `\hat\gamma_j,\hat\gamma_n\in(0,1)` to define `\log\psi`. The appendix handles this, but the main text only flags positivity of the Weissman terms.

**Required fix.** In the main text, after the Weissman positivity paragraph, add that all log-scale statements involving `\psi(\hat\gamma_j)` are also restricted to the high-probability event on which the local and pooled Hill estimators lie in `(0,1)`. This would align Section 3.2 with the proof.

### 10. The proof of Proposition 3.1 is valid for deterministic weights, but the good-event argument should be tightened

**Location:** `main.tex`, lines 92--122 and 204--210.

The proof works, but the presentation is slightly loose. The event `E_n` only ensures membership in `(0,1)`, not boundedness away from 0 and 1. You later obtain `m'(\tilde\gamma_j)=O_p(1)` from convergence to `\gamma`, which is correct, but the proof would be clearer if you explicitly used a compact neighborhood.

**Recommended revision.** Define, for some fixed `\eta>0` with `\eta<\gamma<1-\eta`,

\[
E_{n,\eta}=\{\hat\gamma_j\in[\eta,1-\eta]\ \forall j,\ \hat\gamma_n(\bm\omega)\in[\eta,1-\eta]\}.
\]

Then `P(E_{n,\eta})\to1` and `\sup_{g\in[\eta,1-\eta]}|m'(g)|<\infty`. This gives a cleaner deterministic bound on the Lagrange factors and avoids relying on an implicit `O_p(1)` argument for random intermediate points.

## Medium-level exposition and notation issues

### 11. Clarify whether weights are affine or convex

**Location:** `03_pooled_intermediate.tex`, lines 201--231 and throughout Section 3.2.

You allow real weights satisfying only `\bm\omega^\top\bm 1=1`. This is an affine constraint, not a simplex constraint in the usual nonnegative sense. Later language sometimes sounds like ordinary averaging/geometric averaging. Negative weights are allowed by the formulas, but they change the intuition and affect Jensen-type statements.

**Required fix.** Use “affine weights” or explicitly say “we impose only the sum-to-one constraint; weights need not be nonnegative.” If later sections impose nonnegativity, state that separately.

### 12. Avoid the phrase “independent applications of `\psi`”

**Location:** `03_pooled_intermediate.tex`, lines 263--268.

“Independent applications” can be confused with probabilistic independence. Use “componentwise applications” or “separate applications.”

### 13. The proof conclusion repeats itself

**Location:** `main.tex`, lines 212--255.

Lines 212--217 and 219--227 repeat the same `O_p(k^{-1})` conclusion. This is harmless, but the appendix is already long. Remove one of the repetitions.

### 14. Minor notation inconsistency for the pooled Weissman estimator

**Location:** `03_pooled_intermediate.tex`, lines 9--12 versus lines 216--220.

The overview writes `\hatWei_n(\,\cdot\,;\bm\omega_q)`, while the estimator definition uses `\hatWei_n(\tau_n \mid \bm\omega_q)`. Pick one convention. Since the local Weissman uses `\mid k_j`, the vertical bar notation is acceptable, but consistency matters.

### 15. The long first paragraph in Section 3.1 should be split

**Location:** `03_pooled_intermediate.tex`, lines 21--38.

This paragraph carries setup, exception handling, oracle-equivalence conditions, imported CLTs, and a roadmap distinction about finite-log versus diverging-log Weissman limits. It is dense. Split it into two paragraphs: one for standing assumptions and one for imported/background results.

## Suggested edits to the appendix proof

The deterministic-weight proof is basically correct. I would revise it as follows:

1. Replace the open-interval good event by a compact good event `E_{n,\eta}`.
2. Add a final paragraph proving the random-weight extension.
3. Distinguish the two claims:
   - exact normalization gives `O_p(k^{-1})` for the unscaled log-ratio;
   - approximate normalization with `\sqrt{k}|\hat{\bm\omega}^\top\bm1-1|\to_p0` gives only the required `o_p(k^{-1/2})` result, not necessarily `O_p(k^{-1})`.

A possible final paragraph is:

```tex
The same argument applies to random weights \hat{\bm\omega} satisfying
\hat{\bm\omega}\to_p\bm\omega and \hat{\bm\omega}^\top\bm1=1. Indeed,
\|\hat{\bm\omega}\|=O_p(1), so the weighted Hill deviation remains
O_p(k^{-1/2}) and the weighted sum of squared local deviations remains
O_p(k^{-1}). If s_n=\hat{\bm\omega}^\top\bm1 is not exactly one, Taylor
expansion around \gamma produces the additional term
(s_n-1)\{\gamma m(\gamma)-\log\psi(\gamma)\}; hence
\sqrt{k}|s_n-1|\to_p0 is sufficient for the \sqrt{k}-scaled log-ratio
to converge to zero.
```

Check the sign and notation in the displayed constant before inserting it; with `f=\log\psi`, the constant is `\gamma f'(\gamma)-f(\gamma)`.

## Recommended revised logical framing for Section 3.2

The cleanest version of Section 3.2 would be:

1. Define the communicated primitives.
2. Define the canonical pooled estimator (A) with two weights.
3. Explain that the literal local-QB estimator (B) exists only as a single-weight compression.
4. State that at matched weights, (A) and (B) are `\sqrt{k}`-equivalent.
5. Acknowledge that a two-weight componentwise-geometric variant exists but is also `\sqrt{k}`-equivalent to (A), so choosing (A) is a notational and structural convenience rather than a mathematical necessity.

This preserves your intended methodology while removing the one overclaim that a strict examiner is likely to challenge.

## Final assessment

The core idea of Sections 3.1--3.2 is good, and the deterministic version of Proposition 3.1 is essentially sound. The main work before submission is to tighten the asymptotic setup, tone down universal claims, and align the proposition statement with what the appendix actually proves. The most important single correction is the two-weight discussion around construction (B): as written, it invites a straightforward counterexample/alternative definition, even though that alternative does not damage your estimator.
