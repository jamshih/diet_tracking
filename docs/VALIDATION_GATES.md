# Validation Gates

## Platform baseline

This is a native iOS **Swift + SwiftUI** project.

Core semantic gates must be runnable from the local Mac without interacting with the SwiftUI UI. SwiftUI tests complement semantic tests; they do not replace them.

## Validation authority while GitHub Actions is unavailable

GitHub Actions runtime is currently exhausted.

Until this notice is explicitly removed, a gate passes only from **local-Mac validation evidence**.

Rules:

- CI absence/failure caused by GitHub Actions availability does not count as product failure, but it also does not count as a pass;
- every claimed gate must record the exact command executed on the maintainer's Mac and the result;
- an agent without local-Mac access must mark validation `pending local Mac verification` and provide copy-pasteable commands;
- do not downgrade or skip semantic tests just because CI is unavailable;
- repository text-search instructions used during validation should use standard `grep`.

## P0 — Swift project bootstrap

Pass when local-Mac validation proves:

- the native iOS project opens/builds;
- the SwiftUI app target compiles;
- core Swift module/package tests run headlessly;
- SwiftUI is not imported by Domain/Analysis targets;
- a trivial core test passes;
- exact commands are documented.

## S0 — Contracts

Pass when:

- domain types are defined in UI-independent Swift;
- invalid scores and malformed meals/episodes are rejected;
- symptom-window uncertainty is represented explicitly;
- same input normalizes identically every time;
- analysis input/output schema is versioned.

## S1 — Logging + persistence

Pass when automated Swift tests prove:

- create/edit/delete meal;
- create/edit/delete symptom episode;
- create/update daily context;
- severity/stress/well-being bounds are validated;
- restart/reload preserves records;
- export then import round-trips without semantic loss;
- midnight/timezone/window-crossing fixtures behave as specified.

## S2 — Analysis semantics

Pass when deterministic Swift fixtures prove:

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

Pass when one command on the local Mac can:

1. seed a clean store from a fixture;
2. write meals, symptom episodes, and daily context through production Swift APIs;
3. reload the store;
4. run analysis;
5. compare the resulting report with an expected semantic snapshot.

At S3, the semantic product is considered functionally real.

## U0 — SwiftUI foundation

Only after S3:

- map screens to tested use cases;
- build meal logging;
- build approximate symptom-window + severity logging;
- build daily stress/well-being context meters;
- build thermometer severity visualization;
- render candidate evidence faithfully.

## U1 — UX acceptance

Pass when representative users can complete the core loop without developer guidance and without SwiftUI changing analysis semantics.

## M0 — Monetization isolation

Ads may be integrated only when:

- semantic functionality works with the ad subsystem disabled;
- no raw meal, symptom, stress, or mental-wellbeing fields are passed to the ad provider;
- ad load/failure cannot block logging or analysis;
- consent/privacy behavior is tested;
- ad placement does not obstruct symptom logging or urgent user actions.

## Regression rule

Every bug in domain, persistence, time handling, analysis, or monetization isolation must add a failing test/fixture before the fix is accepted.
