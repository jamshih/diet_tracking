# Validation Gates

## Why this file exists

The project separates “does it work?” from “does it look good?” and “does it monetize?”

No UI/UX or advertising implementation should become the main workstream until Gate S3 passes.

## S0 — Contracts

Pass when:

- domain types are defined;
- invalid scores and malformed meals/episodes are rejected;
- symptom-window uncertainty is represented explicitly;
- same input normalizes identically every time;
- analysis input/output schema is versioned.

## S1 — Logging + persistence

Pass when automated tests prove:

- create/edit/delete meal;
- create/edit/delete symptom episode;
- create/update daily context;
- severity/stress/well-being bounds are validated;
- restart/reload preserves records;
- export then import round-trips without semantic loss;
- midnight/timezone/window-crossing fixtures behave as specified.

## S2 — Analysis semantics

Pass when deterministic fixtures prove:

- a clearly associated synthetic item ranks near the top;
- a neutral item does not rank as harmful;
- a sparse one-off item is suppressed;
- a true pair interaction can surface as a pair candidate;
- a misleading pair with inadequate support is suppressed;
- meal timing relative to symptom window changes evidence appropriately;
- wider onset uncertainty does not become fake precise evidence;
- stress/well-being context does not silently alter rankings unless a versioned model explicitly enables it;
- ranking is stable for identical input;
- candidate evidence fields match the underlying data.

## S3 — End-to-end headless acceptance

Pass when one command can:

1. seed a clean store from a fixture;
2. write meals, symptom episodes, and daily context through production domain APIs;
3. reload the store;
4. run analysis;
5. compare the resulting report with an expected semantic snapshot.

At S3, the semantic product is considered functionally real.

## U0 — UI foundation

Only after S3:

- choose client platform/framework;
- map screens to tested use cases;
- build meal logging;
- build approximate symptom-window + severity logging;
- build daily stress/well-being context meters;
- render candidate evidence faithfully.

## U1 — UX acceptance

Pass when representative users can complete the core loop without developer guidance and without the UI changing analysis semantics.

## M0 — Monetization isolation

Ads may be integrated only when:

- semantic functionality works with the ad subsystem disabled;
- no raw meal, symptom, stress, or mental-wellbeing fields are passed to the ad provider;
- ad load/failure cannot block logging or analysis;
- consent/privacy behavior is tested;
- ad placement does not obstruct symptom logging or urgent user actions.

## Regression rule

Every bug in domain, persistence, time handling, analysis, or monetization isolation must add a failing test/fixture before the fix is accepted.
