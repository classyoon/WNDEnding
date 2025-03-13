//
//  Board.swift
//  BoardGame
//
//  Created by Tim Yoon on 11/27/22.
// Modified by Conner Yoon

import Foundation
import SwiftUI

protocol BoardProtocol {
    var rowMax: Int { set get }
    var colMax: Int { set get }
    func getCoord(of moveable: Mob) -> Coord?
}

class Board : ObservableObject, BoardProtocol {
    @Published var SetUpData : any Mapable
    var rowMax: Int = 2
    var colMax: Int = 2
    @Published var audio = AudioManager.shared
    @Published var timer = NightTracker()
    @Published var pack = OutsideHaulStockpile()
    @Published var terrainBoard: [[TileData]] = [[TileData(name: "g", loot: 0, movePenalty: 0)]]
    @Published var mobs : [Coord: Mob] = [:]
    var unitWasSelected : Bool {
        selectedUnit != nil
    }
    @Published var selectedUnit : (Mob)? = nil
    @Published var examinedEntity : (Mob)? = nil
    @Published var playerControlled = [Soul]()
    @Published var showInfo = false
    @Published var showTileInfo = false
    @Published var highlightSquare : Coord?{
        didSet{
            displayMoves()
            
        }
    }
    
    
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
    @Published var spawnSpeed : Int = 1
    @Published var boardSize = 700
    @Published var missionUnderWay = false
    @Published var canAnyoneMove = true
    @Published var turn = UUID()
    var possibleMoves: [Coord] {
        getMovesOfSelected()
    }
    func getMovesOfSelected()->[Coord]{
        if selectedUnit == nil || selectedUnit?.hasStamina() == false{
//            print("Should not")
            return []
        }
        else {
//            print("Should yes")
            let newList = selectedUnit!.getMoves()
            var giveList : [Coord] = []
            for move in newList {
                var coord = getCoord(of: selectedUnit!)
                coord!.row += move.row
                coord!.col += move.col
                if (coord!.row >= 0 && coord!.row < rowMax
                ) && (coord!.col >= 0 && coord!.col < colMax) {
                    giveList.append(coord!)
                }
            }
            return giveList
        }
    }
    func endBadly(){
        for survivor in mobs {
            if survivor.value.info.location == .inMission(true) && survivor.value.team == .player {
                checkUnitDeath(survivor.key)
            }
        }
    }
    func generateBoard(){
        func spawnFromVanAndSetUpData(){
            mobs = SetUpData.getPieces()
            playerControlled = Stockpile.shared.transportSurvivorsOnVan()
            spawnPlayers()
            spawnAtRandomLoc(type: .recruit, amount: SetUpData.getNeutralSpawnAmount())
            spawnAtRandomLoc(type: .zombie, amount: SetUpData.getZombieSpawnAmount())
        }
        func accessMapSetUpData(){
            SetUpData = MapFactory.shared.createMap(mapType: MapPicker.shared.chooseMap())
            terrainBoard = SetUpData.generateMap()
            mobs = SetUpData.getPieces()
            rowMax = SetUpData.rows
            colMax = SetUpData.columns
            timer = SetUpData.timer
        }
        func intializeSoundAndUI(){
            audio = AudioManager.shared
        }
        accessMapSetUpData()
        spawnFromVanAndSetUpData()
        spawnPlayers()
        intializeSoundAndUI()
        missionUnderWay = true
        chosenOverlay = .onGoing
    }
    func testGenerate(map : MapName){
        SetUpData = MapFactory.shared.createMap(mapType: map)
        generateBoard()
    }
    init(){
        self.SetUpData = MapFactory.shared.createMap(mapType: MapPicker.shared.chooseMap())
        audio = AudioManager.shared
        rowMax = SetUpData.rows
        colMax = SetUpData.columns
    }
    init(_ map : any Mapable){
        self.SetUpData = map
        audio = AudioManager.shared
        rowMax = SetUpData.rows
        colMax = SetUpData.columns
    }
    func getZombieSpawnLimit()->Int{
        return SetUpData.getZombieSpawnLimit()
    }
    func blocksView(coord : Coord)->Bool{
        return getTerrainProperties(of : coord).providesConcealment
    }
    func getTerrainProperties(of coord : Coord)->TileData {
       
        
        return terrainBoard[safeNum(r: coord.row)][coord.col]
                            
                            
    }
    
}
