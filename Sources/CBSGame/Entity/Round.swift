import Foundation
import DDD
import CardGame

public class Round: Entity, Codable {
    public var id: String

    public typealias Id = String

    public struct CommittedCard: Codable {
        public let playerId: String
        public let card: PokeCard
    }

    init(id: String) {
        self.id = id
    }

    public private(set) var committedCards: [CommittedCard] = []
    public private(set) var winnerPlayer: CommittedCard?

    func commit(playerId: String, card: PokeCard) {
        committedCards.append(.init(playerId: playerId, card: card))
    }

    func setWinner(playerId: String, card: PokeCard){
        self.winnerPlayer = .init(playerId: playerId, card: card)
    }
}
