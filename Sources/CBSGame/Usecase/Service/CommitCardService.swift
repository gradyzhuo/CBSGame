import DDD

public struct CommitCardService<EventBusType: DomainEventBus>: CommitCardUsecase {
    public typealias RepositoryType = CBSGameInMemoryRepository
    
    public var repository: RepositoryType
    public let eventBus: EventBusType

    public init(repository: RepositoryType, eventBus: EventBusType) {
        self.repository = repository
        self.eventBus = eventBus
    }
}