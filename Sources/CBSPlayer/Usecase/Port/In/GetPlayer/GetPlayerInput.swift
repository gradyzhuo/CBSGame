import Foundation

public struct GetPlayerInput {
    public let gameId: String
    public let playerId: String

    public init(gameId: String, playerId: String) {
        self.gameId = gameId
        self.playerId = playerId
    }
}
