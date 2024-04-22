//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGame

final class CreateRoundUsecaseTest: CBSGameTests {

    func testStartRoundAndCompareCardFromPlayers() throws{
        guard let gameId: String = createGame() else {
            return
        }

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
