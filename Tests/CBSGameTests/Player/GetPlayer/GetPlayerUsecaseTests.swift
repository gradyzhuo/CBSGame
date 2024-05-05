import XCTest
@testable import CBSPlayer
@testable import CardGame
@testable import CBSGame
@testable import DDD

final class GetPlayerUsecaseTest: CBSGameTests {
    override func setUp() async throws {
        try domainEventBus.register(listener: WhenGameDealCardListener(playerRepository: playerRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenPlayerCreatedListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
    }

    func testGetPlayerHandCards() throws{
        let playerName: String = "Player For Test"

        let gameId: String = createGame()
        let playerId: String = createGamePlayer(gameId: gameId, playerName: playerName)
        
        let cards:[PokeCard] = [.init(suit: .club, rank: .ace), .init(suit: .diamond, rank: .eight)]
        try dealCard(gameId: gameId, cards: cards)

        let usecase = GetPlayerUsecase(playerRepository: playerRepository)
        let input = GetPlayerInput(
            gameId: gameId,
            playerId: playerId
        )
        let output = usecase.execute(input: input)
        XCTAssertNotNil(output.playerDto)
        XCTAssertEqual(output.playerDto?.handCards.count, cards.count)
        XCTAssertEqual(output.playerDto?.handCards, cards)
        
    }
}