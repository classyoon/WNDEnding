//
//  GameManager.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 2/19/23.
//

import Foundation


//var campStats = true

enum CampEventDisplay : Codable {
    case victory, defeat, dailyStats
}
enum CurrentScreen {
    case outside, inside
}
class GameManager : ObservableObject {
    @Published var tutorial : TutorialManager = TutorialManager(currentScreen: .inside)
    @Published var gameConData : ScenarioTracker = ScenarioTracker()
    @Published var stockpileData : StockpileModel = StockpileModel()
    @Published var selectionData = SelectionManagerData()
    @Published var gameCon : GameCondition = GameCondition.shared
    @Published var stockpile : Stockpile = Stockpile.shared
    @Published var buildingMan : BuildingManager = BuildingManager.shared
    @Published var selectionManager : SelectionManager = SelectionManager.shared
    @Published var board = Board()
    @Published var campUi = CampUIState()
    @Published var days = 0
    @Published var audio : AudioManager = AudioManager.shared
    @Published var currentView : CurrentScreen = .inside

    
    func accessSave(savedData: ResourcePoolData) {
        self.days = savedData.days
        self.stockpileData = savedData.stockpileData
        self.gameConData = savedData.gameConData
        self.selectionData = savedData.selectionData
    }
    
    
    func reset() {
        Stockpile.shared.reset()
        BuildingManager.shared.reset()
        GameCondition.shared.reset()
        SelectionManager.shared.reset()
        audio.pauseMusic()
        audio.playMusic("Kurt", after: 0.5)
        days = 0
    }
    
    func promptBoardToGenerateMap(){
        board.generateBoard()
        tutorial.currentScreen = .outside
        currentView = .outside
        audio.musicMute = true
    }
    
    func passDay(){
        audio.playSFX(.nextDay)
        days+=1
        buildingMan.runDaily()
        Stockpile.shared.runDaily()
        gameCon.runDaily()
        tutorial.currentScreen = .inside
        currentView = .inside
        save(items: ResourcePoolData(resourcePool: self), key: key)
    }
    
    func hardmodeReset(){
        reset()
        stockpile.hardModeReset()
    }
}
