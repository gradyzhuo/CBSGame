import Foundation
import DDD

public class DetermineRoundWinnerUsecase{
    let gameRepository: CBSGameRepository
    let eventBus: DomainEventBus

    public init(gameRepository: CBSGameRepository, eventBus: DomainEventBus) {
        self.gameRepository = gameRepository
        self.eventBus = eventBus
    }

    public func execute(input: DetermineRoundWinnerInput) throws ->DetermineRoundWinnerOutput{

        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(winnerPlayerId: nil)
        }

        guard let winnerId = game.determine(roundIndex: input.roundIndex) else {
            return .init(winnerPlayerId: nil)
        }

        try eventBus.postAllEvent(fromSource: game)
        try gameRepository.save(aggregateRoot: game)


        // let winnerPlayerDto: WinnerPlayerDto? = game.getPlayer(byId: winnerId).map{
        //     .init(playerId: $0.id, playerName: $0.name)
        // }
        
        return .init(winnerPlayerId: winnerId)
    }


}