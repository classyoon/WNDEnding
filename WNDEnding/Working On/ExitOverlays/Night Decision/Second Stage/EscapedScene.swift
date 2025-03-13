//
//  EscapedScene.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 3/19/23.
//

import SwiftUI


struct EscapedScene: View {
    @ObservedObject var vm : OutsideHaulStockpile
    @EnvironmentObject var gameData : GameManager
    @ObservedObject var stockpile = Stockpile.shared
    var body: some View {
        VStack{
            Text(stockpile.getSurvivorSent() > 1 ? "You sprinted as fast as you could, hopping inside your van and slamming the accelerator. You made it with \(vm.getFood()) pieces of food." : "Y'all sprinted and y'all made it back with \(vm.getFood()) pieces of food")
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
}

struct ResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        EscapedScene(vm: OutsideHaulStockpile())
            .environmentObject(GameManager())
    }
}

