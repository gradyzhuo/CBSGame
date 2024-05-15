import XCTest
@testable import CBSPlayer
@testable import CardGame
@testable import CBSGame
@testable import DDD

final class GetPlayerUsecaseTest: CBSGameTests {
    override func setUp() async throws {
        try domainEventBus.register(listener: WhenGameDealCardListener(repository: playerRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenPlayerCreatedListener(repository: gameRepository, domainEventBus: domainEventBus))
    }

    func testGetPlayerHandCards() async throws{
        let playerName: String = "Player For Test"

        let gameId: String = try await createGame()
        let playerId: String = try await createGamePlayer(gameId: gameId, playerName: playerName)
        
        let cards:[PokeCard] = [.init(suit: .club, rank: .ace), .init(suit: .diamond, rank: .eight)]
        try await dealCard(gameId: gameId, cards: cards)

        let usecase = GetPlayerService(repository: playerRepository, eventBus: domainEventBus)
        let input = GetPlayerInput(
            gameId: gameId,
            playerId: playerId
        )
        let output = try await usecase.execute(input: input)
        XCTAssertNotNil(output.playerDto)
        XCTAssertEqual(output.playerDto?.handCards.count, cards.count)
        XCTAssertEqual(output.playerDto?.handCards, cards)
        
    }
}