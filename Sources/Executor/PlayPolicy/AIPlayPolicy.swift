import CBSGameCore
public struct AIPlayPolicy: PlayPolicy{

    public func playCard(player: PlayerDto) throws -> Cards.Index {
        return player.handCards.indices.randomElement()!
    }

}