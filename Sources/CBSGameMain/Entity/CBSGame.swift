import Foundation 

public enum CBSGameError: Error{
    case noMoreCard
}

public struct CBSGame {
    public let id: String
    public var joinedPlayers: [Player] = []
    public internal(set) var rounds: [Round] = []

    public mutating func createHumanPlayer(name: String) -> String{
        let player = HumanPlayer.init(
            id: UUID.init().uuidString, 
            name: name)
        self.joinedPlayers.append(player)
        return player.id
    }

    public func getPlayer(byId id: String)->Player?{
        return joinedPlayers.first{
            $0.id == id
        }
    }

    public mutating func dealCards(cards: [PokeCard]) {
        var cardIterator = cards.enumerated().makeIterator()

        while let (offset, card) = cardIterator.next() {
            let index = offset % joinedPlayers.count
            var player = joinedPlayers[index]
            player.add(handCard: card)
        }
    }

    public mutating func start(round roundIndex: Int)->String{
        let round = Round.init(id: "\(id):\(roundIndex))" )
        self.rounds.append(round)
        return round.id
    }

    public func getRound(byId id: String)->Round? {
        return rounds.first{
            $0.id == id
        }
    }
}