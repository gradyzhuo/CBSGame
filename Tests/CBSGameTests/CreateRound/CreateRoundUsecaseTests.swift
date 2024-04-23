//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGameCore

final class CreateRoundUsecaseTest: CBSGameTests {

    func testCreateRound() throws{
        let gameId: String = createGame()

        let roundIndex = 0
        
        let usecase = CreateRoundUsecase.init(gameRepository: gameRepository)
        let input = CreateRoundInput(
            gameId: gameId, 
            roundIndex: roundIndex
        )
        let output = usecase.execute(input: input)
        XCTAssertNotNil(output.id)

        let game:CBSGame! = gameRepository.find(byId: gameId)
        XCTAssertEqual(game.rounds.count, 1)
    }
}
