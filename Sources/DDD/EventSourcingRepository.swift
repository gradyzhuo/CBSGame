import Foundation

public protocol EventSourcingRepository<AggregateRootType>: AnyObject {
    associatedtype AggregateRootType: AggregateRoot where AggregateRootType: DomainEventSource
    associatedtype EventStorageType: EventStorageCoordinator where EventStorageType.AggregateRootType == AggregateRootType
    typealias Id = AggregateRootType.Id

    var coordinator : EventStorageType { get }
}

extension EventSourcingRepository {
    public func find(byId id: Id) async throws -> AggregateRootType?{
        guard let events = try await coordinator.fetchEvents(byId: id) else {
            return nil
        }
        return try? .init(events: events)
    }

    public func save(aggregateRoot: AggregateRootType) async throws {
        // var index = (coordinators.firstIndex{ $0.id == aggregateRoot.id })
        // if index == nil {
        //     index = coordinators.count
        //     coordinators.append(.init(id: aggregateRoot.id))
        // } 

        // let coordinator = coordinators[index!]
        try await coordinator.append(events: aggregateRoot.events, byId: aggregateRoot.id)
        try aggregateRoot.clearAllDomainEvents()
    }

    public func delete(byId id: Id) throws {
        // coordinators[id]?.events.removeAll()
    }
}


protocol StateRepository {
    associatedtype Id: Hashable
    associatedtype T: AggregateRoot where T.Id == Id

    var states: [T] { set get }
}

extension StateRepository { 
    public func find(byId id: Id) -> T?{
        return states.filter{
            $0.id == id
        }.first
    }

    public mutating func save(aggregate: T) {
        delete(byId: aggregate.id)
        states.append(aggregate)
    }

    public mutating func delete(byId id: Id){
        states.removeAll{
            $0.id == id
        }
    }

}