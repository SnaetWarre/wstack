---
name: modernize
description: Bring an old PR up to date and decide whether it should still exist. Use when asked to rebase an old PR, or to "modernize" one.
---

# Modernize

Adapted from `modernize` in [t3dotgg/tstack](https://github.com/t3dotgg/tstack) (MIT).

Update the idea, not only the branch. A clean rebase does not prove the PR still belongs in the product.

## Rules

- `git fetch` first, so the PR branch, the base branch, and related branches are current.
- Treat uncommitted changes in the checkout as the user's. Never stash or discard them. If the checkout is dirty, stop and say so.
- This skill allows rebasing and updating the PR branch. It does not allow merging, closing, changing the base branch, or growing the scope, unless the user also asked for that (for example with "full send").
- Never force-push without a lease. Push a rebased branch with `--force-with-lease=<branch>:<head SHA seen before the rebase>`.
- Post no PR comment unless the user asked for one. Use `leaving-pr-comments` for any comment.

## Find the PR's intent

Record the PR's URL, state, base, head branch, current head SHA, author, checks, and review state. Read the title, body, linked issues, commits, review threads, and the full diff. Write down, in one sentence, the smallest goal the PR was trying to reach before you judge the code.

Record the merge base, so you can tell the PR's own changes apart from what landed on the base since.

## Check what changed around it

Read the commits that landed on the base since the PR branched off. Search merged and open PRs when titles, files, or behavior suggest a replacement or a competing fix. Ask:

- Has the same problem already been solved another way?
- Did APIs, types, schemas, dependencies, or module boundaries change under it?
- Would landing it bring back old behavior, or give two ways to do the same thing?
- Was the code it changes deleted, moved, or simplified on purpose?
- Is what it buys still worth the code it adds?

No Git conflicts does not mean the PR is current.

## Pick one verdict before pushing

- **Modernize**: the goal is still useful and the code still has the right shape. Rebase, resolve conflicts, test, and push.
- **Rework**: the goal is still useful, but a rebase would keep the wrong code. Describe the smallest rewrite that works and stop before pushing, unless the user also asked for the rework.
- **Close**: the PR is replaced, outdated, heading the wrong way, or no longer worth it. Name the evidence and stop. Do not rebase a dead branch, and never close it without the user's permission.

Age alone is no reason to close, and work already spent is no reason to keep it.

## Rebase without losing intent

For a Modernize verdict:

1. Make a local branch at the recorded PR head.
2. Rebase its commits onto the freshly fetched base.
3. Resolve each conflict by the PR's goal and the base's newer rules. If a conflict shows a real disagreement in product or design, stop and reconsider the verdict instead of guessing.
4. Compare the commit series before and after with `git range-diff`, and read the final diff. Check that no intended change disappeared and nothing already on the base came back.
5. Run the repo's checks for the touched area. If the repo has a ship skill (`ship-*-pr`, or else `ship-pr`), use its checks and proof steps. Tell real failures apart from old or infrastructure ones.
6. Push with the lease from the rules above. If the lease fails, fetch and look again instead of overwriting new work.

## Report

Start with Modernize, Rework, or Close and the reason. Then:

- what changed on the base that matters;
- conflicts in intent, or that you found none;
- the rebase and push result, if you did them;
- checks run and their results;
- what is left to decide, with the PR link.

Keep what you saw apart from what you judge. Say what you could not check.
