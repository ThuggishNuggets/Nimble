import Foundation
import XCTest
import Nimble
#if SWIFT_PACKAGE
import NimbleSharedTestHelpers
#endif

final class BeIdenticalToObjectTest: XCTestCase {
    private class BeIdenticalToObjectTester {}
    private let testObjectA = BeIdenticalToObjectTester()
    private let testObjectB = BeIdenticalToObjectTester()

    func testBeIdenticalToPositive() {
        expect(self.testObjectA).to(beIdenticalTo(testObjectA))
    }

    func testbeIdenticalToAsSubmatcher() {
        // check that the typing works out when used as a submatcher.
        expect(self.testObjectA).to(map({ $0 }, be(testObjectA)))
        expect(self.testObjectA).to(map({ $0 }, beIdenticalTo(testObjectA)))
    }

    func testBeIdenticalToAnyObjectProtocol() {
        let object = AnObjectImplementation()

        expect(object as AnObjectProtocol).to(be(object))
        expect(object as AnObjectProtocol).to(beIdenticalTo(object))
    }

    func testBeIdenticalToNegative() {
        expect(self.testObjectA).toNot(beIdenticalTo(testObjectB))
    }

    func testBeIdenticalToPositiveMessage() {
        let message = String(describing: NSString(format: "expected to be identical to <%p>, got <%p>",
            unsafeBitCast(testObjectB, to: Int.self), unsafeBitCast(testObjectA, to: Int.self)))
        failsWithErrorMessage(message) {
            expect(self.testObjectA).to(beIdenticalTo(self.testObjectB))
        }
    }

    func testBeIdenticalToNegativeMessage() {
        let message = String(describing: NSString(format: "expected to not be identical to <%p>, got <%p>",
            unsafeBitCast(testObjectA, to: Int.self), unsafeBitCast(testObjectA, to: Int.self)))
        failsWithErrorMessage(message) {
            expect(self.testObjectA).toNot(beIdenticalTo(self.testObjectA))
        }
    }

    func testFailsOnNils() {
        let message1 = String(describing: NSString(format: "expected to be identical to <%p>, got nil",
            unsafeBitCast(testObjectA, to: Int.self)))
        failsWithErrorMessageForNil(message1) {
            expect(nil as BeIdenticalToObjectTester?).to(beIdenticalTo(self.testObjectA))
        }

        let message2 = String(describing: NSString(format: "expected to not be identical to <%p>, got nil",
            unsafeBitCast(testObjectA, to: Int.self)))
        failsWithErrorMessageForNil(message2) {
            expect(nil as BeIdenticalToObjectTester?).toNot(beIdenticalTo(self.testObjectA))
        }
    }

    func testOperators() {
        expect(self.testObjectA) === testObjectA
        expect(self.testObjectA) !== testObjectB
    }
}

private protocol AnObjectProtocol: AnyObject {}
private final class AnObjectImplementation: AnObjectProtocol {
    init() {}
}
