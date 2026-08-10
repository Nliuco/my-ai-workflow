# AI Workflow Templates Collection (个人 AI 工作流模板合集)

本仓库收录了基于 **AntiGravity (AGY)** 规范演进的通用个人 AI 助手工作流模板集合。不携带任何特定项目的历史业务代码或归档数据，可作为可移植模板拷贝至任何新工程中使用。

---

## 📂 包含的模版版本

| 模板目录 | 适合场景 | 核心特点 |
| --- | --- | --- |
| **`antigravity-suggest`** ⭐ *(推荐)* | **最契合日常习惯** | 100% 还原原汁原味实战工作流。解耦业务后的标准模板，无任何依赖包，直接 `cp -R` 即可使用。 |
| **`antigravity-suggest-v2`** | **通用融合版** | 融合 Codex 非侵入框架。包含受控区块安装 (`install_project_integration.sh`)、`.git/info/exclude` 本地隔离与单元测试 (`tests/run.sh`)。 |
| **`codex-suggest`** | **Codex 基础工程版** | Codex 团队输出的基础工程安装范式。 |
| **`codex-suggest-v2`** | **Codex 语言扩展版** | 引入 `persona/languages/` 语言包三层解耦机制。 |

---

## 🚀 快速使用推荐版本 (`antigravity-suggest`)

1. 将 `antigravity-suggest/.workflow_wengjk` 与 `antigravity-suggest/AGENTS.md` 复制到您的目标开发项目根目录：
   ```bash
   cp -R antigravity-suggest/.workflow_wengjk /path/to/your-project/
   cp antigravity-suggest/AGENTS.md /path/to/your-project/
   ```
2. 在目标项目的 `.gitignore` 中加入：
   ```gitignore
   .workflow_wengjk/
   ```
3. 打开目标项目，AI 助手将自动识别规范并严格遵循编码闸门。
