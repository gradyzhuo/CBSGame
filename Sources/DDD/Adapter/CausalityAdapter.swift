import Foundation
import Causality

public final class CausalityBusAdapter : DomainEventBus {
    private var eventIds: [String:AnyHashable]
    private var eventBus: Causality.Bus
    
    package init(queue: DispatchQueue = .global()){
        self.eventIds = [:]
        self.eventBus = .init(label: "\(Self.self)", queue: queue)
    }

    public func publish<EventType>(event: EventType) throws where EventType : DomainEvent {
        let eventType = "\(EventType.self)"
        let causalityEvent = Causality.Event<EventType>(label: eventType)
        if let eventId = eventIds[eventType] {
            causalityEvent.causalityEventId = eventId
        }
        eventBus.publish(event: causalityEvent, message: event)
    }

    public func subscribe<EventType>(to eventType: EventType.Type, handler: @escaping (EventType) throws -> Void) rethrows where EventType : DomainEvent {
        let eventType = "\(eventType.self)"
        
        let e = Causality.Event<EventType>(label: eventType)
        eventIds[eventType] = e.causalityEventId 

        eventBus.subscribe(e) { (message: EventType) in
            do{
                try handler(message)
            }catch {
                fatalError()
            }
            
        }
    }

    
}

// extension Causality.Bus : DomainEventBus {
//     public func publish<EventType>(event: EventType) throws where EventType : DomainEvent {
//         let e = Causality.Event<EventType>(label: "\(EventType.self)")
//         self.publish(event: e, message: event)
//     }

//     public func subscribe<EventType>(to eventType: EventType.Type, handler: @escaping (EventType) -> Void) where EventType : DomainEvent {
//         let e = Causality.Event<EventType>(label: "\(eventType)")
//         self.subscribe(e) { (message: EventType) in
//             handler(message)
//         }
//     }
   
// }
