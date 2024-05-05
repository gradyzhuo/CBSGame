//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSPlayer

final class CreatePlayerUsecaseTest: CBSGameTests {

    func testCreateANewPlayer() throws {
        let playerName: String = "Player for testing."

        let gameId: String = createGame()
        let usecase = CreatePlayerUsecase.init(playerRepository: playerRepository, eventBus: domainEventBus)
        let input = CreatePlayerInput(
            gameId: gameId,
            playerName: playerName
        )
        let output = try usecase.execute(input: input)
        XCTAssertNotNil(output.playerId)

        let player = playerRepository.find(byId: output.playerId!)
        XCTAssertEqual(player?.name, playerName)
    }
}
