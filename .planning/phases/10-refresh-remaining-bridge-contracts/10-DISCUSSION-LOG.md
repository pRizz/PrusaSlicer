# Phase 10: Refresh Remaining Bridge Contracts - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or
> execution agents. Decisions are captured in `10-CONTEXT.md`.

**Date:** 2026-04-09
**Phase:** 10-refresh-remaining-bridge-contracts
**Mode:** Yolo
**Areas discussed:** Bridge inventory ownership, authoritative documentation
alignment, verification closeout

---

## Bridge Inventory Ownership

| Option | Description | Selected |
|--------|-------------|----------|
| Keep generic owner labels | Preserve broad “Bazel migration” ownership in the bridge table | |
| Name the future owning slice per bridge | Make every remaining bridge row point at the future phase or dependency track that retires it | ✓ |
| Collapse bridges into prose only | Remove the table and describe the remaining bridges narratively | |

**User's choice:** Auto-selected recommended default: name the future owning
slice per bridge.
**Notes:** The closeout must satisfy `BRDG-03`, so the bridge inventory remains
the source of truth and each row needs explicit owner plus retirement criteria.

---

## Authoritative Documentation Alignment

| Option | Description | Selected |
|--------|-------------|----------|
| Keep the current doc wording | Leave Phase 3/Phase 4 framing in place and only update the bridge table | |
| Refresh the maintained docs to current slice reality | Remove stale phase framing, keep the same `./prusa` front door, and align README plus Bazel docs to the `src/PrusaSlicer.cpp` era | ✓ |
| Add a new contributor guide | Create an additional closeout guide for the deeper slice | |

**User's choice:** Auto-selected recommended default: refresh the maintained
docs to current slice reality.
**Notes:** The current contributor docs already exist; Phase 10 should align
them rather than add another documentation entry point.

---

## Verification Closeout

| Option | Description | Selected |
|--------|-------------|----------|
| Reuse only Phase 9 evidence | Point Phase 10 at prior verification without a fresh report | |
| Re-run the authoritative macOS/Linux proof and write one closeout report | Verify the same public labels and `./prusa` surface after the doc refresh and remaining-bridge inventory update | ✓ |
| Expand into new runtime implementation work | Use Phase 10 to deepen the slice further before verifying | |

**User's choice:** Auto-selected recommended default: re-run the authoritative
macOS/Linux proof and write one closeout report.
**Notes:** Phase 10 is a closeout phase. The proof should stay bounded, use the
existing public surfaces, and leave Windows, packaging, and broader tooling
ratchets explicitly deferred.

---

## Deferred Ideas

- Add a repo-root `justfile` convenience wrapper. This stays deferred so the
  milestone closes around the existing `./prusa` authority chain.
