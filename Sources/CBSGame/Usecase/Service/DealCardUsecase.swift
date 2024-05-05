import Foundation
import DDD

public class DealCardUsecase {
    public private(set) var gameRepository: CBSGameRepository
    let eventBus: DomainEventBus

    public init(gameRepository: CBSGameRepository, eventBus: DomainEventBus) {
        self.gameRepository = gameRepository
        self.eventBus = eventBus
    }

    public func execute(input: DealCardInput) throws -> DealCardOutput{
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }

        game.dealCards(cards: input.cards)

        try eventBus.postAllEvent(fromSource: game)
        try gameRepository.save(aggregateRoot: game)
        
        return .init(id: input.gameId)
    }
}