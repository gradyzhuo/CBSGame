import Foundation
import DDD

public struct PlayerCreated : DomainEvent{
    public var metadata: DomainEventMetadata = { 
        .init(eventType: "\(Self.self)") 
    }()
    
    public let id: String 
    public let gameId: String
    public let name: String
}