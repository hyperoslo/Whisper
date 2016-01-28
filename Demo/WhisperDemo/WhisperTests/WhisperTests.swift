import XCTest

class WhisperTests: XCTestCase {
  
  let app = XCUIApplication()
  
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
    XCTAssert(app.navigationBars["Whisper".uppercaseString].exists)
    XCTAssert(app.staticTexts["Welcome to the magic of a tiny Whisper... 🍃"].exists)
    XCTAssertEqual(app.buttons.count, 9)
  }
  
  func testWhisper() {
    app.buttons["Present and silent"].tap()
    XCTAssert(app.staticTexts["This message will silent in 3 seconds."].exists)
    
    app.buttons["Show"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["Showing all the things."].exists)
    
    app.buttons["Present permanent Whisper"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["This is a permanent Whisper."].exists)
    
    
    app.buttons["Disclosure"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["This is a secret revealed!"].exists)
  }
  
  func testNotifications() {
    app.buttons["Notification"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["Ramon Gilabert"].exists)
  }
  
  func testStatusBar() {
    app.buttons["Status bar"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["This is a small whistle..."].exists)
  }
  
  func testDisclosureNotification() {
    app.buttons["Disclosure"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["This is a secret revealed!"].exists)
  }
  
  func testPresenceOfDoneButtonInModalView() {
    app.buttons["Modal view"].tap()
    sleep(1)
    app.buttons["Done"].exists
  }
  
  func testDisclosureNotificationOnModalView() {
    app.buttons["Modal view"].tap()
    sleep(1)
    
    app.buttons["Disclosure"].tap()
    sleep(1)
    XCTAssert(app.staticTexts["Secret revealed!"].exists)
  }
}
