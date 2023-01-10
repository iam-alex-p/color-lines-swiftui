//
//  BallModel.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

let figureColors: [Color] = [.red, .green, .blue, .yellow, .brown, .purple, .cyan]

protocol Figure {
    var color: Color { get set }
}

struct Ball: Figure {
    var color: Color
}
