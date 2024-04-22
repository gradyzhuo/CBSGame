//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGame

final class CreateHumanPlayerUsecaseTest: CBSGameTests {

    func testCreateANewPlayer() throws{
        let playerName: String = "Player"

        guard let gameId: String = createGame() else {
            return
        }
        let usecase = CreateHumanPlayerUsecase.init(gameRepository: gameRepository)
        let input = CreateHumanPlayerInput(
            gameId: gameId,
            playerName: playerName
        )
        let output = usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game:CBSGame! = gameRepository.find(byId: gameId)
        XCTAssertEqual(game.joinedPlayers.count, 1)
    }
}
