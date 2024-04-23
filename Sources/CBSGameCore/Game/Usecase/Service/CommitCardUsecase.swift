import Foundation

public class CommitCardUsecase {
    let gameRepository: CBSGameRepository

    public init(gameRepository: CBSGameRepository) {
        self.gameRepository = gameRepository
    }
    
    public func execute(input: CommitCardInput) throws -> CommitCardOutput {
        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(committedCard: nil)
        }

        guard let player = game.getPlayer(byId: input.playerId) else {
            return .init(committedCard: nil)
        }

        guard let round = game.getRound(byId: input.roundId) else {
            return .init(committedCard: nil)
        }

        let chooseCard = try player.playCard()
        round.commit(playerId: input.playerId, card: chooseCard)
        
        gameRepository.save(aggregate: game)
        return .init(committedCard: chooseCard)

    }
}