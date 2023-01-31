//
//  GameButtonsView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/17/23.
//

import SwiftUI

struct GameButtonsView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    @ObservedObject var viewModel: ColorLinesViewModel<Ball>
    @State private var isShowRecords = false
    @State private var isNewGameConfirmationPresenting = false
    
    var body: some View {
        HStack {
            Spacer()
            Button(role: .none) {
                isNewGameConfirmationPresenting.toggle()
            } label: {
                Image(systemName: "play.circle.fill")
            }
            .confirmationDialog("Start a New Game?", isPresented: $isNewGameConfirmationPresenting) {
                Button("Start a New Game?", role: .none) {
                    withAnimation(.easeInOut(duration: 0.3).repeatCount(5)) {
                        SoundManager.play(.startGame)
                        viewModel.startNewGame()
                    }
                }
            }
            Spacer()
            Button {
                SoundManager.play(.showRecords)
                isShowRecords.toggle()
            } label: {
                Image(systemName: "list.bullet.circle.fill")
            }
            .sheet(isPresented: $isShowRecords, onDismiss: { SoundManager.play(.hideRecords) }) {
                RecordsSheetView()
            }
            Spacer()
            
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.revertFailedMove()
                }
            } label: {
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
            }
            .disabled(!viewModel.gameModel.isRevertAllowed || viewModel.isGameOver)
            Spacer()
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(5)
        .controlSize(hSizeClass == .regular ? .large : .regular)
    }
}

struct GameButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        GameButtonsView(viewModel: ColorLinesViewModel<Ball>())
    }
}
