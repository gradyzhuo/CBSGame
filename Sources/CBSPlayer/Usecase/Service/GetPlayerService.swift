import Foundation
import DDD

public struct GetPlayerService<EventBusType: DomainEventBus>: GetPlayerUsecase{
    public typealias RepositoryType = PlayerInMemoryRepository
    
    public var repository: PlayerInMemoryRepository
    public var eventBus: EventBusType

    public init(repository: RepositoryType, eventBus: EventBusType){
        self.repository = repository
        self.eventBus = eventBus
    }
}