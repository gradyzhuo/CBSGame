//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSPlayer

final class CreatePlayerUsecaseTest: CBSGameTests {

    func testCreateANewPlayer() async throws {
        let playerName: String = "Player for testing."

        let gameId: String = try await createGame()
        let usecase = CreatePlayerService(repository: playerRepository, eventBus: domainEventBus)
        let input = CreatePlayerInput(
            gameId: gameId,
            playerName: playerName
        )
        let output = try await usecase.execute(input: input)
        XCTAssertNotNil(output.playerId)

        let player = try await playerRepository.find(byId: output.playerId!)
        XCTAssertEqual(player?.name, playerName)
    }
}
