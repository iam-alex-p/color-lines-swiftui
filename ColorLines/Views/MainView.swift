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
            Text("Score: \(colorLinesViewModel.score)")
            Spacer()
            GameFieldView(colorLinesViewModel: colorLinesViewModel)
            Spacer()
            Button("New Game") {
                colorLinesViewModel.startNewGame()
            }
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
