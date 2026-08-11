// SPDX-License-Identifier: CC-BY-SA-4.0
// Copyright (c) 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
# Claude Instructions — Authority Watch

These instructions tell Claude Code how to work in this repository.
They supplement and implement the rules in `0-AI-MANIFEST.adoc` and `AGENTS.md`.

## About the Project

Authority Watch is a high-assurance legal/regulatory change monitoring system
that enforces a strictly-controlled pipeline for tracking authoritative documents.

**Core principle:** Never collapse the distinction between observation, interpretation,
approval, and publication. The system must remain operable without external AI.

## Instructions

### Always Do

1. **Read first:** Always start by reading `0-AI-MANIFEST.adoc` and `AGENTS.md`
   before making any changes.

2. **Preserve safety:** Never modify `canAdvance()` or `canActivate()` without
   explicit human approval. These are the core safety invariants.

3. **Maintain separation:** Keep observation, interpretation, approval, and
   publication as distinct concepts in code and documentation.

4. **Verify licence:** Before adding any external dependency, check and document
   its licence in DEPENDENCIES.adoc.

5. **Run checks:** Always run `just check` before committing or creating a PR.

6. **Document:** Update relevant documentation (CHANGELOG, README, EXPLAINME)
   when making changes.

7. **Test:** Add tests for any new functionality, especially safety-critical code.

8. **Ask for help:** If unsure about a safety-critical change, ask a human
   maintainer.

### Never Do

1. **Don't bypass safety:** Never skip or bypass `canAdvance()` or `canActivate()`
   checks.

2. **Don't automate approval:** Never create code that automatically approves,
   signs, or publishes bundles.

3. **Don't commit production data:** Never commit observations, reviews,
   signing keys, or credentials to the repository.

4. **Don't introduce prohibited languages:** Do not add Python, TypeScript,
   Node.js, React, or C FFI code.

5. **Don't invent APIs:** Do not create APIs for projects that don't exist or
   don't have the required capability.

6. **Don't claim authority:** Never present machine-generated content as
   authoritative without explicit human review.

## Project Structure

- `zig/` — Zig source code (CLI and core logic)
- `idris2/` — Idris2 source code (formal invariants)
- `affinescript/` — AffineScript contracts
- `profiles/` — Profile configurations
- `.machine_readable/` — Machine-readable metadata (RSR compliance)
- `docs/` — Documentation (when created)

## Key Files to Understand

- `zig/src/core.zig` — Core types and safety functions
- `idris2/AuthorityWatch/Review.idr` — Review state definitions
- `idris2/AuthorityWatch/Core.idr` — Domain types
- `affinescript/domain/Authority.affine` — Application contracts
- `0-AI-MANIFEST.adoc` — AI use manifest
- `AGENTS.md` — Agent-specific rules
- `RSR-PHILOSOPHY.adoc` — Operating principles

## Useful Commands

```bash
# Check prerequisites
just doctor

# Build
just build

# Run all checks
just check

# Show status
just run

# Ingest a file
just ingest path/to/file

# Run tests
just test

# Lint
just lint
```

## When in Doubt

Always prefer:

1. Safety over convenience
2. Explicit over implicit
3. Human review over automation
4. Failure over silent success
5. Documentation over undocumented behavior
