import XCTest
import DDD
@testable import CBSGame

struct EventForTest : DomainEvent {
    var metadata: DomainEventMetadata = .init(eventType: "EventForTest")
}

final class EventBusTests : XCTestCase {
    
    func testCausalityEventBusByHandler() throws {
        let eventBus = CausalityBusAdapter(queue: .init(label: "queue for test"))
        var counter = 0
        eventBus.subscribe(to: EventForTest.self) { event in
            counter += 1
        }
        try eventBus.publish(event: EventForTest())

        XCTAssertEqual(counter, 1)
    }

    func testCausalityEventBusByListener() throws {
        let eventBus = CausalityBusAdapter(queue: .init(label: UUID().uuidString))
        let fakeListener = EventListenerForTest()

        try eventBus.register(listener: fakeListener)
        try eventBus.publish(event: EventForTest())

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