//
//  GameManager.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 2/19/23.
//

import Foundation


class GameManager : ObservableObject {
    @Published var stockpileData : StockpileModel = StockpileModel()
    @Published var stockpile : Stockpile = Stockpile.shared
    @Published var board = Board()
    @Published var days = 0

    func reset() {
        Stockpile.shared.reset()
        days = 0
    }
    func promptBoardToGenerateMap(){
        board.generateBoard()
    }
    
    func passDay(){
        days+=1
        Stockpile.shared.runDaily()
    }
    
    func hardmodeReset(){
        reset()
        stockpile.hardModeReset()
    }
}
