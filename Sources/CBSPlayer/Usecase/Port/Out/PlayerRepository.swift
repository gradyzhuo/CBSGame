import Foundation
import DDD

public protocol PlayerRepository: EventSourcingRepository<Player> {
    
}

public class PlayerInMemoryRepository: PlayerRepository {
    public var coordinator: InMemoryCoordinator<Player>
    
    public init(){
        self.coordinator = .init()
    }
}
