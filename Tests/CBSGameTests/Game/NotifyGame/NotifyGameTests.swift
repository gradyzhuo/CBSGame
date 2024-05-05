import XCTest
@testable import CBSGame
@testable import CBSPlayer
@testable import DDD
@testable import CardGame

final class NotifyGameTests: CBSGameTests {

    override func setUp() async throws {
        try domainEventBus.register(listener: WhenPlayerCreatedListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(playerRepository: playerRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenPlayerPlayedCardListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
    }

    func testShouldNotifyGameWhenPlayerCreated() throws {
        let playerName = "Player for testing."
        let gameId = createGame()
        let playerId = createGamePlayer(gameId: gameId, playerName: playerName)

        let game = gameRepository.find(byId: gameId)
        XCTAssertEqual(game?.joinedPlayers.count, 1)
        XCTAssertEqual(game?.joinedPlayers.first, playerId)
    }

    func testShouldNotifyGameWhenPlayerPlayedCard() throws {
        let playerName = "Player for testing."
        let gameId = createGame()
        let playerId = createGamePlayer(gameId: gameId, playerName: playerName)

        let cardForTest = PokeCard(suit: .club, rank: .ace)
        try dealCard(gameId: gameId, cards: [cardForTest])

        let roundIndex = 0
        createRound(gameId: gameId, round: roundIndex)
        let playedCard = try playCard(gameId: gameId, playerId: playerId, round: roundIndex, cardIndex: 0)
        
        let game = gameRepository.find(byId: gameId)
        let round = game?.getRound(index: roundIndex)
        XCTAssertEqual(round?.committedCards.count, 1)
        XCTAssertEqual(round?.committedCards.first?.card, playedCard)
    }
}