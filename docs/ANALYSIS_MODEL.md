# Analysis Model

## Goal

Produce a ranked shortlist of food-related candidates associated with higher self-reported stomach discomfort while showing enough evidence for the user to judge the result.

This is association discovery, not causal inference.

## Observation model

The analysis has two evidence sources.

### Primary: symptom episodes

Each episode has:

- an uncertain onset interval;
- severity, 0–10;
- timezone context.

Food exposures are evaluated relative to the episode using an explicit candidate lag window.

The exact lag weighting is not fixed in this document; it must be settled in an RFC.

### Fallback: daily summary

For days without useful symptom episodes, the model may use:

- daily overall discomfort, 0–10;
- food exposure by local calendar day.

This fallback must be distinguishable from episode-level evidence in the output.

## Context variables

Daily context may contain:

- stress, 0–10, higher = more stressed;
- overall mental well-being, 0–10, higher = better.

V0 stores these values but does not silently regress them out or use them to explain symptoms.

A later analysis RFC may test whether using these variables as covariates improves calibration without creating misleading conclusions.

## Exposure candidates

The engine evaluates:

- individual food items;
- unordered food pairs.

A pair is eligible only when both members fall inside the same defined pre-symptom exposure horizon for sufficient episodes.

High-order combinations remain out of scope.

## V0 transparent scoring

For each candidate, the scoring system should combine:

- repeated exposure before higher-severity episodes;
- comparison observations where the candidate was absent;
- support count;
- effect size;
- reliability/shrinkage;
- episode-window uncertainty.

The implementation must keep the exact scoring formula centralized and versioned.

A simple, explainable model is preferred until a more complex model demonstrably performs better on adversarial fixtures.

## Window uncertainty

A wide symptom onset window should contribute less precise temporal evidence than a narrow window.

The model must not collapse a 2-hour uncertainty window to its midpoint and behave as if the user supplied an exact time.

Possible approaches to debate:

- uniform probability across the interval;
- overlap-weighted exposure score;
- conservative earliest/latest bounds;
- sampling/integration across the interval.

This is an RFC decision.

## Minimum evidence rules

Exact constants are configuration.

Initial principles:

- individual candidates require repeated observations;
- pair candidates require stronger support than individuals;
- one-off exposures do not rank;
- wider symptom-time uncertainty should reduce confidence;
- daily-fallback evidence should be labeled separately;
- cap the visible shortlist rather than returning every positive association.

## Candidate output

Each `CandidateSignal` should include at least:

- stable candidate id;
- kind: `item` or `pair`;
- member food ids;
- episode support count;
- comparison count;
- daily-fallback support count if used;
- severity/effect summary;
- temporal confidence;
- reliability/confidence value;
- final ranking score;
- evidence tier;
- analysis-version identifier.

## Guardrails

The engine must not:

- claim causality;
- infer gastrointestinal or mental-health disease;
- recommend eliminating broad food groups as treatment;
- treat stress or mental well-being as proven causes;
- hide timing uncertainty;
- rank one-off foods;
- generate high-order sparse combinations.

## Future analysis questions

Track as RFCs:

- exact lag horizon and decay function;
- symptom duration versus onset uncertainty;
- stress/well-being as model covariates;
- portion size;
- spicy intensity;
- medication, sleep, menstrual cycle, alcohol, illness, exercise;
- user-confirmed aliases/categories;
- robust regression / Bayesian model;
- personalized experiment suggestions.
