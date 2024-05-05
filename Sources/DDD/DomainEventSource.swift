import Foundation

public protocol DomainEventSource: AnyObject {
    associatedtype AggregateRootType: AggregateRoot 

    var coordinator: EventStorageCoordinator<AggregateRootType> { get }

    func apply(event: some DomainEvent) throws
    
    init?(events: [any DomainEvent]) throws
}

extension DomainEventSource {

    public var events: [DomainEvent] {
        get{
            return coordinator.events
        }
    }

    public func add(event: some DomainEvent) throws {
        coordinator.events.append(event)
        try apply(event: event)
    }


    public func addEvents(from coordinator: EventStorageCoordinator<AggregateRootType>) throws {
        for event in coordinator.events{
            try self.add(event: event)
        }
    }

    public func clearAllDomainEvents() throws {
        coordinator.events.removeAll()
    }
}