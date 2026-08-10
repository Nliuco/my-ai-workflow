# AI 助手工作流与项目约束

本文件是 wengjk 在本地 AI 助手工作流入口。目标是让 AI 助手主动续航、少写噪音文档，把用户精力留给需求拍板和代码审查。

## 工作方式

- 默认用中文沟通，回答要短、准、可执行。
- 先读代码和现有模式，再给结论；不要靠猜测改业务代码。
- 代码改动保持小步、可审查，避免无关重构。
- 如果用户只是咨询或复盘工作流，不要擅自修改业务代码。
- 如果进入正式开发任务，必须遵守 `.workflow_wengjk/active/current.md` 和 `task_board.md`。

## 工作流文件

AI 助手工作流只把以下文件作为日常入口：

1. `.workflow_wengjk/active/current.md`：当前任务、编码闸门、下一步动作。
2. `.workflow_wengjk/active/task_board.md`：唯一任务状态真源。
3. `.workflow_wengjk/active/tasks/<task_id>/brief.md`：任务边界与验收。
4. `.workflow_wengjk/active/tasks/<task_id>/plan.md`：开发前计划。
5. `.workflow_wengjk/active/tasks/<task_id>/review.md`：编码完成后的审查包。
6. `.workflow_wengjk/active/decisions.md`：只记录关键决策。
7. `.workflow_wengjk/active/requirements/`：本期需求入口。
8. `.workflow_wengjk/persona/coding_preference.md`：长期个人编码偏好主档。
9. `.workflow_wengjk/paused/`：被正式迭代打断、尚未完成且计划恢复的迭代工作区。

## 原始材料与归档

- 新一期开始时，AI 助手必须先创建当前迭代的 `source_materials/ITERATION-xxxx-主题/` 子目录，再读取原始材料，再开始需求整理。
- 当前迭代原始材料目录以 `active/current.md` 的 `iteration_id` 为准；根目录中可能保留历史遗留目录，但 AI 助手冷启动时只能读取当前目录，避免串期误读。
- 正常归档必须同时归档当前 `active/` 工作产物和当前迭代原始材料，保证历史需求、任务和输入可完整追溯。
- `paused/` 不是归档区，只保存被整体暂停且预计恢复的迭代；暂停包应同时保存当时的 `active/`、暂停说明和对应原始材料。
- 用户不需要手工维护 `source_materials/` 的目录层级；这是 AI 助手的工作。

## 新一期启动顺序

1. 识别当前迭代主题。
2. 自动创建 `source_materials/ITERATION-xxxx-主题/`。
3. 用户把原始 PRD、图片、会议记录等提供给 AI 助手，AI 助手负责放入当前迭代目录。
4. 只读取当前迭代目录内容。
5. 生成或更新 `active/requirements/`。

## 冷启动

当用户要求推进本期需求、继续任务或开发代码时，按顺序读取：

1. `current.md`
2. `task_board.md`
3. 当前选定任务的 `brief.md`（若该任务已进入执行准备）
4. 当前选定任务的 `plan.md`（若该任务已进入执行准备）
5. 若 `current_sub_task_id` 不为空，读取 `tasks/<task_id>/plans/<sub_task_id>.md`；文件不存在时，明确其尚未进入执行准备，不得编码。
6. `decisions.md` 中与当前任务相关的条目
7. 仅按链接读取相关需求文档和相关代码

## 轻量优先

- 默认只使用 `current.md`、`task_board.md`、当前任务的 `brief.md` / `plan.md` / `review.md`、`decisions.md`、`requirements/`。
- `archive/` 只在用户明确要求追溯历史时再读，不作为默认工作流入口。
- 不增加无必要的人肉同步步骤。

首轮只输出：当前任务、状态、编码闸门、阻塞项、建议下一步。不要把全部工作流文档复述给用户。

## 两档任务

### 正式任务

满足任一条件即为正式任务：

- 新功能或跨模块改动。
- 支付、钱包、订单、退款、提现、消息、定时任务、数据修复等高风险链路。
- 会新增表、改状态机、改接口契约、改权限或改导出字段。
- 用户要求按工作流推进。

正式任务规则：

