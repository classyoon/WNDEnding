//
//  ExitOverlayView.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 2/26/23.
//

import SwiftUI
// TODO: Move this to resource pool
struct ExitOverlayView: View {
    @ObservedObject var vm : Board
    @EnvironmentObject var gameData : GameManager

    
   
    var body: some View {
        VStack{
            Text("End Mission : Gathered \(vm.pack.getFood()) rations, \(vm.pack.getMatter()) materials.")
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

struct ExitOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ExitOverlayView(vm: Board())
            .environmentObject(GameManager())
    }
}
