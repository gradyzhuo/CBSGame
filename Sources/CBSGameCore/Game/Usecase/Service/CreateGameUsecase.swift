

class CreateGameUsecase{
    let repository: GameRepository

    init(repository: GameRepository){
        self.repository = repository
    }
    func execute(input: CreateGameInput)->CreateGameOuteput{
        let game = Game(id: input.gameId,
            name: input.gameName, 
            playersNum: input.playersNum, 
            rounds: input.rounds)

        repository.save(game: game)
        return .init(gameId: game.id)
    }
}