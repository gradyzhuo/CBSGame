import XCTest
@testable import CBSGame


final class CommitCardUsecaseTests: CBSGameTests {

    func testPlayerPlayCard() throws{
        let playerNameForTest = "Player1"
        guard let gameId = createGame()else {
            return
        }
        
        let playerId = createGamePlayer(gameId: gameId, playerName: playerNameForTest)
        let roundId = createRound(gameId: gameId, round: 0)

        try dealCard(gameId: gameId, cards: [.init(suit: .club, rank: .ace)])

        let usecase = CommitCardUsecase(gameRepository: gameRepository)
        let cardIndexForTest = 0
        let input: CommitCardInput = .init(gameId: gameId, roundId: roundId, playerId: playerId, cardIndex: cardIndexForTest)
        let output: CommitCardOutput = try usecase.execute(input: input)
        XCTAssertNotNil(output.id)


        guard let game = gameRepository.find(byId: gameId) else {
            return
        }
        
        guard let round = game.getRound(byId: roundId) else {
            return 
        }
        
        XCTAssertEqual(round.committedCards.count, 1) 
    }
}