# `.workflow_wengjk` 工作流引擎指南 (v2)

> AI 助手工作流私有目录。存放当前项目正在推进的迭代任务、历史归档、脚本与个人偏好。

## 目录结构

- `install_project_integration.sh`：项目一键集成脚本。
- `integration/AGENTS.fragment.md`：规则片段（通过标记位自动接入项目 `AGENTS.md`）。
- `persona/`：
  - `coding_preference.md`：跨项目通用的个人长期编码偏好。
  - `project_preference.md`：当前项目专属的补充偏好。
- `active/`：当前活动工作区。AI 助手的主要读写入口。
- `_baseline_active/`：空白基线模板。
- `archive/`：已完成迭代的按年份归档区。
- `paused/`：被高优先级项目插队而暂时挂起的迭代包。
- `source_materials/`：原始需求输入材料。
- `tests/run.sh`：自动化测试脚本。
