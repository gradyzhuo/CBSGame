import Foundation
import CBSPlayer
import DDD

public struct PlayCardUsecase {
    public var playerRepository: PlayerRepository
    public let eventBus: DomainEventBus

    public init(playerRepository: PlayerRepository, eventBus: DomainEventBus) {
        self.playerRepository = playerRepository
        self.eventBus = eventBus
    }

    public func execute(input: PlayCardInput) throws -> PlayCardOutput {
        guard let player = playerRepository.find(byId: input.playerId) else {
            return .init(playedCard: nil)
        }   

        let playedCard = try player.playCard(round: input.round, index: input.cardIndex) 

        try eventBus.postAllEvent(fromSource: player)
        try playerRepository.save(aggregateRoot: player)       
        return .init(playedCard: playedCard)
    }

}