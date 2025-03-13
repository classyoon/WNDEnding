//
//  PlayerMob.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 11/16/23.
//

import Foundation
class PlayerMob : Mob {
  
    init(damage : Int = 2, stamina : Int = 2, survivor : Soul = SurvivorGenerator().generateBio() ) {
        super.init(team: .player, damage: damage, stamina: stamina, info: survivor, image: "SurvivorY", enemy: [.undead])
    }
}
