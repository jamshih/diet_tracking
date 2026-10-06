# Product Specification

## Mission

Build a free, open-source food journal that helps a person discover which foods or food combinations are associated with their own stomach discomfort.

The product is a self-observation tool, not a diagnostic system. It should surface evidence and uncertainty rather than make medical claims.

## Core loop

1. During the day, the user logs each meal.
2. A meal contains one or more food items and simple attributes such as whether it was spicy.
3. When stomach discomfort occurs, the user may log a symptom episode using an approximate start/end time window and a 0–10 severity score.
4. At the end of the day, the app may ask for a brief daily context check-in:
   - overall stomach discomfort, 0–10;
   - stress, 0–10, higher = more stressed;
   - overall mental well-being, 0–10, higher = better.
5. After enough observations, the app ranks candidate food associations.
6. The app explains why each candidate appears, including evidence/support and uncertainty.

## MVP semantic contract

A usable MVP must support, without depending on polished UI:

- create/edit/delete a meal log;
- store meal timestamp, timezone context, and meal type;
- attach one or more food items to a meal;
- record at least a binary spicy attribute;
- create/edit/delete symptom episodes;
- symptom episode start/end may be approximate rather than exact;
- each symptom episode has severity from 0–10;
- record a daily summary with optional stomach, stress, and mental-wellbeing scores;
- derive food exposures relative to symptom windows deterministically;
- retain a daily-analysis fallback for days with no episode-level data;
- rank individual-food candidates;
- rank pairwise-combination candidates when support is sufficient;
- never present a candidate without its evidence/support;
- export/import test data in a stable machine-readable form;
- reproduce the same analysis result from the same dataset.

## Symptom episode semantics

A symptom episode is not required to have an exact onset.

At minimum it contains:

- local start bound;
- local end bound;
- timezone context;
- severity, 0–10.

Example:

```
possible onset: 13:30
possible end/onset bound: 15:00
severity: 7
```

The interval means the user believes the ache began sometime within that window. The system must preserve the uncertainty rather than replacing it with a fabricated exact timestamp.

A later RFC may distinguish onset uncertainty from symptom duration. V0 must keep that distinction explicit in the schema rather than guessing.

## Daily context

The daily context model may include:

- `overallDiscomfort`: 0–10, higher = worse;
- `stress`: 0–10, higher = more stressed;
- `mentalWellbeing`: 0–10, higher = better.

These are personal context observations, not diagnoses.

Stress and mental well-being must not automatically be used as causal explanations or statistical adjustment variables without a versioned analysis decision.

## Non-goals for semantic MVP

- calorie counting;
- weight-loss coaching;
- nutrient optimization;
- disease diagnosis;
- mental-health diagnosis;
- telling the user a food “caused” a symptom;
- social features;
- cloud accounts;
- visual polish;
- AI-generated dietary or psychological advice.

## Candidate language

Preferred wording:

- “candidate association”
- “worth watching”
- “appeared before X higher-severity episodes”
- “limited evidence”
- “stronger evidence”

Avoid causal wording such as “this food caused your stomachache.”

## Individual vs combination signals

The engine should calculate both:

- **individual signals**: one normalized food item;
- **pair signals**: two items within a defined exposure window.

Individual signals are always considered first. Pair signals require a higher evidence threshold because the search space grows quickly and sparse combinations are easy to overinterpret.

Triple-or-larger combinations are explicitly out of scope for the first production version.

## Advertising principle

Ads are allowed as a way to keep the project free.

However:

- food logs are not ad-targeting data;
- symptom episodes are not ad-targeting data;
- stress and mental-wellbeing scores are not ad-targeting data;
- advertising code must be isolated from the analysis domain;
- the semantic MVP must work without the ad subsystem.

Contextual/non-personalized advertising is preferred for the first production version.

## Success definition

Before UI/UX and monetization work become the main focus, a headless acceptance suite must prove that fixture data can be logged, persisted, reloaded, analyzed, and ranked correctly end-to-end.

See `docs/VALIDATION_GATES.md`.
