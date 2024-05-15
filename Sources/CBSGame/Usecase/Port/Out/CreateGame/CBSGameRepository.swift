import Foundation
import DDD

public protocol CBSGameRepository : EventSourcingRepository<CBSGame>{

}

extension InMemoryCoordinator : Sendable {

}

public actor CBSGameInMemoryRepository: CBSGameRepository {
    public let coordinator: InMemoryCoordinator<CBSGame>
    
    public init(){
        self.coordinator = .init()
    }
}