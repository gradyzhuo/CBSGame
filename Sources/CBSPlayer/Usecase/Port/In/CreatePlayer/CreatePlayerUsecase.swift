import DDD
import Foundation

public protocol CreatePlayerUsecase: Usecase<Player, CreatePlayerInput, CreatePlayerOutput> {}

public extension CreatePlayerUsecase {
    func execute(input: CreatePlayerInput) async throws -> CreatePlayerOutput {
        let player = Player(
            id: UUID().uuidString,
            gameId: input.gameId,
            name: input.playerName
        )

        try await eventBus.postAllEvent(fromSource: player)
        try await repository.save(aggregateRoot: player)

        return Output(playerId: player.id)
    }
}
