import XCTest
@testable import CBSGame
@testable import CardGame

final class CommitCardUsecaseTests: CBSGameTests {

    func testPlayerPlayCard() throws{
        let playerNameForTest = "Player1"
        let roundIndex = 0
        let gameId: String = createGame()
        
        let player = createGamePlayer(gameId: gameId, playerName: playerNameForTest)
        createRound(gameId: gameId, round: roundIndex)

        let cardForTest: PokeCard = .init(suit: .club, rank: .ace)
        try dealCard(gameId: gameId, cards: [cardForTest])

        let usecase = CommitCardUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let input: CommitCardInput = .init(gameId: gameId, roundIndex: roundIndex, playerId: player, chooseCard: cardForTest)
        let output: CommitCardOutput = try usecase.execute(input: input)
        XCTAssertNotNil(output.committedCard)

        guard let game = gameRepository.find(byId: gameId) else {
            return
        }
        
        guard let round = game.getRound(index: roundIndex) else {
            return 
        }
        
        XCTAssertEqual(round.committedCards.count, 1) 
    }
}