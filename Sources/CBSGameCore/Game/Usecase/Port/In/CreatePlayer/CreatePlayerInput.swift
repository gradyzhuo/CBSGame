import Foundation

public struct CreatePlayerInput {
    public let gameId: String
    public let playerName: String
    public let policy: PlayPolicy

    public init(gameId: String, playerName: String, policy: PlayPolicy){
        self.gameId = gameId
        self.playerName = playerName
        self.policy = policy
    }
}