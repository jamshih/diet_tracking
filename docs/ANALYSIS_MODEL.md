# Analysis Model

## Goal

Produce a ranked shortlist of food-related candidates associated with higher self-reported stomach discomfort while showing enough evidence for the user to judge the result.

This is association discovery, not causal inference.

## Observation unit

The initial model uses one row per local calendar day:

- outcome `y_d`: daily discomfort score, 0–10;
- food exposure `x[d, i]`: whether normalized food item `i` appeared that day;
- pair exposure `x[d, i, j]`: whether both items appeared that day;
- attributes: e.g. any spicy meal that day.

## V0 transparent scoring

For a candidate `c`:

- collect days where `c` is present;
- collect comparable observed days where `c` is absent;
- compute the difference between mean discomfort when present and absent;
- shrink/rate the result down when support is low;
- report support counts and uncertainty metadata;
- rank only positive associations.

The implementation must keep the exact scoring formula centralized and versioned.

A simple transparent score is preferred before introducing a more complex model. A later RFC may replace V0 with ridge/elastic-net, Bayesian shrinkage, or another repeated-measures model, but only if it beats the semantic fixtures and calibration tests.

## Minimum evidence rules

Exact constants are configuration, not magic numbers scattered through code.

Initial policy proposal:

- individual candidate: at least 3 exposed days and 3 non-exposed observed days;
- pair candidate: at least 3 co-exposed days and 5 non-exposed observed days;
- do not rank a candidate if all outcomes are identical;
- pair candidates should be penalized more strongly than individual candidates;
- cap the visible shortlist rather than returning every positive correlation.

These thresholds are deliberately conservative for an MVP and must be debated in the analysis RFC before being frozen.

## Candidate output

Each `CandidateSignal` should include at least:

- stable candidate id;
- kind: `item` or `pair`;
- member food ids;
- exposed-day count;
- comparison-day count;
- mean discomfort when present;
- mean discomfort when absent;
- raw difference;
- confidence/reliability value;
- final ranking score;
- evidence tier;
- analysis-version identifier.

## Evidence tiers

Suggested language:

- insufficient: not ranked;
- limited: meets minimum support, large uncertainty;
- moderate: repeated signal;
- stronger: repeated signal with materially better support.

Tier thresholds must be deterministic and tested.

## Guardrails

The engine must not:

- claim causality;
- infer a disease;
- recommend eliminating broad food groups as medical treatment;
- hide uncertainty;
- rank one-off foods;
- generate high-order combinations from sparse data.

## Future analysis questions

Track as RFCs, not ad-hoc changes:

- delayed/next-day symptom effects;
- meal-level symptom check-ins;
- portion size;
- spicy intensity instead of binary;
- medication, sleep, stress, menstrual cycle, alcohol, or illness confounders;
- user-confirmed aliases and food categories;
- robust regression / Bayesian model;
- personalized experiment suggestions.
