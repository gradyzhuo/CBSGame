import Foundation
import DDD

public class CreatePlayerUsecase{
    public var playerRepository: PlayerRepository
    public let eventBus: DomainEventBus

    public init(playerRepository: PlayerRepository, eventBus: DomainEventBus) {
        self.playerRepository = playerRepository
        self.eventBus = eventBus
    }

    public func execute(input: CreatePlayerInput) throws -> CreatePlayerOutput{
        let player = Player(
            id: UUID().uuidString, 
            gameId: input.gameId, 
            name: input.playerName)

        try eventBus.postAllEvent(fromSource: player)
        try playerRepository.save(aggregateRoot: player)

        return .init(playerId: player.id)
    }
    
}