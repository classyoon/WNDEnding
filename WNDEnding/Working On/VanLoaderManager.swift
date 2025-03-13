//
//  VanLoaderManager.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 10/5/23.
//

import Foundation
struct VanLoaderManager{
    static let shared = VanLoaderManager()
    var stockManager = Stockpile.shared
    func transportSurvivorsOnVan() -> [Soul] {
        var list : [Soul] = []
        let survivors = Stockpile.shared.getRosterOfSurvivors()
        for survivor in survivors {
            if survivor.location == .inVan {
                Stockpile.shared.send(Stockpile.shared.stockpileData.rosterOfSurvivors[Stockpile.shared.getSurvivorIndex(id: survivor.id)], to: .inMission(true))
                list.append(Stockpile.shared.stockpileData.rosterOfSurvivors[Stockpile.shared.getSurvivorIndex(id: survivor.id)])
            }
          
        }
        return list
    }
}
