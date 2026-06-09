import XCTest

final class CoupleCalendarUITests: XCTestCase {
    func testLaunches() {
        let app = XCUIApplication()
        app.launch()
        dismissInitialProfilePromptIfNeeded(in: app)

        XCTAssertTrue(app.buttons["compact-date-picker-button"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["compact-create-invite-button"].exists)
        XCTAssertTrue(app.buttons["compact-sync-button"].exists)
    }

    func testFirstLaunchGuidanceNavigatesToCalendarSettings() {
        let app = XCUIApplication()
        app.launchArguments = ["--sharecal-reset-user-defaults"]
        app.launch()
        dismissInitialProfilePromptIfNeeded(in: app)

        XCTAssertFalse(app.buttons["Load Sample Schedule"].exists)
        XCTAssertFalse(app.buttons["加载示例日程"].exists)

        let guidanceButton = app.buttons["calendar-setup-guidance-button"]
        XCTAssertTrue(guidanceButton.waitForExistence(timeout: 3))
        guidanceButton.tap()

        XCTAssertTrue(app.buttons["settings-calendar-access-button"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Calendar Access"].exists || app.staticTexts["日历访问"].exists)
    }

    private func dismissInitialProfilePromptIfNeeded(in app: XCUIApplication) {
        let englishSkipButton = app.buttons["Skip"]
        if englishSkipButton.waitForExistence(timeout: 1) {
            englishSkipButton.tap()
            return
        }

        let chineseSkipButton = app.buttons["跳过"]
        if chineseSkipButton.waitForExistence(timeout: 1) {
            chineseSkipButton.tap()
        }
    }
}
