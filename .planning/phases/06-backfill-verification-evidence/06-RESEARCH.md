# Phase 6 Research Memo: Backfill Verification Evidence

## What is actually missing

- The blocker is a missing phase-level verification artifact for Phase 3: `/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/phases/03-migrate-core-targets-and-dependencies/03-VERIFICATION.md`.
- The milestone audit already names the exact gap: BLD-01, BLD-02, DEPS-01, and DEPS-03 are partial only because that report does not exist yet.
- The live repo already contains the underlying evidence in Phase 3 summaries and current Bazel policy files, so Phase 6 should consolidate proof rather than reopen implementation.

## What the phase needs to know

### Evidence already on disk

- Build evidence:
  - `src/BUILD.bazel` proves the `//src:PrusaSlicer` label still exists.
  - `prusa` and `tools/bazel/README.md` both expose the authoritative build command shape for Linux and macOS.
  - `tools/bazel/README.md` documents the macOS and Linux/arm64 commands that correspond to the Phase 3 proof slice.
- Dependency evidence:
  - `tools/bazel/deps/proof_slice_deps.bzl` records the explicit proof-slice dependency set.
  - `tools/bazel/policies/proof_slice_bridges.md` records the tracked bridge inventory, ownership, and retirement criteria.
  - `tools/bazel/policies/system_libraries.bzl` records the temporary Linux system-library exception with scope and lifetime.
  - `tests/libslic3r/BUILD.bazel` shows the bounded `//tests/libslic3r:config_test` target that exercised the seam.

### Why the audit is still blocked

- The audit is not failing because the repo lacks proof; it is failing because the proof is fragmented across summaries, README text, and policy files instead of being consolidated into a phase-level verification report.
- `REQUIREMENTS.md` still maps BLD-01, BLD-02, DEPS-01, and DEPS-03 to Phase 6 as `Pending`, which is coherent only while the report is missing.
- `ROADMAP.md` and `STATE.md` still say Phase 6 is not started, so they will need a lightweight closeout refresh once the evidence report exists.

## Smallest clean implementation scope

The cleanest Phase 6 deliverable is one new file, `03-VERIFICATION.md`, written from the live repo state and the completed Phase 3 summaries.

That report should:

1. State the Phase 3 goal and the exact verification date.
2. Show one build row for Linux and one for macOS.
3. Show one dependency row for explicit dependency ownership.
4. Show one bridge-tracking row for temporary legacy bridges and system-library exceptions.
5. Explain any remaining bounds as non-blocking, not as open implementation work.

Do not add new implementation work unless the live repo evidence no longer matches the Phase 3 claims. Based on the current docs, that does not appear necessary.

## Recommended phase breakdown

Use one plan, `06-01`, with three steps:

1. Collect and cross-check the live evidence for BLD-01, BLD-02, DEPS-01, and DEPS-03.
2. Write `/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/phases/03-migrate-core-targets-and-dependencies/03-VERIFICATION.md` as the phase-level verification report.
3. Refresh traceability metadata so the rest of `.planning` stops describing those requirements as partial.

That is enough. The phase does not need a second implementation plan.

## Verification commands to use

### Build and test proof

```sh
npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer
npx -y @bazel/bazelisk test --config=dev --config=macos //tests/libslic3r:config_test
npx -y @bazel/bazelisk run --config=dev --config=macos //src:PrusaSlicer -- --help
```

```sh
docker run --rm --platform=linux/arm64 --user 0:0 -v "$PWD:/workspace" -w /workspace ubuntu:24.04 bash -lc '
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update >/dev/null
apt-get install -y ca-certificates curl git unzip zip openjdk-21-jdk build-essential python3 pkg-config cmake ninja-build libboost-all-dev libtbb-dev libexpat1-dev libpng-dev catch2 >/dev/null
curl -fsSL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-arm64
chmod +x /usr/local/bin/bazelisk
mkdir -p /tmp/codex-home /tmp/bazelroot
HOME=/tmp/codex-home bazelisk --output_user_root=/tmp/bazelroot build --config=dev --config=linux //src:PrusaSlicer
HOME=/tmp/codex-home bazelisk --output_user_root=/tmp/bazelroot test --config=dev --config=linux //tests/libslic3r:config_test
'
```

### Dependency and bridge proof

```sh
bazel query 'deps(//src:PrusaSlicer)'
bazel query 'deps(//tests/libslic3r:config_test)'
rg -n "owner|retire_when|status|lifetime|allowed_platforms|temporary|deferred|active" \
  tools/bazel/deps/proof_slice_deps.bzl \
  tools/bazel/policies/proof_slice_bridges.md \
  tools/bazel/policies/system_libraries.bzl \
  tools/bazel/README.md
```

## Metadata refresh needed after the report lands

- `REQUIREMENTS.md`: mark BLD-01, BLD-02, DEPS-01, and DEPS-03 as complete rather than Phase 6 pending.
- `ROADMAP.md`: mark Phase 6 complete and record the plan completion.
- `STATE.md`: update current focus, status, and last activity to reflect that the blocker is closed.
- `v1.0-MILESTONE-AUDIT.md`: rerun or regenerate the audit so the partial statuses disappear.

## Risks to watch

- `tools/bazel/README.md` already claims the Phase 3 proof slice is complete on macOS and Linux/arm64, so the verification report should match that wording rather than introduce a narrower story unless the current repo evidence forces it.
- If the traceability metadata is left stale after the report is written, the repo will still look partially blocked even though the evidence gap is closed.
- DEPS-01 and DEPS-03 should be proven by explicit metadata and bridge inventory, not only by successful build output.

