# AGENTS.md

This repository is designed for multiple coding/review agents working asynchronously.

## Prime directive

Do not optimize presentation before semantic correctness.

Until Validation Gate S3 passes, prioritize domain behavior, persistence, analysis correctness, fixtures, and integration over UI polish.

## Start-of-task protocol

Every agent must:

1. read `README.md`, `docs/PRODUCT_SPEC.md`, `docs/ARCHITECTURE.md`, and `docs/VALIDATION_GATES.md`;
2. inspect open GitHub issues before inventing new work;
3. choose one unblocked issue or clearly scoped subtask;
4. comment on the issue with:
   - what you are taking;
   - expected files/modules touched;
   - assumptions or questions;
5. avoid overlapping another active agent unless intentionally reviewing/challenging that work.

## Team model

Agents work by responsibility, not by permanent identity.

- **Team A — Domain & Logging**
  Owns domain types, normalization, meal/check-in commands, time semantics.
- **Team B — Analysis**
  Owns candidate generation, scoring, uncertainty/evidence metadata, ranking.
- **Team C — Validation**
  Owns fixtures, acceptance tests, adversarial datasets, semantic regression gates.
- **Team D — Storage & Privacy**
  Owns persistence interfaces, local store, import/export, privacy boundaries.
- **Team E — Integration / Maintainer**
  Owns contracts between modules, architecture decisions, merge readiness, release gates.
- **Team F — Product UI/UX**
  Begins substantive implementation only after S3. Owns presentation, accessibility, interaction design, and user testing.

An agent may temporarily serve multiple teams, but each PR must name the responsibility being exercised.

## Debate protocol

Important design choices must be debated on GitHub, not buried in private notes.

Use an RFC/decision issue when a choice changes:

- public domain schemas;
- analysis formula or evidence thresholds;
- time semantics;
- normalization semantics;
- persistence format;
- privacy/network behavior;
- module boundaries;
- UI representation of evidence.

An RFC must contain at least:

1. problem;
2. constraints;
3. at least two viable options when alternatives exist;
4. arguments for/against;
5. concrete tests that distinguish the options;
6. proposed decision;
7. dissent or unresolved risks.

Reviewing agents must challenge assumptions, especially around false correlations and data sparsity.

Consensus means either:

- reviewers explicitly agree; or
- disagreements are documented and the maintainer records why one option was chosen.

Silence alone is not consensus.

## PR contract

Every implementation PR must include:

- linked issue/RFC;
- responsibility/team;
- semantic behavior changed;
- tests/fixtures added;
- validation command(s);
- known limitations;
- concise handoff.

Do not merge a behavior change that lacks regression coverage.

## Handoff rule

Before stopping work, update the issue or PR with a concise handoff containing:

- **State:** done / partial / blocked;
- **Changed:** files/modules and behavior;
- **Validated:** exact commands/tests and result;
- **Remaining:** smallest next tasks;
- **Risks:** assumptions, edge cases, disagreements;
- **Next agent:** which team should pick it up.

A new agent should be able to continue without reading chat history.

## Scope discipline

Prefer small vertical slices.

Good:
- domain types + tests;
- one storage adapter + round-trip tests;
- one scoring implementation + fixtures.

Bad:
- domain + database + UI + redesign + analytics in one PR.

## Health-product constraint

This project surfaces personal associations. Do not introduce diagnostic claims or medical-treatment recommendations. Candidate output must preserve uncertainty and supporting evidence.
