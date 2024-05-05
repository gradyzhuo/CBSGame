import Foundation
import DDD
import CardGame

public struct CardCommitted: DomainEvent{
    public var metadata: DomainEventMetadata = { 
        .init(eventType: "\(Self.self)") 
    }()
    
    let roundIndex: Int
    let playerId: String
    let card: PokeCard 
}