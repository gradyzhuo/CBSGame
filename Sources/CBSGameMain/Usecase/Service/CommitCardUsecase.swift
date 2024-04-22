import Foundation

public class CommitCardUsecase {
    let gameRepository: CBSGameRepository

    internal init(gameRepository: CBSGameRepository) {
        self.gameRepository = gameRepository
    }
    
    public func execute(input: CommitCardInput) throws -> CommitCardOutput {
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }

        guard let player = game.getPlayer(byId: input.playerId) else {
            return .init(id: nil)
        }

        guard var round = game.getRound(byId: input.roundId) else {
            return .init(id: nil)
        }

        let chooseCard = try player.playCard(index: input.cardIndex)
        round.commit(playerId: input.playerId, card: chooseCard)
        
        gameRepository.save(aggregate: game)
        
        return .init(id: input.roundId)
    }
}