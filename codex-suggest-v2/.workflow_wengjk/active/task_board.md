# 本期任务总表

> 唯一任务状态真源。其他文件不重复维护任务状态。

## 状态

- `todo`：已拆分，尚未进入执行准备。
- `planned`：brief/plan 已完成，等待用户确认。
- `doing`：用户已确认计划并明确开始开发。
- `review`：代码完成，等待用户审查。
- `done`：用户审查通过。
- `blocked`：被外部依赖阻塞。
- `paused`：主动为更高优先级工作让路。
- `cancelled`：明确取消。
- `out_of_scope`：本期明确不做。

## 任务列表

| task_id | 标题 | owner | 需求入口 | 状态 | 任务目录 | 备注 |
| --- | --- | --- | --- | --- | --- | --- |
| TASK-001 | （初始化后替换） | owner | `requirements/overview.md` | todo | `tasks/TASK-001/` | — |

## 规则

- 拆分阶段只更新本表，不提前创建所有任务文档。
- 选定任务进入执行准备后才创建 brief/plan，并改为 `planned`。
- 用户确认计划并明确开始开发后才能改为 `doing`。
- 代码完成后填写 review 并改为 `review`。
- 用户审查通过后改为 `done`。
- 复杂任务的子任务计划放在 `tasks/<task_id>/plans/<sub_task_id>.md`。
- 子任务审查包放在 `tasks/<task_id>/reviews/<sub_task_id>.md`。
