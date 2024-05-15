import DDD
import Foundation

public protocol CreateRoundUsecase: Usecase<CBSGame, CreateRoundInput, CreateRoundOutput> {}

public extension CreateRoundUsecase {
    func execute(input: CreateRoundInput) async throws -> CreateRoundOutput {
        guard let game = try await repository.find(byId: input.gameId) else {
            return Output(id: nil)
        }
        let roundId = game.start(round: input.roundIndex)

        try await eventBus.postAllEvent(fromSource: game)

        try await repository.save(aggregateRoot: game)
        return Output(id: roundId)
    }
}
