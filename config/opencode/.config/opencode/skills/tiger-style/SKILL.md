---
name: tiger-style
description: Tiger Style coding discipline for all coding tasks. Use when writing, editing, reviewing, refactoring, testing, or designing code in any language, with pragmatic language-specific adaptation.
---

# Tiger Style

Apply a language-agnostic adaptation of TigerBeetle's Tiger Style to everyday
software work. Optimize for safety, performance, and developer experience, in
that order. Treat simplicity as the hard revision that reconciles these goals,
not as the first obvious implementation.

This skill is self-contained. It adapts the principles of Tiger Style for any
language, especially web and backend code, without requiring Zig-specific rules.

## Trigger Behavior

Use this skill for all coding tasks: implementation, refactoring, debugging,
testing, code review, API design, data modeling, and performance-sensitive
changes.

Apply the rules pragmatically:

- Prefer the idioms and safety tools of the target language when they preserve
  the Tiger Style principle.
- Make local improvements directly when already editing code.
- Ask before broad rewrites, architectural changes, dependency removals, or
  large style-only refactors.
- Do not block useful work on stylistic perfection when the codebase has a
  conflicting established convention. Preserve local consistency unless the
  convention is unsafe.

## Core Priorities

Use these priorities in order:

1. Safety: Make invalid states hard to represent, detect programmer errors
   early, bound work and resources, handle operating errors explicitly.
2. Performance: Think about resource use before implementing, especially I/O,
   memory, CPU, latency, and allocation behavior.
3. Developer experience: Choose names, structure, comments, and tests that let
   the next reader build a precise mental model quickly.

Simplicity is the mechanism for achieving all three. Prefer direct designs,
small APIs, explicit state, and minimal abstraction. Avoid cleverness, hidden
control flow, and abstractions whose costs or invariants are unclear.

## Safety Rules

Use simple, explicit control flow.

- Avoid recursion unless the language/runtime makes bounded recursion explicit
  and the maximum depth is known and enforced.
- Prefer loops with clear termination conditions. Put an upper bound on work
  where practical: page sizes, batch sizes, retry counts, queue depths, request
  sizes, result limits, and loop iterations.
- Avoid complex compound conditions when correctness matters. Split them into
  simple branches so positive and negative cases are visible.
- Prefer positive invariants: `index < length` is easier to reason about than
  `!(index >= length)`.

Assert programmer assumptions.

- Use assertions, contracts, type refinements, schema validation, or exhaustive
  pattern checks to encode invariants.
- Assert function preconditions, postconditions, important internal invariants,
  and impossible states.
- Split compound assertions so failures identify the exact violated property.
- Pair assertions across boundaries: validate before writing or sending data,
  and validate again after reading or receiving it.
- Assertions are for programmer errors. Expected operating errors must be
  returned, thrown, retried, or handled explicitly according to the language and
  application model.

Bound resources and failure modes.

- Put explicit limits on memory, file sizes, request body sizes, pagination,
  concurrency, retry loops, queues, caches, and background jobs.
- Prefer fail-fast behavior for impossible or unsupported states.
- Handle all errors deliberately. Do not ignore promises, results, exceptions,
  failed writes, failed cleanup, failed parses, or partial I/O.
- Avoid doing expensive work directly in reaction to each external event. Queue,
  batch, debounce, or schedule work when this improves control and bounds.

Minimize state hazards.

- Declare variables at the smallest possible scope.
- Introduce variables close to where they are used.
- Avoid aliases, duplicated state, and cached derived values unless there is a
  clear invalidation strategy.
- Keep functions run-to-completion when possible. Be careful with async gaps,
  callbacks, effects, and suspension points that can invalidate preconditions.
- Centralize state mutation. Prefer leaf helpers that compute values rather than
  mutate shared state.

## Performance Rules

Think about performance during design, before profiling is available.

- Sketch rough costs for network, disk, memory, and CPU. Consider both latency
  and bandwidth.
- Optimize the slowest and most frequent resources first. For backend and web
  code, network calls, database queries, serialization, and cache misses often
  dominate.
- Batch where possible: database writes, network requests, queue processing,
  logging, cache fills, and file operations.
- Separate control plane from data plane. Keep coordination and policy code out
  of hot data-processing paths when possible.
- Be allocation-aware. Avoid unbounded intermediate arrays, repeated string
  concatenation in loops, accidental deep copies, and N+1 query patterns.
