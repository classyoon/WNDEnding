//
//  Board.swift
//  BoardGame
//
//  Created by Tim Yoon on 11/27/22.
// Modified by Conner Yoon

import Foundation
import SwiftUI

class Board : ObservableObject{
    @Published var pack = OutsideHaulStockpile()
    @Published var mobs : [Coord: Mob] = [:]
    @Published var playerControlled = [Soul]()
    @Published var timer = NightTracker()
    enum EndingChoice : Equatable {
        case distract, run, eaten
    }
    
    enum SpecialEndings : Equatable {
        case haveToEscape
    }
    
    enum StandardEndings : Equatable {
        case everyoneDied, escaped
    }
    enum Ending : Equatable {
        case end(StandardEndings), options(SpecialEndings), result(EndingChoice)
    }
    enum GameStatus : Equatable {
        case onGoing, ended(Ending)
    }
    
    @Published var chosenOverlay = GameStatus.onGoing
    
    @Published var numberOfZombies : Int = 0
    @Published var missionUnderWay = false
    @Published var turn = UUID()
    
    
    func endBadly(){
        for survivor in mobs {
            if survivor.value.info.location == .inMission(true) && survivor.value.team == .player {
                checkUnitDeath(survivor.key)
            }
        }
    }
    func generateBoard(){
        func spawnFromVanAndSetUpData(){
            playerControlled = Stockpile.shared.transportSurvivorsOnVan()
        }
        spawnFromVanAndSetUpData()
        missionUnderWay = true
        chosenOverlay = .onGoing
    }
    
}
