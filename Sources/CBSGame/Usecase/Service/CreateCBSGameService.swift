import Foundation
import DDD

public class CreateCBSGameService<EventBusType: DomainEventBus>: CreateCBSGameUsecase {
    public var eventBus: EventBusType
    public var repository: CBSGameInMemoryRepository

    public init(repository: CBSGameInMemoryRepository, eventBus: EventBusType) {
        self.eventBus = eventBus
        self.repository = repository
    }
}
                            




