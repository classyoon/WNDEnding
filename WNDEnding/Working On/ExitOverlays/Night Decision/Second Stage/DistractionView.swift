//
//  DistractionView.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 5/8/23.
//

import SwiftUI

struct DistractionView: View {
    @ObservedObject var vm : OutsideHaulStockpile
    @EnvironmentObject var gameData : GameManager
    @ObservedObject var stockpile = Stockpile.shared
    var body: some View {
        VStack{
            Text(stockpile.getSurvivorSent() > 1 ? "You set up a little piece of bait with your \(returnDescriptor())food. You made it with \(vm.getFood()) pieces of food." : "Y'all sprinted and y'all made it back with \(vm.getFood()) pieces of food")
                .font(.title).foregroundColor(Color.black)
            Button {
               
                ReturnVanManager.shared.unloadVan(vm, board: gameData.board)
                gameData.passDay()
               
            } label: {
                Text("Return to Camp")
            }.buttonStyle(.borderedProminent)
            
        }.padding()
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
    func returnDescriptor() -> String{
        let totalNumOfSurvivors = stockpile.getAllSurvivorsAliveEverywhere().count


        
        if (stockpile.getNumOfFood()+vm.getFood()) - (totalNumOfSurvivors) >= totalNumOfSurvivors{
            return " precious "
        }
        return ""
    }
}

struct DistractionView_Previews: PreviewProvider {
    static var previews: some View {
        DistractionView( vm : OutsideHaulStockpile())
            .environmentObject(GameManager())
    }
}
