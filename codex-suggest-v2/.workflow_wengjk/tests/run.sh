#!/usr/bin/env bash
set -euo pipefail

WORKFLOW_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

bash -n \
  "$WORKFLOW_ROOT/archive_active_iteration.sh" \
  "$WORKFLOW_ROOT/pause_active.sh" \
  "$WORKFLOW_ROOT/resume_paused.sh" \
  "$WORKFLOW_ROOT/reset_active_to_baseline.sh" \
  "$WORKFLOW_ROOT/install_project_integration.sh"

test_pause_resume() {
  local root
  root="$(mktemp -d /tmp/workflow-template-pause.XXXXXX)"
  local workflow="$root/.workflow_wengjk"
  mkdir -p "$workflow/archive" "$workflow/paused" "$workflow/source_materials/ITERATION-20260810-测试"
  cp -R "$WORKFLOW_ROOT/_baseline_active" "$workflow/_baseline_active"
  cp -R "$WORKFLOW_ROOT/_baseline_active" "$workflow/active"
  cp "$WORKFLOW_ROOT/pause_active.sh" "$WORKFLOW_ROOT/resume_paused.sh" "$workflow/"
  printf 'marker\n' >> "$workflow/active/current.md"
  "$workflow/pause_active.sh" ITERATION-20260810-测试 ITERATION-20260810-测试 测试 >/dev/null
  diff -qr "$workflow/active" "$workflow/_baseline_active" >/dev/null
  "$workflow/resume_paused.sh" ITERATION-20260810-测试 >/dev/null
  grep -q marker "$workflow/active/current.md"
  test -d "$workflow/source_materials/ITERATION-20260810-测试"
}

test_archive_and_reset() {
  local root
  root="$(mktemp -d /tmp/workflow-template-archive.XXXXXX)"
  local workflow="$root/.workflow_wengjk"
  mkdir -p "$workflow/archive" "$workflow/source_materials/ITERATION-20260810-测试"
  cp -R "$WORKFLOW_ROOT/_baseline_active" "$workflow/_baseline_active"
  cp -R "$WORKFLOW_ROOT/_baseline_active" "$workflow/active"
  cp "$WORKFLOW_ROOT/archive_active_iteration.sh" "$WORKFLOW_ROOT/reset_active_to_baseline.sh" "$workflow/"
  perl -0pi -e 's/\| todo \| `tasks\/TASK-001\/` \| — \|/| done | `tasks\/TASK-001\/` | 已完成 |/' "$workflow/active/task_board.md"
  "$workflow/archive_active_iteration.sh" ITERATION-20260810-测试 ITERATION-20260810-测试 >/dev/null
  test -f "$workflow/archive/2026/ITERATION-20260810-测试/task_board.md"
  diff -qr "$workflow/active" "$workflow/_baseline_active" >/dev/null
  printf 'discard\n' >> "$workflow/active/current.md"
  if "$workflow/reset_active_to_baseline.sh" >/dev/null 2>&1; then
    return 1
  fi
  grep -q discard "$workflow/active/current.md"
  "$workflow/reset_active_to_baseline.sh" --confirm-discard-active >/dev/null
  diff -qr "$workflow/active" "$workflow/_baseline_active" >/dev/null
}

test_install_integration() {
  local root
  root="$(mktemp -d /tmp/workflow-template-install.XXXXXX)"
  mkdir -p "$root/project/.workflow_wengjk/integration" "$root/project/.workflow_wengjk/persona"
  cp "$WORKFLOW_ROOT/install_project_integration.sh" "$root/project/.workflow_wengjk/"
  cp "$WORKFLOW_ROOT/integration/AGENTS.fragment.md" "$root/project/.workflow_wengjk/integration/"
  printf '# Existing Rules\n' > "$root/project/AGENTS.md"
  "$root/project/.workflow_wengjk/install_project_integration.sh" "$root/project" >/dev/null
  "$root/project/.workflow_wengjk/install_project_integration.sh" "$root/project" >/dev/null
  test "$(grep -c '<!-- workflow_wengjk:start -->' "$root/project/AGENTS.md")" -eq 1
  grep -q '# Existing Rules' "$root/project/AGENTS.md"
}

test_v2_contract() {
  local fragment="$WORKFLOW_ROOT/integration/AGENTS.fragment.md"
  local generic_files=(
    "$WORKFLOW_ROOT/README.md"
    "$fragment"
    "$WORKFLOW_ROOT/persona/coding_preference.md"
    "$WORKFLOW_ROOT/persona/project_preference.md"
  )

  test -f "$WORKFLOW_ROOT/persona/languages/java.md"
  grep -q '^### 任务分级$' "$fragment"
  grep -q '^正式任务包括：' "$fragment"
  grep -q '^快速任务适用于' "$fragment"
  grep -q 'reset_active_to_baseline.sh --confirm-discard-active' "$fragment"

  if grep -E -n \
    'GlobalConstant|TotalTable|Wrappers|ITrimmedRequest|com\.bjpygh|闲置交易|订单链路|急救扫码|dxt-server' \
    "${generic_files[@]}"; then
    echo "generic workflow files contain project-specific content" >&2
    return 1
  fi
}

test_pause_resume
test_archive_and_reset
test_install_integration
test_v2_contract
echo "workflow template tests: PASS"
