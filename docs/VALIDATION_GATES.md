# Validation Gates

## Why this file exists

The project separates “does it work?” from “does it look good?”

No UI/UX implementation should become the main workstream until Gate S3 passes.

## S0 — Contracts

Pass when:

- domain types are defined;
- invalid scores and malformed meals are rejected;
- same input normalizes identically every time;
- analysis input/output schema is versioned.

## S1 — Logging + persistence

Pass when automated tests prove:

- create/edit/delete meal;
- create/update one daily check-in;
- restart/reload preserves records;
- export then import round-trips without semantic loss;
- midnight/timezone fixtures behave as specified.

## S2 — Analysis semantics

Pass when deterministic fixtures prove:

- a clearly harmful synthetic item ranks near the top;
- a neutral item does not rank as harmful;
- a sparse one-off item is suppressed;
- a true pair interaction can surface as a pair candidate;
- a misleading pair with inadequate support is suppressed;
- ranking is stable for identical input;
- candidate evidence fields match the underlying data.

## S3 — End-to-end headless acceptance

Pass when one command can:

1. seed a clean store from a fixture;
2. write meals and check-ins through production domain APIs;
3. reload the store;
4. run analysis;
5. compare the resulting report with an expected semantic snapshot.

At S3, the product is considered functionally real.

## U0 — UI foundation

Only after S3:

- choose client platform/framework;
- map screens to already-tested use cases;
- build logging and daily check-in flows;
- render candidate evidence faithfully.

## U1 — UX acceptance

Pass when representative users can complete the core loop without developer guidance and without the UI changing analysis semantics.

## Regression rule

Every bug in domain, persistence, time handling, or analysis must add a failing test/fixture before the fix is accepted.
