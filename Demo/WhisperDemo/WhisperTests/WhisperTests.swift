import XCTest

class WhisperTests: XCTestCase {
        
  override func setUp() {
    super.setUp()

    continueAfterFailure = false
    XCUIApplication().launch()

    XCUIDevice.sharedDevice().orientation = .Portrait
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func testBasicSetup() {
    let app = XCUIApplication()

    XCTAssert(app.navigationBars["Whisper".uppercaseString].exists)
    XCTAssert(app.staticTexts["Welcome to the magic of a tiny Whisper... 🍃"].exists)
    XCTAssertEqual(app.buttons.count, 6)
  }

  func testWhisper() {
    let app = XCUIApplication()

    app.buttons["Present and silent"].tap()
    XCTAssert(app.staticTexts["This message will silent in 3 seconds."].exists)

    app.buttons["Show"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["Showing all the things."].exists)

    app.buttons["Present permanent Whisper"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["This is a permanent Whisper."].exists)
  }

  func testNotifications() {
    let app = XCUIApplication()

    app.buttons["Notification"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["Ramon Gilabert"].exists)
  }

  func testStatusBar() {
    let app = XCUIApplication()

    app.buttons["Status bar"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["This is a small whistle..."].exists)
  }
}
