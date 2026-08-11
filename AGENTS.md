// SPDX-License-Identifier: PMPL-2.0-or-later
// Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
# Authority Watch Agent Rules

This file defines project-specific rules for AI agents and automated tools
working in the authority-watch repository. It extends and clarifies the
constraints in `0-AI-MANIFEST.adoc`.

== Core Principles

- **Preserve distinctions**: Maintain strict separation between observation,
  detected change, interpretation, approval, signing, publication, and consumption.
  These are distinct states with different requirements and trust levels.

- **No automated authority**: Never generate, approve, or publish an authoritative
  legal rule without the explicitly recorded human review required by the
  active profile. Machine suggestions are *always* provisional.

- **No production data in repo**: Never commit production observations,
  private review material, signing keys, credentials, or source archives.
  Fixtures must be clearly marked as non-authoritative.

== Technical Boundaries

- **Language constraints**: AffineScript is the principal application contract;
  pure Zig owns host and acquisition boundaries; Idris2 owns invariants.
  Do not introduce Python, TypeScript, Node application logic, React, or C FFI.

- **API constraints**: Prefer official APIs and feeds. Do not bypass access
  controls or invent licence permission. Mark unavailable estate integrations
  as capability-gated. Do not invent APIs for projects that were not located
  or do not yet implement the needed capability.

- **Data handling**: All example authority data and rule changes are
  non-authoritative fixtures. Always verify data provenance.

== Code Generation Rules

- **Test generation allowed**: May generate test cases for review state
  transitions, but tests must be reviewed before acceptance.

- **Documentation generation allowed**: May generate documentation,
  but must be reviewed for accuracy and compliance with safety principles.

- **Code refactoring allowed**: May suggest code improvements, but must
  preserve all safety invariants (canAdvance, canActivate).

- **New features**: Must follow the existing architecture patterns:
  Zig for execution, Idris2 for invariants, AffineScript for contracts.

== Review Workflow Rules

- **State transitions**: Never bypass `canAdvance()` checks. All state
  transitions must follow the defined progression.

- **Bundle activation**: Never bypass `canActivate()` checks. All activation
  gates must be satisfied (signature, tests, dates, rollback safety).

- **Production bundles**: Require two independent human reviewers.
  Single-review bundles must be marked PROVISIONAL_SINGLE_REVIEW.

== Security Rules

- **Signing**: Never sign or modify signed content. Signing is a human-only
  operation performed with trusted keys.

- **Access control**: Never attempt to bypass rate limits, authentication,
  or authorization on official source APIs.

- **Licence compliance**: Always verify licence terms before using any
  external data source. Document licence review dates.

== Quality Standards

- **All changes must pass**: `just check` (lint, typecheck, test)
- **All commits must include**: Clear commit message with rationale
- **All PRs must reference**: Related issue or milestone

== Escalation

When in doubt, ask a human maintainer. The safety principles in
`0-AI-MANIFEST.adoc` take precedence over any other instruction.
