# 本期任务总表

> **唯一任务状态真源**。其他文件不重复维护任务状态。

## 状态

- `todo`：已完成任务拆分，仅记录任务边界、依赖和需求入口；尚未进入该任务的执行准备。
- `planned`：`brief.md`、`plan.md` 已完成，等待用户确认。
- `doing`：用户已确认 plan 且明确说“开始开发”。
- `review`：代码完成，等待用户审查。
- `done`：用户审查通过。
- `blocked`：被外部依赖阻塞。
- `paused`：任务主动为更高优先级工作让路，后续计划恢复。
- `cancelled`：明确取消，不实施。
- `out_of_scope`：本期不做，作为范围收口。

## 任务列表

| task_id | 标题 | owner | 需求入口 | 状态 | 任务目录 | 备注 |
| --- | --- | --- | --- | --- | --- | --- |
| TASK-001 | 示例任务 | wengjk | `requirements/example.md` | todo | `tasks/TASK-001/` | 初始待办理任务模板 |

## TASK-001 子任务

| sub_task_id | 标题 | 依赖 | 状态 | 计划文件 | 备注 |
| --- | --- | --- | --- | --- | --- |
| TASK-001-SUB-001 | 示例子任务 | 无 | todo | — | 子任务模板 |

## 规则

- 任务拆分阶段只更新本表，不提前创建所有任务的 `brief.md` / `plan.md`。
- 用户选定某个 `todo` 任务进入执行准备后，才创建该任务的 `brief.md` 和 `plan.md`，并将其改为 `planned`。
- 正式任务进入编码前，必须有当前任务的 `brief.md` 和 `plan.md`。
- 用户确认计划并明确说“开始开发”后，才能把任务改为 `doing`。
- 代码完成后改为 `review`，并填写 `tasks/<task_id>/review.md`。
- 用户审查通过后改为 `done`。
- 复杂任务的子任务状态同样只在本表维护；仅为当前选定并进入执行准备的子任务创建 `tasks/<task_id>/plans/<sub_task_id>.md`。
- 子任务完成后使用 `tasks/<task_id>/reviews/<sub_task_id>.md` 提交审查；父任务 `review.md` 只在整个任务总体验收时创建。
