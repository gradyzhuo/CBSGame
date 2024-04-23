class Game {
    let id: String
    let name: String
    let playersNum: Int
    let rounds: Int

    internal init(id: String, name: String, playersNum: Int, rounds: Int) {
        self.id = id
        self.name = name
        self.playersNum = playersNum
        self.rounds = rounds
    }
}