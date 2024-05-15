import DDD
import Foundation

public protocol CommitCardUsecase: Usecase<CBSGame, CommitCardInput, CommitCardOutput> {}

public extension CommitCardUsecase {
    func execute(input: CommitCardInput) async throws -> CommitCardOutput {
        guard let game = try await repository.find(byId: input.gameId) else {
            return Output(committedCard: nil)
        }

        guard let round = game.getRound(index: input.roundIndex) else {
            return Output(committedCard: nil)
        }
        round.commit(playerId: input.playerId, card: input.chooseCard)

        try await eventBus.postAllEvent(fromSource: game)
        try await repository.save(aggregateRoot: game)
        return Output(committedCard: input.chooseCard)
    }
}
