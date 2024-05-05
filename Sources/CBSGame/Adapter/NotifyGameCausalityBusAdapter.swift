import Foundation
import DDD

public struct NotifyGameBusAdapter{
    let eventBus: DomainEventBus
    
    public init(eventBus: DomainEventBus){
        self.eventBus = eventBus
    }


}