# Contributing

Thank you for contributing.

## Current validation environment

GitHub Actions runtime is currently exhausted, so **GitHub Actions is not the project's validation authority right now**.

Required tests must pass on the maintainer's local Mac.

If you can run on that Mac, record the exact command and outcome. If you cannot, provide the exact validation command in your handoff and mark the work **pending local Mac verification**. Do not claim a pass based on an unavailable or infrastructure-failed CI run.

For repository text search, use standard `grep`, not `rg`, `ag`, `ack`, or another search utility. This keeps commands reproducible on the maintainer's machine.

Example:

```sh
grep -R -n --exclude-dir=.git "search term" .
```

## Development order

The project intentionally follows this order:

1. semantic contracts;
2. domain + persistence;
3. analysis + adversarial validation;
4. end-to-end headless acceptance;
5. UI/UX;
6. production hardening.

See `AGENTS.md` for the multi-agent workflow.

## Before opening a PR

- work from an issue;
- keep scope narrow;
- add tests for behavior changes;
- run the relevant semantic gates on the local Mac, or hand off the exact commands for local execution;
- document the actual validation state;
- document known limitations;
- include a concise handoff.

## Commit/PR preference

Use small, descriptive commits and focused PRs.

Suggested prefixes:

- `feat:`
- `fix:`
- `test:`
- `docs:`
- `refactor:`
- `chore:`

## Open-source conduct

Be critical of ideas, not contributors. Record technical disagreement in the relevant GitHub issue so later contributors can understand the tradeoff.
