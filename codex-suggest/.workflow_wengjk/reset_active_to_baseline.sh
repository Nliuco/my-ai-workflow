#!/usr/bin/env bash
# 将 active 恢复为 Codex v2 基线模板（与 _baseline_active 相同）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

if [[ "${1:-}" != "--confirm-discard-active" ]]; then
  echo "错误：该操作会删除当前 active。确认丢弃时请使用：$0 --confirm-discard-active" >&2
  exit 1
fi

if [[ ! -d "$ROOT/_baseline_active" ]]; then
  echo "错误：缺少 $ROOT/_baseline_active，请先保留基线目录。" >&2
  exit 1
fi
rm -rf "$ROOT/active"
cp -R "$ROOT/_baseline_active" "$ROOT/active"
echo "已恢复 active 为 Codex v2 基线模板。"
