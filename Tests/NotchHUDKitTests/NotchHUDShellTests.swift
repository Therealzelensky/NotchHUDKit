import XCTest
@testable import NotchHUDKit

@MainActor
final class NotchHUDShellTests: XCTestCase {
    func testPresentWithNilScreenIsNoOp() {
        let shell = NotchHUDShell()
        shell.present(size: NSSize(width: 200, height: 42), on: nil)
        XCTAssertFalse(shell.isVisible)
    }

    func testDismissWhenNotVisibleCallsCompletion() {
        let shell = NotchHUDShell()
        var called = false
        shell.dismiss { called = true }
        XCTAssertTrue(called)
        XCTAssertFalse(shell.isVisible)
    }
}
