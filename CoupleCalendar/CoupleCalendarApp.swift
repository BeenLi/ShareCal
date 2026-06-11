import CloudKit
import SwiftUI
import SwiftData
import UIKit

final class ShareCalAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: ShareCalSceneDelegateConfigurationPlan.configurationName,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = ShareCalSceneDelegateConfigurationPlan.sceneDelegateClass
        return configuration
    }

    func application(
        _ application: UIApplication,
        userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata
    ) {
        ShareCalCloudKitShareAcceptanceHandler.handle(metadata: cloudKitShareMetadata)
    }
}

@MainActor
enum ShareCalUITestLaunchPlan {
    static let resetUserDefaultsArgument = "--sharecal-reset-user-defaults"

    static func resetUserDefaultsIfRequested(
        arguments: [String] = ProcessInfo.processInfo.arguments,
        defaults: UserDefaults = .standard,
        bundleIdentifier: String? = Bundle.main.bundleIdentifier
    ) {
        guard arguments.contains(resetUserDefaultsArgument),
              let bundleIdentifier else {
            return
        }
        defaults.removePersistentDomain(forName: bundleIdentifier)
    }
}

@MainActor
enum ShareCalLaunchDiagnostics {
    static func runIfRequested(
        services: AppServices,
        settings: SettingsStore,
        arguments: [String] = ProcessInfo.processInfo.arguments
    ) async {
        if ShareCalLaunchDiagnosticPlan.shouldSeedCalendarEvent(arguments: arguments) {
            do {
                let eventID = try services.calendarAccess.ensureShareCalSmokeTestEvent(
                    draft: ShareCalLaunchDiagnosticPlan.seedCalendarEventDraft(arguments: arguments)
                )
                NSLog("ShareCal seeded calendar event: \(eventID)")
            } catch {
                NSLog("ShareCal failed to seed calendar event: \(error)")
            }
        }

        if ShareCalLaunchDiagnosticPlan.shouldRunCloudKitWriteProbe(arguments: arguments) {
            await services.cloudKit.runPrivateDatabaseWriteProbe()
        }

        if ShareCalLaunchDiagnosticPlan.shouldRunSharedReadProbe(arguments: arguments) {
            let diagnostic = await services.cloudKit.sharedReadDiagnostic()
            NSLog("ShareCal shared read probe:\n\(diagnostic.displayText)")
            NSLog("ShareCal shared read probe proves no access: \(diagnostic.provesNoSharedCalendarReadAccess)")
        }

        if ShareCalLaunchDiagnosticPlan.shouldRunStopSharingProbe(arguments: arguments) {
            do {
                try await services.cloudKit.stopSharing(ownerMemberID: settings.currentMemberID)
                NSLog("ShareCal stop sharing probe succeeded")
            } catch {
                NSLog("ShareCal stop sharing probe failed: \(error)")
            }
        }

        if ShareCalLaunchDiagnosticPlan.shouldPreparePairingShare(arguments: arguments) {
            do {
                if !settings.hasSyncedMemberID {
                    settings.currentMemberID = try await services.cloudKit.fetchCurrentUserRecordID()
                }
                if PairingSettingsPlan.normalizedDisplayName(settings.currentDisplayName) == nil {
                    settings.currentDisplayName = PairingSettingsPlan.randomDisplayName()
                    settings.hasCompletedInitialProfilePrompt = true
                }
                let preparedShare = try await services.cloudKit.prepareShare(ownerMemberID: settings.currentMemberID)
                try await services.cloudKit.saveMemberProfileForSync(
                    ownerMemberID: settings.currentMemberID,
                    displayName: settings.currentDisplayName
                )
                settings.iCloudSharingEnabled = true
                settings.hasStartedPairing = true
                settings.markPairingDateIfNeeded()
                NSLog(
                    "%@ %@",
                    ShareCalLaunchDiagnosticPlan.pairingShareURLLogPrefix,
                    preparedShare.share.url?.absoluteString ?? "missing"
                )
            } catch {
                NSLog("ShareCal prepare pairing share probe failed: \(error)")
            }
        }

        if let shareURL = ShareCalLaunchDiagnosticPlan.acceptShareURL(arguments: arguments) {
            do {
                let metadata = try await services.cloudKit.fetchShareMetadata(from: shareURL)
                ShareCalCloudKitShareAcceptanceHandler.handle(metadata: metadata)
                NSLog("ShareCal accept share probe handled metadata owner=%@", metadata.share.recordID.zoneID.ownerName)
            } catch {
                NSLog("ShareCal accept share probe failed: \(error)")
            }
        }

        if ShareCalLaunchDiagnosticPlan.shouldForceSync(arguments: arguments) {
            // Reuses the accepted-share signal channel: RootView consumes it and
            // runs a foreground sync that bypasses the automatic-sync throttle.
            ShareCalAcceptedShareSignal.markAccepted(partnerOwnerID: nil)
        }
    }
}

@main
struct CoupleCalendarApp: App {
    @UIApplicationDelegateAdaptor(ShareCalAppDelegate.self) private var appDelegate
    @State private var settings: SettingsStore
    @State private var services = AppServices()

    private let modelContainer: ModelContainer = {
        do {
            return try ShareCalModelContainer.make()
        } catch {
            fatalError("Unable to create SwiftData container: \(error)")
        }
    }()

    init() {
        ShareCalUITestLaunchPlan.resetUserDefaultsIfRequested()
        _settings = State(initialValue: SettingsStore())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(settings)
                .environment(services)
                .modelContainer(modelContainer)
                .task {
                    await ShareCalLaunchDiagnostics.runIfRequested(services: services, settings: settings)
                }
        }
    }
}
