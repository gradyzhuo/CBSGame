import Foundation

public struct ShowHandCardsUsecase {
    public var gameRepository: CBSGameRepository

    public func execute(input: ShowHandCardsInput) throws -> ShowHandCardsOutput{
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(handCardsDto: nil)
        }

        guard let player = game.getPlayer(byId: input.playerId) else {
            return .init(handCardsDto: nil)
        }

        return .init(
            handCardsDto: .init(
                playerId: player.id, 
                playerName: player.name, 
                handCards: player.handCards.map{
                    .init(pokeCard: $0)
                })
        )
    }
}