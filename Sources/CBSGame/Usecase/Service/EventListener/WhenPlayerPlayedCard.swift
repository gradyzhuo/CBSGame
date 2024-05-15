import CBSPlayer
import DDD
import Foundation

public struct WhenPlayerPlayedCardListener<RepositoryType: CBSGameRepository>: DomainEventListener {
    public init(gameRepository: RepositoryType, domainEventBus: any DomainEventBus) {
        self.gameRepository = gameRepository
        self.domainEventBus = domainEventBus
    }

    public typealias EventType = CardPlayed

    let gameRepository: RepositoryType
    let domainEventBus: DomainEventBus

    @MainActor
    public func observed(event: CBSPlayer.CardPlayed) async throws {
        guard let game: RepositoryType.AggregateRootType = try await gameRepository.find(byId: event.gameId) else {
            return
        }

        game.commitCard(roundIndex: event.round, playerId: event.playerId, card: event.card)
        
        try await domainEventBus.postAllEvent(fromSource: game)
        try await gameRepository.save(aggregateRoot: game)
        
    }
}
