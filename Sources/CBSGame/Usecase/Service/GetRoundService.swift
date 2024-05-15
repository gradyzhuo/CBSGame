import DDD

public struct GetRoundService<EventBusType: DomainEventBus>: GetRoundUsecase {
    public init(repository: CBSGameInMemoryRepository, eventBus: EventBusType) {
        self.eventBus = eventBus
        self.repository = repository
    }

    public var eventBus: EventBusType

    public var repository: CBSGameInMemoryRepository
    public typealias RepositoryType = CBSGameInMemoryRepository
}
