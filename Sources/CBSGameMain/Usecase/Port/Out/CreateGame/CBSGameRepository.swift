import Foundation

public class CBSGameRepository {
    var aggregates: [CBSGame] = []

    func find(byId id: String) -> CBSGame?{
        return aggregates.filter{
            $0.id == id
        }.first
    }

    func save(aggregate: CBSGame) {
        delete(byId: aggregate.id)
        aggregates.append(aggregate)
    }

    func delete(byId id: String){
        aggregates.removeAll{
            $0.id == id
        }
    }

}