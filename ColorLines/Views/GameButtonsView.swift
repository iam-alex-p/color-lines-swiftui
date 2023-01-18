//
//  GameButtonsView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/17/23.
//

import SwiftUI

struct GameButtonsView: View {
    @ObservedObject var viewModel: ColorLinesViewModel<Ball>
    
    var body: some View {
        HStack {
            Button("New Game") {
                withAnimation(.easeInOut(duration: 0.3).repeatCount(2)) {
                    viewModel.startNewGame()
                }
            }
            Spacer()
            Button("Revert Move") {
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.revertFailedMove()
                }
            }
            .disabled(!viewModel.gameModel.isFailedMove || viewModel.isGameOver())
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

struct GameButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        GameButtonsView(viewModel: ColorLinesViewModel<Ball>())
    }
}
