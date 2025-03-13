//
//  Mob.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 11/15/23.
//
import SwiftUI
enum TypeMob {
    case player
    case undead
    case neutral
    case item
}
import Foundation
class Mob : Identifiable, ObservableObject, Equatable {
    static func == (lhs: Mob, rhs: Mob) -> Bool {
           return lhs.id == rhs.id
    }
    
    @Published var concealment : Visibility = .visible
    @Published var wanderTrail : [Coord] = []
    @Published var viewRange : Int
    @Published var enemy : [TypeMob] = []
    @Published var inGame : Bool = true
    @Published var energySpent: Int = 0
    @Published var trust = 0
    @Published var attackRange = 1
    
    @Published var hp: Int
    var stamina: Int
    var damage : Int
    var armor: Int = 0
    var talkingAbility: Int
    var defaultImage = ""
    @Published var targetCoord : Coord?
    var info : Soul
    @Published var id = UUID()
    @Published var team : TypeMob
    var vectors: [Vector] = [
        Vector(row: 1, col: 1),
        Vector(row: 1, col: 0),
        Vector(row: 1, col: -1),
        Vector(row: 0, col: 1),
        Vector(row: 0, col: -1),
        Vector(row: -1, col: 1),
        Vector(row: -1, col: 0),
        Vector(row: -1, col: -1)]
    
    func getView()-> Image {
        return Image(defaultImage)
    }
    func hasStamina()->Bool{
        return energySpent < stamina
    }
    func getMoves()-> [Vector]{
        return vectors
    }
    func canAfford(_ extraCost : Int = 0)->Bool{
        
        energySpent+extraCost<=stamina
    }
    func takeTurn(board: Board) {
        
    }
  
    init(team : TypeMob, hp : Int = 10, damage : Int = 0, stamina: Int = 0, speech : Int = 5, info : Soul = Soul(), image : String, viewRange : Int = 0, enemy : [TypeMob] = []) {
        self.hp = hp
        
        self.stamina = stamina
        self.damage = damage
       
        self.talkingAbility = speech
        
        self.info = info
        self.team = team
        self.defaultImage = image
        self.viewRange = viewRange
        self.enemy = enemy
    }
    
    init(team : TypeMob = .item, hp: Int = 0, damage : Int = 0, image : String = "SurvivorW"){
        self.hp = hp
        
        self.stamina = 0
        self.damage = damage
       
        self.talkingAbility = 0
        
        self.info = Soul()
        self.team = team
        self.defaultImage = image
        self.viewRange = 0
    }
}
