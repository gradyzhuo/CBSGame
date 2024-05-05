import Foundation

public struct GetRoundUsecase{
    let gameRepository: CBSGameRepository

    public func execute(input: GetRoundInput)->GetRoundOutput{
        guard let game = gameRepository.find(byId: input.gameId) else {
            return .init(roundDto: nil)
        }

        guard let round = game.getRound(index: input.roundIndex) else {
            return .init(roundDto: nil)
        }
        
        return .init(roundDto: .init(round: round))
    }
}