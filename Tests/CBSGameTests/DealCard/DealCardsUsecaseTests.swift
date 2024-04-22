import XCTest
@testable import CBSGame


final class DealCardUsecaseTests: CBSGameTests {
    func testDealingCardsToPlayer() throws{
        let player1NameForTest = "Player1"
        let player2NameForTest = "Player2"
        let player3NameForTest = "Player3"
        let player4NameForTest = "Player4"
        guard let gameId = createGame()else {
            return
        }
        
        let gamePlayerIds = createGamePlayers(gameId: gameId, playerNames: [player1NameForTest, player2NameForTest, player3NameForTest, player4NameForTest])

        let usecase = DealCardUsecase(gameRepository: gameRepository)
        let input: DealCardInput = .init(gameId: gameId, cards: PokeCard.allCases)
        let output: DealCardOutput = try usecase.execute(input: input)
        XCTAssertNotNil(output.id)


        guard let game = gameRepository.find(byId: gameId) else {
            return
        }
        
        for playerId in gamePlayerIds {
            let player = game.getPlayer(byId: playerId)!
            XCTAssertEqual(player.handCards.count, 13)
        }
        
    }
}