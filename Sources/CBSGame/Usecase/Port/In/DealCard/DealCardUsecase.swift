import DDD
import Foundation

public protocol DealCardUsecase: Usecase<CBSGame, DealCardInput, DealCardOutput> {}

public extension DealCardUsecase {
    func execute(input: DealCardInput) async throws -> DealCardOutput {
        guard let game = try await repository.find(byId: input.gameId) else {
            return Output(id: nil)
        }
        game.dealCards(cards: input.cards)

        try await eventBus.postAllEvent(fromSource: game)

        try await repository.save(aggregateRoot: game)
        return Output(id: input.gameId)
    }
}
