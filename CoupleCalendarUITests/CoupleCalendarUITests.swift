import XCTest

final class CoupleCalendarUITests: XCTestCase {
    func testLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["ShareCal"].waitForExistence(timeout: 3))
    }
}
