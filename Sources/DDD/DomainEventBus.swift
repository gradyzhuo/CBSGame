import Foundation



public protocol DomainEventBus {
    func publish<EventType: DomainEvent>(event: EventType) throws
    func subscribe<EventType: DomainEvent>(to eventType: EventType.Type, handler: @escaping (_ event: EventType) throws ->Void) rethrows
}

extension DomainEventBus {
    public func postAllEvent(fromSource source: some DomainEventSource) throws{
        for event in source.events{
            try self.publish(event: event)
        }
    }
    
    public func register<Listener: DomainEventListener>(listener: Listener) throws {
        try self.subscribe(to: Listener.EventType.self){
            try listener.observed(event: $0)
        }
    }
}