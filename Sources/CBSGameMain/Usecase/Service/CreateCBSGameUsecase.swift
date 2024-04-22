import Foundation

public class CreateCBSGameUsecase{
    public var repository: CBSGameRepository

    init(repository: CBSGameRepository){
        self.repository = repository
    }
    
    public func execute(input: CreateCBSGameInput)-> CreateCBSGameOutput {
        let game = CBSGame.init(id: UUID.init().uuidString)
        repository.save(aggregate: game)    
        return .init(id: game.id)
    }
}                            




