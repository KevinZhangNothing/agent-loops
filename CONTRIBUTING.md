# Contributing to Agent Loops

This repo is a **practical engineering reference**, not a hype collection. We welcome patterns, stories, tool examples, and honest failure reports.

## Ways to Contribute

| Contribution | Where | Time |
|--------------|-------|------|
| Typo fix, link update | Any `.md` file | ~10 min |
| Add your project to adopters | [Issue form](https://github.com/KevinZhangNothing/agent-loops/issues/new?template=add-adopter.yml) | ~10 min |
| Production story | `stories/` | ~30 min |
| Tool example | `examples/{tool}/` | ~1 hr |
| New pattern | `patterns/` + `patterns/registry.yaml` | Half day |
| npm package fix | `tools/loop-*` | 1-2 hrs |

**Start here:** [`good first issues`](https://github.com/KevinZhangNothing/agent-loops/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

## Pattern Requirements

Every new pattern must include:

1. **Goal** — one sentence
2. **Scheduling** — per-tool commands
3. **Required skills** — `SKILL.md` templates
4. **State schema** — with example
5. **Typical cycle** — numbered steps
6. **Verification** — maker/checker split
7. **Human handoff** — when to escalate
8. **Tool notes** — at least 2 tools
9. **Failure modes** — what breaks and why
10. **Success metrics** — how to measure

Also add an entry to `patterns/registry.yaml`.

## Story Requirements

- Real experience (anonymize if needed)
- Name the pattern used
- Include at least one failure or surprise
- Actionable lesson in one paragraph

## Pull Request Checklist

- [ ] Links work from README or docs index
- [ ] No secrets, tokens, or internal URLs
- [ ] `STATE.md` examples use `.example` suffix (live state is gitignored)
- [ ] Safety-sensitive patterns reference [docs/SAFETY.md](docs/SAFETY.md)

**For npm package changes:**
- [ ] Tests pass (`npm test` in tool directory)
- [ ] Version bumped (semver)
- [ ] Changelog updated (if applicable)

## Code of Conduct

- **Engineering over hype** — substance over marketing
- **Failures are first-class** — post-mortems welcome
- **Tool-agnostic by default** — tool-specific in labeled sections
- **No performative agreement** — technical rigor over politeness

## npm Package Development

For contributing to npm packages (`@kevinzhangnothing/loop-*`):

1. **Make changes** in `tools/loop-*/src/`
2. **Build & test:** `cd tools/loop-audit && npm run build && npm test`
3. **Bump version:** `npm version patch` (or minor/major)
4. **Publish:** `npm run publish:all` from repo root

See [docs/PUBLISH.md](docs/PUBLISH.md) for detailed publishing instructions.

## Maintainer Response

PRs that only touch `stories/`, `docs/adopters.md`, or the Add Adopter issue get **same-day review** when possible:

1. Maintainer merges or requests one small fix within 24 hours
2. Public thank-you on the PR (`@mention` the contributor)
3. Optional follow-up issue if contributor wants a second PR

## Questions?

- **General Q&A:** [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions)
- **Bug reports:** [New Issue](https://github.com/KevinZhangNothing/agent-loops/issues/new)
- **Security:** [SECURITY.md](SECURITY.md) — do not file public issues for vulnerabilities

Thank you for helping make this the go-to reference for agent loops.
