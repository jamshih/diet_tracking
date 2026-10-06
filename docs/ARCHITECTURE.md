# Architecture

## Principle

Semantic correctness comes before presentation or monetization.

The first implementation should make the domain engine runnable without any mobile UI or advertising SDK. The eventual app client and ad layer are adapters around a tested core.

## Module boundaries

### 1. Domain

Owns immutable concepts and validation rules:

- FoodItem
- FoodExposure
- MealLog
- SymptomEpisode
- DailyContextCheckIn
- CandidateSignal
- AnalysisReport

No persistence, networking, UI, or advertising dependencies.

### 2. Logging

Owns commands for creating, editing, deleting, and querying:

- meals;
- symptom episodes;
- daily context check-ins.

It validates user-entered data and converts it into domain records.

### 3. Storage

Owns durable persistence behind an interface.

Initial target: local-first storage. Tests must also have an in-memory implementation.

Cloud sync is a later adapter and must not be required for analysis correctness.

### 4. Analysis

Consumes normalized meal exposures, symptom windows, severity, and optional daily context.

The analysis module emits ranked candidate signals and must be deterministic for a fixed dataset and configuration.

Stress and mental well-being are initially stored as contextual variables. Whether they become model covariates requires an explicit RFC and regression validation.

### 5. Validation

Owns fixtures, semantic acceptance tests, property tests, and regression datasets.

This module defines whether the product “works.”

### 6. Presentation

Blocked until the semantic gate passes.

The UI may not duplicate domain or analysis rules.

### 7. Advertising / Monetization

Owns ad-provider integration, ad placement contracts, consent/configuration, failure behavior, and monetization tests.

It must not own or read raw diet/symptom/stress/mental-wellbeing data.

Advertising failures must never break logging, persistence, or analysis.

## Data flow

```
raw meal input
  -> Logging validation
  -> normalized MealLog
  -> Storage
             \
symptom window -> validation -> Storage
                              \
daily context -----------------> Analysis
                                  -> CandidateSignal[]
                                  -> Presentation
```

Advertising is outside this path:

```
Ad provider -> Advertising adapter -> Presentation slot
```

No health-domain event is routed to the ad provider.

## Time semantics

Meals and symptom windows carry timezone context.

V0 analysis should compare food exposure against symptom intervals using explicit lag-window semantics defined by RFC.

A daily fallback remains available for days where the user does not create symptom episodes.

Tests must cover:

- meals near midnight;
- symptom windows crossing midnight;
- timezone changes;
- wide/uncertain windows;
- missing daily context.

## Symptom-window representation

Do not fabricate precision.

If a user says discomfort began “between 1:30 and 3,” store the interval itself.

The schema should distinguish:

- onset uncertainty interval;
- optional duration/end information if later collected.

If V0 only collects onset uncertainty, name fields accordingly rather than implying a duration.

## Food normalization

Do not silently merge arbitrary foods with fuzzy AI logic in the semantic MVP.

Start with transparent normalization:

- trim whitespace;
- case-fold;
- normalize repeated spaces;
- preserve original display label;
- allow explicit aliases later.

## Privacy default

Food, symptom, stress, and mental-wellbeing logs are sensitive personal data.

The default architecture is local-first, with no remote processing required to obtain candidate results.

The advertising module has a separate privacy boundary and must not receive these health-context fields for targeting or analytics.

Any future sync, telemetry, or ad personalization proposal requires explicit review.
