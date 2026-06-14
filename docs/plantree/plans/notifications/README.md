# Plan: notifications（系统级提醒）

由 [idea-002](../../ideas/inbox.md) 提升而来。Baseline：[../../baseline/README.md](../../baseline/README.md)。

## Scope
把关键双人事件做成 App 系统级通知。触发范围（用户确认，全选）：
1. 对方评论了我的日程
2. 收到新邀请
3. 我的邀请被接受 / 拒绝
4. 历史访问请求 / 其回复

## Status
- Status: **✅ Code landed（2026-06-14）** — 纯逻辑 9 单测通过、全套 215 通过、模拟器启动无崩溃。
- **剩余**：端到端推送送达需两台真机 + 两个 iCloud 账号手动验证（见 roadmap「Needs manual verification」）。
- 依赖 [../activity-feed/](../activity-feed/) 已完成。

## File map
- [roadmap.md](roadmap.md)
- [decisions/0001-triggers-and-delivery.md](decisions/0001-triggers-and-delivery.md) — 触发范围 + 交付架构

## 现状（已核实，见 baseline）
- 推送权限 `aps-environment` 已配（dev+prod）。
- `CKDatabaseSubscription`（静默推送）已定义但 `configureDatabaseSubscription()` **从未调用** = dead code。
- 缺：远程通知注册/回调、`UNUserNotification` 授权与本地通知、后台模式、两端 private DB 订阅。

## Open questions
- OQ1 核实 `remote-notification` 后台模式是否在 pbxproj/Info.plist 中（baseline 标记待核实）。
- OQ2 APNs 生产链路：TestFlight(prod) 证书 / `aps-environment=production` 推送是否打通。
- OQ3 静默推送的系统节流与 App 被杀时的可靠性，是否需要兜底（前台 `foregroundSync` 已有）。
- OQ4 通知与 in-app 角标的去重 / 已读联动。
- OQ5 两端各自在 private database 上订阅的具体实现（见 baseline 两人制数据流说明）。
