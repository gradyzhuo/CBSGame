import DDD

public protocol PlayCardUsecase: Usecase<Player, PlayCardInput, PlayCardOutput> {}

public extension PlayCardUsecase {
    func execute(input: PlayCardInput) async throws -> PlayCardOutput {
        guard let player = try await repository.find(byId: input.playerId) else {
            return Output(playedCard: nil)
        }

        let playedCard = try player.playCard(round: input.round, index: input.cardIndex)

        try await eventBus.postAllEvent(fromSource: player)
        try await repository.save(aggregateRoot: player)
        return Output(playedCard: playedCard)
    }
}
