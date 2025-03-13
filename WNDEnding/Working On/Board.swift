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
    @Published var terrainBoard: [[TileData]] = [[TileData(name: "g", loot: 0, movePenalty: 0)]]
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
    func getTerrainAt(_ coord : Coord)->String{
        
        return terrainBoard[coord.row][coord.col].name
    }
    func canEscape(on : Coord)->Bool{
        return getTerrainAt(on) == "X"
    }
    func getCoord(of moveable: Mob) -> Coord? {
           for (coord, mob) in mobs {
               if moveable == mob {
                   return coord
               }
           }
           
           print("⚠️ FAILED TO FIND MOB: \(moveable.id)")
           print("📋 Current mobs in board:")
           for (coord, mob) in mobs {
               print("- \(mob.id) at \(coord)")
           }
           
           assertionFailure("Mob not found in board! Check if mobs dictionary is updated properly.")
           return nil
       }
    func callMoveFunctionForPlayer(tapRow: Int, tapCol: Int, startPoint : Coord, piece : Mob){
    
        
        if let coordAfterMove = getCoord(of: piece){
            if canEscape(on: coordAfterMove) {
                handleUnitEscape(at: coordAfterMove)
            }
        }
    }
    func handleUnitEscape(at providedCoord: Coord) {
        if var entityOnCoord = mobs[providedCoord] {
            // Update the survivor here as needed before setting it
            
            for survivor in playerControlled.indices {
                if playerControlled[survivor] == entityOnCoord.info {
                    var new = playerControlled[survivor]
                    new.location = .inMission(false)
                    playerControlled[survivor] = new
                }
            }
            mobs[providedCoord] = nil
            
        }
        updateGameStatus()
    }
}
