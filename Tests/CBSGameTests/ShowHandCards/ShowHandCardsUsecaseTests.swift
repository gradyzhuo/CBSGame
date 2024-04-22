import XCTest
@testable import CBSGame


final class ShowHandCardsUsecaseTests: CBSGameTests {
    func testShowingHandCardOfPlayer() throws{
        let player1NameForTest = "Player1"

        guard let gameId = createGame()else {
            return
        }
        
        let playerId = createGamePlayer(gameId: gameId, playerName: player1NameForTest)
        let cardsForTest = [
            PokeCard.init(suit: .club, rank: .eight), 
            PokeCard.init(suit: .club, rank: .j), 
            PokeCard.init(suit: .heart, rank: .ace)
        ]
        _ = try dealCard(gameId: gameId, cards: cardsForTest)
        
        let usecase = ShowHandCardsUsecase(gameRepository: gameRepository)
        let input: ShowHandCardsInput = .init(gameId: gameId, playerId: playerId)
        let output: ShowHandCardsOutput = try usecase.execute(input: input)
        XCTAssertNotNil(output.handCardsDto)
        XCTAssertEqual(output.handCardsDto!.handCards.count, cardsForTest.count)

    }
}