//
//  BallView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/10/23.
//

import SwiftUI

struct BallView: View {
    var figure: Ball?
    
    var body: some View {
        Circle()
            .fill(figure != nil ? figure!.color : Color(UIColor.systemBackground))
    }
}

struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        BallView(figure: Ball(color: .green))
    }
}
