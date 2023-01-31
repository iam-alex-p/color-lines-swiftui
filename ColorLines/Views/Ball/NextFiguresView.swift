//
//  NextFiguresView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/17/23.
//

import SwiftUI

struct NextFiguresView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    var figures: [Ball?]
    
    var body: some View {
        Grid {
            GridRow {
                ForEach(0..<figures.count) {
                    BallView(figure: figures[$0])
                }
            }
        }
        .aspectRatio(hSizeClass == .regular ? 0.3 : 0.4, contentMode: .fit)
    }
}

struct NextFiguresView_Previews: PreviewProvider {
    private static let figures = [Ball](arrayLiteral:
                                            Ball(color: .red),
                                        Ball(color: .yellow),
                                        Ball(color: .green)
    )
    static var previews: some View {
        NextFiguresView(figures: figures)
    }
}
