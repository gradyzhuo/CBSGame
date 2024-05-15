//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSPlayer
@testable import CardGame
@testable import CBSGame

final class PlayCardUsecaseTest: CBSGameTests {
    
    override func setUp() async throws{
        try domainEventBus.register(listener: WhenGameDealCardListener(repository: playerRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenPlayerCreatedListener(repository: gameRepository, domainEventBus: domainEventBus))
    }
    func testShouldSucceedWhenPlayerPlayACard() async throws {
        let playerName: String = "Player for testing."
        let cardIndex = 0
        let round = 0

        let gameId: String = try await createGame()
        let playerId = try await createGamePlayer(gameId: gameId, playerName: playerName)
        
        let card = PokeCard(suit: .club, rank: .eight)
        try await dealCard(gameId: gameId, cards: [ card ])

        let usecase = PlayCardService(repository: playerRepository, eventBus: domainEventBus)
        let input = PlayCardInput(
            gameId: gameId,
            playerId: playerId,
            round: round,
            cardIndex: cardIndex 
        )
        let output = try await usecase.execute(input: input)
        XCTAssertNotNil(output.playedCard)

        let player = try await playerRepository.find(byId: playerId)
        XCTAssertEqual(player?.name, playerName)
    }
}
