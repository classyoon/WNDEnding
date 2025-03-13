//
//  NightExitView.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 3/12/23.
//

import SwiftUI

struct NightExitView: View {
    var pack : OutsideHaulStockpile
    var gameData : GameManager
    var presentChoices = false//Present user with two
    @ObservedObject var stockpile = Stockpile.shared
    
    private func getTotalFood()->Int{
        return stockpile.getNumOfFood()-stockpile.getRosterOfSurvivors().count+pack.getFood()
    }
    var body: some View {
        VStack{
            Text("We survived the night. Let's not do that again. We gathered \(pack.getFood()) rations. That should leave us with \(getTotalFood()) rations")
                    .font(.title).foregroundColor(Color.black)
                Button {
                   
                    ReturnVanManager.shared.unloadVan(pack, board: gameData.board)
                    gameData.passDay()
                } label: {
                    Text("Back to Camp")
                }.buttonStyle(.borderedProminent)
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
 
        }
    }
}

struct NightExitView_Previews: PreviewProvider {
    static var previews: some View {
        NightExitView(pack: OutsideHaulStockpile(), gameData: GameManager())
    }
}
