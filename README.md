# Diet Tracking

A free, open-source personal food journal for discovering which foods or food combinations are **associated** with stomach discomfort.

> **Current contributor notice:** GitHub Actions runtime is exhausted. Required validation is performed on the maintainer's local Mac. Agents must record exact local test commands/results, or mark work `pending local Mac verification`. Use standard `grep` for repository text search rather than `rg`/`ag`/other alternatives.

The app’s core loop is:

1. log what you eat for each meal;
2. record simple meal attributes such as whether it was spicy;
3. log discomfort episodes using an approximate time window plus severity;
4. optionally complete an end-of-day summary with stomach discomfort, stress, and overall mental well-being;
5. after enough data, review a ranked shortlist of evidence-backed candidate associations.

The product does **not** diagnose disease or claim a food caused a symptom.

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
contracts
  -> domain + logging + storage
  -> symptom-window semantics + analysis + adversarial fixtures
  -> headless end-to-end acceptance (Gate S3)
  -> UI/UX
  -> monetization integration
  -> production hardening
```

The UI is deliberately not the source of truth. The eventual client must call a headlessly tested core.

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
- `docs/ARCHITECTURE.md` — module boundaries and data flow
- `docs/ANALYSIS_MODEL.md` — proposed association-ranking model
- `docs/VALIDATION_GATES.md` — S0–S3 semantic gates, then UI/monetization gates
- `docs/WORKSTREAMS.md` — teams, dependencies, and parallel work
- `docs/DECISIONS.md` — RFC/consensus protocol
- `docs/HANDOFF.md` — concise takeover format
- `CONTRIBUTING.md` — contribution workflow

## Current milestone

Gate S3: one headless command on the local Mac must prove **log -> persist -> reload -> analyze -> expected report**.

## Open source

This project is intended to remain free and open source. The exact license will be selected through an explicit RFC rather than silently assumed.