- 任务拆分阶段不提前创建所有任务的 `brief.md` / `plan.md`；只有选定某个任务进入执行准备时才创建。
- 选定任务开发前必须存在该任务的 `brief.md` 和 `plan.md`。
- `plan.md` 必须经用户确认。
- 用户明确说“开始开发”后，才允许改业务代码。
- 开发开始时，将 `task_board.md` 当前任务改为 `doing`。
- 代码完成后，将任务改为 `review`，并更新 `review.md`。
- 用户审查通过后，才把任务改为 `done`。

### 快速任务

小 bug、小文案、小字段、小 SQL 修正，可走快速通道：

- 先用 3-5 行说明改动计划。
- 不强制新建完整任务目录。
- 涉及已有 `task_id` 时，完成后补 `review.md` 即可。
- 一旦发现影响状态机、资金、接口契约或跨模块边界，立即升级为正式任务。

## 文档瘦身规则

- `task_board.md` 是唯一状态真源，其他文件不要重复维护任务状态。
- `current.md` 只写当前指针和下一步，不写历史百科。
- `decisions.md` 只记录不可逆或容易被 AI 误判的决策。
- `brief.md` 写需求边界，`plan.md` 写实现计划，`review.md` 写代码审查重点。
- 不要为了“同步工作流”批量改 5 个以上文档。除非用户明确要求，单轮最多更新：`task_board.md`、`current.md`、当前任务 `review.md`、必要的 `decisions.md`。
- 不要把聊天流水、长历史、过期状态搬进 active；归档材料放到 `archive/`。

## 代码质量闸门

提交给用户审查前，AI 助手必须自查：

- 命名是否表达业务语义，避免 `row`、`column` 等弱语义变量。
- Controller 是否只做分发、参数处理和响应封装，避免塞业务。
- 是否复用现有 Service、Mapper、Enum、常量、工具类。
- 是否引入了不必要的新抽象；抽象必须降低真实复杂度。
- 是否存在重复查询、重复状态判断、重复文案拼接。
- 是否保持项目现有异常风格、分页风格、假删过滤、权限风格。
- 日志、注释、文档和命名要贴近真实业务场景，避免使用“归因”等含义抽象、容易产生理解偏差的黑话；不排斥专业术语，但有更直观的业务表达时优先使用更容易理解、正式但不互联网黑话的说法。
- 支付、钱包、订单、退款、提现相关改动必须说明状态机和幂等点。
- 不要把个人工作流信息写进业务代码、SQL、注释或文档正文中，例如 `TASK-xxx`、`brief`、`plan`、`review`、`current`、`task_board` 这类个人目录标识；这些内容只属于 `.workflow_wengjk/`。
- 业务代码里的注释只保留对项目其他人和未来维护者有价值的内容，不要写“这是某个 TASK 的实现”这类个人工作流备注。
- 编码完成后，必须对照 `.workflow_wengjk/persona/coding_preference.md` 做自检；如果发现不符合，优先修正后再交付。
- 如果后续对话里出现“我偏好/我喜欢/我觉得更好看”这类表达，AI 助手应先判断它是否是可长期复用的通用编码偏好；只有在你明确确认后，才补入 `persona/coding_preference.md`。临时口径、一次性方案和本期特有偏好，不要自动升级为长期规则。

`review.md` 必须包含“建议用户重点审查”的 3-5 个点。

## 通用 Java / 代码规范

- Lombok 使用 `@Getter` + `@Setter`，避免 `@Data`。
- `Byte` / `byte` 且只有 0/1 两种状态时，优先用 `GlobalConstant.FALSE` / `GlobalConstant.TRUE`。
- 无分页接口返回 `R<T>`；分页接口返回 `TotalTable<List<T>>`。
- REST 接口禁止路径参数传参；GET 参数大于等于 3 个时封装 request 对象。
- 永远不要改 `package` 声明。
- Java 外部类引用必须通过 `import`，不要在代码里写全限定类名，除非类名冲突。
- 引入第三方依赖前必须向用户确认官方出处或文档链接。
- 待办统一写 `TODO_wengjk:`；关键注释写 `COMMENT_wengjk:`；关键任务写 `TASK_wengjk:`。
- Bean 注入多数场景使用 `@Resource`；基础设施类可使用构造器注入。
- 查询优先使用 `Wrappers.<T>lambdaQuery()`，并带 `is_delete = GlobalConstant.FALSE`。
- 判空和比较优先使用 `Objects`、`StringUtils`、`CollectionUtils` 等工具类，判空喜欢 Optional 处理。
- 请求 VO 的 trim 逻辑优先用 `ITrimmedRequest`。
- 序列化字段使用 `@Serial private static final long serialVersionUID = 1L;`。
- 编码完成后关注 Spring Bean 循环依赖；不要轻易用 `@Lazy` 兜底。

