import Foundation

public struct DealCardUsecase {
    public var gameRepository: CBSGameRepository

    public func execute(input: DealCardInput) throws -> DealCardOutput{
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }

        game.dealCards(cards: input.cards)
        
        return .init(id: input.gameId)
    }
}