import Foundation

public protocol EventSourcingRepository: AnyObject {
    associatedtype AggregateRootType: AggregateRoot where AggregateRootType: DomainEventSource
    typealias Id = AggregateRootType.Id

    var coordinators : [EventStorageCoordinator<Self.AggregateRootType>] { set get }
}

extension EventSourcingRepository {
    public func find(byId id: Id) -> AggregateRootType?{
        
        guard let coordinator = (coordinators.first{ $0.id == id }) else {
            return nil
        }
        return try? .init(events: coordinator.events)
    }

    public func save(aggregateRoot: AggregateRootType) throws {
        var index = (coordinators.firstIndex{ $0.id == aggregateRoot.id })
        if index == nil {
            index = coordinators.count
            coordinators.append(EventStorageCoordinator(id: aggregateRoot.id))
        } 

        let coordinator = coordinators[index!]
        coordinator.events.append(contentsOf: aggregateRoot.events)
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