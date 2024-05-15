import DDD

public protocol GetPlayerUsecase: Usecase<Player, GetPlayerInput, GetPlayerOutput> {
    
}

extension GetPlayerUsecase {
    public func execute(input: Input) async throws -> Output {
        guard let player = try await repository.find(byId: input.playerId) else {
            return .init(playerDto: nil)
        }
        
        return .init(playerDto: .init(player: player))
    }
}

