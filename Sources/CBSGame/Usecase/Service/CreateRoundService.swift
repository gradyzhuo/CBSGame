import DDD
import Foundation

public struct CreateRoundService<EventBusType: DomainEventBus>: CreateRoundUsecase {
    public typealias RepositoryType = CBSGameInMemoryRepository

    public var eventBus: EventBusType
    public var repository: CBSGameInMemoryRepository

    public init(repository: CBSGameInMemoryRepository, eventBus: EventBusType) {
        self.eventBus = eventBus
        self.repository = repository
    }
}
