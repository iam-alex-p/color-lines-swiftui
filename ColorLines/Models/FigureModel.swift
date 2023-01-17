//
//  BallModel.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

let figureColors: [Color] = [.green, .red, .blue, .yellow, .brown, .purple, .mint]

protocol Figure {
    var color: Color { get }
}

struct Ball: Figure {
    let color: Color
}
