//
//  ContentView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var colorLinesViewModel = ColorLinesViewModel<Ball>()
    
    var body: some View {
        VStack {
            Text(!colorLinesViewModel.isGameOver ? "Score: \(colorLinesViewModel.score)": "Game Over! You score: \(colorLinesViewModel.score)")
                .font(.title)
                .foregroundColor(!colorLinesViewModel.isGameOver ? .primary : .accentColor)
            Spacer()
            GameFieldView(colorLinesViewModel: colorLinesViewModel)
            Spacer()
            Button("New Game") {
                colorLinesViewModel.startNewGame()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
