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
    var prevFieldState  = [[FigureType?]]()
    var freeCells       = Set<Point>()
    var prevFreeCells   = Set<Point>()
    var score           = 0
    var nextFigures     = [FigureType?]()
    var isFailedMove    = false
    var isGameOver      = false
    
    let maxX            = 9
    let maxY            = 9
    let newFigureAmt    = 3
    let minFigureSeq    = 5
}
