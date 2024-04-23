import CBSGameCore

@main
struct CBSGameMain {

    static let gameRepository = CBSGameRepository.init()

    static func createGame()->String? {
        let usecase = CreateCBSGameUsecase(repository: gameRepository)
        let input = CreateCBSGameInput.init()
        let output = usecase.execute(input: input)
        return output.id
    }

    static func createGamePlayer(gameId: String, playerName: String, policy: PlayPolicy)->PlayerDto {
        let usecase = CreatePlayerUsecase(gameRepository: gameRepository)
        let input: CreatePlayerInput = .init(gameId: gameId, playerName: playerName, policy: policy)
        let output: CreatePlayerOutput = usecase.execute(input: input)
        return output.playerDto!
    }

    static func createRound(gameId: String, round: Int)->String {
        let usecase = CreateRoundUsecase(gameRepository: gameRepository)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output: CreateRoundOutput = usecase.execute(input: input)
        return output.id!
    }
    
    static func dealCard(gameId: String, cards: [PokeCard]) throws {
        let dealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase: DealCardUsecase = DealCardUsecase(gameRepository: gameRepository)
        _ = try dealCardUsecase.execute(input: dealCardInput)
    }

    static func determinWinner(gameId: String, roundId: String)->WinnerPlayerDto?{
        let usecase = DetermineRoundWinnerUsecase(gameRepository: gameRepository)
        let input = DetermineRoundWinnerInput(gameId: gameId, roundId: roundId)
        return usecase.execute(input: input).winnerPlayer
    }

    static func main() throws {

        guard let gameId = createGame() else{
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

        
        let players: [PlayerDto] = (0..<playerNums).compactMap{ index in
            print("請輸入玩家[\(index)]名字:", terminator: " ")
            return readLine().flatMap{
                createGamePlayer(gameId: gameId, playerName: $0, policy: HumanPlayPolicy.init())
            }
        } + (0..<(4-playerNums)).compactMap{ index in
            createGamePlayer(gameId: gameId, playerName: "AI:\(index)", policy: AIPlayPolicy.init())
        }

        var scores: [Int] = .init(repeating: 0, count: players.count)
        
        try dealCard(gameId: gameId, cards: PokeCard.allCases.shuffled())
        print("++ 發牌完成")
        
        for round in 0..<maxRounds {
            print("==========")
            print("++ Round [\(round+1)]")
            let roundId = createRound(gameId: gameId, round: round)
            for player in players {
                let usecase = CommitCardUsecase.init(gameRepository: gameRepository)
                let input = CommitCardInput.init(gameId: gameId, roundId: roundId, playerId: player.playerId)
                let output = try usecase.execute(input: input)
                print("++ \(player.playerName) 出牌：\(output.committedCard!)")
            }

            if let winnerPlyerDto = determinWinner(gameId: gameId, roundId: roundId){ 
                print("++ 第\(round+1)回合獲勝玩家是 \(winnerPlyerDto.playerName)")

                let index = players.firstIndex{
                    $0.playerId == winnerPlyerDto.playerId
                }!
                scores[index] = scores[index] + 1
            }
        }

        let max = scores.enumerated().max{
            $0.element < $1.element
        }!
 
        print("\n=========")
        print("最後贏家：", players[max.offset].playerName)
    }

}