import Foundation

public class DetermineRoundWinnerUsecase{
    let gameRepository: CBSGameRepository
    
    public init(gameRepository: CBSGameRepository) {
        self.gameRepository = gameRepository
    }

    public func execute(input: DetermineRoundWinnerInput)->DetermineRoundWinnerOutput{

        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(winnerPlayer: nil)
        }

        guard let round = game.getRound(byId: input.roundId) else {
            return .init(winnerPlayer: nil)
        }

        let winnerId = round.determine()

        let winnerPlayerDto: WinnerPlayerDto? = game.getPlayer(byId: winnerId).map{
            .init(playerId: $0.id, playerName: $0.name)
        }
        
        return .init(winnerPlayer: winnerPlayerDto)
    }


}