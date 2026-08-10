# AntiGravity AI 助手个人工作流模板 (Pure Template)

本仓库是基于 **AntiGravity (AGY)** 规范提炼的纯净版工作流模板。不包含任何特定项目的历史业务代码、需求文档或归档记录，仅保留核心自动化脚本、基线模板与个人编码偏好。

---

## 🚀 快速开始

### 1. 复制工作流文件到目标项目
将本仓库中的 `.workflow_wengjk` 目录与 `AGENTS.md` 文件复制到任何开发项目的根目录下：

```bash
cp -R .workflow_wengjk /path/to/your-project/
cp AGENTS.md /path/to/your-project/
```

### 2. 在 Git 中忽略工作流目录
为了防止个人 AI 工作流的临时文件污染项目代码仓库，请在目标项目的 `.gitignore` 中添加：

```gitignore
# AI 助手工作流（本地私有，不提交到项目 Git）
.workflow_wengjk/
```

---

## 📂 目录结构说明

```
.workflow_wengjk/
├── README.md                      # 工作流命令与使用说明
├── archive_active_iteration.sh     # 迭代收口归档脚本
├── pause_active.sh                # 正式迭代暂停让路脚本
├── resume_paused.sh               # 被暂停迭代恢复脚本
├── reset_active_to_baseline.sh    # 工作台安全重置脚本
├── persona/
│   └── coding_preference.md       # 个人长期编码偏好档案
├── _baseline_active/              # 空白工作台基线模板
├── active/                        # 当前项目正在推进的工作区
├── archive/                       # 历史迭代归档区
├── paused/                        # 临时暂停迭代区
└── source_materials/              # 当前迭代原始需求材料区
```

---

## 🛠️ 常用脚本命令

| 脚本 | 适用场景 | 执行示例 |
| --- | --- | --- |
| **迭代归档** | 所有任务全完成（`done`/`cancelled`）后归档 | `./.workflow_wengjk/archive_active_iteration.sh ITERATION-20260810-订单重构 原始材料目录名` |
| **迭代暂停** | 正式大版本开发中途被紧急插队 | `./.workflow_wengjk/pause_active.sh ITERATION-20260810-订单重构 原始材料目录名 "插队原因"` |
| **恢复暂停** | 紧急插队完成后，恢复暂停的工作区 | `./.workflow_wengjk/resume_paused.sh ITERATION-20260810-订单重构` |
| **重置工作台** | 放弃当前临时工作台，重置为基线 | `./.workflow_wengjk/reset_active_to_baseline.sh --confirm-discard-active` |

---

## 📌 注意事项

1. **状态真源**：`.workflow_wengjk/active/task_board.md` 是唯一任务状态真源。
2. **编码闸门**：只有任务状态进入 `doing`（且拥有已确认的 `brief.md` / `plan.md`）后，AI 助手才允许修改业务代码。
3. **长期偏好**：个人编码偏好存放于 `.workflow_wengjk/persona/coding_preference.md`，AI 助手在交付代码前会自动自检。
