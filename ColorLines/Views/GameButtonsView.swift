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
    
    var body: some View {
        HStack {
            Button("New Game") {
                withAnimation(.easeInOut(duration: 0.2).repeatCount(2)) {
                    viewModel.startNewGame()
                }
            }
            Spacer()
            Button("Revert Move") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.revertFailedMove()
                }
            }
            .disabled(!viewModel.gameModel.isRevertAllowed || viewModel.isGameOver)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(hSizeClass == .regular ? .large : .regular)
    }
    
}

struct GameButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        GameButtonsView(viewModel: ColorLinesViewModel<Ball>())
    }
}
