# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A data/content repository (not an application) that tracks a Yahoo! Pigskin Pick'em fantasy football league across seasons. Each season is a top-level directory (`2023-24/`, `2024-25/`, `2025-26/`, `2026-27/`, ...) containing a `README.md` and one folder per week with screenshots. The only "code" is a set of GitHub Actions workflows (and a local test harness for them) that enforce PR conventions and automate versioning.

## Commands

- `npm test` — runs `npm run test:workflows` (times the run)
- `npm run test:workflows` — runs `.github/test-workflows.sh`, which uses [act](https://github.com/nektos/act) to locally simulate the `pr-title-check`, `version-bump`, and `ghcr-cleanup` GitHub Actions workflows against fixture events in `.github/test-data/pr-events/`
- Requires Docker Desktop running and `act` installed (`brew install act` on macOS, v0.2.76+)
- There is no single-test flag; to test one workflow only, run its `act` invocation directly, e.g.:
  ```bash
  act pull_request -e .github/test-data/pr-events/minor.json -W .github/workflows/pr-title-check.yml --container-architecture linux/amd64 --pull=false --bind
  ```
- The test script auto-cleans `act-*` Docker containers on exit (see `.github/docs/act-testing.md`); some `version-bump`/`ghcr-cleanup` act runs are expected to show auth errors locally since they need real GitHub Actions credentials.

## Git workflow

- Branch names: `YYYY.MM.DD/descriptive-branch-name`, dated with the actual `date` command, never typed by hand. Never commit directly on `main`.
- PR titles must start with a conventional-commit type, optionally with `!` for breaking changes: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert` (e.g. `feat: add week 03 screenshots`). This is enforced by `.github/workflows/pr-title-check.yml`.
- On merge to `main`, `.github/workflows/version-bump.yml` inspects the merge commit message and bumps `package.json`'s version automatically via a bot-created PR: `feat!`/`fix!`/`refactor!` → major, `feat` → minor, anything else → patch. Don't hand-bump the version.
- Use the GitHub CLI (`gh`) for PR creation, based on `.github/pull_request_template.md`. Never close/recreate a PR to edit it — use `gh pr edit`.
- `.github/workflows/ghcr-cleanup.yml` runs weekly to prune old GHCR container image versions; unrelated to app code since this repo has no containers of its own to publish (this workflow was inherited from the template this repo was created from).

## Season/week content structure

- Each season directory has its own `README.md` embedding that season's weekly screenshots and season-specific info (Yahoo group ID/password, league URL).
- Within a season, weeks are folders named `week-01`, `week-02`, ... plus postseason folders (`postseason-wildcard`, `postseason-divisional`, `postseason-conference-championship`, `postseason-super-bowl`).
- Starting with the 2024-25 season, screenshots inside each week folder use fixed numeric names in a fixed order — **do not rename or reorder these**:
  - `01.png` — Standings
  - `02.png` — Group picks
  - `03.png` — Weekly performance
  - `04.png` — My picks
  - (The 2023-24 season predates this convention and instead uses descriptive names like `week-01-standings.png`; leave that season as-is.)
- The root `README.md` links to the current season's README as "this year's pick'em" plus links to prior seasons — update that pointer when a new season directory is added.
- When adding a new week's results, add the 4 screenshots to `weekly-name/`, then add a corresponding `### Week NN` (or postseason round) section to the season's `README.md`, following the existing entries' format exactly.
