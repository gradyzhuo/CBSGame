import DDD
import Foundation

public protocol CreateCBSGameUsecase: Usecase<CBSGame, CreateCBSGameInput, CreateCBSGameOutput> {}

public extension CreateCBSGameUsecase {
    func execute(input _: CreateCBSGameInput) async throws -> CreateCBSGameOutput {
        let game = CBSGame(id: UUID().uuidString)

        try await  eventBus.postAllEvent(fromSource: game)
        try await repository.save(aggregateRoot: game)
        return Output(id: game.id)
    }
}
