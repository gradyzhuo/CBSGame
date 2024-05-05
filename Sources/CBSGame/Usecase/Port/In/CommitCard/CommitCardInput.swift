import Foundation
import CardGame

public struct CommitCardInput {
    public init(gameId: String, roundIndex: Int, playerId: String, chooseCard: PokeCard) {
        self.gameId = gameId
        self.roundIndex = roundIndex
        self.playerId = playerId
        self.chooseCard = chooseCard
    }

    public let gameId: String
    public let roundIndex: Int
    public let playerId: String
    public let chooseCard: PokeCard
}
