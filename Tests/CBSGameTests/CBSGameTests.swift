import XCTest
@testable import CBSGame

class CBSGameTests: XCTestCase {
    let gameRepository: CBSGameRepository = CBSGameRepository.init()

    func createGame()->String? {
        let usecase = CreateCBSGameUsecase(repository: gameRepository)
        let input = CreateCBSGameInput.init()
        let output = usecase.execute(input: input)
        return output.id
    }

    func createGamePlayer(gameId: String, playerName: String)->String {
        let usecase = CreateHumanPlayerUsecase(gameRepository: gameRepository)
        let input: CreateHumanPlayerInput = .init(gameId: gameId, playerName: playerName)
        let output: CreateHumanPlayerOutput = usecase.execute(input: input)
        return output.id!
    }

    func createGamePlayers(gameId: String, playerNames: [String])-> [String]{
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
