import DDD
import Foundation

public struct WhenGameDealCardListener: DomainEventListener {
    public init(playerRepository: PlayerRepository, domainEventBus: any DomainEventBus) {
        self.playerRepository = playerRepository
        self.domainEventBus = domainEventBus
    }

    public typealias EventType = CardDealed

    let playerRepository: PlayerRepository
    let domainEventBus: DomainEventBus

    public func observed(event: CardDealed) throws {
        guard let player = playerRepository.find(byId: event.playerId) else {
            return
        }

        try player.take(handCard: event.card)

        try domainEventBus.postAllEvent(fromSource: player)
        try playerRepository.save(aggregateRoot: player)
    }
}
