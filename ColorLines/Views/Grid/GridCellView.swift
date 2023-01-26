//
//  GridCellView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/17/23.
//

import SwiftUI

struct GridCellView: View {
    var body: some View {
        Rectangle()
            .fill(Color(UIColor.systemBackground))
            .aspectRatio(1, contentMode: .fit)
    }
}

struct GridCellView_Previews: PreviewProvider {
    static var previews: some View {
        GridCellView()
    }
}
