//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGame

final class CreateRoundUsecaseTest: CBSGameTests {

    func testCreateRound() async throws{
        let gameId: String = try await createGame()

        let roundIndex = 0
        
        let usecase = CreateRoundService(repository: gameRepository, eventBus: domainEventBus)
        let input = CreateRoundInput(
            gameId: gameId, 
            roundIndex: roundIndex
        )
        let output = try await usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game = try await gameRepository.find(byId: gameId)
        XCTAssertEqual(game?.rounds.count, 1)
        let round = game?.getRound(index: roundIndex)
        XCTAssertEqual(round?.id, output.id)
    }
}
