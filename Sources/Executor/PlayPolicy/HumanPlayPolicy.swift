import Foundation
import CBSGameCore

public struct HumanPlayPolicy: PlayPolicy{
    
    public func playCard(player: PlayerDto) throws -> Cards.Index {
        print("++ \(player.playerName) 的手牌：")
        player.handCards.enumerated().forEach{
            print("[\($0)] \($1)")
        }
        print("---")
        print("請輸入你要出的手牌編號：", terminator: " ")
        let playId = readLine().flatMap{
            Int($0)
        } 
        return playId!
    }

}