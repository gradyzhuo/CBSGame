import Foundation
import DDD

public class PlayerRepository: EventSourcingRepository {
    public var coordinators: [EventStorageCoordinator<Player>]

    public typealias AggregateRootType = Player

    public init(){
        self.coordinators = []
    }
}
