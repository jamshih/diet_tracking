# Decision Process

## Decision classes

### Inline decision

Use a normal task/PR discussion for reversible implementation details that do not change a public contract.

### RFC decision

Open a GitHub RFC issue for any semantic or architectural choice listed in `AGENTS.md`.

## RFC lifecycle

`PROPOSED -> CHALLENGED -> CONSENSUS -> IMPLEMENTED`

An RFC may also end as `DEFERRED` or `REJECTED`.

### PROPOSED

Author states the problem, constraints, options, tests, and preferred option.

### CHALLENGED

At least one reviewer attempts to falsify the proposal using counterexamples, data sparsity, failure modes, or maintainability concerns.

### CONSENSUS

The issue records:

- chosen option;
- why;
- rejected alternatives;
- remaining risks;
- acceptance tests.

### IMPLEMENTED

A merged PR links back to the RFC and the issue records the implementation reference.

## Required early RFCs

1. V0 candidate scoring and evidence thresholds.
2. Food normalization / alias policy.
3. Timezone and day-boundary semantics.
4. Local persistence format and migration policy.
5. Open-source license.
6. Eventual UI platform/framework, but only near Gate S3.

## Analysis-specific rule

For statistical/inference changes, reviewers must test at least one adversarial dataset where a naive approach gives a misleading ranking.

No formula is accepted solely because it “seems reasonable.”
