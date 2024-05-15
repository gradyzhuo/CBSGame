import DDD
import Foundation

public protocol DetermineRoundWinnerUsecase: Usecase<CBSGame, DetermineRoundWinnerInput, DetermineRoundWinnerOutput> {}

public extension DetermineRoundWinnerUsecase {
    func execute(input: DetermineRoundWinnerInput) async throws -> DetermineRoundWinnerOutput {
        guard let game = try await repository.find(byId: input.gameId) else {
            return Output(winnerPlayerId: nil)
        }

        guard let winnerId = game.determine(roundIndex: input.roundIndex) else {
            return Output(winnerPlayerId: nil)
        }

        try await eventBus.postAllEvent(fromSource: game)

        return Output(winnerPlayerId: winnerId)
    }
}
