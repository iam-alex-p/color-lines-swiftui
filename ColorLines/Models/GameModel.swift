//
//  GameModel.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/17/23.
//

import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct GameModel<FigureType: Figure> {
    var field           = [[FigureType?]]()
    var score           = 0
    var nextFigures     = [FigureType]()
    var isRevertAllowed = false
    var isGameOver      = false
    
    let fieldSize       = 9
    let newFigureAmt    = 3
    let minFigureSeq    = 5
    
    var moveComment     = ""
    
    var freeCells: [Point] {
        self.field.enumerated().map {
            top in top.element.enumerated()
                .filter { $0.element == nil }
            .map { Point(x: top.offset, y: $0.offset) } }
        .filter { $0.count > 0 }
        .flatMap { $0 }
    }
}
