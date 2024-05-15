import Foundation
import DDD

public class CreatePlayerService<EventBusType: DomainEventBus>: CreatePlayerUsecase{
    public typealias RepositoryType = PlayerInMemoryRepository

    public var repository: RepositoryType
    public let eventBus: EventBusType

    public init(repository: RepositoryType, eventBus: EventBusType) {
        self.repository = repository
        self.eventBus = eventBus
    }
    
}