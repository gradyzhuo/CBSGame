import XCTest
@testable import CBSGame


final class CreateCBSGameUsecaseTest: CBSGameTests {
    func testCreateGame() throws{

        let usecase = CreateCBSGameUsecase(repository: gameRepository)
        let input: CreateCBSGameInput = CreateCBSGameInput()
        let output = usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game = gameRepository.find(byId: output.id!) 
        XCTAssertNotNil(game)
    }
}