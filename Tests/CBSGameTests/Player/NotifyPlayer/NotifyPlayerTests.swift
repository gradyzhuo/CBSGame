import XCTest
@testable import CBSPlayer
@testable import CBSGame
@testable import DDD
@testable import CardGame

final class NotifyPlayerTests: CBSGameTests {

    override func setUp() async throws {
        
        try domainEventBus.register(listener: WhenPlayerCreatedListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(playerRepository: playerRepository, domainEventBus: domainEventBus))
    }

    func testShouldNotifyPlayerWhenCardDealed() throws {
        let playerName = "Player for testing."
        let gameId = createGame()
        let playerId = createGamePlayer(gameId: gameId, playerName: playerName)

        let cardForTest: PokeCard = .init(suit: .diamond, rank: .four)
        try dealCard(gameId: gameId, cards: [ cardForTest ])

        let player = playerRepository.find(byId: playerId)
        XCTAssertEqual(player?.handCards.count, 1)
        XCTAssertEqual(player?.handCards.first, cardForTest)
    }
}