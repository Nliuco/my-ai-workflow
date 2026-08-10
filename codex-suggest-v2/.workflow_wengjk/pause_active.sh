#!/usr/bin/env bash
# 将当前 active 和可选原始材料安全保存为可恢复的暂停包，并建立新的基线 active。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PAUSE_NAME="${1:-}"
SOURCE_NAME="${2:-}"
PAUSE_REASON="${3:-正式产品迭代插队}"

if [[ -z "$PAUSE_NAME" || -z "$SOURCE_NAME" || "$PAUSE_NAME" == */* || "$SOURCE_NAME" == */* ]]; then
  echo "用法：$0 <暂停包名> <原始材料目录名> [暂停原因]" >&2
  exit 1
fi

if [[ ! -d "$ROOT/active" || ! -d "$ROOT/_baseline_active" ]]; then
  echo "错误：缺少 active 或 _baseline_active 目录。" >&2
  exit 1
fi

DEST="$ROOT/paused/$PAUSE_NAME"
if [[ -e "$DEST" ]]; then
  echo "错误：暂停包已存在：$DEST" >&2
  exit 1
fi

if [[ ! -d "$ROOT/source_materials/$SOURCE_NAME" ]]; then
  echo "错误：原始材料目录不存在或名称不合法：$SOURCE_NAME" >&2
  exit 1
fi

BRANCH="$(git -C "$ROOT/.." branch --show-current 2>/dev/null || true)"
COMMIT="$(git -C "$ROOT/.." rev-parse HEAD 2>/dev/null || true)"
PAUSED_AT="$(date '+%Y-%m-%d %H:%M:%S %z')"

mkdir -p "$ROOT/paused"
STAGING="$(mktemp -d "$ROOT/paused/.staging-${PAUSE_NAME}.XXXXXX")"
NEW_ACTIVE="$(mktemp -d "$ROOT/.active-baseline.XXXXXX")"
OLD_ACTIVE=""
DEST_CREATED=false
COMPLETED=false

cleanup() {
  local exit_code=$?

  if [[ "$COMPLETED" == false && -n "$OLD_ACTIVE" && -d "$OLD_ACTIVE" ]]; then
    rm -rf "$ROOT/active"
    mv "$OLD_ACTIVE" "$ROOT/active" || true
  fi
  if [[ "$COMPLETED" == false && "$DEST_CREATED" == true ]]; then
    rm -rf "$DEST"
  fi
  rm -rf "$STAGING" "$NEW_ACTIVE"
  exit "$exit_code"
}
trap cleanup EXIT

cp -R "$ROOT/active/." "$STAGING/active"
mkdir -p "$STAGING/source_materials"
cp -R "$ROOT/source_materials/$SOURCE_NAME" "$STAGING/source_materials/"
cp -R "$ROOT/_baseline_active/." "$NEW_ACTIVE/"

cat > "$STAGING/pause.md" <<EOF
# 暂停信息

- **暂停包**：\`$PAUSE_NAME\`
- **暂停时间**：\`$PAUSED_AT\`
- **暂停原因**：$PAUSE_REASON
- **状态真源**：\`active/task_board.md\`
- **恢复入口**：\`active/current.md\`
- **Git 分支**：\`${BRANCH:-未记录}\`
- **基准提交**：\`${COMMIT:-未记录}\`
- **原始材料**：\`$SOURCE_NAME\`
- **未合入代码**：恢复前人工确认
- **恢复条件**：当前高优先级产品迭代完成并归档
- **恢复前检查**：重新核对暂停期间的代码、数据库和接口变化，必要时更新并重新确认 plan
EOF

test -f "$STAGING/active/current.md"
test -f "$STAGING/active/task_board.md"
test -f "$STAGING/pause.md"
test -f "$NEW_ACTIVE/current.md"
test -f "$NEW_ACTIVE/task_board.md"

mv "$STAGING" "$DEST"
STAGING=""
DEST_CREATED=true

OLD_ACTIVE="$(mktemp -d "$ROOT/.active-previous.XXXXXX")"
rmdir "$OLD_ACTIVE"
mv "$ROOT/active" "$OLD_ACTIVE"
mv "$NEW_ACTIVE" "$ROOT/active"
NEW_ACTIVE=""

rm -rf "$OLD_ACTIVE"
OLD_ACTIVE=""
COMPLETED=true

if ! rm -rf "$ROOT/source_materials/$SOURCE_NAME"; then
  echo "警告：暂停包已建立，但原始材料旧目录未清理：$SOURCE_NAME" >&2
fi

trap - EXIT
echo "已暂停当前迭代：$DEST"
echo "已恢复新的基线 active，可开始高优先级产品迭代。"
