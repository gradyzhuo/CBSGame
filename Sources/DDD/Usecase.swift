import Foundation

public protocol Usecase<AggregateRootType, Input, Output> {
    associatedtype Input
    associatedtype Output
    associatedtype EventBus: DomainEventBus
    associatedtype RepositoryType: EventSourcingRepository
    associatedtype AggregateRootType: AggregateRoot where RepositoryType.AggregateRootType == AggregateRootType
    
    var eventBus: EventBus { get }
    var repository: RepositoryType { get }

    func execute(input: Input) async throws -> Output 
}