import Foundation

public class DealCardUsecase {
    public var gameRepository: CBSGameRepository

    public init(gameRepository: CBSGameRepository) {
        self.gameRepository = gameRepository
    }

    public func execute(input: DealCardInput) throws -> DealCardOutput{
        guard var game = gameRepository.find(byId: input.gameId) else {
            return .init(id: nil)
        }

        game.dealCards(cards: input.cards)
        
        return .init(id: input.gameId)
    }
}