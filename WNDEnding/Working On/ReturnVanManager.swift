//
//  ReturnVanManager.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 10/5/23.
//

import Foundation
/*
 Takes stuff from board to camp, and camp to board
 */
class ReturnVanManager{
    static let shared = ReturnVanManager()
    func unloadVan(_ vm : OutsideHaulStockpile, board : Board){

        if board.chosenOverlay != .ended(.end(.everyoneDied)){
            print("Adding resources")
            Stockpile.shared.stockpileData.foodStored += vm.getFood()
            Stockpile.shared.stockpileData.buildingResources += vm.getMatter()
        }
        returnHome(vm: board)
        Stockpile.shared.selfSave()
    }
    
    /*
     The goal is to appened any new people to the survivor roster and to update any old people. You have an array from board called Player Controlled. Then you have pieces from the Roster of Survivors.
     */
    func returnHome(vm:Board) {
        var list = Stockpile.shared.getRosterOfSurvivors()//Gets original list
        print("Here is where people were before returnHome was called.")
        SurvivorDirector.shared.printSurvivorsAndLocations()
        for var survivor in vm.playerControlled {//Goes through everyone that went into board.
            survivor.location = .inCamp
            if let index = list.firstIndex(where: { $0.id == survivor.id }) {//Locates and updates those already in the original list.
                list[index] = survivor
            } else {
                list.append(survivor)
            }
        }
        Stockpile.shared.setSurvivorRoster(newList: list)
        // Next day will properly process the graves
    }
    
    private func killLastPerson(vm : Board){
        var stragglers = [Soul]()
        for survivor in vm.playerControlled {
            if survivor.location == .inMission(true) {
                stragglers.append(survivor)
            }
        }
        stragglers[Int.random(in: 0...stragglers.count)].livingStatus = .dead
    }
}
class ReturningManager {
    
}
class EndingTransformer {
    
}
