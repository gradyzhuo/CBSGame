import Foundation

public enum PlayerError : Error{
    case indexOfHandCardsNotFound(range: Range<Int>, index: Int)
}

public protocol Player{
    var id: String {get}
    var name: String {get}
    var handCards: [PokeCard] {get}

    func add(handCard card: PokeCard)
    func playCard(index: Int) throws -> PokeCard
}

public class HumanPlayer: Player{
    public var id: String
    public var name: String
    public private(set) var handCards: [PokeCard]

    internal init(id: String, name: String) {
        self.id = id
        self.name = name
        self.handCards = []
    }
    
    public func add(handCard card: PokeCard){
        self.handCards.append(card)
    }

    public func playCard(index: Int) throws -> PokeCard{
        guard handCards.indices.contains(index) else {
            throw PlayerError.indexOfHandCardsNotFound(range: handCards.indices, index: index)
        }
        return handCards.remove(at: index)
    }

}

