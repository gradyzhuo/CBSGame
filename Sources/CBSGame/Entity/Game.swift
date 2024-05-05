import Foundation 
import DDD
import CardGame

public enum CBSGameError: Error{
    case noMoreCard
    case unknownEvent(DomainEvent)
}

public class CBSGame: AggregateRoot, DomainEventSource {
    public var coordinator: EventStorageCoordinator<CBSGame>

    public private(set) var id: String
    public private(set) var joinedPlayers: [String] = []
    public internal(set) var rounds: [Round] = []
    
    public required convenience init?(events: [any DomainEvent]) throws {
        var events = events
        guard let gameEvent = events.removeFirst() as? GameCreated else {
            return nil
        }

        self.init(id: gameEvent.id)
        for event in events{
            try self.add(event: event)
        }
        try clearAllDomainEvents()
    }

    init(id: String){
        self.id = id 
        self.coordinator = .init(id: self.id)
        try! self.add(event: GameCreated(id: id))
    }

    public func apply(event: some DomainEvent) throws  {
        switch event {
            case let e as GameCreated:
                when(e)
            case let e as CardDealed:
                when(e)
            case let e as RoundCreated:
                when(e)
            case let e as RoundWinnerDetermined:
                when(e)
            case let e as CardCommitted:
                when(e)
            case let e as PlayerJoined:
                when(e)
            default:
                throw CBSGameError.unknownEvent(event)
        }
    }
    
    public func joinPlayer(id: String){
        try! self.add(event: PlayerJoined(gameId: self.id, playerId: id))
    }

    public func dealCards(cards: [PokeCard]) {
        var cardIterator = cards.enumerated().makeIterator()
        while let (offset, card) = cardIterator.next() {
            let index = offset % joinedPlayers.count
            let playerId = joinedPlayers[index]
            let event = CardDealed(playerId: playerId, card: card)
            try! self.add(event: event)
        }
    }

    public func start(round roundIndex: Int)->String{
        let round = Round(id: roundIndex.description)
        let event = RoundCreated(roundIndex: roundIndex, roundId: round.id)
        try! self.add(event: event)
        return round.id
    }

    public func getRound(index: Int)->Round? {
        guard rounds.indices.contains(index) else {
            return nil
        }
        return rounds[index]
    }

    public func commitCard(roundIndex: Int, playerId: String, card: PokeCard){
        let event = CardCommitted(roundIndex:roundIndex, playerId: playerId, card: card)
        try! self.add(event: event)
    }

    public func determine(roundIndex: Int)-> String?{
        let round = rounds[roundIndex]
        let winner = round.committedCards.max{
            $0.card < $1.card
        }!
        let event = RoundWinnerDetermined(roundIndex: roundIndex, winnerPlayerId: winner.playerId, pokerCard: winner.card)
        try! add(event: event)
        return winner.playerId
    }

    func when(_ event: GameCreated){
        self.id = event.id
    }

    func when(_ event: CardDealed){
        // guard let player = getPlayer(byId: event.playerId) else {
        //     return
        // }
        // player.add(handCard: event.card)
    }
    
    func when(_ event: RoundCreated){
        let round = Round(id: event.roundId)
        self.rounds.append(round)
    }

    public func when(_ event: CardCommitted){
        let round = rounds[event.roundIndex]
        round.commit(playerId: event.playerId, card: event.card)
        rounds[event.roundIndex] = round
    }

    func when(_ event: RoundWinnerDetermined){
        let round = self.rounds[event.roundIndex]
        round.setWinner(playerId: event.winnerPlayerId, card: event.pokerCard)
        self.rounds[event.roundIndex] = round
    }

    func when(_ event: PlayerJoined){
        self.joinedPlayers.append(event.playerId)
    }
}  