import CardGame
import CBSGame
import CBSPlayer
import DDD
import EventStoreDB

@main
struct CBSGameMain {

    static let gameRepository = CBSGameInMemoryRepository()
    static let playerRepository = PlayerInMemoryRepository()
    static let domainEventBus = CausalityBusAdapter()

    static func createGame() async throws ->String? {
        let usecase = CreateCBSGameService(repository: gameRepository, eventBus: domainEventBus)
        let input = CreateCBSGameInput.init()
        let output = try await usecase.execute(input: input)
        return output.id
    }

    static func createGamePlayer(gameId: String, playerName: String) async throws ->String {
        let usecase = CreatePlayerService(repository: playerRepository, eventBus: domainEventBus)
        let input: CreatePlayerInput = .init(gameId: gameId, playerName: playerName)
        let output = try await usecase.execute(input: input)
        return output.playerId!
    }

    static func createRound(gameId: String, round: Int) async throws ->String {
        let usecase = CreateRoundService(repository: gameRepository, eventBus: domainEventBus)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output: CreateRoundOutput = try await usecase.execute(input: input)
        return output.id!
    }
    
    static func dealCard(gameId: String, cards: [PokeCard]) async throws {
        let dealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase = DealCardService(repository: gameRepository, eventBus: domainEventBus)
        _ = try await dealCardUsecase.execute(input: dealCardInput)
    }

    static func determinWinner(gameId: String, roundIndex: Int) async throws ->String?{
        let usecase = DetermineRoundWinnerService(repository: gameRepository, eventBus: domainEventBus)
        let input = DetermineRoundWinnerInput(gameId: gameId, roundIndex: roundIndex)
        return try await usecase.execute(input: input).winnerPlayerId
    }

    static func getPlayer(gameId: String, playerId: String) async throws ->PlayerDto{
        let usecase = GetPlayerService(repository: playerRepository, eventBus: domainEventBus)
        let input = GetPlayerInput(gameId: gameId, playerId: playerId)
        return try await usecase.execute(input: input).playerDto!
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

    static func main() async throws {
        
        try domainEventBus.register(listener: WhenPlayerCreatedListener(repository: gameRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenGameDealCardListener(repository: playerRepository, domainEventBus: domainEventBus))
        try domainEventBus.register(listener: WhenPlayerPlayedCardListener(gameRepository: gameRepository, domainEventBus: domainEventBus))
        
        try EventStoreDB.using(settings: "esdb://localhost:2113?tls=false")

        let client = try EventStoreDB.Client()
        
        guard let gameId = try await createGame() else{
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

        
        let players: [(id: String, name: String)] = []
        // let players: [(id: String, name: String)] = try await (0..<playerNums).compactMap{ index in
        //     print("請輸入玩家[\(index)]名字:", terminator: " ")
        //     return try readLine().flatMap{
        //         (try createGamePlayer(gameId: gameId, playerName: $0), $0)
        //     }
        // } + (0..<(4-playerNums)).compactMap{ index in
        //     let playerName = "AI:\(index)"
        //     return (try createGamePlayer(gameId: gameId, playerName: playerName), playerName)
        // }

        var scores: [Int] = .init(repeating: 0, count: players.count)
        
        try await dealCard(gameId: gameId, cards: PokeCard.allCases.shuffled())
        print("++ 發牌完成")
        
        for round in 0..<maxRounds {
            print("==========")
            print("++ Round [\(round+1)]")
            try await createRound(gameId: gameId, round: round)
            for player in players {
                let playerDto = try await getPlayer(gameId: gameId, playerId: player.id)
                let playedIndex = getPlayedCardIndex(playerDto: playerDto)

                let usecase = CommitCardService(repository: gameRepository, eventBus: domainEventBus)
                let input = CommitCardInput.init(gameId: gameId, roundIndex: round, playerId: player.id, chooseCard: playerDto.handCards[playedIndex])
                let output = try await usecase.execute(input: input)
                print("++ \(playerDto.playerName) 出牌：\(output.committedCard!)")
            }

            if let winnerPlyerId = try await determinWinner(gameId: gameId, roundIndex: round), 
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