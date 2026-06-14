# Decision 0001 — 通知触发范围与交付架构

- **日期**：2026-06-14
- **状态**：触发范围 Accepted（用户确认全选）；交付架构 Proposed（待 phase 2 验证）

## 触发范围（Accepted）
1. 对方评论了我的日程
2. 收到新邀请
3. 我的邀请被接受 / 拒绝
4. 历史访问请求 / 其回复

## 交付架构（Proposed，推荐）
**静默 CloudKit 推送（content-available）唤醒 App → App 拉取变更 → App 发本地通知（`UNUserNotification`）。**

理由：CloudKit 无法可靠把私有/共享数据内容塞进推送 payload；静默推送 + 本地通知能定制文案且适配两人制（对方写入会落到我的 private database）。

备选（未采纳）：直接用 `CKSubscription.NotificationInfo.alertBody` 服务端弹窗——内容受限，共享 zone 变更的可靠性存疑。

## 触发 4 的 source 语义（修订 2026-06-14，Codex review 发现）
历史访问请求有三种 source：`localOutgoing`（我刚发出的本地副本）、`privateOwnerZone`（对方发来、落在我的 zone 的来件）、`acceptedSharedZone`（对方对我请求的**回复**副本，从对方 zone 导入）。
- 「收到来件」通知 = `source == .privateOwnerZone && owner == 我 && status == pending`。
- 「我的请求被回复」通知 = `source != .privateOwnerZone && requester == 我 && status != pending`（对齐 `CalendarAccessRequestListPlan.outgoing`）。

教训:初版把两个分支都套在 `source == .privateOwnerZone` 下,导致**回复通知永不触发**;且单测用例没设 source(默认 privateOwnerZone)与错误实现一致,所以没抓到——已改测试用真实 source 复现后再修。

## 顺序决定
用户选择「先动态后推送」：本 plan 整体 **Deferred 至 phase 2**，依赖 [../../activity-feed/](../../activity-feed/) 定义「什么算一条可通知的动态」。
