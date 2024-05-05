import Foundation

public class EventStorageCoordinator<AggregateRootType: AggregateRoot>{
    public internal(set) var id: AggregateRootType.Id
    public internal(set) var events: [any DomainEvent] = []

    public init(id: AggregateRootType.Id){
        self.id = id
    }

    internal func appendEvents(fromCoordinator coordinator: EventStorageCoordinator) {
        events.append(contentsOf: coordinator.events)
    }
}
