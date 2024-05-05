//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGame

final class CreateRoundUsecaseTest: CBSGameTests {

    func testCreateRound() throws{
        let gameId: String = createGame()

        let roundIndex = 0
        
        let usecase = CreateRoundUsecase.init(gameRepository: gameRepository, eventBus: domainEventBus)
        let input = CreateRoundInput(
            gameId: gameId, 
            roundIndex: roundIndex
        )
        let output = try usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game = gameRepository.find(byId: gameId)
        XCTAssertEqual(game?.rounds.count, 1)
        let round = game?.getRound(index: roundIndex)
        XCTAssertEqual(round?.id, output.id)
    }
}
