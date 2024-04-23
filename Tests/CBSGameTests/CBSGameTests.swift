import XCTest
@testable import CBSGameCore


public struct AlwayFirst: PlayPolicy {

    public func playCard(player: PlayerDto) throws -> Cards.Index {
        return 0
    }

    
}

class CBSGameTests: XCTestCase {
    let gameRepository: CBSGameRepository = CBSGameRepository.init()

    func createGame()->String {
        let usecase = CreateCBSGameUsecase(repository: gameRepository)
        let input = CreateCBSGameInput.init()
        let output = usecase.execute(input: input)
        return output.id!
    }

    func createGamePlayer(gameId: String, playerName: String)->PlayerDto {
        let policyForTest = AlwayFirst()
        let usecase = CreatePlayerUsecase(gameRepository: gameRepository)
        let input: CreatePlayerInput = .init(gameId: gameId, playerName: playerName, policy: policyForTest)
        let output: CreatePlayerOutput = usecase.execute(input: input)
        return output.playerDto!
    }

    func createGamePlayers(gameId: String, playerNames: [String])-> [PlayerDto]{
        return playerNames.map{
            createGamePlayer(gameId: gameId, playerName: $0)
        }
    }

    func createRound(gameId: String, round: Int)->String {
        let usecase = CreateRoundUsecase(gameRepository: gameRepository)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output: CreateRoundOutput = usecase.execute(input: input)
        return output.id!
    }

    func dealCard(gameId: String, cards: [PokeCard]) throws -> String{
        let dealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase: DealCardUsecase = DealCardUsecase(gameRepository: gameRepository)
        let dealCardUsecaseOutput = try dealCardUsecase.execute(input: dealCardInput)
        return dealCardUsecaseOutput.id!
    }
}
