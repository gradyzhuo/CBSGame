import Foundation
import DDD


public struct GameCreated: DomainEvent{
    public var metadata: DomainEventMetadata = { 
        .init(eventType: "\(Self.self)") 
    }()

    let id: String 
}