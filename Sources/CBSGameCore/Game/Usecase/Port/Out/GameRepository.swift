
class GameRepository{
    var games: [Game] = []

    func find(byId id: String)->Game?{
        return games.first{ element in
            element.id == id
        }
    }

    func save(game: Game){
        games.append(game)
    }

}