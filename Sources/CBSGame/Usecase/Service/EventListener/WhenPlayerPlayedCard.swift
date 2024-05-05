import CBSPlayer
import DDD
import Foundation

public struct WhenPlayerPlayedCardListener: DomainEventListener {
    public init(gameRepository: CBSGameRepository, domainEventBus: any DomainEventBus) {
        self.gameRepository = gameRepository
        self.domainEventBus = domainEventBus
    }

    public typealias EventType = CardPlayed

    let gameRepository: CBSGameRepository
    let domainEventBus: DomainEventBus

    public func observed(event: CBSPlayer.CardPlayed) throws {
        guard let game: CBSGameRepository.AggregateRootType = gameRepository.find(byId: event.gameId) else {
            return
        }

        game.commitCard(roundIndex: event.round, playerId: event.playerId, card: event.card)
        
        try domainEventBus.postAllEvent(fromSource: game)
        try gameRepository.save(aggregateRoot: game)
    }
}
