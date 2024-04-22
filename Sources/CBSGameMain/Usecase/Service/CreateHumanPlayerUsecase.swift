import Foundation

public struct CreateHumanPlayerUsecase{
    public var gameRepository: CBSGameRepository

    public func execute(input: CreateHumanPlayerInput) -> CreateHumanPlayerOutput{
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }
        
        let playerId = game.createHumanPlayer(name: input.playerName)
        gameRepository.save(aggregate: game)

        return .init(id: playerId)
    }
    
}