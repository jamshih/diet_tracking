# Architecture

## Principle

Semantic correctness comes before presentation.

The first implementation should make the domain engine runnable without any mobile UI. The eventual app client is an adapter around a tested core, not the place where business logic lives.

## Module boundaries

### 1. Domain

Owns immutable concepts and validation rules:

- FoodItem
- FoodExposure
- MealLog
- DailyCheckIn
- CandidateSignal
- AnalysisReport

No persistence, networking, or UI dependencies.

### 2. Logging

Owns commands for creating, editing, deleting, and querying meal/check-in records.

It validates user-entered data and converts it into domain records.

### 3. Storage

Owns durable persistence behind an interface.

Initial target: local-first storage. Tests must also have an in-memory implementation.

Cloud sync is a later adapter and must not be required for analysis correctness.

### 4. Analysis

Consumes normalized daily exposures plus daily discomfort scores and emits ranked candidate signals.

The analysis module must be deterministic for a fixed dataset and configuration.

### 5. Validation

Owns fixtures, semantic acceptance tests, property tests, and regression datasets.

This module defines whether the product “works.”

### 6. Presentation

Blocked until the semantic gate passes.

The UI can later choose platform-specific technologies, but it may not duplicate domain or analysis rules.

## Data flow

```
raw meal input
  -> Logging validation
  -> normalized MealLog
  -> Storage
  -> daily exposure projection
  -> Analysis
  -> CandidateSignal[]
  -> Presentation
```

Daily check-in:

```
0..10 score
  -> validation
  -> Storage
  -> Analysis joins by local calendar day
```

## Time semantics

The daily outcome is tied to the user’s local calendar day.

A meal belongs to a day according to the timezone captured for that event. Tests must cover meals near midnight and timezone changes.

The first analysis version uses same-day exposure because the symptom label is daily. Lagged effects can be added later only through an explicit decision record.

## Food normalization

Do not silently merge arbitrary foods with fuzzy AI logic in the semantic MVP.

Start with transparent normalization:

- trim whitespace;
- case-fold;
- normalize repeated spaces;
- preserve the original display label;
- allow explicit aliases later.

“fried chicken” and “chicken” remain different unless a rule or user action merges them.

## Privacy default

Food and symptom logs are sensitive personal data. The default architecture is local-first, with no analytics or remote processing required to obtain candidate results.

Any future sync or telemetry work must be isolated behind interfaces and reviewed separately.
