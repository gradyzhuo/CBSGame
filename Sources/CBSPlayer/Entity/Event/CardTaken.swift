import DDD
import Foundation
import CardGame

public struct CardTaken: DomainEvent {
    public var metadata: DDD.DomainEventMetadata = {
        .init(eventType: "\(Self.self)")
    }()

    let playerId: String
    let card: PokeCard
}