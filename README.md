# wstack

The agent skills I use every day. They work in Claude Code and Codex. Some use
[T3 Code](https://github.com/pingdotgg/t3code) features when they are available
and fall back to native tools when they are not.

## Skills

### Shipping code

| Skill | Say | What it does |
|---|---|---|
| `ship-pr` | "make a PR" | Turns a finished change into a PR with proof (screenshots, timings) and waits for CI. A repo's own `ship-*-pr` skill wins over this one. |
| `full-send` | "full send" | Takes a change to a merged PR while nobody watches the thread. |
| `full-stop` | "full stop" | Same as `full-send`, but stops at a green PR so you merge it yourself. |
| `takeover` | "take over" | Finishes someone else's PR, branch, or agent thread and keeps their credit. |
| `modernize` | "modernize" | Rebases an old PR and decides if it should still exist. |
| `leaving-pr-comments` | (automatic) | Formats the comments an agent posts on GitHub for you. |
| `bug-hunt` | `/bug-hunt [count] [focus]` | Finds real bugs across the whole codebase and fixes each one in its own PR. |

### Writing code

| Skill | Say | What it does |
|---|---|---|
| `deletion-principles` | (automatic) | Pushes every change toward deleting code and the smallest diff. |
| `diagnosing-bugs` | "diagnose", "debug this" | A step-by-step loop for hard bugs and slowdowns. It builds a check that fails, shrinks the case, then tests guesses about the cause. |
| `frontend-design` | "design", "mock up" | Picks a clear visual direction for new UI and shows it for approval before writing code. |
| `good-css` | (automatic) | Modern CSS that replaces breakpoint ladders, extra wrappers, and scripts. |

### Understanding code

| Skill | Say | What it does |
|---|---|---|
| `how` | `/how` | Explains how a part of the codebase works, or where new code should go. |
| `why` | `/why` | Finds out why code works the way it does, using git history, issues, chat, and docs, with sources. |
| `teach` | `/teach` | Runs `how` and `why` and turns the results into one plain explanation. |

### Testing apps

| Skill | Say | What it does |
|---|---|---|
| `create-verification-skill` | `/create-verification-skill` | Writes a skill for a project that drives the app the way a user does. |
| `maintain-verification-skill` | `/maintain-verification-skill` | Checks that a project's verification skill still matches the app, and fixes it in one PR. |

### Writing for people

| Skill | Say | What it does |
|---|---|---|
| `unslop` | (automatic), `/unslop` | Rules that strip AI patterns from anything a person reads. |
| `humanizer` | "humanize this" | Rewrites AI-sounding text so it reads like a person wrote it. |
| `bro` | `/bro` | Restates the last answer in plain words. |

"(automatic)" means the agent loads the skill on its own when the task fits.
Skills shown as `/name` only run when you type them.

Some skills call others, so install them together:

- `full-send`, `bug-hunt`, `modernize`, and `takeover` use `ship-pr`.
- `full-stop` uses `full-send`.
- `takeover` and `modernize` use `leaving-pr-comments`.
- `teach` uses `how` and `why`.

## Install

```bash
git clone https://github.com/SnaetWarre/wstack ~/wstack
~/wstack/install.sh                    # Claude Code
~/wstack/install.sh ~/.codex/skills    # Codex
```

`install.sh` links each skill folder into the target folder. It skips any skill
that already exists there as a real folder, so delete or move that one first.
After that, `git pull` in `~/wstack` updates every machine.

To copy the files instead of linking them:

```bash
cp -R ~/wstack/skills/* ~/.claude/skills/
```

## Requirements

- An authenticated [GitHub CLI](https://cli.github.com) (`gh`) for the PR skills.
- `why` works best with MCP servers for your issue tracker, chat, and docs.

## Credits

- `takeover`, `modernize`, and `leaving-pr-comments` are adapted from
  [t3dotgg/tstack](https://github.com/t3dotgg/tstack) (MIT). `full-send` and
  `full-stop` follow the same idea.
- `deletion-principles` combines three principles from pstack.
- `humanizer` is [blader/humanizer](https://github.com/blader/humanizer) by
  Siqi Chen (MIT, see `skills/humanizer/LICENSE`).
- `frontend-design` is based on Anthropic's
  [frontend-design skill](https://github.com/anthropics/skills) (Apache 2.0,
  see `skills/frontend-design/LICENSE.txt`).

## License

[MIT](LICENSE), except `humanizer` and `frontend-design`, which keep the
licenses in their own folders.
