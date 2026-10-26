---
name: takeover
description: Finish someone else's PR, branch, or agent thread and keep their credit. Use when asked to take over a PR, branch, or thread.
---

# Takeover

Adapted from `takeover` in [t3dotgg/tstack](https://github.com/t3dotgg/tstack) (MIT).

You now own finishing the original goal. The people who started it keep their credit. Do not defend the code just because someone else already wrote it.

## Read the handoff

Read the source PR, branch, or thread in full, including review findings and later corrections from the user. Match it to the actual code and current head, and look for uncommitted work. Treat the handoff as context, not as proof that anything works.

## Continue the work

- For a replacement PR, bring the original commits onto a new branch and add your fixes as separate commits. If the user asked to continue in place or to stack on top, do that instead.
- Never overwrite unrelated work, and never change the original PR without permission.
- Run `modernize` to bring the work up to date with its base and the current code. Rework what the same goal needs, not new features. Simplify where you can without dropping intended behavior.
- Check the source PR again before you finish; its author may have pushed in the meantime.

## Keep the credit

- Keep Git authorship and existing `Co-authored-by` trailers for people.
- Name the original contributors in the PR description and link the original PR.
- If the work will be squash-merged, keep human authors as `Co-authored-by` trailers in the merge commit, with identities you checked (from their commits or GitHub profile), never a guessed e-mail.
- The user's rule against Claude attribution still holds: credit people, never the model.

## Prove and ship

Check the original problem yourself, the way a user meets it, following the repo's guidance. Green mocked tests do not prove that a screen works. Say what you could not check.

When the finish includes a PR, use the repo's ship skill (`ship-*-pr` in its `.claude/skills/`, or else `ship-pr`) to open or update it and see it through CI. Use `leaving-pr-comments` for replies. Merge or close the original PR only with permission.

## Report

What you took over, what you changed, how you checked it, how you kept the credit, and what is left to decide.
