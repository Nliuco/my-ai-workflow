#!/usr/bin/env bash
# 在当前 active 为基线时，安全恢复指定暂停迭代及其原始材料。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PAUSE_NAME="${1:-}"

if [[ -z "$PAUSE_NAME" || "$PAUSE_NAME" == */* ]]; then
  echo "用法：$0 <暂停包名>" >&2
  exit 1
fi

SOURCE="$ROOT/paused/$PAUSE_NAME"
if [[ ! -d "$SOURCE/active" ]]; then
  echo "错误：暂停包不存在或缺少 active：$SOURCE" >&2
  exit 1
fi

if ! diff -qr "$ROOT/active" "$ROOT/_baseline_active" >/dev/null; then
  echo "错误：当前 active 不是基线。请先归档当前迭代，再重置 active。" >&2
  exit 1
fi

SOURCE_DIRS=()
if [[ -d "$SOURCE/source_materials" ]]; then
  while IFS= read -r SOURCE_DIR; do
    SOURCE_BASENAME="$(basename "$SOURCE_DIR")"
    if [[ -e "$ROOT/source_materials/$SOURCE_BASENAME" ]]; then
      echo "错误：原始材料目录已存在，拒绝覆盖：$SOURCE_BASENAME" >&2
      exit 1
    fi
    SOURCE_DIRS+=("$SOURCE_DIR")
  done < <(find "$SOURCE/source_materials" -mindepth 1 -maxdepth 1 -type d)
fi

NEW_ACTIVE="$(mktemp -d "$ROOT/.active-resume.XXXXXX")"
SOURCE_STAGING="$(mktemp -d "$ROOT/.source-resume.XXXXXX")"
OLD_ACTIVE=""
MOVED_SOURCE_NAMES=()
COMPLETED=false

cleanup() {
  local exit_code=$?

  if [[ "$COMPLETED" == false && -n "$OLD_ACTIVE" && -d "$OLD_ACTIVE" ]]; then
    rm -rf "$ROOT/active"
    mv "$OLD_ACTIVE" "$ROOT/active" || true
  fi
  if [[ "$COMPLETED" == false ]]; then
    for source_name in "${MOVED_SOURCE_NAMES[@]}"; do
      rm -rf "$ROOT/source_materials/$source_name"
    done
  fi
  rm -rf "$NEW_ACTIVE" "$SOURCE_STAGING"
  exit "$exit_code"
}
trap cleanup EXIT

cp -R "$SOURCE/active/." "$NEW_ACTIVE/"
for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
  cp -R "$SOURCE_DIR" "$SOURCE_STAGING/"
done

test -f "$NEW_ACTIVE/current.md"
test -f "$NEW_ACTIVE/task_board.md"

OLD_ACTIVE="$(mktemp -d "$ROOT/.active-previous.XXXXXX")"
rmdir "$OLD_ACTIVE"
mv "$ROOT/active" "$OLD_ACTIVE"
mv "$NEW_ACTIVE" "$ROOT/active"
NEW_ACTIVE=""

for SOURCE_DIR in "$SOURCE_STAGING"/*; do
  [[ -e "$SOURCE_DIR" ]] || continue
  SOURCE_BASENAME="$(basename "$SOURCE_DIR")"
  mv "$SOURCE_DIR" "$ROOT/source_materials/"
  MOVED_SOURCE_NAMES+=("$SOURCE_BASENAME")
done

rm -rf "$OLD_ACTIVE"
OLD_ACTIVE=""
COMPLETED=true

if ! rm -rf "$SOURCE"; then
  echo "警告：工作台已恢复，但暂停包旧目录未清理：$SOURCE" >&2
fi

trap - EXIT
echo "已恢复暂停迭代：$PAUSE_NAME"
echo "恢复后请先复核 current.md、task_board.md 和原 plan，再决定是否继续编码。"
