---
name: ship-pr
description: Finish an authorized code change as a reviewable pull request. Use when asked to create, update, or check a PR, including UI or performance evidence and CI status. A repo's own ship-*-pr skill wins over this one.
---

# Ship PR

If the repo has its own ship skill (a `ship-*-pr` folder in its `.claude/skills/`, such as `ship-myapp-pr`), use that instead. This skill is the general version for repos without one, and the starting point when you write one for a new repo.

Carry the requested change through a reviewable PR using the current checkout and one agent. Follow repository instructions. Use an ordinary Git branch, never a worktree. Preserve unrelated changes and stage only files belonging to the task.

## Full send and full stop

When this skill runs from `full-send` or `full-stop`, nobody watches the thread. The user reads your final message long after you stop, so a question or a "waiting for CI" line in a normal message goes unseen and the thread looks done.

- **Full send** carries the change all the way to a merged PR. The request is the merge permission.
- **Full stop** does everything except the merge, and stops once the PR passes every merge check below. Say in the report that the base can move before the user merges.
- Without either, merge or deploy only when the user or the repo's instructions allow it.

In both modes:

- Stay on it until the end state: merged, ready (full stop), or blocked. Ending a turn with a PR watch running counts as waiting; ending it without one stops the work, because nobody prompts you again.
- Ask only when you cannot go on alone: you cannot prove the change, a check fails for a reason outside the task, the next step touches anything outside the repo (production, a release, someone else's branch, deleting data), the request has two readings that give different results, or another PR makes this one pointless. Ask with the `AskUserQuestion` tool, not in a message, and put everything in the question: the PR link, what blocks you, and the options with your pick first. If the tool is missing or comes back without an answer, leave the PR open and unmerged and start your final message with the question.
- Decide everything else yourself and list each decision in the final report.

## Prepare

- If the change comes from a design request, the user must have approved the mockup first (see the `frontend-design` skill). If they haven't, show the design and wait instead of opening a PR.
- Run `git fetch`. Inspect Git status, current branch, base branch, diff, existing PR, and repository PR template. Reuse the task branch and PR when they exist. If the PR is old and the base moved a lot, run the `modernize` skill first. If the PR or branch is someone else's, use `takeover`.
- Make the smallest change that does the job. Fix the case that happened, not every case that could. Reviews and failing checks tend to grow a PR one cheap-looking fix at a time; fix real bugs in the intended case, and list the rest (extra guards, extra tests, edge cases nobody hits) as follow-ups with one line each.
- Finish the authorized implementation and run checks that exercise the result people will use. Record exact commands and outcomes; distinguish local checks, CI, and deployment.
- Review the final diff for scope, secrets, generated noise, and `git diff --check`. Make a focused commit.
- Get a second read before you open the PR: run the `code-review` skill at `high` on the whole branch against the base (`/code-review high origin/<base>...HEAD`), not only the newest commit. Check each finding against the code yourself. Fix the real ones, run the checks again, and review again until a round finds nothing worth fixing (at most three rounds). For each finding you leave, write one line in the PR on why.
- Push the task branch when creating or updating the PR is authorized.
- No `Co-Authored-By` trailer for Claude and no "Generated with" line anywhere.

## Evidence when the change needs it

Keep capture files and raw measurements in one unique temporary directory outside the checkout, for example `mktemp -d "${TMPDIR:-/tmp}/ship-pr.XXXXXX"`. Use those files to upload screenshots as PR attachments and put the measured results in the PR body. Keep the temporary files until the PR content is verified, then remove only that temporary directory. Do not add an evidence directory, screenshots, benchmark logs, or report files to the repository just for the PR. Do not invent a benchmark or require screenshots for changes they cannot clarify.

For a material UI change, capture matching base and head states: same route, data, viewport, scroll position, and relevant interaction. Include the changed surfaces and a narrow viewport when responsive behavior changed. Avoid stealing focus during GUI capture. Put before and after images together in the PR body, state the scenario, and verify they render for reviewers. If direct attachment is unavailable, explain that limitation in the PR instead of committing screenshots as a workaround.

Mark what changed, so the reader does not have to compare two screenshots pixel by pixel. Draw a numbered red ring around each changed part, on base and head alike: the new or moved control, the fixed text, the spot where something wrong used to appear. In a Playwright capture, add the rings as a top-layer popover over each element's `boundingBox()`, screenshot, then remove them. Two or three rings at most. Open each marked image and check the rings sit on the change. Under the table, write one short line per number.

For a performance claim, measure base and head on the same machine with the same build mode, data, workload, warm-up, and sample count. Choose a metric that matches the claim. Report units, base, head, delta, and run-to-run spread; for short benchmarks prefer at least five measured repetitions. Treat differences within noise as inconclusive, and include the command, environment, revisions, and correctness checks. Never turn a single run, estimate, or unmatched workload into a measured improvement claim.

## Open or update the PR

Use the repo template when present. Write the title, body, commit messages, and your final report with the `unslop` skill. Open the description with the problem the way the user met it, in one or two sentences, then the approach; never lead with a list of changed files or functions. Then the visible result, validation, and material risks or follow-ups. Use a small diagram only when it makes a non-obvious flow easier to review. Put measurements and evidence directly in the PR and keep claims tied to what was actually verified.

Create or update the PR with `gh` or the available native GitHub action. On GitHub, use `gh pr create` or `gh pr edit` with `--body-file` and repeated `--attach` flags for temporary screenshots. Put local image references such as `![Before](./before.png)` in the body file so `gh` replaces them with uploaded asset URLs in place. If an attachment command partly fails, inspect the PR before retrying to avoid duplicate uploads. Open a real PR, not a draft, so review bots run. Open the resulting PR and check its title, body, base/head, and image links.

## CI and reviews

Wait without a loop of your own. In T3 Code, call `watch_pull_request` and end your turn; it wakes you when a check fails, the checks pass, someone comments, or the branch conflicts. A wake does not mean the PR is green; check the required checks and `gh pr view <n> --json mergeStateStatus` yourself. Call `unwatch_pull_request` before you stop for any reason other than a merge. Outside T3 Code, use the Monitor tool on `gh pr checks <n> --watch`. Some repos add required checks late, after others finish; know which check is the real gate before you call the PR green. When a wake needs no action, end the turn without a message; never write "still waiting".

If a check fails, read its log (`gh run view --log-failed`), fix failures within the task, push, and check again. Tell repository failures apart from infrastructure flakes. Only act on checks and comments newer than the latest push. Check every review comment, human or bot, against the code before changing anything. Fix real findings; reply to the rest with a written reason, using the `leaving-pr-comments` skill for every comment you post.

## Merge

Merge only under full send or another clear permission. All of these must hold on the latest commit:

- Required checks are green and `mergeStateStatus` is `CLEAN`.
- Your proof covers every change in the diff.
- Review bots have finished, and no human review still asks for changes.
- Right before merging, `git fetch` shows the branch has every commit on the base (`git rev-list --count HEAD..origin/<base>` prints 0). If not, update the branch and wait for CI again, even when the new commits touch other files.

Use the merge method the repo uses (check recent merged PRs). Never use `--admin` or another bypass. Confirm the merge with `gh pr view <n> --json state,mergeCommit` and report the merge commit you saw. Never claim a merge you did not see.

The final report holds the PR link, the merge commit (or the PR's real state), the proof you ran, and each decision you made on the user's behalf.
