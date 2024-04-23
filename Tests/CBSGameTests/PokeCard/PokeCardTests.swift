//
//  File.swift
//  
//
//  Created by 卓俊諺 on 2024/4/18.
//

import XCTest
@testable import CBSGameCore

final class PokeCardTest: XCTestCase {
    func testCreateCardsOfDeck() throws{
        
        let cards = PokeCard.allCases
        XCTAssertEqual(cards.count, 52)
        
    }
}
