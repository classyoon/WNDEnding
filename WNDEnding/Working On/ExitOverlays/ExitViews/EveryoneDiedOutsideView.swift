//
//  EveryoneDiedOutsideView.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 10/10/23.
//

import SwiftUI

struct EveryoneDiedOutsideView: View {
    @ObservedObject var vm : Board
    @EnvironmentObject var gameData : GameManager

    private func manyDeadOrOne()->String{
        if Stockpile.shared.getAllRecentDead().count > 1{
            return "bodies"
        }
        else {
            return "body"
        }
    }
    private func manyAliveOrOne()->String{
        if Stockpile.shared.getAllSurvivorsAliveEverywhere().count > 1{
            return "We"
        }
        else {
            return "I"
        }
    }
   
    var body: some View {
        VStack{
            Text("\(manyAliveOrOne()) found the \(manyDeadOrOne()) in the morning")
                .font(.title).foregroundColor(Color.black)
            Button {
                vm.missionUnderWay = false
                ReturnVanManager.shared.unloadVan(vm.pack, board: vm)
                gameData.passDay()
            } label: {
                Text("Back to Camp")
            }.buttonStyle(.borderedProminent)
            
        }.padding()
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

struct EveryoneDiedOutsideView_Previews: PreviewProvider {
    static var previews: some View {
        EveryoneDiedOutsideView(vm: Board())
            .environmentObject(GameManager())
    }
}
