import Foundation

public struct DetermineRoundWinnerInput {
    public let gameId: String
    public let roundId: String
    
    public init(gameId: String, roundId: String){
        self.gameId = gameId
        self.roundId = roundId
    }
}