//
//  NightTracker.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 10/6/23.
//

import Foundation
class NightTracker : ObservableObject {
    @Published var turnsSinceStart = 0
    @Published var changeToNight = false
    @Published var turnsOfDaylight = 8
    @Published var turnsOfNight = 12
    @Published var spawnRate = 2
    var lengthOfPlay : Int {
        turnsOfDaylight + turnsOfNight
    }
    
    private func updateDayLightStatus(_ zombiesInLevel : Int, board : Board){
        if turnsSinceStart > turnsOfDaylight && turnsSinceStart < lengthOfPlay {
            changeToNight = true
        } else if turnsSinceStart > lengthOfPlay {
            board.chosenOverlay = .ended(.end(.escaped))
        }
       
    }
    
    
    func advanceHour(_ zombiesInLevel : Int, board : Board){
        turnsSinceStart += 1
        print("Times is : \(turnsSinceStart) out of \(lengthOfPlay)")
        updateDayLightStatus(zombiesInLevel, board: board)
    }
    
    func modNightLength(by: Int){
        turnsOfNight += by
    }
    func modDayLength(by: Int){
        turnsOfDaylight += by
    }
    func modBothLength(by : Int){
        modNightLength(by: by)
         modDayLength(by: by)
    }
    func setSpawnRate(zombiesPerTurn : Int){
        spawnRate = zombiesPerTurn
    }
    
    
    init(turnsOfDaylight: Int = 8, turnsOfNight: Int = 12,  spawnRate : Int = 2) {
        self.turnsSinceStart = 0
        self.changeToNight = false
        self.turnsOfDaylight = turnsOfDaylight
        self.turnsOfNight = turnsOfNight
        self.spawnRate = spawnRate
    }
}