- Make hot loops and hot paths simple, predictable, and easy to inspect.

Do not prematurely micro-optimize. First choose a design with the right shape:
bounded work, fewer round trips, fewer allocations, fewer states, and clearer
data ownership.

## Simplicity And Structure

Prefer code that is easy to audit.

- Keep functions short enough to understand without scrolling when practical.
  Use roughly 70 lines as a warning threshold, not a universal hard law.
- Split large functions by responsibility, not by arbitrary line count.
- Push conditionals up and loops down: let parent functions decide control flow;
  let helpers perform focused work.
- Keep related state and checks close together.
- Prefer explicit parameters over hidden globals or ambient context.
- Avoid generic abstractions until at least two or three real use cases prove
  the shared shape.
- Prefer simple return types. Do not add optional/error/union states unless the
  caller must genuinely handle them.

For web/backend code:

- Keep request validation, authorization, business logic, persistence, and
  response mapping distinct enough that each is auditable.
- Avoid hiding I/O inside innocent-looking helpers.
- Make transaction boundaries, idempotency keys, retries, and timeouts explicit.
- Avoid N+1 database access. Make query count and data volume obvious.
- Keep schema constraints and application invariants aligned.

## Naming Rules

Names should communicate the domain model.

- Use the established naming convention of the language or codebase.
- Do not abbreviate unless the abbreviation is standard in the domain.
- Include units and qualifiers in names: `timeout_ms`, `size_bytes`,
  `attempts_max`, `created_at_utc`.
- Put the most significant word first when it improves grouping and scanning:
  `latency_ms_min`, `latency_ms_max`, `latency_ms_p99`.
- Avoid names with different meanings in different contexts.
- Prefer nouns for durable concepts and verbs for actions.
- Choose names that work in code, tests, docs, logs, metrics, and incident
  discussion.

When a function takes multiple same-typed values that can be confused, prefer
named parameters, options objects, small domain types, or explicit wrappers if
the language supports them.

## Comments And Rationale

Always explain why when the reason is not obvious.

- Comments should describe rationale, invariants, constraints, tradeoffs,
  protocol details, or test methodology.
- Do not comment what the code mechanically does.
- Use assertions as executable documentation for critical invariants.
- In tests, briefly explain the scenario and why it matters when the setup is
  non-trivial.
- When reporting or reviewing, teach the principle behind the recommendation.

## Dependencies And Tooling

Treat dependencies as liabilities as well as assets.

- Do not add a dependency for small code that can be written clearly and safely.
- Before adding a dependency, consider supply-chain risk, maintenance, install
  cost, transitive dependencies, performance, and failure behavior.
- Prefer existing project tools over introducing a new tool for a narrow task.
- Use strict compiler, linter, formatter, type-checker, and test settings that
  are already accepted by the project.

## Testing Rules

Tests should encode the mental model.

- Test valid and invalid inputs.
- Test boundaries: empty, one, many, max, overflow, timeout, cancellation,
  duplicate, reordered, missing, and malformed cases.
- Test error-handling paths, not only successful paths.
- Prefer deterministic tests. Control time, randomness, network, filesystem,
  and concurrency where possible.
- Use property-based, fuzz, simulation, or generative testing when the domain
  has complex state spaces or parsers.
- Pair tests with assertions: tests exercise scenarios; assertions guard the
  invariants inside the implementation.

For web/backend code, include tests for authorization boundaries, idempotency,
transaction rollback, pagination limits, rate limits, serialization changes,
and external-service failures when relevant.

## Review Checklist

When reviewing or editing code, check:

- Are all resources and loops bounded?
- Are programmer errors asserted and operating errors handled?
- Are invalid states impossible, or at least detected early?
- Are names precise, unambiguous, and unit-qualified where useful?
- Are variables scoped tightly and computed close to use?
- Is control flow explicit and auditable?
- Are abstractions justified by the domain rather than convenience?
- Are dependencies and tools necessary?
- Are performance costs roughly sketched for I/O, memory, and CPU?
- Are tests covering boundaries, invalid inputs, and error paths?
- Does the code explain why the design is correct?

## Reporting Style

When reporting findings, use a teaching mode:

- State the concrete issue first, with file and line references when available.
- Explain the Tiger Style principle behind the issue.
- Suggest the smallest correct change.
- Separate correctness issues from style preferences.
- If no issues are found, say so and mention residual risks or untested paths.

Keep reports concise, but include enough rationale that the user can apply the
principle next time.
