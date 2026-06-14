# Roadmap — notifications（Deferred / phase 2）

## Done（2026-06-14，按推荐架构落地：静默推送唤醒 → 拉取变更 → 发本地通知）
- ✅ `LocalNotificationPlan`（纯，4 类触发）+ 6 单测；`LocalNotificationContentPlan`（kind→文案）+ 3 单测。
- ✅ `SettingsStore.lastNotifiedAt` 高水位游标（首次同步只建基线，不刷屏）。
- ✅ `LocalNotificationScheduling` + `UserNotificationScheduler`（UNUserNotificationCenter，按 id 去重）。
- ✅ `SyncCoordinator.foregroundSync` 成功尾部 `postPendingNotifications`：同步后拉取并发本地通知。
- ✅ `configureDatabaseSubscription()` 现订阅 **private + shared** 两个库（之前是 dead code）。
- ✅ `ShareCalAppDelegate`：`didReceiveRemoteNotification` → `ShareCalRemoteChangeSignal` + `.newData`；注册/失败回调；`UNUserNotificationCenterDelegate` 前台横幅。
- ✅ 启动 `ShareCalNotificationSetup.configure`：请求授权 + `registerForRemoteNotifications` + 订阅（gated by isCloudKitEnabled）。
- ✅ `RootView` 监听 `ShareCalRemoteChangeSignal` → 拉取同步。
- ✅ `remote-notification` 后台模式已在 Info.plist（原已配）。

## Needs manual verification（无法用单测/单机覆盖）
- ⚠️ 端到端静默推送 → 唤醒 → 本地通知:需**两台真机 + 两个 iCloud 账号**(Dev 环境用 `Scripts/dev-pairing-smoke.sh` 思路)。
- ⚠️ APNs 生产链路 + TestFlight(prod entitlement) 推送送达。
- ⚠️ 后台被杀场景下 `didReceiveRemoteNotification` 的执行窗口（当前 completion 立即回调，属 best-effort；如需可加 background task 包裹）。
- ✅ 可单机验证:前台/切到 tab 触发同步后，对方新数据会弹本地通知横幅(模拟器即可，需有已配对数据)。
