import Foundation

@propertyWrapper
public struct Guard<Value: Comparable> {
    enum Range {
        case bounded(ClosedRange<Value>)
        case lowerBounded(PartialRangeFrom<Value>)
        case upperBounded(PartialRangeThrough<Value>)
    }

    private var range: Range
    private var base: Value

    public var wrappedValue: Value {
        get {
            switch range {
            case .bounded(let closedRange):
                return min(max(base, closedRange.lowerBound), closedRange.upperBound)
            case .lowerBounded(let fromRange):
                return max(base, fromRange.lowerBound)
            case .upperBounded(let throughRange):
                return min(base, throughRange.upperBound)
            }
        }
        set {
            base = newValue
        }
    }

    public init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = .bounded(range)
        self.base = wrappedValue
    }

    public init(wrappedValue: Value, _ range: PartialRangeFrom<Value>) {
        self.range = .lowerBounded(range)
        self.base = wrappedValue
    }

    public init(wrappedValue: Value, _ range: PartialRangeThrough<Value>) {
        self.range = .upperBounded(range)
        self.base = wrappedValue
    }
}
