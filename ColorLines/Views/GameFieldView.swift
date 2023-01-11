//
//  GameFieldView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct GameFieldView: View {
    @ObservedObject var colorLinesViewModel: ColorLinesViewModel<Ball>
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<colorLinesViewModel.field.count) { row in
                GridRow {
                    ForEach(0..<colorLinesViewModel.field[row].count) { col in
                        if let figure = colorLinesViewModel.field[col][row] {
                            BallView(figure: figure)
                        } else {
                            Color.clear
                        }
                    }
                    .border(.gray, width: 0.5)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .border(.gray, width: 1)
    }
}

struct GameFieldView_Previews: PreviewProvider {
    static var previews: some View {
        GameFieldView(colorLinesViewModel: ColorLinesViewModel<Ball>())
    }
}
