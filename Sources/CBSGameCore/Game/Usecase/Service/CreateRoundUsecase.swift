import Foundation

public class CreateRoundUsecase {
    public var gameRepository: CBSGameRepository

    public init(gameRepository: CBSGameRepository){
        self.gameRepository = gameRepository
    }
    
    public func execute(input: CreateRoundInput)-> CreateRoundOutput {
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }

        let roundId = game.start(round: input.roundIndex)
        gameRepository.save(aggregate: game)
        return .init(id: roundId)
    }
}