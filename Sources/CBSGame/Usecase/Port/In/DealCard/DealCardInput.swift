import Foundation
import CardGame

public struct DealCardInput{
    public let gameId: String
    public let cards: [PokeCard]

    public init(gameId: String, cards: [PokeCard]){
        self.gameId = gameId
        self.cards = cards
    }
}