# Project Preference

> **项目专属偏好档案**。在此记录特定项目的技术栈约定、专属工具类、数据库规范或业务特殊规则。
> 本文件仅在当前项目生效，不会被同步回通用工作流模板。

## 项目技术栈与基础规范示例

- **框架/版本**：如 Spring Boot 3.x / MyBatis-Plus / Flutter 3.x
- **常用工具类路径**：如 `com.xxx.common.utils.DateUtils`
- **基础响应体**：如 `R<T>` / 分页 `TotalTable<List<T>>`
- **项目专属伪删除/标记字段**：如 `is_delete`（配合 `GlobalConstant.FALSE` / `GlobalConstant.TRUE`）
- **接口传参规则**：如 REST 风格禁止路径传参，GET 参数 >= 3 时使用 Request 对象封装。
