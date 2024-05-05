import XCTest
@testable import CBSGame
@testable import CardGame

final class GetRoundUsecaseTests: CBSGameTests {

    func testShouldSucceedGetRoundWinners() throws {
        let gameId = createGame()

        let roundIndex = 0
        let roundId = createRound(gameId: gameId, round: roundIndex)

        let input = GetRoundInput(gameId: gameId, roundIndex: roundIndex)
        let usecase = GetRoundUsecase(gameRepository: gameRepository)
        let output = usecase.execute(input: input)

        XCTAssertNotNil(output.roundDto)
        XCTAssertEqual(roundId, output.roundDto?.roundId)

    }
}