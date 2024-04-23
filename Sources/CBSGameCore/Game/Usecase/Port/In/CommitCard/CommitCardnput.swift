import Foundation

public struct CommitCardInput {     
    public let gameId: String
    public let roundId: String
    public let playerId: String

    public init(gameId: String, roundId: String, playerId: String){
        self.gameId = gameId
        self.roundId = roundId
        self.playerId = playerId
    }
}