import XCTest
@testable import CBSGame
@testable import CardGame

final class GetRoundUsecaseTests: CBSGameTests {

    func testShouldSucceedGetRoundWinners() async throws {
        let gameId = try await createGame()

        let roundIndex = 0
        let roundId = try await createRound(gameId: gameId, round: roundIndex)

        let input = GetRoundInput(gameId: gameId, roundIndex: roundIndex)
        let usecase = GetRoundService(repository: gameRepository, eventBus: domainEventBus)
        let output = try await usecase.execute(input: input)

        XCTAssertNotNil(output.roundDto)
        XCTAssertEqual(roundId, output.roundDto?.roundId)

    }
}