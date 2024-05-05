import Foundation

public struct CreatePlayerInput {
    public let gameId: String
    public let playerName: String

    public init(gameId: String, playerName: String){
        self.gameId = gameId
        self.playerName = playerName
    }
}