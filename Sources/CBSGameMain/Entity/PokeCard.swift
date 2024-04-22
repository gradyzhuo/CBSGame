import Foundation

public struct PokeCard {
    public enum Suit: Int{
        case club = 0
        case diamond
        case heart
        case spade
    }
    public enum Rank: Int {
        case ace = 14
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
        case ten = 10
        case j = 11
        case q = 12
        case k = 13
    }

    public let suit: Suit
    public let rank: Rank   
}

extension PokeCard: Comparable {
    public static func > (lhs: Self, rhs: Self) -> Bool {
        guard lhs.rank != rhs.rank else {
            return lhs.suit > rhs.suit
        }
        return lhs.rank > rhs.rank
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.rank != rhs.rank else {
            return lhs.suit < rhs.suit
        }
        return lhs.rank < rhs.rank
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }

}

extension PokeCard.Suit: Comparable {
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension PokeCard.Rank: Comparable {
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension PokeCard.Rank : CaseIterable {
    
}

extension PokeCard.Suit : CaseIterable {

}

extension PokeCard : CaseIterable {
    public static var allCases: [PokeCard] {
        return PokeCard.Rank.allCases.reduce([PokeCard].init()){ results, rank in
            results + PokeCard.Suit.allCases.reduce(.init()){ 
                $0 + [PokeCard.init(suit: $1, rank: rank)]
            } 
        }
    }
}

extension PokeCard.Rank: CustomStringConvertible {
    public var description: String{
        return switch self {
            case .ace:
                "A"
            case .j:
                "J"
            case .q:
                "Q"
            case .k:
                "K"
            default:
                "\(self.rawValue)"
        }
    }
}