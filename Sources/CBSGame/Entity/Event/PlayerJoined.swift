import Foundation
import DDD


public struct PlayerJoined: DomainEvent{
    public var metadata: DomainEventMetadata = { 
        .init(eventType: "\(Self.self)") 
    }()
    
    let gameId: String
    let playerId: String
}