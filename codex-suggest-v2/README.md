# Codex Suggest Workflow v2

一套兼顾规则完整度与跨项目可移植性的个人 AI 开发工作流模板。它将任务状态、需求整理、计划确认、代码审查、迭代暂停/恢复和归档能力放在 `.workflow_wengjk/` 中，同时通过受控片段接入目标项目的 `AGENTS.md`。

## 安装到项目

```bash
cp -R .workflow_wengjk /path/to/project/
/path/to/project/.workflow_wengjk/install_project_integration.sh
```

安装脚本会：

1. 将通用工作流规则以受控区块写入或更新目标项目根 `AGENTS.md`。
2. Git 项目中默认把 `.workflow_wengjk/` 写入 `.git/info/exclude`，不修改团队共享的 `.gitignore`。
3. 保留目标项目已有 `AGENTS.md` 内容，重复执行不会重复追加规则。

## 模板与实例

- 本仓库中的 `.workflow_wengjk/` 是纯净模板，应提交到模板仓库。
- 安装到业务项目后，`active/`、`paused/`、`archive/`、`source_materials/` 会成为该项目的本地运行数据。
- 项目专属规范写入 `persona/project_preference.md`，不要写回通用模板的 `coding_preference.md`。
- Java 项目额外读取 `persona/languages/java.md`；其他技术栈按需增加对应语言偏好文件。

## 验证

```bash
.workflow_wengjk/tests/run.sh
```
