import Foundation
import DDD

public struct RoundCreated : DomainEvent{
    public var metadata: DomainEventMetadata = { 
        .init(eventType: "\(Self.self)") 
    }()
    
    let roundIndex: Int
    let roundId: String

}