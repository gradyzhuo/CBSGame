import XCTest
@testable import CBSGameCore


final class CommitCardUsecaseTests: CBSGameTests {

    func testPlayerPlayCard() throws{
        let playerNameForTest = "Player1"
        let gameId: String = createGame()
        
        let player = createGamePlayer(gameId: gameId, playerName: playerNameForTest)
        let roundId = createRound(gameId: gameId, round: 0)

        try dealCard(gameId: gameId, cards: [.init(suit: .club, rank: .ace)])

        let usecase = CommitCardUsecase(gameRepository: gameRepository)
        let input: CommitCardInput = .init(gameId: gameId, roundId: roundId, playerId: player.playerId)
        let output: CommitCardOutput = try usecase.execute(input: input)
        XCTAssertNotNil(output.committedCard)

        guard let game = gameRepository.find(byId: gameId) else {
            return
        }
        
        guard let round = game.getRound(byId: roundId) else {
            return 
        }
        
        XCTAssertEqual(round.committedCards.count, 1) 
    }
}