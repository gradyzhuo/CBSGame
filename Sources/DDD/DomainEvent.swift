import Foundation

public struct DomainEventMetadata: Codable {
    let eventId: String 
    let eventType: String

    public init(eventId: String = UUID().uuidString, eventType: String){
        self.eventId = eventId
        self.eventType = eventType
    }
}

public protocol DomainEvent: Codable {
    var metadata: DomainEventMetadata { get }
    
}

extension DomainEvent {
    public var eventId: String {
        return "\(metadata.eventId)"
    }
    public var eventType: String {
        return "\(metadata.eventType)"
    }
}

