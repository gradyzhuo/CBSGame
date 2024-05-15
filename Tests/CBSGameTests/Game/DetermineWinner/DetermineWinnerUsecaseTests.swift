import XCTest
@testable import CBSGame
@testable import CardGame

final class DetermineRoundWinnerUsecaseTests: CBSGameTests {

    override func setUp() async throws {
        try domainEventBus.register(listener: WhenPlayerCreatedListener(repository: gameRepository, domainEventBus: domainEventBus))
    }

    func testDetermineRoundWinner() async throws{ 
        let roundIndex = 0

        let gameId = try await createGame()

        let winnerPlayerId = try await createGamePlayer(gameId: gameId, playerName: "WinnerPlayerForTest")
        let player2 = try await createGamePlayer(gameId: gameId, playerName: "Player2")
        let player3 = try await createGamePlayer(gameId: gameId, playerName: "Player3")
        let player4 = try await createGamePlayer(gameId: gameId, playerName: "Player4")
        
        let roundId = try await createRound(gameId: gameId, round: roundIndex)

        try await dealCard(gameId: gameId, cards: [
            .init(suit: .club, rank: .ace), 
            .init(suit: .club, rank: .two), 
            .init(suit: .club, rank: .five),
            .init(suit: .club, rank: .eight)
        ])

        let commitCardUsecase = CommitCardService(repository: gameRepository, eventBus: domainEventBus)
        for player in [winnerPlayerId, player2, player3, player4] {
            let input = CommitCardInput.init(gameId: gameId, roundIndex: roundIndex, playerId: player, chooseCard: .init(suit: .club, rank: .ace))
            let output = try await commitCardUsecase.execute(input: input)
        }

        let usecase = DetermineRoundWinnerService(repository: gameRepository, eventBus: domainEventBus)
        let input = DetermineRoundWinnerInput(gameId: gameId, roundIndex: roundIndex)
        let output: DetermineRoundWinnerOutput = try await usecase.execute(input: input)
        
        XCTAssertEqual(output.winnerPlayerId, winnerPlayerId)

        let game = try await gameRepository.find(byId: gameId)
        let round = game?.getRound(index: roundIndex)
        XCTAssertEqual(winnerPlayerId, round?.winnerPlayer?.playerId)
    }
}