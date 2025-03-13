//
//  OutsideHaulStockpile.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 10/6/23.
//

import Foundation
class OutsideHaulStockpile :ObservableObject {
    @Published var foodNew = 0
    @Published var materialNew = 0
    func addFood(_ amount : Int = 1){
        foodNew+=amount
    }
    func addMatter(_ amount : Int = 1){
        materialNew+=amount
    }
    func getFood()->Int{
        return foodNew
    }
    func getMatter()->Int{
        return materialNew
    }
    func reset(){
       foodNew = 0
    materialNew = 0
    }
}
