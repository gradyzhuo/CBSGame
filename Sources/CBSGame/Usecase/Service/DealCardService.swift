import DDD

public struct DealCardService<EventBusType: DomainEventBus>: DealCardUsecase {
    public init(repository: CBSGameInMemoryRepository, eventBus: EventBusType) {
        self.eventBus = eventBus
        self.repository = repository
    }

    public var eventBus: EventBusType

    public var repository: CBSGameInMemoryRepository

    public typealias RepositoryType = CBSGameInMemoryRepository
}
