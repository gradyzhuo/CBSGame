import XCTest
@testable import CBSGame
@testable import CardGame
@testable import CBSPlayer
@testable import DDD

// public struct AlwayFirst: PlayPolicy {

//     public func playCard(player: PlayerDto) throws -> Cards.Index {
//         return 0
//     }

    
// }

class CBSGameTests: XCTestCase {
    let gameRepository = CBSGameInMemoryRepository()
    let playerRepository = PlayerInMemoryRepository()
    let domainEventBus = EventBus()// CausalityBusAdapter(queue: .main)

    func createGame() async throws ->String {
        let usecase = CreateCBSGameService(repository: gameRepository, eventBus: domainEventBus)
        let input = CreateCBSGameInput.init()
        let output = try await usecase.execute(input: input)
        return output.id!
    }

    func createGamePlayer(gameId: String, playerName: String) async throws-> String {
        // let policyForTest = AlwayFirst()
        let usecase = CreatePlayerService(repository: playerRepository, eventBus: domainEventBus)
        let input: CreatePlayerInput = .init(gameId: gameId, playerName: playerName)
        let output: CreatePlayerOutput = try await usecase.execute(input: input)
        return output.playerId!
    }

    func createRound(gameId: String, round: Int) async throws -> String? {
        let usecase = CreateRoundService(repository: gameRepository, eventBus: domainEventBus)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output = try await usecase.execute(input: input)
        return output.id
    }

    func dealCard(gameId: String, cards: [PokeCard]) async throws -> String{
        let dealCardInput: DealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase = DealCardService(repository: gameRepository, eventBus: domainEventBus)
        let dealCardUsecaseOutput = try await dealCardUsecase.execute(input: dealCardInput)
        return dealCardUsecaseOutput.id!
    }

    func playCard(gameId: String, playerId: String, round: Int, cardIndex: Int ) async throws -> PokeCard? {
        let input = PlayCardInput(gameId: gameId, playerId: playerId, round: round, cardIndex: cardIndex)
        let usecase = PlayCardService(repository: playerRepository, eventBus: domainEventBus)
        let output = try await usecase.execute(input: input)
        return output.playedCard
    }

}
