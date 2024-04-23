import Foundation

public class CreatePlayerUsecase{
    public var gameRepository: CBSGameRepository

    public init(gameRepository: CBSGameRepository) {
        self.gameRepository = gameRepository
    }

    public func execute(input: CreatePlayerInput) -> CreatePlayerOutput{
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(playerDto: nil)
        }

        let playerDto = game.createPlayer(name: input.playerName, policy: input.policy)
        gameRepository.save(aggregate: game)

        return .init(playerDto: playerDto)
    }
    
}