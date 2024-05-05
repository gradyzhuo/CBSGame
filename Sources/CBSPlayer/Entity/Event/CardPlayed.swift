import DDD
import CardGame
import Foundation

public struct CardPlayed: DomainEvent{
    public var metadata: DDD.DomainEventMetadata = {
        return .init(eventType: "\(Self.self)")
    }()

    public let gameId: String
    public let playerId: String
    public let round: Int
    public let cardIndex: Int 
    public let card: PokeCard
}