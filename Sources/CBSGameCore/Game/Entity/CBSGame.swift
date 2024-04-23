import Foundation 

public enum CBSGameError: Error{
    case noMoreCard
}

public struct CBSGame {
    public let id: String
    public var joinedPlayers: [Player] = []
    public internal(set) var rounds: [Round] = []

    public mutating func createPlayer(name: String, policy: PlayPolicy) -> PlayerDto{
        let player = Player.init(
            id: UUID.init().uuidString, 
            name: name,
            policy: policy
        )
        self.joinedPlayers.append(player)
        return .init(player: player)
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
            let player = joinedPlayers[index]
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