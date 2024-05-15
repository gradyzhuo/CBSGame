import DDD

public struct DetermineRoundWinnerService<EventBusType: DomainEventBus>: DetermineRoundWinnerUsecase {
    public init(repository: CBSGameInMemoryRepository, eventBus: EventBusType) {
        self.eventBus = eventBus
        self.repository = repository
    }

    public var eventBus: EventBusType

    public var repository: CBSGameInMemoryRepository
    public typealias RepositoryType = CBSGameInMemoryRepository
}
