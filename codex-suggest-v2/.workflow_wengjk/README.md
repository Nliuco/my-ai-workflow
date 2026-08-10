# 个人 AI 工作流

本目录管理需求、任务、计划、审查、决策、个人偏好和迭代生命周期。状态只以 `active/task_board.md` 为准，当前指针只写入 `active/current.md`。

## 日常入口

| 路径 | 用途 |
| --- | --- |
| `active/current.md` | 当前迭代、任务、编码闸门和下一步 |
| `active/task_board.md` | 唯一任务状态真源 |
| `active/tasks/<task_id>/brief.md` | 任务边界与验收 |
| `active/tasks/<task_id>/plan.md` | 用户确认后的开发计划 |
| `active/tasks/<task_id>/review.md` | 代码完成后的审查包 |
| `active/decisions.md` | 关键且易误判的决策 |
| `persona/coding_preference.md` | 跨项目个人编码偏好 |
| `persona/languages/` | 按技术栈生效的条件式偏好 |
| `persona/project_preference.md` | 当前项目专属约束 |

## 生命周期

- 临时小需求插队：只在当前看板新增独立任务，不切换迭代。
- 正式迭代插队：预览并确认后执行 `pause_active.sh`。
- 恢复暂停迭代：当前 `active/` 为基线后执行 `resume_paused.sh`。
- 迭代全部收口：执行 `archive_active_iteration.sh`，脚本会归档并自动重置工作台。
- 明确丢弃无保留价值的工作台：执行 `reset_active_to_baseline.sh --confirm-discard-active`。

## 安全原则

- 未收到用户明确确认，不暂停、归档、恢复或重置工作台。
- 正常迁移必须使用脚本，不手工拼接 `mv/cp/rm`。
- `archive/` 是已结束历史，`paused/` 是尚未完成且计划恢复的工作区。
- 同一期只能位于 `active/`、`paused/`、`archive/` 之一。
- 项目脚本与规则验证使用 `tests/run.sh`。
