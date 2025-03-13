//
//  NameTag.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 9/28/23.
//

import Foundation
struct Soul : Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: Soul, rhs: Soul) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID()
    var childhood : String = ""
    var currentOccupation : String = ""
    var daysAlive : Int = 0
    var firstName : String = ""
    var lastName : String = ""
    
    var conscriptable : Bool = true
    
    var health : Int = 10
    var stamina : Int = 2
    var workProfficency : Int = 1
    
    var name : String {
        firstName + " " + lastName
    }
    
    var location : Place = .inCamp
    var familiarity : Familiarity = .familiar
    var livingStatus :LifeStatus  = .alive
    var sex : Sex = .unknown
}
enum Familiarity : Codable, Hashable {
    case newbie, familiar, stranger
}

enum LifeStatus : Codable, Hashable {
    case dead, alive
}
enum Place : Codable, Hashable {
    case inCamp, inVan, inMission(Bool), inBuilding(BuildingID), inGrave
}
enum Sex : Codable {
    case male, female, unknown
}
//ADDED
enum BuildingID : CaseIterable, Codable, Hashable {
    case farm
    case mine
    case cure
    case noneFound
    case upgrade
    case lab
    case nursery
    case upgrade2
    case attackUpgrade
    case buildUpgrade
    case attackUpgrade2
}
