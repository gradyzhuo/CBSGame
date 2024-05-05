import Foundation
import DDD
import struct CardGame.PokeCard

public enum PlayerError : Error{
    case indexOfHandCardsNotFound(range: Range<Int>, index: Int)
    case unknownEventError(event: DomainEvent)
}

public class Player: AggregateRoot, DomainEventSource{
    public var coordinator: EventStorageCoordinator<Player>

    public var id: String
    public var name: String
    public var gameId: String
    public private(set) var handCards: [PokeCard]

    internal init(id: String, gameId: String, name: String) {
        self.id = id
        self.name = name
        self.gameId = gameId
        self.handCards = []
        self.coordinator = .init(id: id)

        try! self.add(event: PlayerCreated(id: id, gameId: gameId, name: name))
    }

    public func apply(event: some DomainEvent) throws {
        switch event {
            case let e as PlayerCreated:
                return
            case let e as CardTaken:
                self.handCards.append(e.card)
            case let e as CardPlayed:
                self.handCards.remove(at: e.cardIndex)
            default: 
                throw PlayerError.unknownEventError(event: event)
        }
    }

    public required convenience init?(events: [any DomainEvent]) throws {
        var events = events
        guard let event = events.removeFirst() as? PlayerCreated  else {
            return nil
        }

        self.init(id: event.id, gameId: event.gameId, name: event.name)

        for event in events{
            try self.add(event: event)
        }
        try clearAllDomainEvents()
    }
    
    public func take(handCard card: PokeCard) throws {
        let event = CardTaken(playerId: self.id, card: card)
        try self.add(event: event)
    }

    public func playCard(round: Int, index: Int) throws -> PokeCard{
        guard handCards.indices.contains(index) else {
            throw PlayerError.indexOfHandCardsNotFound(range: handCards.indices, index: index)
        }

        let playedCard = handCards[index]

        let event = CardPlayed(gameId: self.gameId, playerId: self.id, round: round, cardIndex: index, card: playedCard)
        try self.add(event: event)

        return playedCard
    }

}

