import Foundation
import DDD

public class CommitCardUsecase {
    let gameRepository: CBSGameRepository
    let eventBus: DomainEventBus

    public init(gameRepository: CBSGameRepository, eventBus: DomainEventBus) {
        self.gameRepository = gameRepository
        self.eventBus = eventBus
    }
    
    public func execute(input: CommitCardInput) throws -> CommitCardOutput {
        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(committedCard: nil)
        }

        guard let round = game.getRound(index: input.roundIndex) else {
            return .init(committedCard: nil)
        }

        // let chooseCard = try player.playCard(index: input.cardIndex)
        round.commit(playerId: input.playerId, card: input.chooseCard)
        
        try eventBus.postAllEvent(fromSource: game)
        try gameRepository.save(aggregateRoot: game)
        return .init(committedCard: input.chooseCard)

    }
}