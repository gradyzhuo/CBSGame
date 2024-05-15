import Foundation

public protocol EventStorageCoordinator<AggregateRootType>: AnyObject {
    associatedtype AggregateRootType: AggregateRoot

    func fetchEvents(byId id: AggregateRootType.Id) async throws -> [any DomainEvent]?
    func append(event: any DomainEvent, byId aggregateRootId: AggregateRootType.Id) async throws -> UInt64?
}

extension EventStorageCoordinator {
    public func append(events: [DomainEvent], byId aggregateRootId: AggregateRootType.Id) async throws{
        for event in events {
            try await append(event: event, byId: aggregateRootId)
        }
    }
}