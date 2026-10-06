# Architecture

## Production platform contract

Diet Tracking is a **native iOS application written in Swift with SwiftUI**.

This is not an open platform-selection question.

Production architecture:

```
SwiftUI iOS application
        |
        v
application/use-case layer
        |
        +--------------------+
        |                    |
        v                    v
Swift Domain            Swift Analysis
        |                    |
        +---------+----------+
                  |
                  v
          Storage protocols
                  |
                  v
        local persistence adapter
```

Core rules:

- domain, analysis, validation, and storage protocols are Swift but **must not depend on SwiftUI**;
- use Swift Package Manager / separate Swift modules where practical so core behavior can run headlessly;
- SwiftUI owns presentation and user interaction only;
- no React Native, Flutter, Kotlin Multiplatform, embedded web app, or other production UI framework without a future architecture RFC;
- do not select a persistence technology in a way that leaks persistence-framework types into Domain/Analysis.

## Principle

Semantic correctness comes before presentation or monetization.

The first implementation should make the Swift domain engine runnable without SwiftUI or an advertising SDK. The iOS app and ad layer are adapters around a tested core.

## Suggested module boundaries

The exact target names may be refined by the bootstrap PR, but preserve these dependency directions.

### 1. DietTrackingDomain

Owns immutable concepts and validation rules:

- FoodItem
- FoodExposure
- MealLog
- SymptomEpisode
- DailyContextCheckIn
- CandidateSignal
- AnalysisReport

Dependencies: Swift standard/Foundation functionality only as necessary. No SwiftUI, persistence framework, networking SDK, or ad SDK.

### 2. DietTrackingLogging / Application

Owns commands/use cases for creating, editing, deleting, and querying:

- meals;
- symptom episodes;
- daily context check-ins.

It validates user-entered data and converts it into domain records.

No SwiftUI dependency.

### 3. DietTrackingStorage

Owns storage protocols plus adapters.

Initial direction: local-first storage. Tests must have an in-memory implementation.

Cloud sync is a later adapter and must not be required for analysis correctness.

### 4. DietTrackingAnalysis

Consumes normalized meal exposures, symptom windows, severity, and optional daily context.

It emits ranked candidate signals and must be deterministic for fixed data/configuration.

No SwiftUI dependency.

Stress and mental well-being are initially contextual variables. Whether they become model covariates requires an explicit RFC and regression validation.

### 5. DietTrackingValidation / tests

Owns fixtures, semantic acceptance tests, property/regression datasets, and Gate S3 harnesses.

This defines whether the product “works.”

### 6. iOS App / SwiftUI Presentation

Owns:

- SwiftUI app lifecycle;
- screens/navigation;
- meal/symptom/context entry;
- thermometer severity graph;
- accessibility;
- rendering candidate evidence.

It may not duplicate domain/analysis rules.

### 7. Advertising / Monetization

Owns ad-provider integration, ad placement contracts, consent/configuration, failure behavior, and monetization tests.

It must not own or read raw diet/symptom/stress/mental-wellbeing data.

Advertising failures must never break logging, persistence, or analysis.

## Data flow

```
SwiftUI input
  -> Logging/Application
  -> normalized Domain records
  -> Storage
             \
symptom window -> validation -> Storage
                              \
daily context -----------------> Analysis
                                  -> CandidateSignal[]
                                  -> SwiftUI presentation
```

Advertising stays outside the health-data path:

```
Ad provider -> Advertising adapter -> SwiftUI ad slot
```

No health-domain event is routed to the ad provider.

## Time semantics

Meals and symptom windows carry timezone context.

V0 analysis compares food exposure against symptom intervals using explicit lag-window semantics defined by RFC.

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
