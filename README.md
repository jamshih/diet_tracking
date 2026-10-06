# Diet Tracking

A free, open-source **native iOS app built in Swift and SwiftUI** for discovering which foods or food combinations are **associated** with stomach discomfort.

> **Production platform contract:** this project is a native Apple-platform codebase. Production application code is written in **Swift**. The iOS presentation layer is **SwiftUI**. Core domain, analysis, validation, and storage contracts must remain independent of SwiftUI so they can be tested headlessly.
>
> **Current contributor notice:** GitHub Actions runtime is exhausted. Required validation is performed on the maintainer's local Mac. Agents must record exact local test commands/results, or mark work `pending local Mac verification`. Use standard `grep` for repository text search rather than `rg`/`ag`/other alternatives.

The app’s core loop is:

1. log what you eat for each meal;
2. record simple meal attributes such as whether it was spicy;
3. log discomfort episodes using an approximate time window plus severity;
4. optionally complete an end-of-day summary with stomach discomfort, stress, and overall mental well-being;
5. after enough data, review a ranked shortlist of evidence-backed candidate associations.

The product does **not** diagnose disease or claim a food caused a symptom.

## Technology contract

The production application is:

- **Platform:** native iOS;
- **Language:** Swift;
- **UI:** SwiftUI;
- **Core modularity:** Swift Package Manager / Swift modules where practical;
- **Testing:** headless Swift tests for domain/analysis/storage behavior, plus app/UI tests later;
- **Architecture rule:** SwiftUI views must not contain or duplicate analysis/domain rules.

Do not introduce React Native, Flutter, Kotlin Multiplatform, web-app shells, or another cross-platform production framework unless a future architecture RFC explicitly reverses this contract.

The minimum iOS deployment version and concrete persistence framework are implementation decisions and should not be silently coupled to the semantic model.

## Why symptom windows

Users should not be forced to remember an exact timestamp.

A symptom episode can be recorded as something like:

- ache window: 13:30–15:00;
- severity: 7/10.

The analysis can then reason about which meals occurred before a plausible symptom window rather than assigning one daily score to every meal.

## Daily context

The daily summary may also include:

- overall stomach discomfort, 0–10;
- stress, 0–10 where higher means more stressed;
- overall mental well-being, 0–10 where higher means better overall well-being.

These context variables are stored explicitly. They are not automatically interpreted as causes and are not automatically used to adjust the ranking model without an analysis RFC.

## Build strategy

We are building semantic correctness before visual polish.

```
native Swift project skeleton
  -> Swift domain + logging + storage modules
  -> symptom-window semantics + Swift analysis + adversarial fixtures
  -> headless end-to-end acceptance on local Mac (Gate S3)
  -> SwiftUI UX
  -> monetization integration
  -> production hardening
```

The SwiftUI layer is deliberately not the source of truth. It must call the tested Swift core.

## Candidate model

The first production analysis should consider both:

- individual food items;
- pairwise food combinations.

Pairs require stronger evidence and are penalized more heavily to reduce false discoveries from sparse data. The app should show multiple candidates with support and uncertainty rather than announcing one definitive culprit.

## Ads

The app may be supported by ads while remaining free and open source.

Advertising must be isolated from health inference. Diet logs, symptom episodes, stress, and mental-wellbeing data must not be used for ad personalization or exported to advertising systems merely for monetization.

## Repository map

- `AGENTS.md` — rules for agents/contributors and GitHub debate
- `docs/PRODUCT_SPEC.md` — semantic product contract
- `docs/ARCHITECTURE.md` — Swift module boundaries and data flow
- `docs/ANALYSIS_MODEL.md` — proposed association-ranking model
- `docs/VALIDATION_GATES.md` — S0–S3 semantic gates, then UI/monetization gates
- `docs/WORKSTREAMS.md` — teams, dependencies, and parallel work
- `docs/DECISIONS.md` — RFC/consensus protocol
- `docs/HANDOFF.md` — concise takeover format
- `CONTRIBUTING.md` — contribution workflow

## Current milestone

First bootstrap the native Swift project/module skeleton. Then Gate S3 must eventually prove **log -> persist -> reload -> analyze -> expected report** on the local Mac.

## Open source

This project is intended to remain free and open source. The exact license will be selected through an explicit RFC rather than silently assumed.

## Native iOS bootstrap

The implementation skeleton lives in `DietTracking.xcodeproj` and `Packages/DietTrackingCore`.

Core Swift targets:

- `DietTrackingDomain`
- `DietTrackingStorage`
- `DietTrackingAnalysis`
- `DietTrackingLogging`

See `docs/BUILD_AND_TEST.md` for exact local-Mac build, headless-test, and architecture-check commands.

