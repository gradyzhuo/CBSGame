import Foundation
import DDD
import CardGame

public struct RoundWinnerDetermined: DomainEvent {
    public var metadata: DomainEventMetadata = { 
        .init(eventType: "\(Self.self)") 
    }()

    let roundIndex: Int
    let winnerPlayerId: String
    let pokerCard: PokeCard
}