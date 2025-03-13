//
//  BadResultView.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 5/8/23.
//

import SwiftUI

struct BadResultView: View {
    @ObservedObject var vm : Board
    @ObservedObject var pack : OutsideHaulStockpile
    @EnvironmentObject var gameData : GameManager
    @ObservedObject var stockpile = Stockpile.shared
    var body: some View {
        VStack{
            Text(stockpile.getRosterOfSurvivors().count != 1 ? "End Mission : Gathered \(pack.getFood()) pieces of food. Gathered \(pack.getMatter()) pieces of material. Someone didn't make it though." : "It was agony...\nYou didn't make it...")
                .font(.title).foregroundColor(Color.black)
            Button {
               
                ReturnVanManager.shared.unloadVan(pack, board: vm)
                gameData.passDay()
            } label: {
                Text(stockpile.lastSurvivor() ? "Perish" : "Move on" )
            }.buttonStyle(.borderedProminent)
            
        }.padding()
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

struct BadResultView_Previews: PreviewProvider {
    static var previews: some View {
        BadResultView(vm: Board(), pack: OutsideHaulStockpile())
            .environmentObject(GameManager())
    }
}
