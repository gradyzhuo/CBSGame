import XCTest
@testable import CBSGameCore


final class DetermineRoundWinnerUsecaseTests: CBSGameTests {

    func testDetermineRoundWinner() throws{ 
        let winnerId = ""

        let gameId = createGame()

        let winnerPlayer = createGamePlayer(gameId: gameId, playerName: "WinnerPlayerForTest")
        let player2 = createGamePlayer(gameId: gameId, playerName: "Player2")
        let player3 = createGamePlayer(gameId: gameId, playerName: "Player3")
        let player4 = createGamePlayer(gameId: gameId, playerName: "Player4")
        
        let roundId = createRound(gameId: gameId, round: 0)

        try dealCard(gameId: gameId, cards: [
            .init(suit: .club, rank: .ace), 
            .init(suit: .club, rank: .two), 
            .init(suit: .club, rank: .five),
            .init(suit: .club, rank: .eight)
        ])

        let commitCardUsecase = CommitCardUsecase.init(gameRepository: gameRepository)
        for player in [winnerPlayer, player2, player3, player4] {
            let input = CommitCardInput.init(gameId: gameId, roundId: roundId, playerId: player.playerId)
            let output = try commitCardUsecase.execute(input: input)
        }

        let usecase = DetermineRoundWinnerUsecase(gameRepository: gameRepository)
        let input = DetermineRoundWinnerInput(gameId: gameId, roundId: roundId)
        let output: DetermineRoundWinnerOutput = usecase.execute(input: input)
        
        XCTAssertEqual(output.winnerPlayer?.playerId, winnerPlayer.playerId)
    }
}