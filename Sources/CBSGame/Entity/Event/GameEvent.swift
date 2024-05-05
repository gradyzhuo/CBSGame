import Foundation
import DDD

public enum GameEvent: DomainEvent {
    public var metadata: DomainEventMetadata{
        return switch self{
            case .gameCreated(let event):
                event.metadata
            case .cardsDealed(let event):
                event.metadata
            case .roundCreated(let event):
                event.metadata
            case .roundWinnerDetermined(let event):
                event.metadata 
            case .cardCommitted(let event):
                event.metadata  
            case .playerJoined(let event):
                event.metadata
        }
    }

    case gameCreated(event: GameCreated)
    case cardsDealed(event: CardDealed)
    case roundCreated(event: RoundCreated)
    case roundWinnerDetermined(event: RoundWinnerDetermined)
    case cardCommitted(event: CardCommitted)
    case playerJoined(event: PlayerJoined)
}