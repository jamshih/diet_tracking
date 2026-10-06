# AGENTS.md

This repository is designed for multiple coding/review agents working asynchronously.

## Production platform — mandatory

This is a **native iOS project written in Swift with SwiftUI**.

Unless an explicit architecture RFC later changes the decision:

- production application code uses Swift;
- presentation uses SwiftUI;
- Domain/Analysis/Storage contracts remain UI-independent Swift;
- prefer Swift Package Manager / separate Swift modules for the core where practical;
- do not introduce React Native, Flutter, Kotlin Multiplatform, a web shell, or another production framework;
- do not move semantic logic into SwiftUI views.

## Current execution constraint — local Mac validation only

**GitHub Actions runtime is currently exhausted. Do not rely on GitHub Actions as a validation gate.**

Until this notice is explicitly removed:

- required tests must pass on the maintainer's local Mac;
- do not treat a missing, skipped, queued, or infrastructure-failed GitHub Actions run as evidence that code passed;
- if you have access to the local Mac environment, run required validation there;
- if you do **not** have access, hand off exact commands and mark validation **pending local Mac verification**;
- never write "tests passed" unless the relevant commands actually completed successfully on the local Mac or their result was provided back;
- PRs/handoffs must record exact commands and result/output summary.

### Repository search tooling

For repository text searches, use standard `grep`.

Examples:

```sh
grep -R "CandidateSignal" .
grep -R -n "SymptomEpisode" .
grep -R -n --exclude-dir=.git "TODO" .
```

Do not assume or require `rg`, `ag`, `ack`, or another search tool.

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
  Owns UI-independent Swift food, meal, symptom-episode, daily-context types, normalization, commands, and time semantics.
- **Team B — Analysis**
  Owns UI-independent Swift temporal exposure, candidate generation, scoring, uncertainty/evidence metadata, ranking.
- **Team C — Validation**
  Owns Swift fixtures, acceptance tests, adversarial datasets, semantic regression gates.
- **Team D — Storage & Privacy**
  Owns Swift persistence protocols/adapters, local store, import/export, sensitive-data boundaries.
- **Team E — Integration / Maintainer**
  Owns Xcode/SwiftPM project structure, contracts between modules, architecture decisions, merge readiness, release gates.
- **Team F — Product UI/UX**
  Owns SwiftUI presentation, accessibility, interaction design, and user testing after S3.
- **Team G — Ads & Monetization**
  Owns iOS ad-provider adapters, placement contracts, consent/configuration, privacy-safe revenue instrumentation, and failure isolation.

An agent may temporarily serve multiple teams, but each PR must name the responsibility being exercised.

## Ads-team hard boundary

Team G must not receive or transmit raw food logs, symptom windows/severity, stress, mental-wellbeing scores, or candidate-analysis results for ad targeting or ad analytics.

## Debate protocol

Important design choices must be debated on GitHub.

Use an RFC/decision issue when changing:

- public domain schemas;
- symptom-time semantics;
- analysis formula/evidence thresholds;
- use of stress/well-being in analysis;
- normalization;
- persistence format/framework;
- privacy/network/ad behavior;
- Swift module boundaries;
- UI representation of evidence.

Reviewing agents must challenge assumptions, especially false correlations, data sparsity, fake timing precision, privacy leakage, and unwanted framework coupling.

Consensus means explicit agreement or documented disagreement plus a maintainer decision. Silence alone is not consensus.

## PR contract

Every implementation PR must include:

- linked issue/RFC;
- responsibility/team;
- semantic behavior changed;
- tests/fixtures added;
- exact local-Mac validation command(s), or an explicit pending-local-validation handoff;
- known limitations;
- concise handoff.

Do not merge a behavior change that lacks regression coverage and required local-Mac validation evidence.

## Handoff rule

Before stopping work, update the issue or PR with:

- **State:** done / partial / blocked;
- **Changed:** files/modules and behavior;
- **Validated:** exact local-Mac commands/tests and result, or `pending local Mac verification`;
- **Remaining:** smallest next tasks;
- **Risks:** assumptions, edge cases, disagreements;
- **Next agent:** which team should pick it up.

A new agent should be able to continue without reading chat history.

## Health-product constraint

This project surfaces personal associations. Do not introduce diagnostic claims, mental-health diagnosis, or medical-treatment recommendations. Candidate output must preserve uncertainty and supporting evidence.
