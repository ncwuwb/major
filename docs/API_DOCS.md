# API 文档使用说明

## 在线文档

项目启动后可直接访问以下地址：

- Swagger UI: `http://localhost:8080/swagger-ui.html`
- OpenAPI JSON: `http://localhost:8080/v3/api-docs`

## 认证方式

除 `/api/auth/login`、`/v3/api-docs/**`、`/swagger-ui.html`、`/swagger-ui/**` 外，其余接口默认都需要 JWT。
登录成功后，在 Swagger UI 右上角点击 `Authorize`，填入：

```text
Bearer 你的JWT令牌
```

演示账号：

```text
username: admin
password: admin123456
```

## Swagger 分组

当前 Swagger 左侧分组按业务域拆分为：

- `认证与账户`：登录、当前用户、修改密码
- `学校管理`：学校基础信息维护
- `校区管理`：校区基础配置维护
- `学院管理`：学院和教学单位维护
- `专业管理`：专业基础信息维护
- `系统用户`：后台账号和数据权限维护
- `教师管理`：教师主数据维护
- `学生管理`：学生主数据维护
- `课程管理`：课程主数据维护
- `实验基地管理`：实验基地维护
- `招生数据`：年度招生计划和完成情况
- `经费数据`：年度预算和经费使用情况
- `毕业去向`：就业率、升学率、平均薪资等数据
- `成果数据`：科研与教学成果
- `竞赛数据`：学生竞赛与获奖记录
- `国际交流`：国际交流项目记录
- `监测分析`：概览、趋势、排行、综合评分
- `预警管理`：预警查询与预警重算
- `指标规则配置`：权重和阈值规则维护
- `数据导入`：Excel/CSV 导入
- `数据导出`：Excel 导出

## 导入接口说明

统一入口：`POST /api/import/{type}`

当前支持的 `type`：

- `teachers`
- `students`
- `courses`
- `admissions`
- `fundings`
- `graduate-outcomes`

导入规则：

- 主数据重复时直接报错
- 年度数据按业务唯一键覆盖更新
- 越权导入会被拒绝

## 导出接口说明

当前提供以下导出接口：

- `GET /api/export/major-summary`
- `GET /api/export/warning-list`
- `GET /api/export/annual-indicators`

## 接口约定

- 统一前缀：`/api`
- 统一返回结构：`ApiResponse<T>`
- 分页参数：`pageNum`、`pageSize`
- 鉴权请求头：`Authorization: Bearer <token>`

## 调试建议

- 先调用 `POST /api/auth/login` 获取 token
- 再点击 Swagger UI 的 `Authorize` 填入 Bearer token
- 分页查询接口优先从 `pageNum=1&pageSize=10` 开始调试
- 分析接口支持按当前用户数据范围自动收敛结果