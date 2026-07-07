---
name: garage-safe-change
description: Plan and execute a narrow, repo-safe Garage code change with inspection, scope control, build verification, diff review, and explicit risk reporting. Use for refactors, multi-file changes, architecture-sensitive work, bug fixes with uncertain ownership, or tasks where unrelated worktree changes must be protected. Do not use for tiny copy-only edits.
---

# Garage Safe Change

Read `references/change-report.md`.

## Objective

Make the smallest correct change without damaging unrelated work, architecture, or user changes.

## Workflow

### 1. Establish reality

Before editing:
- print or inspect the working directory
- find the project or workspace
- detect the Git root if one exists
- inspect repository status when Git is available
- identify the app scheme and relevant target
- inspect task-relevant docs, but treat stale absolute paths cautiously

Do not assume a path from previous sessions is still correct.

### 2. Inspect ownership

Trace:
- entry point
- state owner
- model/service owner
- downstream callers
- related tests
- shared components or utilities

For a large file, identify whether the task can be solved locally or whether extraction is required for safe modification.

### 3. Define scope

Before code changes, state:
- files expected to change
- behavior expected to change
- behavior explicitly protected
- verification plan

If the discovered architecture contradicts the request, report the conflict and choose the least destructive path.

### 4. Edit narrowly

Rules:
- no drive-by cleanup
- no unrelated rename sweep
- no third-party dependency by default
- no broad model migration for a local view issue
- no silent behavior change
- no deletion or revert of unrelated user work

### 5. Build in stages

After a meaningful structural change:
- run a build or targeted compilation check
- fix compiler errors before expanding the edit
- then continue

For complex refactors, verify behavior again after the final integration step.

### 6. Review the diff

Before concluding:
- inspect changed files
- check for unintended formatting churn
- check for accidental asset/project-file changes
- check for removed logic not covered by the task
- confirm unrelated working-tree changes remain untouched

### 7. Report truthfully

Use the report contract in `references/change-report.md`.

If a simulator runtime, signing configuration, package resolution, or tool mismatch blocks verification, report the exact limitation. Do not translate "could not run" into "should work."

## Pairing

Use with:
- `swiftui-view-refactor` for large SwiftUI cleanup
- `gh-fix-ci` for failing Actions
- `garage-ui-guardian` when visuals change
- `simulator-proof` for visible or interactive behavior
