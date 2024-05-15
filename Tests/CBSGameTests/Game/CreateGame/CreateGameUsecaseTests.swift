import XCTest
@testable import CBSGame


final class CreateCBSGameUsecaseTest: CBSGameTests {
    func testCreateGame() async throws{
        let usecase = CreateCBSGameService(repository: gameRepository, eventBus: domainEventBus)
        let input: CreateCBSGameInput = CreateCBSGameInput()
        let output = try await usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game = try await gameRepository.find(byId: output.id!) 
        XCTAssertNotNil(game)

    }
}