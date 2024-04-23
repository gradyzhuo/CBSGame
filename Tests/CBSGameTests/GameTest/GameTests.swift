import XCTest
@testable import CBSGameCore


class CreateGameUsecaseTests: XCTestCase {
    func testCreatingGame() throws{
        let repository = GameRepository()
        let usecase: CreateGameUsecase = CreateGameUsecase(repository: repository)
        let input = CreateGameInput(
            gameId: UUID().uuidString, 
            gameName: "CBSGame", 
            playersNum: 4, 
            rounds: 13
        )
        let output: CreateGameOuteput = usecase.execute(input: input)
        XCTAssertNotNil(output.gameId)

        
        let game = repository.find(byId: output.gameId!)
        XCTAssertNotNil(game)
    }
    
}
