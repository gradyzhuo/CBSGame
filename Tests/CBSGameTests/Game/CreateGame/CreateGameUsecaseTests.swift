import XCTest
@testable import CBSGame


final class CreateCBSGameUsecaseTest: CBSGameTests {
    func testCreateGame() throws{

        let usecase: CreateCBSGameUsecase = CreateCBSGameUsecase(repository: gameRepository, eventBus: domainEventBus)
        let input: CreateCBSGameInput = CreateCBSGameInput()
        let output = try usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game = gameRepository.find(byId: output.id!) 
        XCTAssertNotNil(game)

    }
}