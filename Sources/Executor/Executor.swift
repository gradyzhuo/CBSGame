import CardGame
import CBSGame
import CBSPlayer
import DDD

@main
struct CBSGameMain {

    static let gameRepository = CBSGameRepository.init()
    static let playerRepository = PlayerRepository()
    static let domainEventBus: DomainEventBus = CausalityBusAdapter()

    static func createGame() throws ->String? {
        let usecase = CreateCBSGameUsecase(repository: gameRepository, eventBus: domainEventBus)
        let input = CreateCBSGameInput.init()
        let output = try usecase.execute(input: input)
        return output.id
    }

    static func createGamePlayer(gameId: String, playerName: String) throws ->String {
        let usecase = CreatePlayerUsecase(playerRepository: playerRepository, eventBus: domainEventBus)
        let input: CreatePlayerInput = .init(gameId: gameId, playerName: playerName)
        let output: CreatePlayerOutput = try usecase.execute(input: input)
        return output.playerId!
    }

    static func createRound(gameId: String, round: Int) throws ->String {
        let usecase = CreateRoundUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output: CreateRoundOutput = try usecase.execute(input: input)
        return output.id!
    }
    
    static func dealCard(gameId: String, cards: [PokeCard]) throws {
        let dealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase: DealCardUsecase = DealCardUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        _ = try dealCardUsecase.execute(input: dealCardInput)
    }

    static func determinWinner(gameId: String, roundIndex: Int) throws ->String?{
        let usecase = DetermineRoundWinnerUsecase(gameRepository: gameRepository, eventBus: domainEventBus)
        let input = DetermineRoundWinnerInput(gameId: gameId, roundIndex: roundIndex)
        return try usecase.execute(input: input).winnerPlayerId
    }

    static func getPlayer(gameId: String, playerId: String)->PlayerDto{
        let usecase = GetPlayerUsecase(playerRepository: playerRepository)
        let input = GetPlayerInput(gameId: gameId, playerId: playerId)
        return usecase.execute(input: input).playerDto!
    }

    static func getPlayedCardIndex(playerDto: PlayerDto)->Int{
        print("++ \(playerDto.playerName) 的手牌：")
        playerDto.handCards.enumerated().forEach{
            print("[\($0)] \($1)")
        }
        print("---")
        print("請輸入你要出的手牌編號：", terminator: " ")
        let playId = readLine().flatMap{
            Int($0)
        } 
        return playId!
    }

    static func main() throws {
        
        try domainEventBus.register(listener: WhenPlayerCreatedListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(playerRepository: playerRepository, domainEventBus: domainEventBus))

        guard let gameId = try createGame() else{
            return
        }

        print("請輸入遊玩人數(最多4人):", terminator: " ")
        let playerNums = readLine().flatMap{
            Int($0)
        } ?? 4

        print("請輸入預計回合(最多13回合):", terminator: " ")
        let maxRounds = readLine().flatMap{
            Int($0)
        } ?? 13

        
        
        let players: [(id: String, name: String)] = try (0..<playerNums).compactMap{ index in
            print("請輸入玩家[\(index)]名字:", terminator: " ")
            return try readLine().flatMap{
                (try createGamePlayer(gameId: gameId, playerName: $0), $0)
            }
        } + (0..<(4-playerNums)).compactMap{ index in
            let playerName = "AI:\(index)"
            return (try createGamePlayer(gameId: gameId, playerName: playerName), playerName)
        }

        var scores: [Int] = .init(repeating: 0, count: players.count)
        
        try dealCard(gameId: gameId, cards: PokeCard.allCases.shuffled())
        print("++ 發牌完成")
        
        for round in 0..<maxRounds {
            print("==========")
            print("++ Round [\(round+1)]")
            try createRound(gameId: gameId, round: round)
            for player in players {
                let playerDto = getPlayer(gameId: gameId, playerId: player.id)
                let playedIndex = getPlayedCardIndex(playerDto: playerDto)

                let usecase = CommitCardUsecase.init(gameRepository: gameRepository, eventBus: domainEventBus)
                let input = CommitCardInput.init(gameId: gameId, roundIndex: round, playerId: player.id, chooseCard: playerDto.handCards[playedIndex])
                let output = try usecase.execute(input: input)
                print("++ \(playerDto.playerName) 出牌：\(output.committedCard!)")
            }

            if let winnerPlyerId = try determinWinner(gameId: gameId, roundIndex: round), 
                let winnerPlayer = players.first(where: { $0.id == winnerPlyerId }) { 
                
                print("++ 第\(round+1)回合獲勝玩家是 \(winnerPlayer.name)")

                let index = players.firstIndex{
                    $0.id == winnerPlyerId
                }!
                scores[index] = scores[index] + 1
            }
        }

        let max = scores.enumerated().max{
            $0.element < $1.element
        }!
 
        print("\n=========")
        print("最後贏家：", players[max.offset])
    }

}