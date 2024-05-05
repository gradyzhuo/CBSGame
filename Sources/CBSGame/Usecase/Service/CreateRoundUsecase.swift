import Foundation
import DDD

public class CreateRoundUsecase {
    public var gameRepository: CBSGameRepository
    let eventBus: DomainEventBus

    public init(gameRepository: CBSGameRepository, eventBus: DomainEventBus){
        self.gameRepository = gameRepository
        self.eventBus = eventBus
    }
    
    public func execute(input: CreateRoundInput) throws -> CreateRoundOutput {
        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }

        let roundId = game.start(round: input.roundIndex)
        
        try eventBus.postAllEvent(fromSource: game)
        try gameRepository.save(aggregateRoot: game)

        return .init(id: roundId)
    }
}