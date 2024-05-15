import DDD
import Foundation

public protocol GetRoundUsecase: Usecase<CBSGame, GetRoundInput, GetRoundOutput> {}

public extension GetRoundUsecase {
    func execute(input: GetRoundInput) async throws -> GetRoundOutput {
        guard let game = try await repository.find(byId: input.gameId) else {
            return Output(roundDto: nil)
        }

        guard let round = game.getRound(index: input.roundIndex) else {
            return Output(roundDto: nil)
        }

        return Output(roundDto: .init(round: round))
    }
}
