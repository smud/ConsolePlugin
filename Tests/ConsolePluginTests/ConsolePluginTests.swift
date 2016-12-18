import XCTest
@testable import ConsolePlugin

class ConsolePluginTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(ConsolePlugin().text, "Hello, World!")
    }


    static var allTests : [(String, (ConsolePluginTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
