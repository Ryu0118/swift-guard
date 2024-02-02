import XCTest
@testable import Guard

final class GuardTests: XCTestCase {
    struct Foo {
        @Guard(5...10) var intBounded = 5
        @Guard(...10) var intUpperBounded = 5
        @Guard(10...) var intLowerBounded = 10

        @Guard(5.0...10.0) var doubleBounded = 5.0
        @Guard(...10.0) var doubleUpperBounded = 5.0
        @Guard(10.0...) var doubleLowerBounded = 10.0

        @Guard(Date().addingTimeInterval(-3600)...Date().addingTimeInterval(3600)) var dateBounded = Date()
        @Guard(...Date().addingTimeInterval(3600)) var dateUpperBounded = Date()
        @Guard(Date().addingTimeInterval(-3600)...) var dateLowerBounded = Date()

        @Guard(CustomType(value: 1)...CustomType(value: 100)) var customTypeBounded = CustomType(value: 50)
        @Guard(...CustomType(value: 100)) var customTypeUpperBounded = CustomType(value: 50)
        @Guard(CustomType(value: 1)...) var customTypeLowerBounded = CustomType(value: 50)
    }

    var foo: Foo!

    override func setUp() {
        super.setUp()
        foo = Foo()
    }

    // Int Tests
    func testGuardIntBoundedRange() {
        // Test lower bound
        foo.intBounded = 4
        XCTAssertEqual(foo.intBounded, 5, "Int value should be clipped to the lower bound of the range.")
        // Test at lower bound
        foo.intBounded = 5
        XCTAssertEqual(foo.intBounded, 5, "Int value should be at the lower bound of the range.")
        // Test upper bound
        foo.intBounded = 11
        XCTAssertEqual(foo.intBounded, 10, "Int value should be clipped to the upper bound of the range.")
        // Test at upper bound
        foo.intBounded = 10
        XCTAssertEqual(foo.intBounded, 10, "Int value should be at the upper bound of the range.")
        // Test within range
        foo.intBounded = 7
        XCTAssertEqual(foo.intBounded, 7, "Int value should be within the range.")
    }

    func testGuardIntUpperBoundedRange() {
        // Test upper bound
        foo.intUpperBounded = 11
        XCTAssertEqual(foo.intUpperBounded, 10, "Int value should be clipped to the upper bound of the range.")
        // Test at upper bound
        foo.intUpperBounded = 10
        XCTAssertEqual(foo.intUpperBounded, 10, "Int value should be at the upper bound of the range.")
        // Test within range
        foo.intUpperBounded = 7
        XCTAssertEqual(foo.intUpperBounded, 7, "Int value should be within the range.")
    }

    func testGuardIntLowerBoundedRange() {
        // Test lower bound
        foo.intLowerBounded = 9
        XCTAssertEqual(foo.intLowerBounded, 10, "Int value should be clipped to the lower bound of the range.")
        // Test at lower bound
        foo.intLowerBounded = 10
        XCTAssertEqual(foo.intLowerBounded, 10, "Int value should be at the lower bound of the range.")
        // Test within range
        foo.intLowerBounded = 15
        XCTAssertEqual(foo.intLowerBounded, 15, "Int value should be within the range.")
    }

    // Double Tests
    func testGuardDoubleBoundedRange() {
        // Test lower bound
        foo.doubleBounded = 4.0
        XCTAssertEqual(foo.doubleBounded, 5.0, "Double value should be clipped to the lower bound of the range.")
        // Test upper bound
        foo.doubleBounded = 11.0
        XCTAssertEqual(foo.doubleBounded, 10.0, "Double value should be clipped to the upper bound of the range.")
        // Test within range
        foo.doubleBounded = 7.5
        XCTAssertEqual(foo.doubleBounded, 7.5, "Double value should be within the range.")
    }

    func testGuardDoubleUpperBoundedRange() {
        // Test upper bound
        foo.doubleUpperBounded = 11.0
        XCTAssertEqual(foo.doubleUpperBounded, 10.0, "Double value should be clipped to the upper bound of the range.")
        // Test within range
        foo.doubleUpperBounded = 7.5
        XCTAssertEqual(foo.doubleUpperBounded, 7.5, "Double value should be within the range.")
    }

    func testGuardDoubleLowerBoundedRange() {
        // Test lower bound
        foo.doubleLowerBounded = 9.0
        XCTAssertEqual(foo.doubleLowerBounded, 10.0, "Double value should be clipped to the lower bound of the range.")
        // Test within range
        foo.doubleLowerBounded = 15.0
        XCTAssertEqual(foo.doubleLowerBounded, 15.0, "Double value should be within the range.")
    }

