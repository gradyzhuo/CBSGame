import Foundation

public struct GetPlayerUsecase {
    let playerRepository: PlayerRepository

    public init(playerRepository: PlayerRepository){
        self.playerRepository = playerRepository
    }


    public func execute(input: GetPlayerInput)-> GetPlayerOutput{
        guard let player = playerRepository.find(byId: input.playerId) else {
            return .init(playerDto: nil)
        }
        
        return .init(playerDto: .init(player: player))
    }
}