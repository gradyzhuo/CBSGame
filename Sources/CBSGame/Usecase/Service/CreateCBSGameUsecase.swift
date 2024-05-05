import Foundation
import DDD

public class CreateCBSGameUsecase{
    public var repository: CBSGameRepository
    let eventBus: DomainEventBus

    public init(repository: CBSGameRepository, eventBus: DomainEventBus){
        self.repository = repository
        self.eventBus = eventBus
    }
    
    public func execute(input: CreateCBSGameInput) throws -> CreateCBSGameOutput {
        let game = CBSGame.init(id: UUID.init().uuidString)

        try eventBus.postAllEvent(fromSource: game)
        try repository.save(aggregateRoot: game)    
        return .init(id: game.id)
    }
}                            




