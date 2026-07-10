# Sources & Attribution

This repository exists because of public discussion and practice by experienced practitioners. Primary sources:

## Core Definition & Framework

- **Kevin Zhang** — [Agent Loops](https://KevinZhangNothing.substack.com/p/agent-loops) (June 2026)
  Companion essay for this repository: context engineering vs harness engineering vs agent loops, the five primitives + memory, Grok mapping, and production realities.

- **Addy Osmani** — Agent Loops concept (June 2026)
  Public discussion on X (Twitter) highlighting loop engineering as a shift from prompting to designing control systems.
  Note: Originally attributed blog post URL is no longer available; see community discussions for context.

## Anthropic / Claude Code Perspective

- **Boris Cherny** (Head of Claude Code at Anthropic)
  - Public statements: “I don’t prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops.”
  - Practical usage shared in the community: `/loop 5m /babysit`, `/loop 30m /slack-feedback`, `/loop /post-merge-sweeper`, `/pr-pruner`, etc.
  - Emphasis on turning workflows into skills + loops.
  - `/loop`, `/goal`, and `/schedule` as first-class primitives in Claude Code.

- Related commentary from the Claude Code team (including @_catwu) highlighting loops as one of the highest-leverage features for long-term agentic work.

## Related Concepts (Osmani)

- Agent Harness Engineering
- The Factory Model
- Intent Debt
- Comprehension Debt
- Cognitive Surrender
- Orchestration Tax
- Code Agent Orchestra / Adversarial Code Review

These provide important context and guardrails for loop design.

## Other Early Signals

- Peter Steinberger: emphasis on designing loops rather than prompting agents directly.
- Various practitioners experimenting with closed-loop systems, feedback agent loops, and "routines that prompt the model."

## Community Philosophy Artifacts

- **Marius ([@sololys](https://github.com/sololys))** — [KY Cut Surface Philosophy v0.1](./ky-cut-surface-philosophy-v0_1/) (July 2026)
  Archived public philosophy on the distinction between generation and consequence. Not a pattern or runtime — indexed via [stories/ky-cut-surface-generation-vs-consequence.md](../stories/ky-cut-surface-generation-vs-consequence.md).

## How This Repo Relates

We treat the above sources as the current best articulation of the idea and aim to turn the abstract framework into practical, copyable patterns, templates, and tool-specific guidance (with special attention to the Grok Build TUI, which has strong native support for the primitives).

If you have additional primary sources, real production loop stories, or corrections, please open an issue or PR.
