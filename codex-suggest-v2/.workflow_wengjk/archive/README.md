# 归档区

只保存已经结束的迭代。固定结构：

```text
archive/YYYY/ITERATION-YYYYMMDD-主题/
├── current.md
├── task_board.md
├── decisions.md
├── requirements/
├── tasks/
└── source_materials/
    └── ITERATION-YYYYMMDD-主题/
```

归档前任务状态只能是 `done`、`cancelled` 或 `out_of_scope`。统一使用：

```bash
.workflow_wengjk/archive_active_iteration.sh <迭代目录名> <原始材料目录名>
```
