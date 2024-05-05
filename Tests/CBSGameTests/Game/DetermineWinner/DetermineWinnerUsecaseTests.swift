import XCTest
@testable import CBSGame
@testable import CardGame

final class DetermineRoundWinnerUsecaseTests: CBSGameTests {

    override func setUp() async throws {
        try domainEventBus.register(listener: WhenPlayerCreatedListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
    }

    func testDetermineRoundWinner() throws{ 
        let roundIndex = 0

        let gameId = createGame()

        let winnerPlayerId = createGamePlayer(gameId: gameId, playerName: "WinnerPlayerForTest")
        let player2 = createGamePlayer(gameId: gameId, playerName: "Player2")
        let player3 = createGamePlayer(gameId: gameId, playerName: "Player3")
        let player4 = createGamePlayer(gameId: gameId, playerName: "Player4")
        
        let roundId = createRound(gameId: gameId, round: roundIndex)

        try dealCard(gameId: gameId, cards: [
            .init(suit: .club, rank: .ace), 
            .init(suit: .club, rank: .two), 
            .init(suit: .club, rank: .five),
            .init(suit: .club, rank: .eight)
        ])

        let commitCardUsecase = CommitCardUsecase.init(gameRepository: gameRepository, eventBus: domainEventBus)
        for player in [winnerPlayerId, player2, player3, player4] {
            let input = CommitCardInput.init(gameId: gameId, roundIndex: roundIndex, playerId: player, chooseCard: .init(suit: .club, rank: .ace))
            let output = try commitCardUsecase.execute(input: input)
        }

        let usecase = DetermineRoundWinnerUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let input = DetermineRoundWinnerInput(gameId: gameId, roundIndex: roundIndex)
        let output: DetermineRoundWinnerOutput = try usecase.execute(input: input)
        
        XCTAssertEqual(output.winnerPlayerId, winnerPlayerId)

        let game = gameRepository.find(byId: gameId)
        let round = game?.getRound(index: roundIndex)
        XCTAssertEqual(winnerPlayerId, round?.winnerPlayer?.playerId)
    }
}