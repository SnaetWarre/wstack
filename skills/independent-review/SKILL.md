---
name: independent-review
description: Read-only review of a branch diff before opening or updating a PR. Use when a shipping skill needs a second review and no host-native review command is available.
---

# Independent review

Review the requested diff without editing files, committing, posting comments, or changing the branch.

## Input

The caller should give you:

- The base ref or range to review.
- The user's goal or the originating request.
- Any proof already run.

If the base is missing, use the upstream default branch when one exists. If the goal is missing, infer it from commit messages and the PR body, and say that it is uncertain.

## Review

1. Read the repository instructions that apply, such as `AGENTS.md`.
2. Resolve the comparison ref. Run `git merge-base HEAD <base>`, then inspect `git diff <merge-base>..HEAD` so you review what would merge, not unrelated base-branch changes.
3. Inspect the whole diff, plus enough surrounding code, tests, and call sites to confirm each concern.
4. Check two things separately:
   - Defects: correctness, security, data loss, meaningful performance problems, and maintainability problems introduced by this change.
   - Intent: requested behavior that is missing or wrong, and material behavior the user did not ask for.
5. Confirm every finding from the code. Skip speculative concerns, pre-existing problems, intentional behavior changes, and style nits that tooling already handles.

## Report

Report findings first, ordered by severity. Use one entry per issue:

`[P1] Imperative finding title - path/to/file:line`

Use `P0` for a release blocker, `P1` for an urgent defect, `P2` for an ordinary defect, and `P3` for a low-impact issue. After the title, give one short paragraph with the affected scenario and evidence. Mark each finding as `defect` or `intent`.

If there are no findings, say `No findings.` Do not invent one. End with material test gaps or residual risks, or say there are none.
