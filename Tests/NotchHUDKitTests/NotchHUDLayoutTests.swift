import XCTest
@testable import NotchHUDKit

final class NotchHUDLayoutTests: XCTestCase {
    private let screenFrame = CGRect(x: 0, y: 0, width: 1512, height: 982)
    private let visibleFrame = CGRect(x: 0, y: 0, width: 1512, height: 944)

    func testEdgeGapIsFive() {
        XCTAssertEqual(NotchHUDLayout.edgeGap, 5)
    }

    func testIslandFrameUsesVisibleFrameMaxYMinusHeightMinusGap() {
        let size = NSSize(width: 200, height: 42)
        let rect = NotchHUDLayout.islandFrame(
            size: size,
            screenFrame: screenFrame,
            visibleFrame: visibleFrame
        )
        XCTAssertEqual(rect.width, 200)
        XCTAssertEqual(rect.height, 42)
        XCTAssertEqual(rect.midX, screenFrame.midX, accuracy: 0.001)
        XCTAssertEqual(rect.maxY, visibleFrame.maxY - NotchHUDLayout.edgeGap, accuracy: 0.001)
        XCTAssertEqual(rect.origin.y, visibleFrame.maxY - size.height - 5, accuracy: 0.001)
    }

    func testIslandFrameDoesNotUseScreenFrameMaxY() {
        let size = NSSize(width: 180, height: 42)
        let rect = NotchHUDLayout.islandFrame(
            size: size,
            screenFrame: screenFrame,
            visibleFrame: visibleFrame
        )
        let wrongY = screenFrame.maxY - size.height - 5
        XCTAssertNotEqual(rect.origin.y, wrongY, accuracy: 0.001)
    }

    func testTuckedInAnchorsToPhysicalTop() {
        let target = CGRect(x: 656, y: 897, width: 200, height: 42)
        let tucked = NotchHUDLayout.tuckedInFrame(around: target, screenFrame: screenFrame)
        XCTAssertEqual(tucked.width, 120)
        XCTAssertEqual(tucked.height, 28)
        XCTAssertEqual(tucked.midX, target.midX, accuracy: 0.001)
        XCTAssertEqual(tucked.origin.y, screenFrame.maxY - 4, accuracy: 0.001)
    }

    func testTuckedOutAnchorsAbovePhysicalTop() {
        let current = CGRect(x: 656, y: 897, width: 200, height: 42)
        let tucked = NotchHUDLayout.tuckedOutFrame(from: current, screenFrame: screenFrame)
        XCTAssertEqual(tucked.width, 104)
        XCTAssertEqual(tucked.height, 24)
        XCTAssertEqual(tucked.midX, current.midX, accuracy: 0.001)
        XCTAssertEqual(tucked.origin.y, screenFrame.maxY + 6, accuracy: 0.001)
    }
}
