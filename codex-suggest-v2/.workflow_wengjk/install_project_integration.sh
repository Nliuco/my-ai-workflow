#!/usr/bin/env bash
# 将通用工作流规则以受控区块接入项目根 AGENTS.md，并配置本地 Git 忽略。
set -euo pipefail

WORKFLOW_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="${1:-$(cd "$WORKFLOW_ROOT/.." && pwd)}"
FRAGMENT="$WORKFLOW_ROOT/integration/AGENTS.fragment.md"
AGENTS_FILE="$PROJECT_ROOT/AGENTS.md"
START_MARKER='<!-- workflow_wengjk:start -->'
END_MARKER='<!-- workflow_wengjk:end -->'

if [[ ! -f "$FRAGMENT" || ! -d "$PROJECT_ROOT" ]]; then
  echo "错误：缺少 AGENTS 片段或目标项目目录。" >&2
  exit 1
fi

TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/agents-workflow.XXXXXX")"
cleanup() {
  rm -f "$TEMP_FILE"
}
trap cleanup EXIT

if [[ -f "$AGENTS_FILE" ]]; then
  awk -v start="$START_MARKER" -v end="$END_MARKER" '
    $0 == start { skipping = 1; next }
    $0 == end { skipping = 0; next }
    !skipping { print }
  ' "$AGENTS_FILE" > "$TEMP_FILE"
else
  : > "$TEMP_FILE"
fi

while [[ -s "$TEMP_FILE" ]] && [[ "$(tail -c 1 "$TEMP_FILE" | wc -l | tr -d ' ')" == "0" ]]; do
  printf '\n' >> "$TEMP_FILE"
done

if [[ -s "$TEMP_FILE" ]]; then
  printf '\n' >> "$TEMP_FILE"
fi
cat "$FRAGMENT" >> "$TEMP_FILE"
printf '\n' >> "$TEMP_FILE"
mv "$TEMP_FILE" "$AGENTS_FILE"
trap - EXIT

if git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  GIT_DIR="$(git -C "$PROJECT_ROOT" rev-parse --git-dir)"
  if [[ "$GIT_DIR" != /* ]]; then
    GIT_DIR="$PROJECT_ROOT/$GIT_DIR"
  fi
  EXCLUDE_FILE="$GIT_DIR/info/exclude"
  mkdir -p "$(dirname "$EXCLUDE_FILE")"
  touch "$EXCLUDE_FILE"
  if ! grep -Fxq '.workflow_wengjk/' "$EXCLUDE_FILE"; then
    printf '\n.workflow_wengjk/\n' >> "$EXCLUDE_FILE"
  fi
fi

echo "已接入工作流规则：$AGENTS_FILE"
echo "请填写：$WORKFLOW_ROOT/persona/project_preference.md"
