import XCTest
@testable import CBSGame
@testable import CardGame
@testable import CBSPlayer
@testable import DDD

final class DealCardUsecaseTests: CBSGameTests {
    
    override func setUp() async throws {
        try domainEventBus.register(listener: WhenPlayerCreatedListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(playerRepository: playerRepository, domainEventBus: domainEventBus))
    }

    func testDealingCardsToPlayer() throws{
        let player1NameForTest = "Player1"
        let player2NameForTest = "Player2"
        let player3NameForTest = "Player3"
        let player4NameForTest = "Player4"
        
        let gameId: String = createGame()
        
        let player1Id = createGamePlayer(gameId: gameId, playerName: player1NameForTest)
        let player2Id = createGamePlayer(gameId: gameId, playerName: player2NameForTest)
        let player3Id = createGamePlayer(gameId: gameId, playerName: player3NameForTest)
        let player4Id = createGamePlayer(gameId: gameId, playerName: player4NameForTest)

        // let gamePlayers = [player1Id, player2Id, player3Id, player4Id]

        let usecase = DealCardUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let input: DealCardInput = .init(gameId: gameId, cards: PokeCard.allCases)
        let output: DealCardOutput = try usecase.execute(input: input)
        XCTAssertNotNil(output.id)


        guard let player1 = playerRepository.find(byId: player1Id) else {
            return
        }

        XCTAssertEqual(player1.handCards.count, 13)
              
        // for player in gamePlayers {
        //     let player = game.getPlayer(byId: player)!
        //     XCTAssertEqual(player.handCards.count, 13)
        // }
        
    }
}