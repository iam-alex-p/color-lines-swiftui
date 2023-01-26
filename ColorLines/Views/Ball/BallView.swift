//
//  BallView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/10/23.
//

import SwiftUI

struct BallView: View {
    var figure: Ball?
    var selection: Point?
    var row: Int = 0
    var col: Int = 0
    
    var body: some View {        
        ZStack {
            GridCellView()
            
            Circle()
                .fill(isSelected ? figureColor.opacity(0.9) : figureColor)
                .aspectRatio(isSelected ? 0.75 : 0.88, contentMode: .fit)
                .animation(.linear, value: isSelected ? 0.1 : 0)
        }
    }
}

struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        BallView(row: 0, col: 0)
    }
}

extension BallView {
    var isSelected: Bool {
        selection?.x == col && selection?.y == row
    }
    var figureColor: Color {
        figure?.color ?? Color(UIColor.systemBackground)
    }
}
