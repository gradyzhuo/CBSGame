import Foundation
import DDD

public class CBSGameRepository: EventSourcingRepository {
    public var coordinators: [EventStorageCoordinator<CBSGame>]

    public typealias AggregateRootType = CBSGame

    public init(){
        self.coordinators = []
    }
}
// public class CBSGameRepository {
//     var aggregates: [CBSGame]
    
//     public init(){
//         self.aggregates = []
//     }
    
//     public func find(byId id: String) -> CBSGame?{
//         return aggregates.filter{
//             $0.id == id
//         }.first
//     }

//     public func save(aggregate: CBSGame) {
//         delete(byId: aggregate.id)
//         aggregates.append(aggregate)
//     }

//     public func delete(byId id: String){
//         aggregates.removeAll{
//             $0.id == id
//         }
//     }

// }