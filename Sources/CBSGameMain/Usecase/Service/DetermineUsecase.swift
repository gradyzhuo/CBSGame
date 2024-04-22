import Foundation

public class DetermineWinnerUsecase{
    let gameRepository: CBSGameRepository
    
    internal init(gameRepository: CBSGameRepository) {
        self.gameRepository = gameRepository
    }

    public func execute(input: DetermineWinnerInput)->DetermineWinnerOutput{

        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(winnerPlayerId: nil)
        }

        guard let round = game.getRound(byId: input.roundId) else {
            return .init(winnerPlayerId: nil)
        }

        guard let winnerId = round.determine() else {
            return .init(winnerPlayerId: nil)
        }
        round.set(winnerId: winnerId)
        gameRepository.save(aggregate: game)
        
        return .init(winnerPlayerId: winnerId)
    }


}