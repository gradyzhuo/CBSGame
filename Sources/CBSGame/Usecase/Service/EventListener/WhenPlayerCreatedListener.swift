import CBSPlayer
import DDD
import Foundation

public struct WhenPlayerCreatedListener: DomainEventListener {
    public init(gameRepository: CBSGameRepository, domainEventBus: any DomainEventBus) {
        self.gameRepository = gameRepository
        self.domainEventBus = domainEventBus
    }

    public typealias EventType = PlayerCreated

    let gameRepository: CBSGameRepository
    let domainEventBus: DomainEventBus

    public func observed(event: CBSPlayer.PlayerCreated) throws {
        guard let game: CBSGameRepository.AggregateRootType = gameRepository.find(byId: event.gameId) else {
            return
        }

        game.joinPlayer(id: event.id)
        try domainEventBus.postAllEvent(fromSource: game)
        try gameRepository.save(aggregateRoot: game)
    }
}
