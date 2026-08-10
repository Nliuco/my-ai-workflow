<!-- workflow_wengjk:start -->
## 个人 AI 工作流与项目约束

本区块由 wengjk 个人 AI 工作流脚本受控维护。目标是让 AI 助手主动续航、少写噪音文档，把用户精力留给需求拍板和代码审查。

### 1. 工作模式与日常入口

- 默认使用中文沟通，回答简短、准确、可执行。
- AI 助手冷启动时只读取以下文件作为入口：
  1. `.workflow_wengjk/active/current.md`（当前指针与编码闸门）
  2. `.workflow_wengjk/active/task_board.md`（唯一任务状态真源）
  3. 当前选定任务的 `brief.md` / `plan.md`（进入执行准备后读取）
  4. 若 `current_sub_task_id` 不为空，读取 `tasks/<task_id>/plans/<sub_task_id>.md`；不存在则不得编码。
  5. `decisions.md` 中与当前任务相关的条目
  6. 编码前必须自查 `.workflow_wengjk/persona/coding_preference.md` 与 `persona/project_preference.md`。
- **轻量沟通规则**：首轮回复只输出当前任务、状态、编码闸门、阻塞项和建议下一步，不要复述完整工作流文档。

### 2. 两档任务与编码闸门

- **正式任务**：涉及新功能、跨模块改动、关键链路（支付/钱包/订单/退款/提现/消息/定时任务等）、改表/接口契约/权限改动。必须先编写 `brief.md` 与 `plan.md`，经用户确认并明确指示“开始开发”后（任务改为 `doing`）方可开启编码闸门修改业务代码。
- **快速任务**：小 bug、小文案、小字段修补。用 3-5 行说明计划即可，完成后补 `review.md`。
- 业务代码改动完成后，将状态改为 `review` 并填写审查包，经用户审查通过后方可改为 `done`。

### 3. 代码质量与审查闸门

提交代码审查前，AI 助手必须自查：
- 命名表达明确业务语义，避免 `row`、`column` 等弱语义变量。
- Controller 层只做分发、参数校验与响应封装，不塞业务逻辑。
- 优先复用已有 Service、Mapper、Enum、常量与工具类。
- 不引入无意义的过度抽象，不存在重复查询、重复状态判断或硬编码文案。
- 业务注释只保留对项目维护者有价值的内容，**严禁将 `TASK-xxx` 等个人工作流标识写进业务代码、SQL 或注释中**。
- 若 `AGENTS.md` 的项目专属规则与通用偏好冲突，以项目专属明确规则为准。

### 4. 工作流自动化脚本闸门

- 必须优先使用现有脚本，严禁使用手动 `mv`/`cp`/`rm` 替代流程。
- **迭代归档**：使用 `./.workflow_wengjk/archive_active_iteration.sh <迭代目录名> <原始材料目录名>`。
- **迭代暂停**：使用 `./.workflow_wengjk/pause_active.sh <暂停包名> <原始材料目录名> [原因]`。
- **恢复暂停**：使用 `./.workflow_wengjk/resume_paused.sh <暂停包名>`。
- **安全重置**：`./.workflow_wengjk/reset_active_to_baseline.sh --confirm-discard-active`。
<!-- workflow_wengjk:end -->
