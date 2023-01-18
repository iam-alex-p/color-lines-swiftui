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
        let ballColor = figure != nil ? figure!.color : Color(UIColor.systemBackground)
        let aspectRatioSelected: CGFloat = 0.75
        let aspectRatio: CGFloat = 0.88
        
        if let selection {
            if (selection.x == col && selection.y == row) {
                Circle()
                    .fill(ballColor)
                    .aspectRatio(aspectRatioSelected, contentMode: .fit)
            } else {
                Circle()
                    .fill(ballColor)
                    .aspectRatio(aspectRatio, contentMode: .fit)
            }
        } else {
            Circle()
                .fill(ballColor)
                .aspectRatio(aspectRatio, contentMode: .fit)
        }
    }
}

struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        BallView(row: 0, col: 0)
    }
}
