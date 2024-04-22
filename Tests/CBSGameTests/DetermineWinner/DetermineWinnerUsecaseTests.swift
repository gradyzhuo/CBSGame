import XCTest
@testable import CBSGame


final class DetermineWinnerUsecaseTests: CBSGameTests {

    func testDetermineWinner() throws{ 
        let winnerId = ""

        guard let gameId = createGame() else {
            return
        }

        let winnerPlayerId = createGamePlayer(gameId: gameId, playerName: "WinnerPlayerForTest")
        let playerId2 = createGamePlayer(gameId: gameId, playerName: "Player2")
        let playerId3 = createGamePlayer(gameId: gameId, playerName: "Player3")
        let playerId4 = createGamePlayer(gameId: gameId, playerName: "Player4")
        
        let roundId = createRound(gameId: gameId, round: 0)

        try dealCard(gameId: gameId, cards: [
            .init(suit: .club, rank: .ace), 
            .init(suit: .club, rank: .two), 
            .init(suit: .club, rank: .five),
            .init(suit: .club, rank: .eight)
        ])

        let commitCardUsecase = CommitCardUsecase.init(gameRepository: gameRepository)
        for playerId in [winnerPlayerId, playerId2, playerId3, playerId4] {
            let input = CommitCardInput.init(gameId: gameId, roundId: roundId, playerId: playerId, cardIndex: 0)
            let output = try commitCardUsecase.execute(input: input)
        }

        let usecase = DetermineWinnerUsecase(gameRepository: gameRepository)
        let input = DetermineWinnerInput(gameId: gameId, roundId: roundId)
        let output: DetermineWinnerOutput = usecase.execute(input: input)
        
        XCTAssertEqual(output.winnerPlayerId, winnerPlayerId)

        let winnerIdFromRepository = gameRepository.find(byId: gameId).flatMap{
            $0.getRound(byId: roundId).flatMap{
                $0.winnerPlayerId
            }
        }
        
        XCTAssertEqual(winnerIdFromRepository, winnerPlayerId)


    }
}