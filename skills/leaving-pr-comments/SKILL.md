---
name: leaving-pr-comments
description: How to write and post comments on GitHub for the user. Use whenever you leave a PR comment, review comment, or reply to a reviewer or review bot.
---

# Leaving PR comments

Adapted from `leaving-pr-comments` in [t3dotgg/tstack](https://github.com/t3dotgg/tstack) (MIT).

This covers top-level PR comments, inline review comments, replies to people or bots, and the written reason before you resolve or dismiss a finding. It does not cover PR descriptions, commit messages, or text the user asked you to post word for word.

## Writing

Write it with the `unslop` skill.

- Start with the conclusion.
- Point at the code, behavior, check, or repro it rests on.
- Keep it short. No thanks, no filler, no "I will now look into this".
- Keep what you checked apart from what you think.

## Who wrote it

A comment posted from the user's GitHub account reads as if they typed it, so start every comment with one note that says an agent wrote it:

```md
> [!NOTE]
> Claude Opus 5.5 responding on behalf of Warre

The comment starts here.
```

- Use the model name your harness reports, and the user's name or GitHub login. If the harness gives no model name, name the harness. Never guess.
- The note holds only that line. The reply goes below it, outside the note.
- Say it once. No second attribution, signature, footer, heading, or horizontal rule anywhere else in the comment.
- This is only for comments. Commits and PR descriptions stay without any Claude attribution, and so does text the user asked you to post word for word.

## Posting

- Before posting, check the whole comment, including quotes and attachments, for secrets and private details (passwords, tokens, e-mail addresses, phone numbers, real people's data).
- Preview the Markdown so quotes and blank lines render as meant.
- After posting, check that GitHub returned the comment or review URL.
- Resolve a review thread only after your reply posted.
