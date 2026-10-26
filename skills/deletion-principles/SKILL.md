---
name: deletion-principles
description: "Bias every code change toward deletion and the smallest diff. Use when writing, fixing, refactoring, cleaning up, or reviewing code, and before adding a fallback, compatibility shim, wrapper, helper, guard, or extra test. Combines pstack's laziness-protocol, subtract-before-you-add, and migrate-callers-then-delete-legacy-apis principles."
---

# Deletion principles

Aim for the most result with the least code and complexity. These are pstack's three deletion principles in one file.

## In Warre's projects

- No fallbacks, compatibility shims, thin wrappers, or helpers kept "just in case" unless the user asks for one. His projects have no outside users that depend on old behavior.
- When he says remove something, remove it fully: the parameter, its callers, its tests, and its docs.
- Add tests that protect real behavior. Don't pile up tests for every edge case.

## Laziness protocol

- **Prefer deletion.** When asked to refactor or improve, look for removals before additions.
- **Keep the call hierarchy flat.** Avoid deep call chains. A rich interface that hides substantial work is not a deep call chain. If answering a question requires tracing through more than 3 files or layers, flatten it.
- **Consolidate decisions.** Do not repeat the same choice in several places. Put it behind one source of truth and pass the result as a simple flag.
- **Minimize the diff.** Make the smallest change that solves the problem. Fewer lines beat "elegant" boilerplate.
- **Question the threading.** If a task asks you to pass a new signal through types, schemas, pipelines, or similar layers, stop and look for a more direct path.
- **Sweat the small leaks.** Remove tiny pass-throughs, representation leaks, and duplicated choices before they spread. Small leaks compound into permanent coordination costs.

**The test.** If a human developer would find the code exhausting to maintain, it is a bad solution.

## Subtract before you add

When evolving a system, remove complexity first, then build. Adding to a complex system compounds complexity. Removing first leaves less code, shows the essential structure, and usually makes the next design obvious.

Leave the design slightly simpler and more capable than you found it, behind the same or a smaller interface.

- Remove before you build.
- Cut before you polish. Get to the minimum before investing in quality.
- Design for observed usage, not speculative edge cases.
- No speculative validators, parsers, or guards beyond what the task demands.
- Simplify prompts. Remove redundant instructions and excessive templates.
- When a reference has no new content, delete it rather than leaving a stub.

## Migrate callers, then delete the old API

When a new internal API is the right design, migrate every caller and remove the old API in the same change instead of keeping a compatibility layer.

- Do not keep a legacy path only because internal callers still use it.
- List the callers, migrate them, and delete the old API right away.
- Treat a temporary adapter as an exception with an end date, not as default architecture.
- Update tests to check the new contract. Delete tests that only protect the old implementation details.

This applies when no external users depend on backward compatibility and the project can absorb a coordinated breaking change. Keeping both old and new APIs creates two code paths, slows cleanup, and makes the codebase grow only by addition.
