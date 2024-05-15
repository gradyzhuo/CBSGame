@testable import CardGame
@testable import CBSGame
@testable import CBSPlayer
@testable import DDD
import XCTest

final class NotifyPlayerTests: CBSGameTests {
    override func setUp() async throws {
        try domainEventBus.register(listener: WhenPlayerCreatedListener(repository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(repository: playerRepository, domainEventBus: domainEventBus))
    }

    func testShouldNotifyPlayerWhenCardDealed() async throws {
        Task { @MainActor in
            let playerName = "Player for testing."
            let gameId = try await createGame()
            let playerId = try await createGamePlayer(gameId: gameId, playerName: playerName)

            let cardForTest: PokeCard = .init(suit: .diamond, rank: .four)
            try await dealCard(gameId: gameId, cards: [cardForTest])

            let player = try await playerRepository.find(byId: playerId)
            XCTAssertEqual(player?.handCards.count, 1)
            XCTAssertEqual(player?.handCards.first, cardForTest)
        }
    }
}
