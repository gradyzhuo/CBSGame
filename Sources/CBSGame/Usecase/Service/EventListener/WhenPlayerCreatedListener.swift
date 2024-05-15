import CBSPlayer
import DDD
import Foundation

public struct WhenPlayerCreatedListener<RepositoryType: CBSGameRepository>: DomainEventListener {
    public typealias EventType = PlayerCreated

    let repository: RepositoryType
    let domainEventBus: DomainEventBus

    public init(repository: RepositoryType, domainEventBus: any DomainEventBus) {
        self.repository = repository
        self.domainEventBus = domainEventBus
    }

    @MainActor
    public func observed(event: CBSPlayer.PlayerCreated) async throws {
        guard let game: RepositoryType.AggregateRootType = try await repository.find(byId: event.gameId) else {
            return
        }

        game.joinPlayer(id: event.id)
        try await domainEventBus.postAllEvent(fromSource: game)
        try await repository.save(aggregateRoot: game)
    }
}
