import Foundation

public class Round {
    public struct CommittedCard{
        let playerId: String
        let card: PokeCard
    }
    
    let id: String
    public private(set) var committedCards: [CommittedCard] = []

    init(id: String){
        self.id = id
    }

    public func commit(playerId: String, card: PokeCard){
        committedCards.append(.init(playerId: playerId, card: card))
    }

    public func determine()->String{
        let winner = committedCards.max{
            $0.card < $1.card
        }!
        return winner.playerId
    }

}