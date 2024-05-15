import Foundation

public protocol DomainEventStorage : AnyObject{
    var events: [any DomainEvent] { set get }
}

public class DomainEventInMemoryStorage: DomainEventStorage {
    public init(events: [any DomainEvent] = []) {
        self.events = events
    }

    public var events: [ any DomainEvent ] = []

}

public protocol DomainEventSource {
    associatedtype Storage: DomainEventStorage

    var eventStorage: Storage { get }
    var revision: UInt64? { set get }

    func apply(event: some DomainEvent) throws
    
    init?(events: [any DomainEvent]) throws
}

extension DomainEventSource {

    public var events: [DomainEvent] {
        get{
            return eventStorage.events
        }
    }

    public func add(event: some DomainEvent) throws {
        eventStorage.events.append(event)
        try apply(event: event)
    }

    public func clearAllDomainEvents() throws {
        eventStorage.events.removeAll()
    }
}