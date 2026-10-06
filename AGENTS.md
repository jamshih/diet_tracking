# AGENTS.md

This repository is designed for multiple coding/review agents working asynchronously.

## Prime directive

Do not optimize presentation or monetization before semantic correctness.

Until Validation Gate S3 passes, prioritize domain behavior, persistence, symptom-window semantics, analysis correctness, fixtures, and integration over UI polish or ad revenue.

## Start-of-task protocol

Every agent must:

1. read `README.md`, `docs/PRODUCT_SPEC.md`, `docs/ARCHITECTURE.md`, and `docs/VALIDATION_GATES.md`;
2. inspect open GitHub issues before inventing new work;
3. choose one unblocked issue or clearly scoped subtask;
4. comment on the issue with what you are taking, files/modules, assumptions/questions;
5. avoid overlapping another active agent unless intentionally reviewing/challenging that work.

## Team model

- **Team A — Domain & Logging**
  Owns food, meal, symptom-episode, daily-context types, normalization, commands, and time semantics.
- **Team B — Analysis**
  Owns temporal exposure, candidate generation, scoring, uncertainty/evidence metadata, ranking.
- **Team C — Validation**
  Owns fixtures, acceptance tests, adversarial datasets, semantic regression gates.
- **Team D — Storage & Privacy**
  Owns persistence interfaces, local store, import/export, sensitive-data boundaries.
- **Team E — Integration / Maintainer**
  Owns contracts between modules, architecture decisions, merge readiness, release gates.
- **Team F — Product UI/UX**
  Begins substantive implementation only after S3. Owns presentation, accessibility, interaction design, and user testing.
- **Team G — Ads & Monetization**
  Owns ad-provider adapters, ad placement contracts, consent/configuration, revenue instrumentation that does not expose health-context data, and monetization failure isolation.

An agent may temporarily serve multiple teams, but each PR must name the responsibility being exercised.

## Ads-team hard boundary

Team G must not receive or transmit raw:

- food logs;
- symptom windows or severity;
- stress scores;
- mental-wellbeing scores;
- candidate-analysis results

for ad targeting or ad analytics.

Any proposal to relax this boundary requires a dedicated privacy RFC and maintainer approval. The default assumption is contextual/non-personalized advertising.

## Debate protocol

Important design choices must be debated on GitHub.

Use an RFC/decision issue when a choice changes:

- public domain schemas;
- symptom-time semantics;
- analysis formula/evidence thresholds;
- use of stress/well-being in analysis;
- normalization semantics;
- persistence format;
- privacy/network/ad behavior;
- module boundaries;
- UI representation of evidence.

Reviewing agents must challenge assumptions, especially false correlations, data sparsity, fake timing precision, and privacy leakage.

Consensus means explicit agreement or documented disagreement plus a maintainer decision. Silence alone is not consensus.

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

Before stopping work, update the issue or PR with:

- **State:** done / partial / blocked;
- **Changed:** files/modules and behavior;
- **Validated:** exact commands/tests and result;
- **Remaining:** smallest next tasks;
- **Risks:** assumptions, edge cases, disagreements;
- **Next agent:** which team should pick it up.

A new agent should be able to continue without reading chat history.

## Health-product constraint

This project surfaces personal associations. Do not introduce diagnostic claims, mental-health diagnosis, or medical-treatment recommendations. Candidate output must preserve uncertainty and supporting evidence.
