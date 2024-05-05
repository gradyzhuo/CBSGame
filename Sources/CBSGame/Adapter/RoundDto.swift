import Foundation

public struct RoundDto {
    public let roundId: String
    public let winnerPlayerId: String?

    init(round: Round){
        self.roundId = round.id
        self.winnerPlayerId = round.winnerPlayer?.playerId
    }
}
