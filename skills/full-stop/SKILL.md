---
name: full-stop
description: Same as full send, but stop at a green PR and let the user merge it. Use when the user says "full stop".
---

# Full stop

Read `full-send` (`~/.claude/skills/full-send/SKILL.md`). Pick the ship skill the same way and do all the work, with the same permissions for testing and for force-pushing this task's branch. Run the ship skill in its "full stop" mode. These rules win over anything that says to merge:

- Never merge. Never turn on auto-merge, never push to the base branch, and never ask another agent to merge. If auto-merge is already on, turn it off and say so in the report.
- Stop when the PR passes every merge check of the ship skill. Leave it open and ready.
- In T3 Code, call `unwatch_pull_request` before you stop or ask a question.

## Report

Start with one of these:

- **Ready to merge.** Every merge check passes and the PR waits for the user.
- **Blocked.** Say what stops it, what you tried, and what is needed.

Then the PR link, the final commit, how you proved the change, review findings and what you did with them, and each decision you made. Say plainly that the PR is still open and unmerged.
