# Workstreams and Dependency Map

## Phase 0 — Repository contract

Status: infrastructure bootstrap.

Deliverables:
- product contract;
- architecture;
- analysis proposal;
- validation gates;
- agent workflow;
- initial RFC/task issues.

## Phase 1 — Semantic core

### A1. Domain model
Owner: Team A

Deliver:
- FoodItem / FoodExposure;
- MealLog;
- DailyCheckIn;
- CandidateSignal / AnalysisReport;
- validation and normalization rules.

Depends on: none.

### A2. Logging service
Owner: Team A

Deliver:
- create/edit/delete meal;
- create/update check-in;
- day projection APIs.

Depends on: A1.

### D1. Storage abstraction + in-memory store
Owner: Team D

Deliver:
- repository interfaces;
- deterministic in-memory adapter for tests;
- serialization contract.

Depends on: A1.

### D2. Durable local storage
Owner: Team D

Deliver:
- production local persistence adapter;
- migration/version strategy;
- import/export round-trip.

Depends on: D1.

## Phase 2 — Analysis + adversarial validation

### B1. Candidate enumeration
Owner: Team B

Deliver:
- individual candidates;
- pair candidates;
- support counts;
- configurable support thresholds.

Depends on: A1.

### B2. V0 scoring/ranking
Owner: Team B

Deliver:
- transparent effect estimate;
- low-support shrink/reliability weighting;
- evidence tier;
- deterministic ranking.

Depends on: B1 and analysis RFC consensus.

### C1. Synthetic truth fixtures
Owner: Team C

Create datasets for:
- one strong individual signal;
- neutral food;
- rare misleading food;
- true pair interaction;
- confounded-looking pair;
- constant outcome;
- missing days;
- midnight/timezone edges.

Depends on: A1.

### C2. Analysis acceptance suite
Owner: Team C

Verify expected candidate ordering and suppression rules.

Depends on: B2 + C1.

## Phase 3 — Headless integration

### E1. End-to-end semantic harness
Owner: Team E

One command must:
seed -> log -> persist -> reload -> analyze -> snapshot-check.

Depends on: A2, D2, B2, C2.

This is Gate S3.

## Phase 4 — UI/UX

### F1. UX architecture
Owner: Team F

Only after S3.

Define:
- meal logging interaction;
- spicy control;
- end-of-day check-in;
- candidate/evidence presentation;
- accessibility behavior.

### F2. Visual system
Owner: Team F

Only after interaction flow is validated.

## Phase 5 — Production hardening

- crash/error handling;
- backup/export;
- privacy review;
- accessibility;
- performance;
- open-source packaging;
- release checklist.

## Parallelism

Safe early parallel work:

- A1 and C1 can proceed together if C1 targets the written contracts.
- D1 can begin once A1 types stabilize.
- Analysis RFC debate can run while A1 is implemented.

Do not begin B2 before the scoring RFC is resolved.
Do not make F1/F2 the dominant work before S3.
