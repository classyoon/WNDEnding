//
//  NightResultsCalculator.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 3/13/23.
//

import Foundation
struct NightResult {
    var costOfSafeOption : Int
    var chanceOfFailure : Double
}
struct NightResultCalculator {
    var zombieCount : Int
    var results : NightResult {
        switch zombieCount {
            case 0...3:
            return NightResult(costOfSafeOption: 0, chanceOfFailure: 0.0)
            case 4...7:
            return NightResult(costOfSafeOption: 3, chanceOfFailure: 0.10)
            case 8...10:
            return NightResult(costOfSafeOption: 5, chanceOfFailure: 0.40)
            default:
            return NightResult(costOfSafeOption: 7, chanceOfFailure: 0.80)
        }
    }
    func getResult()->Bool{
        let randomNumber = Double.random(in: 0...1)
        return randomNumber < results.chanceOfFailure
    }
}
