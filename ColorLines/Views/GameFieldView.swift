//
//  GameFieldView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct GameFieldView: View {
    @ObservedObject var viewModel: ColorLinesViewModel<Ball>
    @State private var selection: Point?
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<viewModel.gameModel.field.count) { row in
                GridRow {
                    ForEach(0..<viewModel.gameModel.field[row].count) { col in
                        BallView(figure: viewModel.gameModel.field[col][row], selection: selection, row: row, col: col)
                            .onTapGesture {
                                let selectedPoint = Point(x: col, y: row)
                                
                                if (!viewModel.isEmptyCell(point: selectedPoint)) {
                                    selection = selectedPoint
                                } else {
                                    if let initPoint = selection {
                                        let isMoved = viewModel.moveFigure(from: initPoint, to: Point(x: col, y: row))
                                        if (isMoved) {
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.9, blendDuration: 0.75)) {
                                                viewModel.reduceFigures(from: Point(x: col, y: row))
                                            }
                                            selection = nil
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            .border(.gray, width: 0.5)
        }
        .border(.gray, width: 1)
    }
}

struct GameFieldView_Previews: PreviewProvider {
    static var previews: some View {
        GameFieldView(viewModel: ColorLinesViewModel<Ball>())
    }
}
