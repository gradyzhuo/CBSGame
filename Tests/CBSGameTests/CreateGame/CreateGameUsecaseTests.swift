import XCTest
@testable import CBSGameCore


final class CreateCBSGameUsecaseTest: CBSGameTests {
    func testCreateGame() throws{

        let usecase: CreateCBSGameUsecase = CreateCBSGameUsecase(repository: gameRepository)
        let input: CreateCBSGameInput = CreateCBSGameInput()
        let output = usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game = gameRepository.find(byId: output.id!) 
        XCTAssertNotNil(game)
    }
}