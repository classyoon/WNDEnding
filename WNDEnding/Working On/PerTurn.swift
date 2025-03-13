//
//  PerTurn.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 1/16/23.
//

import Foundation
extension Board {
    
    func findThisGuy(_ bio : Soul)->Mob? {
        for piece in mobs {
            if piece.value.info.id == bio.id {
                return piece.value
            }
        }
        return nil
    }
    
    func checkForSurvivorsOnBoard()->Bool{
        for piece in playerControlled {
            if findThisGuy(piece)?.info.location == .inMission(true) && findThisGuy(piece)?.team == .player {
                return true
            }
        }
        return false
    }
    func didEveryoneDie()->Bool{
        
        print("Survivor List \(playerControlled.count)")
        for piece in playerControlled {
            print("GUY")
            print("\(piece.name), is located at \(piece.location)")
            if piece.location == .inMission(false) || piece.livingStatus == .alive  {
                print("ALive")
                return false
            }else{
                print("Instead founf \(piece.name), is located at \(String(describing: findThisGuy(piece)?.info.location))")
            }
        }
        return true
    }
    
    func updateGameStatus(){
        if !checkForSurvivorsOnBoard() {
            if didEveryoneDie() {
                chosenOverlay = .ended(.end(.everyoneDied))
            }
            else{
                chosenOverlay = .ended(.end(.escaped))
            }
        }
        else if timer.turnsSinceStart > timer.lengthOfPlay {
            chosenOverlay = .ended(.options(.haveToEscape))
        }
        else{
            chosenOverlay = .onGoing
            missionUnderWay = true
        }
        
    }
    func needToEscape()->Bool{
        return numberOfZombies > 8
    }
    
    
    
    //MARK: Next Turn
    func getTerrainAt(_ coord : Coord)->String{
        
        return terrainBoard[coord.row][coord.col].name
    }
    func killPlayerUnit(_ piece : Soul){
            for player in playerControlled.indices {
                if playerControlled[player].id ==  piece.id {
                    playerControlled[player] = piece
                }
            }
    }
    func checkUnitDeath(_ location: Coord) {
        if let piece = mobs[location] {
            if piece.hp <= 0 {
                piece.info.livingStatus = .dead
                if piece.team == .player {
                    killPlayerUnit(piece.info)
                }
                mobs[location] = nil
            }
            
        }
        updateGameStatus()
    }
    
    func runBehaviorOfAllZombies() {
        for mob in mobs {
            if mob.value.team == .undead {
                executeZombieBehavior(zombie: mob.value)
            }
        }
    }
    func applyTileStatuses(){
        for piece in mobs {
            let shouldHide = getTerrainProperties(of: piece.key).providesConcealment
            mobs[piece.key]!.concealment = shouldHide ? .hidden : .visible
        }
    }
    func checkHPAndRefreshStamina(){
        for piece in mobs {
            checkUnitDeath(piece.key)
            mobs[piece.key]?.energySpent = 0
        }
    }
    func nextTurn(){
        if timer.turnsSinceStart <= timer.lengthOfPlay {
            //audio.playSFX(.nextTurn)
            timer.advanceHour(numberOfZombies, board: self)
            
            let clock = ContinuousClock()
            var start = clock.now
            print("Starting Applying Tiles")
            applyTileStatuses()
            print("Finished in \(clock.now - start)")
            start = clock.now
            print("Starting Zombies")
           runBehaviorOfAllZombies()
            print("Finished in \(clock.now - start)")
            start = clock.now
            print("Starting HP and Stamina")
            checkHPAndRefreshStamina()
            print("Finished in \(clock.now - start)")
            start = clock.now
            deselectUnit()
            updateGameStatus()
        }
        else{
           // audio.playSFX(.noStamina)
#warning("REMEMBER TO TURN THIS BACK ON, THE SOUNDS")
        }
    }
    
}
