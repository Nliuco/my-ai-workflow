# AntiGravity AI 助手个人工作流模板 (v2 融合工程版)

本仓库是融合了 **AntiGravity 深入规则** 与 **Codex 零侵入工程架构** 的终极纯净版工作流模板。不包含任何历史业务代码，专注于跨项目无缝可移植性、Git 隔离性与自动测试。

---

## 🔥 核心优势

- **一键零侵入安装**：通过 `install_project_integration.sh` 使用标记位 `<!-- workflow_wengjk:start -->` 增量写入目标项目的 `AGENTS.md`，**绝不覆盖项目原有的自定义规则**。
- ** Git 零污染**：自动写入目标项目的 `.git/info/exclude`（Git 本地私有忽略文件），**不需要修改团队共享的 `.gitignore`**，默默在本地使用，不留提交痕迹。
- **偏好架构分层**：解耦全局个人偏好（`coding_preference.md`）与特定项目偏好（`project_preference.md`）。
- **自动化测试**：自带 Bash 单元测试脚本（`tests/run.sh`），保证工作流脚本逻辑稳健。

---

## 🚀 快速开始

### 1. 拷贝到新项目并运行一键安装
将本仓库中的 `.workflow_wengjk` 目录复制到任意新项目的根目录下，并运行安装脚本：

```bash
# 1. 拷贝目录
cp -R .workflow_wengjk /path/to/your-project/

# 2. 运行一键安装
/path/to/your-project/.workflow_wengjk/install_project_integration.sh
```

### 2. 补充项目特有偏好（可选）
安装完成后，如果目标项目有特定的数据库规范或技术栈约定，可在项目本地编辑：
`.workflow_wengjk/persona/project_preference.md`

---

## 🛠️ 常用脚本命令

| 脚本 | 适用场景 | 执行示例 |
| --- | --- | --- |
| **一键安装** | 接入目标项目 `AGENTS.md` 并配置 Git 隔离 | `./.workflow_wengjk/install_project_integration.sh` |
| **迭代归档** | 所有任务完成后归档 active 与原始材料 | `./.workflow_wengjk/archive_active_iteration.sh ITERATION-YYYYMMDD-主题 原始材料目录` |
| **迭代暂停** | 紧急插队，挂起当前 active 为暂停包 | `./.workflow_wengjk/pause_active.sh ITERATION-YYYYMMDD-主题 原始材料目录 "插队原因"` |
| **恢复暂停** | 恢复挂起的迭代包与原始材料 | `./.workflow_wengjk/resume_paused.sh ITERATION-YYYYMMDD-主题` |
| **重置工作台** | 放弃当前 active 并恢复为基线 | `./.workflow_wengjk/reset_active_to_baseline.sh --confirm-discard-active` |
| **脚本测试** | 校验工作流脚本的语法与逻辑正确性 | `./.workflow_wengjk/tests/run.sh` |
