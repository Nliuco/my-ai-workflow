# `.workflow_wengjk` 工作流引擎指南

> AI 助手工作流私有目录。存放当前项目正在推进的迭代任务、历史归档、脚本与个人偏好。

## 目录指南

- `active/`：当前活动工作区。AI 助手的主要读写入口。
- `_baseline_active/`：空白基线模板。在新迭代启动或重置工作台时复制到 `active/`。
- `persona/`：个人长期偏好档案（`coding_preference.md`）。
- `archive/`：已完成迭代的按年份归档区。
- `paused/`：被高优先级项目插队而暂时挂起的迭代包。
- `source_materials/`：原始需求输入材料（PRD、图片、方案等）。

## 核心自动化脚本

所有脚本已加上 `set -euo pipefail` 与安全回滚逻辑：

1. **`archive_active_iteration.sh <迭代目录名> <原始材料目录名>`**
   - 检查 `active/task_board.md` 所有任务是否全为收口状态（`done`/`cancelled`）。
   - 将 `active/` 内容与对应 `source_materials/` 材料打包移动至 `archive/YYYY/<迭代目录名>/`。
   - 自动将 `active/` 重置为 `_baseline_active/` 基线。

2. **`pause_active.sh <暂停包名> <原始材料目录名> [暂停原因]`**
   - 保存当前未完成的 `active/` 及原始材料至 `paused/<暂停包名>/`。
   - 生成 `pause.md` 记录 Git 分支、Commit 基准与恢复检查项。
   - 自动重置 `active/` 为基线，准备开启插队迭代。

3. **`resume_paused.sh <暂停包名>`**
   - 检查当前 `active/` 是否处于基线状态。
   - 恢复暂停包中的 `active/` 与原始材料。

4. **`reset_active_to_baseline.sh --confirm-discard-active`**
   - 强制清空并重置当前 `active/` 为空白基线模板。
