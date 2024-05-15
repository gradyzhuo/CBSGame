import XCTest
@testable import CBSGame
@testable import CardGame

final class CommitCardUsecaseTests: CBSGameTests {

    func testPlayerPlayCard() async throws{
        let playerNameForTest = "Player1"
        let roundIndex = 0
        let gameId: String = try await createGame()
        
        let player = try await createGamePlayer(gameId: gameId, playerName: playerNameForTest)
        try await createRound(gameId: gameId, round: roundIndex)

        let cardForTest: PokeCard = .init(suit: .club, rank: .ace)
        try await dealCard(gameId: gameId, cards: [cardForTest])

        let usecase = CommitCardService(repository: gameRepository, eventBus: domainEventBus)
        let input: CommitCardInput = .init(gameId: gameId, roundIndex: roundIndex, playerId: player, chooseCard: cardForTest)
        let output: CommitCardOutput = try await usecase.execute(input: input)
        XCTAssertNotNil(output.committedCard)

        guard let game = try await gameRepository.find(byId: gameId) else {
            return
        }
        
        guard let round = game.getRound(index: roundIndex) else {
            return 
        }
        
        XCTAssertEqual(round.committedCards.count, 1) 
    }
}