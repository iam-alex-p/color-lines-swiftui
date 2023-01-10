//
//  ContentView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var colorLinesViewModel = ColorLinesViewModel()
    
    var body: some View {
        VStack {
            Text("Score: \(colorLinesViewModel.score)")
            GameFieldView(colorLinesViewModel: colorLinesViewModel)
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
