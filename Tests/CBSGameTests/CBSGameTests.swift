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
    let gameRepository = CBSGameRepository.init()
    let playerRepository = PlayerRepository.init()
    let domainEventBus: DomainEventBus = CausalityBusAdapter(queue: .global())

    func createGame() ->String {
        let usecase = CreateCBSGameUsecase(repository: gameRepository, eventBus: domainEventBus)
        let input = CreateCBSGameInput.init()
        let output = try! usecase.execute(input: input)
        return output.id!
    }

    func createGamePlayer(gameId: String, playerName: String)-> String {
        // let policyForTest = AlwayFirst()
        let usecase = CreatePlayerUsecase(playerRepository: playerRepository, eventBus: domainEventBus)
        let input: CreatePlayerInput = .init(gameId: gameId, playerName: playerName)
        let output: CreatePlayerOutput = try! usecase.execute(input: input)
        return output.playerId!
    }

    func createRound(gameId: String, round: Int) -> String? {
        let usecase = CreateRoundUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output = try! usecase.execute(input: input)
        return output.id
    }

    func dealCard(gameId: String, cards: [PokeCard]) throws -> String{
        let dealCardInput: DealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase: DealCardUsecase = DealCardUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let dealCardUsecaseOutput = try dealCardUsecase.execute(input: dealCardInput)
        return dealCardUsecaseOutput.id!
    }

    func playCard(gameId: String, playerId: String, round: Int, cardIndex: Int ) throws -> PokeCard? {
        let input = PlayCardInput(gameId: gameId, playerId: playerId, round: round, cardIndex: cardIndex)
        let usecase = PlayCardUsecase(playerRepository: playerRepository, eventBus: domainEventBus)
        let output = try usecase.execute(input: input)
        return output.playedCard
    }

}
