import Foundation

public enum PlayerError : Error{
    case indexOfHandCardsNotFound(range: Range<Int>, index: Int)
}

public class Player{
    public var id: String
    public var name: String
    public private(set) var handCards: [PokeCard]
    public let policy: any PlayPolicy

    internal init(id: String, name: String, policy: PlayPolicy) {
        self.id = id
        self.name = name
        self.handCards = []
        self.policy = policy
    }
    
    public func add(handCard card: PokeCard){
        self.handCards.append(card)
    }

    public func playCard() throws -> PokeCard{
        let playerDto = PlayerDto.init(player: self)
        let index = try policy.playCard(player: playerDto)
        guard handCards.indices.contains(index) else {
            throw PlayerError.indexOfHandCardsNotFound(range: handCards.indices, index: index)
        }
        return handCards.remove(at: index)
    }

}

