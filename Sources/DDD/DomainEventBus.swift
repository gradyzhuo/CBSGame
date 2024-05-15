import Foundation

public protocol DomainEventBus {
    func publish<EventType: DomainEvent>(event: EventType) async throws
    func subscribe<EventType: DomainEvent>(to eventType: EventType.Type, handler: @escaping (_ event: EventType) async throws -> Void) rethrows
}

public extension DomainEventBus {
    func postAllEvent(fromSource source: some DomainEventSource) async throws {
        for event in source.events {
            try await publish(event: event)
        }
    }

    func register<Listener: DomainEventListener>(listener: Listener) throws {
        // let event: Listener.EventType = await withUnsafeContinuation { continuation in
                
        //     }
        //     try await listener.observed(event: event)
        try self.subscribe(to: Listener.EventType.self) { event in
            try await listener.observed(event: event)
        }
    }
}
