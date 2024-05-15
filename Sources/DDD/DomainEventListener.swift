import Foundation

public protocol DomainEventListener {
    associatedtype EventType: DomainEvent

    @MainActor func observed(event: EventType) async throws
}