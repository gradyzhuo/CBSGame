import CardGame
import Foundation

public struct CardDealed: DomainEvent {
    public init(metadata: DomainEventMetadata = .init(eventType: "\(Self.self)"), playerId: String, card: PokeCard) {
        self.metadata = metadata
        self.playerId = playerId
        self.card = card
    }

    public var metadata: DomainEventMetadata = .init(eventType: "\(Self.self)")

    public let playerId: String
    public let card: PokeCard
}
