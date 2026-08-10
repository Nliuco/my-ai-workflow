#!/usr/bin/env bash
# 将已收口的 active 和当前迭代原始材料按固定结构归档，并安全重置 active。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ITERATION_NAME="${1:-}"
SOURCE_NAME="${2:-}"

if [[ -z "$ITERATION_NAME" || -z "$SOURCE_NAME" || "$ITERATION_NAME" == */* || "$SOURCE_NAME" == */* ]]; then
  echo "用法：$0 <迭代目录名> <原始材料目录名>" >&2
  exit 1
fi

if [[ ! "$ITERATION_NAME" =~ ^ITERATION-([0-9]{4})[0-9]{4}- ]]; then
  echo "错误：迭代目录名必须为 ITERATION-YYYYMMDD-主题。" >&2
  exit 1
fi

if [[ ! -d "$ROOT/active" || ! -d "$ROOT/_baseline_active" || ! -d "$ROOT/source_materials/$SOURCE_NAME" ]]; then
  echo "错误：缺少 active、基线或指定原始材料目录。" >&2
  exit 1
fi

if rg -n '\| (todo|planned|doing|review|blocked|paused) \|' "$ROOT/active/task_board.md" >/dev/null; then
  echo "错误：task_board.md 仍存在未收口任务，不能归档。" >&2
  exit 1
fi

shopt -s dotglob nullglob
ACTIVE_CONTENTS=("$ROOT/active"/*)
if (( ${#ACTIVE_CONTENTS[@]} == 0 )); then
  echo "错误：active 为空，拒绝归档。" >&2
  exit 1
fi

YEAR="${BASH_REMATCH[1]}"
ARCHIVE_YEAR_DIR="$ROOT/archive/$YEAR"
DEST="$ARCHIVE_YEAR_DIR/$ITERATION_NAME"
if [[ -e "$DEST" ]]; then
  echo "错误：归档目录已存在：$DEST" >&2
  exit 1
fi

mkdir -p "$ARCHIVE_YEAR_DIR"
STAGING="$(mktemp -d "$ARCHIVE_YEAR_DIR/.staging-${ITERATION_NAME}.XXXXXX")"
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

cp -R "$ROOT/active/." "$STAGING/"
rm -rf "$STAGING/tasks/_template"
mkdir -p "$STAGING/source_materials"
cp -R "$ROOT/source_materials/$SOURCE_NAME" "$STAGING/source_materials/"

test -f "$STAGING/current.md"
test -f "$STAGING/task_board.md"
test -d "$STAGING/requirements"
test -d "$STAGING/tasks"
test -d "$STAGING/source_materials/$SOURCE_NAME"

cp -R "$ROOT/_baseline_active/." "$NEW_ACTIVE/"
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
  echo "警告：归档已完成，但原始材料旧目录未清理：$SOURCE_NAME" >&2
fi

trap - EXIT
echo "已归档迭代：$DEST"
echo "已恢复新的基线 active。"
