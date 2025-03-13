//
//  OutsideView.swift
//  BoardGame
//
//  Created by Tim Yoon on 11/27/22.
//
import AVFoundation
import SwiftUI



struct OutsideView: View {
    @StateObject var vm : Board
    @EnvironmentObject var gameData : GameManager
    @EnvironmentObject var uiSettings : UserSettingsManager
    
    var body: some View {
        NavigationStack {
            HStack {
                if uiSettings.isLeft() {
                    StatusViewBar(vm: vm)
                }
                BoardView(vm: gameData.board)
                    .overlay {
                       overlayView()
                    }
                if !uiSettings.isLeft() {
                    StatusViewBar(vm: vm)
                }
            }
            .background(Color.black)
        }
    }
    private func overlayView() -> some View {
        switch vm.chosenOverlay {
        case .onGoing:
            return AnyView(EmptyView())
        case .ended(let ending):
            switch ending {
            case .end(let end):
                switch end {
                case .escaped :
                    return AnyView(ExitOverlayView(vm: vm))
                case .everyoneDied :
                    return AnyView(EveryoneDiedOutsideView(vm: vm))
                }
            case .options(let specialEnding):
                switch specialEnding {
                case .haveToEscape :
                    if vm.needToEscape() {
                        return AnyView(NightDecisionView(resultCalculator: NightResultCalculator(zombieCount: vm.numberOfZombies), vm: vm))
                    } else {
                        return AnyView(ExitOverlayView(vm: vm))
                    }
                }
            case .result(let result):
                switch result {
                case .distract :
                    return AnyView(DistractionView(vm: vm.pack))
                case .run :
                    return AnyView(EscapedScene(vm: vm.pack))
                case .eaten :
                    return AnyView(BadResultView(vm: vm, pack: vm.pack))
                }
            }
        }
    }

}

struct OutsideView_Previews: PreviewProvider {
    static var previews: some View {
        OutsideView(vm: Board())
            .environmentObject(UserSettingsManager.shared)
            .environmentObject(GameManager())
    }
}
