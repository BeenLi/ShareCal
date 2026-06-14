# Baseline — ShareCal

权威 baseline 是仓库根的 **`../../../CLAUDE.md`**（两人制、userRecordID 身份模型、CloudKit 布局、Plan enum 约定、同步流水线）。本文件只补充与当前 ideas 相关、且从代码核实过的局部事实。其余 baseline 维度（完整 module map / runtime flows / storage 边界 / 测试发布门禁 / 风险点）**需要时再做 inventory**，目前标记为 `Unknown / needs inventory`。

## 与当前 ideas 相关的已核实事实（2026-06-14）

### Tab 结构（idea：新增「动态」tab）
- `RootView.swift:5` `enum ShareCalTab { calendar, invites, settings }`。
- `RootView.swift:69` `TabView` 按 calendar → invites → settings 顺序构建；invites tab 已有 `.badge(pendingInviteBadgeCount)`（`RootView.swift:94`）。
- 角标逻辑在 `PendingActionBadgePlan`（`Models.swift:1367`），目前统计「可响应的邀请 + 待处理的历史访问请求」。

### 评论数据（idea：动态流展示对方评论 + 互动）
- `EventComment`（`Models.swift:2203`）已是 CloudKit 同步实体，含 `isRead`（`Models.swift:2211`）。
- 评论读写映射见 `CommentRecordMapper`（`CloudKitCoupleSpaceService.swift` ~`958` 起）。
- 已有按事件展示评论的 UI（事件详情内），但**没有跨事件的聚合「动态流」**，也没有基于 `isRead`/`lastSeenAt` 的未读聚合角标。

### 通知现状（idea：系统级提醒）
- `aps-environment` 推送权限已配置（dev + prod entitlements）。
- `CKDatabaseSubscription`（`CloudKitCoupleSpaceService.swift:2752`，`shouldSendContentAvailable = true`，即**静默推送**）已定义，但 `configureDatabaseSubscription()` **从未被调用**（dead code）。
- **缺失**：`registerForRemoteNotifications`、`didReceiveRemoteNotification` 处理、`UNUserNotificationCenter` 授权与本地通知发送、`remote-notification` 后台模式（待核实 pbxproj）。
- 两人制数据流（来自 CLAUDE.md，影响订阅放在哪个库）：对方对「我的」事件的评论会落到**我的 private database**（对方作为参与者写入我的共享 zone）；我对「对方的」事件的评论写入对方的 shared zone。⇒ 用户级通知需要两端各自在自己的 private database 上订阅。

## 其余 baseline 维度
- module-map / runtime-flows / storage-and-state / test-and-release-gates / risk-hotspots：`Unknown / needs inventory`（提升 plan 时按需补）。
