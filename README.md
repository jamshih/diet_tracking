# Diet Tracking

A free, open-source personal food journal for discovering which foods or food combinations are **associated** with stomach discomfort.

The app’s core loop is intentionally simple:

1. log what you eat for each meal;
2. record attributes such as whether the meal was spicy;
3. complete a daily 0–10 stomach-discomfort check-in;
4. after enough data, review a ranked shortlist of evidence-backed candidate associations.

The project does **not** diagnose disease or claim a food caused a symptom.

## Build strategy

We are building semantic correctness before visual polish.

```
contracts
  -> domain + logging + storage
  -> analysis + adversarial fixtures
  -> headless end-to-end acceptance (Gate S3)
  -> UI/UX
  -> production hardening
```

The UI is deliberately not the source of truth. The eventual client must call a headlessly tested core.

## Candidate model

The first production analysis should consider both:

- individual food items;
- pairwise food combinations.

Pairs require stronger evidence and are penalized more heavily to reduce false discoveries from sparse data. The app should show multiple candidates with support and uncertainty rather than announcing one definitive culprit.

## Repository map

- `AGENTS.md` — rules for agents/contributors and GitHub debate
- `docs/PRODUCT_SPEC.md` — semantic product contract
- `docs/ARCHITECTURE.md` — module boundaries and data flow
- `docs/ANALYSIS_MODEL.md` — proposed association-ranking model
- `docs/VALIDATION_GATES.md` — S0–S3 semantic gates, then UI gates
- `docs/WORKSTREAMS.md` — teams, dependencies, and parallel work
- `docs/DECISIONS.md` — RFC/consensus protocol
- `docs/HANDOFF.md` — concise takeover format
- `CONTRIBUTING.md` — contribution workflow

## Current status

Infrastructure/bootstrap only. No production app implementation is being treated as authoritative yet.

The next milestone is Gate S3: one headless command must prove **log -> persist -> reload -> analyze -> expected report**.

## Open source

This project is intended to remain free and open source. The exact license will be selected through an explicit RFC rather than silently assumed.
