@testable import CardGame
@testable import CBSGame
@testable import CBSPlayer
@testable import DDD
import XCTest

final class NotifyGameTests: CBSGameTests {
    override func setUp() async throws {
        try domainEventBus.register(listener: WhenPlayerCreatedListener(repository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(repository: playerRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenPlayerPlayedCardListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
    }

    func testShouldNotifyGameWhenPlayerCreated() async throws {
        let playerName = "Player for testing."

        // domainEventBus.subscribe(to: PlayerCreated.self) { event in
        //     Task { @MainActor in
        //         guard let game = try await self.gameRepository.find(byId: event.gameId) else {
        //             return
        //         }

        //         game.joinPlayer(id: event.id)
        //         try await self.domainEventBus.postAllEvent(fromSource: game)
        //         try await self.gameRepository.save(aggregateRoot: game)
        //     }
        // }

        let gameId = try await createGame()
        let playerId = try await createGamePlayer(gameId: gameId, playerName: playerName)
        
        let game = try await gameRepository.find(byId: gameId)
        XCTAssertEqual(game?.joinedPlayers.count, 1)
        XCTAssertEqual(game?.joinedPlayers.first, playerId)
    }

    func testShouldNotifyGameWhenPlayerPlayedCard() async throws {
        let playerName = "Player for testing."
        let gameId = try await createGame()
        let playerId = try await createGamePlayer(gameId: gameId, playerName: playerName)
        let cardForTest = PokeCard(suit: .club, rank: .ace)
        try await dealCard(gameId: gameId, cards: [cardForTest])

        let roundIndex = 0
        try await createRound(gameId: gameId, round: roundIndex)
        let playedCard = try await playCard(gameId: gameId, playerId: playerId, round: roundIndex, cardIndex: 0)

        let game = try await gameRepository.find(byId: gameId)
        let round = game?.getRound(index: roundIndex)
        XCTAssertEqual(round?.committedCards.count, 1)
        XCTAssertEqual(round?.committedCards.first?.card, playedCard)
    }
}
