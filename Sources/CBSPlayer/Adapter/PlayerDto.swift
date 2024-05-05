import Foundation
import CardGame

public struct PlayerDto {
    public let playerId: String
    public let playerName: String
    public let handCards: [PokeCard]

    init(player: Player){
        self.playerId = player.id
        self.playerName = player.name
        self.handCards = player.handCards
    }
}