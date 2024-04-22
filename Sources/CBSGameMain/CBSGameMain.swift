// The Swift Programming Language
// https://docs.swift.org/swift-book



@main
struct CBSGameMain {

    static let gameRepository = CBSGameRepository.init()


    // static func createPlayer(gameId: String, playerName: String)->CreatePlayerOutput{
    //     let createPlayerUsecase = CreatePlayerUsecase.init(gameRepository: gameRepository)
    //     let createPlayerInput = CreatePlayerInput.init(gameId: gameId, playerName: playerName)
    //     let creaatePlayeOutput = createPlayerUsecase.execute(input: createPlayerInput)
    //     return creaatePlayeOutput
    // }

    static func createGame()->String? {
        let usecase = CreateCBSGameUsecase(repository: gameRepository)
        let input = CreateCBSGameInput.init()
        let output = usecase.execute(input: input)
        return output.id
    }

    static func createGamePlayer(gameId: String, playerName: String)->String {
        let usecase = CreateHumanPlayerUsecase(gameRepository: gameRepository)
        let input: CreateHumanPlayerInput = .init(gameId: gameId, playerName: playerName)
        let output: CreateHumanPlayerOutput = usecase.execute(input: input)
        return output.id!
    }

    static func createGamePlayers(gameId: String, playerNames: [String])-> [String]{
        return playerNames.map{
            createGamePlayer(gameId: gameId, playerName: $0)
        }
    }

    static func createRound(gameId: String, round: Int)->String {
        let usecase = CreateRoundUsecase(gameRepository: gameRepository)
        let input: CreateRoundInput = .init(gameId: gameId, roundIndex: round)
        let output: CreateRoundOutput = usecase.execute(input: input)
        return output.id!
    }

    static func dealCard(gameId: String, cards: [PokeCard]) throws -> String{
        let dealCardInput = DealCardInput.init(gameId: gameId, cards: cards)
        let dealCardUsecase: DealCardUsecase = DealCardUsecase(gameRepository: gameRepository)
        let dealCardUsecaseOutput = try dealCardUsecase.execute(input: dealCardInput)
        return dealCardUsecaseOutput.id!
    }
    
    static func commitCard(gameId: String, roundId: String, playerId: String, cardIndex: Int) throws{
        let usecase = CommitCardUsecase.init(gameRepository: gameRepository)
        let input = CommitCardInput.init(gameId: gameId, roundId: roundId, playerId: playerId, cardIndex: cardIndex)
        let output = try usecase.execute(input: input)
    }

    static func showHandCard(gameId: String, playerId: String) throws -> PlayerHandCardsDto?{
        let usecase = ShowHandCardsUsecase.init(gameRepository: gameRepository)
        let input = ShowHandCardsInput.init(gameId: gameId, playerId: playerId)
        let output = try usecase.execute(input: input)
        return output.handCardsDto
    }

    static func printHandCard(handCardsDto: PlayerHandCardsDto){
        handCardsDto.handCards.enumerated().forEach{
            print("[\($0)] \($1)")
        }
    }

    static func determinWinner(gameId: String, roundId: String)->String?{
        let usecase = DetermineWinnerUsecase(gameRepository: gameRepository)
        let input = DetermineWinnerInput(gameId: gameId, roundId: roundId)
        return usecase.execute(input: input).winnerPlayerId
    }

    static func main() throws {

        guard let gameId = createGame() else{
            return
        }

        // print("請輸入遊玩人數:", terminator: "")
        // let playerIds: [String] = readLine().flatMap{
        //     Int($0).flatMap{
        //         (0..<$0).compactMap{ index in
        //             print("請輸入玩家[\(index)]名字:", terminator: "")
        //             return readLine().flatMap{
        //                 createGamePlayer(gameId: gameId, playerName: $0)
        //             }
        //         }
        //     }
        // } ?? []
        
        let playerIds: [String] = (0..<4).compactMap{ index in
            print("請輸入玩家[\(index)]名字:", terminator: "")
            return readLine().flatMap{
                createGamePlayer(gameId: gameId, playerName: $0)
            }
        }

        
        try dealCard(gameId: gameId, cards: PokeCard.allCases.shuffled())
        print("發牌完成")

        for round in 0..<13 {
            print("----第\(round+1)回合----")
            let roundId = createRound(gameId: gameId, round: round)
            for playerId in playerIds {

                if let handCardsDto = try showHandCard(gameId: gameId, playerId: playerId) {
                    print("\(handCardsDto.playerName) 您的手牌如下：")
                    printHandCard(handCardsDto: handCardsDto)
                    print("---")
                    print("請輸入你要出的手牌編號：", terminator: "")
                    let playId = readLine().flatMap{
                        Int($0)
                    }
                    try commitCard(gameId: gameId, roundId: roundId, playerId: playerId, cardIndex: playId!)
                }
            }

            if let winnerPlyerId = determinWinner(gameId: gameId, roundId: roundId), 
                let player = gameRepository.find(byId: gameId)?.getPlayer(byId: winnerPlyerId) {
                print("第\(round+1)回合獲勝玩家是 \(player.name)")
            }


        }







        // var createGameUsecase = CreateCBSGameUsecase.init(repository: gameRepository)
        // var input = CreateCBSGameInput.init()
        // let output = createGameUsecase.execute(input: input)

        // guard let gameId = output.id else {
        //     return
        // }

        // let creaatePlayeOutput = createPlayer(gameId: gameId, playerName: "")
        // print(creaatePlayeOutput)




    }
}