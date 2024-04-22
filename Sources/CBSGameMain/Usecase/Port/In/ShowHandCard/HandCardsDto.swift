import Foundation


public enum PokeCardDto: CustomStringConvertible{
    case club(PokeCard.Rank)
    case diamond(PokeCard.Rank)
    case heart(PokeCard.Rank)
    case spade(PokeCard.Rank)

    init(pokeCard: PokeCard){
        switch pokeCard.suit {
            case .club:
                self = .club(pokeCard.rank)
            case .diamond:
                self = .diamond(pokeCard.rank)
            case .heart:
                self = .heart(pokeCard.rank)
            case .spade:
                self = .spade(pokeCard.rank)    
        }
    }

    public var description: String{
        return switch self {
            case .club(let rank):
                "♣️\(rank)"
            case .diamond(let rank):
                "♦︎\(rank)"
            case .heart(let rank):
                "♥︎\(rank)"
            case .spade(let rank):
                "♠️\(rank)"
        }
    }
}

public struct PlayerHandCardsDto {
    public let playerId: String
    public let playerName: String
    public let handCards: [PokeCardDto]
}