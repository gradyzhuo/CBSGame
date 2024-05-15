// 定義事件總線
public class EventBus: DomainEventBus {
    private var eventSubscribers:[String: (DomainEvent) async throws -> ()]

    public func publish<EventType: DomainEvent>(event: EventType) async throws{
        let handler = eventSubscribers[event.eventType]
        try await handler?(event)
    }

    public func subscribe<EventType: DomainEvent>(to eventType: EventType.Type, handler: @escaping (_ event: EventType) async throws -> Void) rethrows{
        let eventTypeString = "\(eventType)"
        eventSubscribers[eventTypeString] = { (event) async throws in
            if let typedEvent = event as? EventType {
                try await handler(typedEvent)
            }
        }
    }

    public init(){
        self.eventSubscribers = [:]
    }
    // // 訂閱事件
    // func subscribe<T>(_ subscriber: T.Type, handler: @escaping (T) async -> ()) where T: DomainEvent{
    //     let eventType = "\(subscriber)"
    //     eventSubscribers[eventType] = { event in
    //         if let typedEvent = event as? Event<T> {
    //             await handler(typedEvent)
    //         }
    //     }
    // }

    // // 發布事件
    // func publish<T>(_ event: T) async where T: DomainEvent{
    //     let handler = eventSubscribers[event.eventType]
    //     await handler?(event)
    // }

    // // 取消訂閱
    // func unsubscribe(_ subscriber: String) {
    //     eventSubscribers.removeValue(forKey: subscriber)
    // }
}