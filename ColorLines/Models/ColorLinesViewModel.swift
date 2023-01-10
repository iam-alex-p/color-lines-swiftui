//
//  ColorLinesViewModel.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import Foundation

protocol Game: ObservableObject {
    typealias Point = (x: Int, y: Int)
    
    var field: [[Ball?]] { get set }
    var maxX: Int { get }
    var maxY: Int { get }
    var newFigureAmt: Int { get }
    var score: Int { get set }
    
    func startNewGame()
    func moveFigure(from: Point, to: Point) -> Bool
    func changeScore(points: Int)
    func addRandomFigures(qty: Int)
    func removeFigures(figures: [Point])
}

class ColorLinesViewModel: Game {
    @Published var field        = [[Ball?]]()
    @Published var score: Int   = 0
    
    let maxX                    = 9
    let maxY                    = 9
    let newFigureAmt            = 3
    
    func startNewGame() {
        // TODO implement game initialization
    }
    
    func moveFigure(from: Point, to: Point) -> Bool {
        // TODO implement moving logic
        true
    }
    
    func changeScore(points: Int) {
        // TODO implement scoring logic
    }
    
    func addRandomFigures(qty: Int) {
        
    }
    
    func removeFigures(figures: [Point]) {
        
    }
}
