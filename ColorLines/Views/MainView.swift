//
//  MainView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    @StateObject var viewModel = ColorLinesViewModel<Ball>()
    
    var body: some View {
        VStack {
            Text(!viewModel.isGameOver() ? "Score: \(viewModel.gameModel.score)": "Game Over! You score: \(viewModel.gameModel.score)")
                .font(hSizeClass == .regular ? .largeTitle : .title3)
                .foregroundColor(!viewModel.isGameOver() ? .primary : .accentColor)
            Spacer()
            NextFiguresView(figures: viewModel.gameModel.nextFigures)
                .padding()
            GameFieldView(viewModel: viewModel)
            GameButtonsView(viewModel: viewModel)
                .padding(.top, 55)
            Spacer()
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
