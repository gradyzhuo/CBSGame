//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGameCore

final class CreatePlayerUsecaseTest: CBSGameTests {

    func testCreateANewPlayer() throws{
        let playerName: String = "Player"

        let policyForTest = AlwayFirst.init()

        let gameId: String = createGame()
        let usecase = CreatePlayerUsecase.init(gameRepository: gameRepository)
        let input = CreatePlayerInput(
            gameId: gameId,
            playerName: playerName,
            policy: policyForTest
        )
        let output = usecase.execute(input: input)
        XCTAssertNotNil(output.playerDto)

        let game:CBSGame! = gameRepository.find(byId: gameId)
        XCTAssertEqual(game.joinedPlayers.count, 1)
    }
}
