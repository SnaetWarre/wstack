---
name: bug-hunt
description: Hunt for major, verified bugs across the whole codebase, then fix each one in its own T3 thread, ship it as a PR with ship-pr, and merge when CI is green. Run by hand once in a while to catch regressions.
disable-model-invocation: true
argument-hint: "[minimum number of bugs, default 7] [optional focus area]"
---

# Bug hunt

The user's request, as they wrote it:

> Find as many major issues in this codebase as possible: backend, frontend, middleware, anything. Once you find one and know a really good and easy fix, start a new thread inside T3 Code to fix it, and ship it in a PR using my ship-pr skill. If all CI passes, get it merged; I don't read the code anyway. Go for at least 7. They should be real issues, not hallucinations, so double-check by running pieces of code, Playwright, or whatever computer-use tool works best.

Arguments: `$ARGUMENTS` (a number sets the minimum bug count; any other text is a focus area).

## 1. Hunt (do this yourself, don't spawn search agents)

- Read the project docs (README, `docs/codebase-map.md`, CLAUDE.md/AGENTS.md) and `git log` since the last bug hunt, so recently changed code gets the most attention.
- Start with the paths that hurt most if they break: data writes, the race/timing flow, undo, startup and migrations, replication/failover, imports and exports. Then cover the UI.
- Prefer untested paths. Run `npm test` and the Playwright suite (`npm run build`, then `node scripts/validation/run.mjs`) early. A green suite tells you where the bugs are not.
- Good bug sources: concurrent or stale screens (two laptops, queued clicks), restart/startup code that runs outside the replicated write path, undo after unusual sequences, ties in ordering where client and server sort differently, quick double presses, real-world input files (Excel ANSI CSVs, short rows, accented names), and exports opened in Excel.
- Skip style nits, speculative security issues without a realistic attacker, and anything that is deliberate according to docs or comments.

## 2. Verify every bug before it counts

A bug counts only after you reproduced it. Record the exact repro and its output.
- DB/server logic: a small `.mts` script outside the repo that imports `server/db.ts` with a temporary `DATA_PATH` and `NODE_ENV=test`, run with `node --import tsx`.
- HTTP behaviour: build, seed with `node --import tsx scripts/seed-test-db.mjs --scenario=live --data-path=$PWD/.test-data/<name>` (the seed script only accepts paths inside the repo), start `dist-server/server/index.js` on a spare port with `CLUSTER_ENABLED=false BACKUP_ENABLED=false`, and use curl.
- UI: headless Playwright. Put the probe script temporarily in `scripts/validation/` so it resolves `playwright`, and delete it afterwards. Never show windows on the user's screen.
- Track server PIDs and kill them by PID. Never use `pkill -f`/`pgrep -f`. Clean up `.test-data/<name>` afterwards.

## 3. Fix: one T3 thread per bug

For each verified bug that has a good, easy fix, call `t3_thread_launch` with:
- `workspaceStrategy: {"type":"worktree","baseRef":"main","branch":"fix/<slug>","startFromOrigin":false}`
- a self-contained `message`: what the bug is, the verified repro and its actual vs expected output, the intended fix and its scope, the regression test to add, and the rules below.

Rules to put in every thread prompt (the thread runs in a different worktree path, so it does not see this project's memory):
- It is already in its own worktree; don't create another one.
- Invoke the `ship-pr` skill to ship the PR, using the repo PR template.
- Lint and format with oxlint/oxfmt (`npm run lint`, `npm run format`), never ESLint/Prettier. Run `npm test` and `npm run check`, plus `npm run test:e2e` for critical flows.
- No attribution in commits or PRs. Dutch user-facing text. No left accent borders.
- Headless GUI only; `unset ELECTRON_RUN_AS_NODE` before launching Electron; no `pkill -f`.
- Call `link_pull_request` after creating the PR.
- Merge only after every required check passes and `mergeStateStatus` is `CLEAN` (in Apolloon that is the "All checks" job), using `gh pr merge --squash --delete-branch`. On conflicts, rebase on origin/main, re-run the checks, and wait for CI again.

When two fixes touch the same file, say so in both prompts so each keeps its diff focused.

## 4. Report

Give the user a short list with each bug, how you verified it, and its thread, then the PR and merge state as the threads finish. Say plainly which threads are still running or failed. Never claim a merge you did not see.
