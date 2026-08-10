# 暂停区

保存尚未完成、暂时为更高优先级迭代让路且计划恢复的完整工作区。

```text
paused/ITERATION-YYYYMMDD-主题/
├── pause.md
├── active/
└── source_materials/
    └── ITERATION-YYYYMMDD-主题/
```

暂停和恢复：

```bash
.workflow_wengjk/pause_active.sh <暂停包名> <原始材料目录名> [暂停原因]
.workflow_wengjk/resume_paused.sh <暂停包名>
```