## 验证

- 能运行测试或编译时，优先运行与改动相关的最小验证命令。
- 如果没有运行验证，必须在最终回复和 `review.md` 中说明原因。

## 归档

- 未收到用户明确归档指令，不要移动、删除或清空 `.workflow_wengjk/active/`。
- 正常归档只允许全部任务达到 `done`、`cancelled` 或 `out_of_scope` 后执行；未完成但后续要继续的迭代使用 `paused/`，不要归档。
- 归档统一使用 `.workflow_wengjk/archive_active_iteration.sh <迭代目录名> <原始材料目录名>`，不得把整层 `active/` 嵌套放入归档目录。
- 归档固定结构为 `archive/YYYY/<迭代目录名>/` 下的 `current.md`、`task_board.md`、`decisions.md`、`requirements/`、`tasks/` 和 `source_materials/<原始材料目录名>/`。
- 新一期开始前，归档脚本会重置 `active/`；不要再单独对同一已归档工作区执行重置脚本。

## 工作流脚本闸门

- AI 助手必须优先使用现有工作流脚本，不得以手工 `mv`、`cp`、`rm` 拼接替代正常暂停、恢复、归档流程。
- 用户说“归档当前迭代”时，先检查任务是否全部收口，再执行 `archive_active_iteration.sh`；该脚本完成归档并重置 `active/`，归档后不得再执行 reset。
- 用户说“暂停当前迭代”时，先输出暂停包名、当前断点、当前迭代原始材料和 Git 信息预览；只有用户明确说“确认暂停”后，才执行 `pause_active.sh`，原始材料目录不得省略。
- 用户说“恢复暂停的 <迭代>”时，先确认当前 `active/` 是基线且不存在原始材料目录冲突，再执行 `resume_paused.sh`。
- `reset_active_to_baseline.sh --confirm-discard-active` 仅用于用户明确要求丢弃当前空白或无保留价值的工作台；执行前必须说明它会删除当前 `active/`，并等待用户明确确认。不得省略确认参数，它不是归档、暂停或恢复流程的一部分。

## 迭代暂停与恢复

- 临时产品需求只新增独立任务并调整优先级，不为几天的小需求切换整个迭代工作区。
- 只有正式大版本需要接管 `active/`，且当前迭代尚未完成、后续明确要继续时，才使用 `.workflow_wengjk/paused/`。
- `active/`、`paused/`、`archive/` 的语义分别是“正在推进”“尚未完成且暂时让路”“已经结束”；同一期只能存在于其中一个位置。
- 暂停前必须把当前任务或子任务停在可说明的边界，在 `current.md` 写清恢复后的第一个动作，并在 `task_board.md` 将对应任务标记为 `paused`。
- 暂停包目录为 `paused/ITERATION-xxxx-主题/`，必须包含 `pause.md`、完整的 `active/` 和 `source_materials/<当前迭代目录>/`。
- `pause.md` 只记录暂停原因、恢复条件、Git 分支与提交、未合入代码情况和恢复前检查项；任务详细状态仍以暂停包内的 `active/task_board.md` 为准。
- 暂停使用 `.workflow_wengjk/pause_active.sh`，恢复使用 `.workflow_wengjk/resume_paused.sh`；不要手工合并两个 `task_board.md`。
- 恢复前必须先归档或清理当前产品迭代，使 `active/` 回到基线；恢复后重新检查代码、数据库和接口变化，原计划失效时更新 `plan.md` 并重新确认，不自动直接进入编码。
