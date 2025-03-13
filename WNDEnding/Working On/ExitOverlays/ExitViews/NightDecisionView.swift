//
//  NightDecisionView.swift
//  WeNeverDie
//
//  Created by Conner Yoon on 3/12/23.
//

import SwiftUI

struct NightDecisionView: View {
    let resultCalculator : NightResultCalculator
    @ObservedObject var vm : Board
    @EnvironmentObject var gameData : GameManager
    @ObservedObject var stockpile = Stockpile.shared
    var body: some View {
        VStack{
            Text("You have to get home now. \(resultCalculator.zombieCount) zombies nearby.")
            HStack{
                vm.pack.getFood() >= resultCalculator.results.costOfSafeOption ? Button("Distract with \(resultCalculator.results.costOfSafeOption)") {
                    
                    vm.pack.addFood(-resultCalculator.results.costOfSafeOption)
                    vm.audio.playSFX(.transition)
                    vm.chosenOverlay = .ended(.result(.distract))
                } : Button("Unable to distract. Cost : \(resultCalculator.results.costOfSafeOption)"){}
                Button("Run"){
                    // code for the risky option
                    let randomNumber = Double.random(in: 0...1)
                    if randomNumber < resultCalculator.results.chanceOfFailure {
                        vm.audio.playSFX(.badResult)
                        vm.chosenOverlay = .ended(.result(.eaten))
                    }
                    else {
                        vm.audio.playSFX(.transition)
                        vm.chosenOverlay = .ended(.result(.run))
                    }
                    
                }.buttonStyle(.bordered)
            }
            
        }.frame(width: 300, height: 300)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thickMaterial)
            )
    }
    
}


struct NighttimeExitDecisonView_Previews: PreviewProvider {
    static var previews: some View {
        NightDecisionView(resultCalculator: NightResultCalculator(zombieCount: 10), vm: Board())
            .environmentObject(GameManager())
    }
}