    func testGuardDateBoundedRange() {
        let lowerBound = Date().addingTimeInterval(-3600)
        let upperBound = Date().addingTimeInterval(3600)

        // Test lower bound
        let inputDate1 = lowerBound.addingTimeInterval(-7200)
        foo.dateBounded = inputDate1
        XCTAssertEqual(foo.dateBounded.timeIntervalSince1970, lowerBound.timeIntervalSince1970, accuracy: 0.001, "Date should be clipped to the lower bound of the range.")

        // Test upper bound
        let inputDate2 = upperBound.addingTimeInterval(7200)
        foo.dateBounded = inputDate2
        XCTAssertEqual(foo.dateBounded.timeIntervalSince1970, upperBound.timeIntervalSince1970, accuracy: 0.001, "Date should be clipped to the upper bound of the range.")

        // Test within range
        let inputDate3 = lowerBound.addingTimeInterval(1800)
        foo.dateBounded = inputDate3
        XCTAssertEqual(foo.dateBounded.timeIntervalSince1970, inputDate3.timeIntervalSince1970, accuracy: 0.001, "Date should be within the range.")
    }

    func testGuardDateUpperBoundedRange() {
        let upperBound = Date().addingTimeInterval(3600)

        // Test upper bound
        let inputDate1 = upperBound.addingTimeInterval(7200)
        foo.dateUpperBounded = inputDate1
        XCTAssertEqual(foo.dateUpperBounded.timeIntervalSince1970, upperBound.timeIntervalSince1970, accuracy: 0.001, "Date should be clipped to the upper bound of the range.")

        // Test within range
        let inputDate2 = upperBound.addingTimeInterval(-1800)
        foo.dateUpperBounded = inputDate2
        XCTAssertEqual(foo.dateUpperBounded.timeIntervalSince1970, inputDate2.timeIntervalSince1970, accuracy: 0.001, "Date should be within the range.")
    }

    func testGuardDateLowerBoundedRange() {
        let lowerBound = Date().addingTimeInterval(-3600)

        // Test lower bound
        let inputDate1 = lowerBound.addingTimeInterval(-7200)
        foo.dateLowerBounded = inputDate1
        XCTAssertEqual(foo.dateLowerBounded.timeIntervalSince1970, lowerBound.timeIntervalSince1970, accuracy: 0.001, "Date should be clipped to the lower bound of the range.")

        // Test within range
        let inputDate2 = lowerBound.addingTimeInterval(1800)
        foo.dateLowerBounded = inputDate2
        XCTAssertEqual(foo.dateLowerBounded.timeIntervalSince1970, inputDate2.timeIntervalSince1970, accuracy: 0.001, "Date should be within the range.")
    }

    // CustomType Tests
    func testGuardCustomTypeBoundedRange() {
        // Test lower bound
        foo.customTypeBounded = CustomType(value: 0)
        XCTAssertEqual(foo.customTypeBounded.value, 1, "CustomType value should be clipped to the lower bound of the range.")
        // Test upper bound
        foo.customTypeBounded = CustomType(value: 101)
        XCTAssertEqual(foo.customTypeBounded.value, 100, "CustomType value should be clipped to the upper bound of the range.")
        // Test within range
        foo.customTypeBounded = CustomType(value: 50)
        XCTAssertEqual(foo.customTypeBounded.value, 50, "CustomType value should be within the range.")
    }

    func testGuardCustomTypeUpperBoundedRange() {
        // Test upper bound
        foo.customTypeUpperBounded = CustomType(value: 101)
        XCTAssertEqual(foo.customTypeUpperBounded.value, 100, "CustomType value should be clipped to the upper bound of the range.")
        // Test within range
        foo.customTypeUpperBounded = CustomType(value: 50)
        XCTAssertEqual(foo.customTypeUpperBounded.value, 50, "CustomType value should be within the range.")
    }

    func testGuardCustomTypeLowerBoundedRange() {
        // Test lower bound
        foo.customTypeLowerBounded = CustomType(value: 0)
        XCTAssertEqual(foo.customTypeLowerBounded.value, 1, "CustomType value should be clipped to the lower bound of the range.")
        // Test within range
        foo.customTypeLowerBounded = CustomType(value: 50)
        XCTAssertEqual(foo.customTypeLowerBounded.value, 50, "CustomType value should be within the range.")
    }
}

struct CustomType: Comparable {
    var value: Int

    static func < (lhs: CustomType, rhs: CustomType) -> Bool {
        return lhs.value < rhs.value
    }

    static func == (lhs: CustomType, rhs: CustomType) -> Bool {
        return lhs.value == rhs.value
    }

    init(value: Int) {
        self.value = value
    }
}
