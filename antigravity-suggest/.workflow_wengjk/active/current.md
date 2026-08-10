# 当前工作台

> AI 助手读取入口。这里只写当前指针和下一步，不写历史百科。

## 当前迭代

- **iteration_id**：`ITERATION-YYYYMMDD-主题`
- **阶段**：初始化准备

## 当前任务

- **current_task_id**：`TASK-001`
- **current_sub_task_id**：`TASK-001-SUB-001`
- **状态真源**：`task_board.md`
- **任务目录**：`tasks/TASK-001/`
- **子任务计划**：`tasks/TASK-001/plans/SUB-001.md`（尚未创建）
- **编码闸门**：关闭

## 下一步

1. 用户提供原始需求材料（存入 `source_materials/ITERATION-YYYYMMDD-主题/`）。
2. 在 `requirements/` 下整理需求入口文件。
3. 建立 `task_board.md` 任务拆分表。
4. 选定当前任务后，生成 `brief.md` / `plan.md` 供用户确认，确认后开启编码闸门。
