//
//  MainView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = ColorLinesViewModel<Ball>()
    
    var body: some View {
        VStack {
            Text(!viewModel.isGameOver() ? "Score: \(viewModel.gameModel.score)": "Game Over! You score: \(viewModel.gameModel.score)")
                .font(.title)
                .foregroundColor(!viewModel.isGameOver() ? .primary : .accentColor)
            Spacer()
            NextFiguresView(figures: viewModel.gameModel.nextFigures)
            Spacer()
            GameFieldView(viewModel: viewModel)
            Spacer()
            GameButtonsView(viewModel: viewModel)
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
