//
//  ColorLinesViewModel.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

struct Point: Hashable {
    let x: Int
    let y: Int
}

protocol Game: ObservableObject {
    associatedtype FigureType: Figure
    
    var field: [[FigureType?]] { get set }
    var freeCells: Set<Point> { get set }
    var maxX: Int { get }
    var maxY: Int { get }
    var newFigureAmt: Int { get }
    var score: Int { get set }
    
    func startNewGame()
    func moveFigure(from: Point, to: Point) -> Bool
    func changeScore(points: Int)
    func addRandomFigures(qty: Int)
    func removeFigures(cells: [Point])
}

class ColorLinesViewModel<FigureType: Figure>: Game {
    @Published var field        = [[FigureType?]]()
    @Published var score: Int   = 0
    
    var freeCells               = Set<Point>()
    let maxX                    = 9
    let maxY                    = 9
    let newFigureAmt            = 3
    
    init() {
        self.startNewGame()
    }
    
    func startNewGame() {
        self.freeCells.removeAll()
        self.score = 0
        self.field.removeAll()
        
        for i in 0..<self.maxX {
            self.field.append([])
            for j in 0..<self.maxY {
                self.field[i].append(nil)
                self.freeCells.insert(Point(x: j, y: i))
            }
        }
        addRandomFigures(qty: self.newFigureAmt)
    }
    
    func moveFigure(from: Point, to: Point) -> Bool {
        if from == to || !self.freeCells.contains(to) {
            return false
        }
        
        // TODO implement finding paths logic
        return true
    }
    
    func changeScore(points: Int) {
        // TODO Implement score changing
    }
    
    func addRandomFigures(qty: Int) {
        let endRange = self.freeCells.count < qty ? freeCells.count : qty
        
        for _ in 0..<endRange {
            if let rndPoint = self.freeCells.randomElement() {
                self.field[rndPoint.y][rndPoint.x] = Ball(color: figureColors.randomElement() ?? .red) as? FigureType
                
                if self.field[rndPoint.y][rndPoint.x] != nil {
                    self.freeCells.remove(rndPoint)
                }
            }
        }
    }
    
    func removeFigures(cells: [Point]) {
        cells.forEach {
            self.field[$0.y][$0.x] = nil
            self.freeCells.insert($0)
        }
    }
}
