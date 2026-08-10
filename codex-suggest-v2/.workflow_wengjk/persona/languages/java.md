# Java Preference

> 仅在当前项目使用 Java 或相关框架时生效；项目已有明确规范时以项目规范为准。

## 模型与语言

- Lombok 场景优先使用 `@Getter` + `@Setter`，谨慎使用职责过重的 `@Data`。
- Java 外部类型通过 `import` 引用，除非类名冲突，不在业务代码中写全限定类名。
- 序列化类型使用 `@Serial private static final long serialVersionUID = 1L;`。
- `record` 优先放在 DTO 或对应模型目录统一管理。
- 只有 0/1 两态且没有扩展语义的字段，不为形式创建枚举，优先复用项目布尔或状态常量。

## Web 与 Spring

- Controller 只做参数接收、Service 调用和响应封装。
- GET 参数较多时优先封装请求对象；项目采用 OpenAPI/Knife4j 时优先使用 `@ParameterObject`。
- 前置条件已由可靠上游保证时，Controller 不堆叠兼容分支。
- Bean 注入方式遵循项目主流习惯；业务组件优先保持一致，基础设施组件可使用构造器注入。
- 编码完成后检查 Spring Bean 循环依赖，不轻易用 `@Lazy` 掩盖设计问题。
- 引入第三方依赖前确认官方出处、维护状态和项目兼容性。

## 数据与工具

- PO、Request、DTO、VO 字段高度一致时优先复用项目已有 Bean 复制工具。
- 差异字段较多时显式组装，不为少量字段强行复制。
- 项目使用代码生成器时，PO、Mapper、Service 等基础层代码优先按现有生成流程产生。
- 判空和比较优先使用项目已有标准工具，不重复造轮子。

## 测试

- JUnit 测试优先使用 `@DisplayName` 直接说明场景和预期。
- 并发、事务和异步测试必须明确线程、事务边界、时序控制及最终数据不变量。
