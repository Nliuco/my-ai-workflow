<!-- workflow_wengjk:start -->
## 个人 AI 工作流

- 默认先读取 `.workflow_wengjk/active/current.md` 和 `active/task_board.md`，首轮只输出当前任务、状态、编码闸门、阻塞项和建议下一步。
- 当前任务进入执行准备后，读取对应 `brief.md` 和 `plan.md`；存在 `current_sub_task_id` 时读取 `tasks/<task_id>/plans/<sub_task_id>.md`，文件不存在则不得编码。
- 编码前读取 `.workflow_wengjk/persona/coding_preference.md` 和 `persona/project_preference.md`。
- 正式任务必须先有 brief/plan、用户确认计划并明确说“开始开发”，才允许修改业务代码。
- 任务状态只维护在 `active/task_board.md`；代码完成后进入 `review` 并填写审查包，用户审查通过后才能进入 `done`。
- 临时小需求只新增独立任务；正式迭代插队时先提供暂停预览，用户说“确认暂停”后才执行 `pause_active.sh`。
- 正常归档必须执行 `archive_active_iteration.sh`；暂停、恢复、归档不得用手工文件移动替代。
- `reset_active_to_baseline.sh --confirm-discard-active` 只用于用户明确确认丢弃当前工作台，不属于正常归档流程。
- `archive/` 只在用户明确追溯历史时读取；冷启动只读取 `current.md` 指向的当前原始材料目录。
- 若项目根 `AGENTS.md` 的项目专属规则与通用偏好冲突，以项目专属明确规则为准。
<!-- workflow_wengjk:end -->
