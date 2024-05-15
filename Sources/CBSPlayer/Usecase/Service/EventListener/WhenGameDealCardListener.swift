import DDD
import Foundation

public struct WhenGameDealCardListener<RepositoryType: PlayerRepository>: DomainEventListener {

    public init(repository: RepositoryType, domainEventBus: any DomainEventBus) {
        self.repository = repository
        self.domainEventBus = domainEventBus
    }

    public typealias EventType = CardDealed

    let repository: RepositoryType
    let domainEventBus: DomainEventBus

    @MainActor
    public func observed(event: CardDealed) async throws {
        guard let player = try await repository.find(byId: event.playerId) else {
            return
        }

        try player.take(handCard: event.card)

        try await domainEventBus.postAllEvent(fromSource: player)
        try await repository.save(aggregateRoot: player)
    }
}
