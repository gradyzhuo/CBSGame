import Foundation

public struct CreateRoundInput {
    public let gameId: String
    public let roundIndex: Int

    public init(gameId: String, roundIndex: Int){
        self.gameId = gameId
        self.roundIndex = roundIndex
    }
}