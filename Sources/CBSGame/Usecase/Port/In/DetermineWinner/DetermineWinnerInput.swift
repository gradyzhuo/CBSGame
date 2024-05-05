import Foundation

public struct DetermineRoundWinnerInput {
    public let gameId: String
    public let roundIndex: Int
    
    public init(gameId: String, roundIndex: Int){
        self.gameId = gameId
        self.roundIndex = roundIndex
    }
}