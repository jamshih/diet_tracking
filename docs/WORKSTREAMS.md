# Workstreams and Dependency Map

## Phase 0 — Repository contract

Deliverables:
- product contract;
- architecture;
- symptom-window semantics;
- analysis proposal;
- validation gates;
- agent workflow;
- privacy-safe monetization contract;
- initial RFC/task issues.

## Phase 1 — Semantic core

### A1. Domain model
Owner: Team A

Deliver:
- FoodItem / FoodExposure;
- MealLog;
- SymptomEpisode;
- DailyContextCheckIn;
- CandidateSignal / AnalysisReport;
- validation and normalization rules.

### A2. Logging service
Owner: Team A

Deliver:
- create/edit/delete meal;
- create/edit/delete symptom episode;
- create/update daily context;
- day/time-window projection APIs.

Depends on: A1.

### D1. Storage abstraction + in-memory store
Owner: Team D

Deliver:
- repository interfaces;
- deterministic in-memory adapter;
- serialization contract.

Depends on: A1.

### D2. Durable local storage
Owner: Team D

Deliver:
- production local persistence adapter;
- migration/version strategy;
- import/export round-trip.

Depends on: D1.

## Phase 2 — Temporal analysis + adversarial validation

### B1. Temporal exposure projection
Owner: Team B

Deliver:
- define exposures relative to uncertain symptom-onset windows;
- preserve uncertainty;
- support daily fallback observations.

Depends on: A1 + symptom-window RFC.

### B2. Candidate enumeration
Owner: Team B

Deliver:
- individual candidates;
- pair candidates;
- support counts;
- configurable thresholds.

Depends on: B1.

### B3. V0 scoring/ranking
Owner: Team B

Deliver:
- transparent effect estimate;
- temporal uncertainty weighting;
- low-support shrink/reliability;
- evidence tier;
- deterministic ranking.

Depends on: B2 + scoring RFC.

### C1. Synthetic truth fixtures
Owner: Team C

Create datasets for:
- strong individual signal;
- neutral food;
- rare misleading food;
- true pair interaction;
- under-supported pair;
- narrow vs wide symptom windows;
- meals inside/outside plausible lag horizons;
- high stress with neutral food;
- missing context;
- midnight/timezone edges.

### C2. Analysis acceptance suite
Owner: Team C

Verify expected candidate ordering and suppression rules.

Depends on: B3 + C1.

## Phase 3 — Headless integration

### E1. End-to-end semantic harness
Owner: Team E

One command must:
seed -> log meals/symptoms/context -> persist -> reload -> analyze -> snapshot-check.

Depends on: A2, D2, B3, C2.

This is Gate S3.

## Phase 4 — UI/UX

### F1. UX architecture
Owner: Team F

Define:
- meal logging;
- spicy control;
- symptom onset-window picker;
- severity meter;
- daily stress meter;
- daily mental-wellbeing meter;
- candidate/evidence presentation;
- accessibility behavior.

### F2. Visual system
Owner: Team F

Only after interaction flow is validated.

## Phase 5 — Ads & monetization

### G1. Monetization architecture
Owner: Team G

Deliver:
- ad-provider abstraction;
- contextual/non-personalized default;
- consent/configuration;
- zero health-data targeting contract;
- disabled/offline behavior.

Depends on: S3.

### G2. Ad placement
Owner: Team G + Team F

Deliver:
- placements that do not interrupt meal/symptom logging;
- loading/failure states;
- accessibility;
- no dark patterns.

Depends on: G1 + core UX.

### G3. Monetization validation
Owner: Team G + Team C/D

Verify:
- ad subsystem cannot read health-domain payloads;
- ad failure does not affect semantic functionality;
- no sensitive health-context fields appear in ad telemetry.

## Phase 6 — Production hardening

- crash/error handling;
- backup/export;
- privacy review;
- accessibility;
- performance;
- open-source packaging;
- release checklist.

## Parallelism

Safe early parallel work:

- A1 and C1 can proceed together.
- D1 can begin once A1 types stabilize.
- symptom-window and scoring RFC debate can run while A1 is implemented.

Do not begin B3 before the scoring RFC is resolved.
Do not make F1/F2 or Team G the dominant work before S3.
