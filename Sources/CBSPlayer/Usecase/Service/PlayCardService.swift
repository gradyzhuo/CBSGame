import DDD
import Foundation

public struct PlayCardService<EventBusType: DomainEventBus>: PlayCardUsecase {
    init(repository: PlayerInMemoryRepository, eventBus: EventBusType) {
        self.eventBus = eventBus
        self.repository = repository
    }

    public typealias RepositoryType = PlayerInMemoryRepository

    public var eventBus: EventBusType
    public var repository: PlayerInMemoryRepository
}
