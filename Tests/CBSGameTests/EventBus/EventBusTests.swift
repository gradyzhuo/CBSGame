import XCTest
import DDD
@testable import CBSGame

struct EventForTest : DomainEvent {
    var metadata: DomainEventMetadata = .init(eventType: "EventForTest")
}

final class EventBusTests : XCTestCase {
    
    func testCausalityEventBusByHandler() async throws {
        let eventBus = CausalityBusAdapter(queue: .init(label: "queue for test"))
        var counter = 0
        eventBus.subscribe(to: EventForTest.self) { event in
            counter += 1
        }
        try await eventBus.publish(event: EventForTest())

        XCTAssertEqual(counter, 1)
    }

    func testCausalityEventBusByListener() async throws {
        let eventBus = CausalityBusAdapter(queue: .init(label: UUID().uuidString))
        let fakeListener = EventListenerForTest()

        try eventBus.register(listener: fakeListener)
        try await eventBus.publish(event: EventForTest())

        XCTAssertEqual(fakeListener.counter, 1)
    }

    func testMyEventBus() async throws {
        let bus = EventBus()
        var counter = 0

        bus.subscribe(to: EventForTest.self){ event in 
            counter += 1
        }
        // bus.subscribe("test"){ (event: Event<Any>) async in
        //     counter += 1
        // }

        try await bus.publish(event: EventForTest.init())

        XCTAssertEqual(counter, 1)
    }

    func testMyEventBusByListener() async throws {
        let eventBus = EventBus()
        let fakeListener = EventListenerForTest()

        try eventBus.register(listener: fakeListener)
        try await eventBus.publish(event: EventForTest())

        XCTAssertEqual(fakeListener.counter, 1)
    }

}

class EventListenerForTest: DomainEventListener{
    typealias EventType = EventForTest
    
    var counter:Int = 0

    func observed(event: EventType) {
        counter += 1
    }


}