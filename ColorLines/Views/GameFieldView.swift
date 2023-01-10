//
//  GameFieldView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct GameFieldView: View {
    @ObservedObject var colorLinesViewModel: ColorLinesViewModel
    
    var body: some View {
        Grid {
            ForEach(0..<colorLinesViewModel.field.count) { row in
                GridRow {
                    ForEach(0..<colorLinesViewModel.field[0].count) { col in
                        
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .border(.black, width: 1)
    }
}

struct GameFieldView_Previews: PreviewProvider {
    static var previews: some View {
        GameFieldView(colorLinesViewModel: ColorLinesViewModel())
    }
}
