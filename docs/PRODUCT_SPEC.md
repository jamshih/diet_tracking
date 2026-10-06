# Product Specification

## Mission

Build a free, open-source food journal that helps a person discover which foods or food combinations are associated with their own stomach discomfort.

The product is a self-observation tool, not a diagnostic system. It should surface evidence and uncertainty rather than make medical claims.

## Core loop

1. During the day, the user logs each meal.
2. A meal contains one or more food items and simple attributes such as whether it was spicy.
3. At the end of the day, the app asks for a stomach-discomfort score from 0 to 10.
4. After enough observations, the app ranks candidate associations.
5. The app explains why each candidate appears: exposure count, average difference, uncertainty, and whether the candidate is an individual item or combination.

## MVP semantic contract

A usable MVP must support, without depending on a polished UI:

- create/edit/delete a meal log;
- store meal timestamp and meal type;
- attach one or more food items to a meal;
- record at least a binary spicy attribute;
- record one daily 0–10 stomach-discomfort score;
- derive daily food exposures deterministically;
- rank individual-food candidates;
- rank pairwise-combination candidates when support is sufficient;
- never present a candidate without its evidence/support;
- export/import test data in a stable machine-readable form;
- reproduce the same analysis result from the same dataset.

## Non-goals for semantic MVP

- calorie counting;
- weight-loss coaching;
- nutrient optimization;
- disease diagnosis;
- telling the user a food “caused” a symptom;
- social features;
- cloud accounts;
- visual polish;
- AI-generated dietary advice.

## Candidate language

Preferred wording:

- “candidate association”
- “worth watching”
- “appeared on X higher-discomfort days”
- “limited evidence”
- “stronger evidence”

Avoid causal wording such as “this food caused your stomachache.”

## Individual vs combination signals

The engine should calculate both:

- **individual signals**: one normalized food item;
- **pair signals**: two items appearing on the same day.

Individual signals are always considered first. Pair signals require a higher evidence threshold because the search space grows quickly and sparse combinations are easy to overinterpret.

Triple-or-larger combinations are explicitly out of scope for the first production version.

## Success definition

Before UI/UX work starts, a headless acceptance suite must prove that a fixture dataset can be logged, persisted, reloaded, analyzed, and ranked correctly end-to-end.

See `docs/VALIDATION_GATES.md`.
