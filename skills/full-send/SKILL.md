---
name: full-send
description: Take a change all the way to a merged PR while nobody watches the thread. Use when the user says "full send".
---

# Full send

The user said "full send" because they are not watching this thread. They read your final message long after you stop. You own the work from its current state to a merged PR.

## Pick the ship skill

1. If the repo has its own ship skill, use it. Look in the repo's `.claude/skills/` for a folder named `ship-*-pr` (for example `ship-myapp-pr`), or a skill whose description says to use it instead of `ship-pr`. Read its `SKILL.md` and follow it from start to merge.
2. Otherwise, use `ship-pr` (`~/.claude/skills/ship-pr/SKILL.md`).

Run it in its "full send" mode. If the chosen skill has no such mode, follow the "Full send and full stop" section of `ship-pr` on top of it.

## Permission

This request is the permission to:

- merge the PR once the ship skill's merge checks pass;
- force-push this task's own branch with `--force-with-lease` after a rebase;
- run the app, a browser, or screenshots to prove the change, without asking first.

It does not cover anything outside the repo: production, a deploy, a release, deleting data, or another person's branch. Ask before those, the way `ship-pr` says.

## Report

The PR link, the merge commit you saw on the base branch, how you proved the change, review findings and what you did with them, and each decision you made on the user's behalf.
