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
    var minFigureSeq: Int { get }
    var score: Int { get set }
    var isGameOver: Bool { get set }
    
    func startNewGame()
    func moveFigure(from: Point, to: Point) -> Bool
    func changeScore(points: Int)
    func addRandomFigures(qty: Int) -> [Point]
    func removeFigures(cells: [Point])
    func isEmpty(point: Point) -> Bool
}

class ColorLinesViewModel<FigureType: Figure>: Game {
    @Published var field        = [[FigureType?]]()
    @Published var score        = 0
    @Published var isGameOver   = false
    
    var freeCells               = Set<Point>()
    let maxX                    = 9
    let maxY                    = 9
    let newFigureAmt            = 3
    let minFigureSeq            = 5
    
    init() {
        self.startNewGame()
    }
    
    func startNewGame() {
        self.freeCells.removeAll()
        self.isGameOver = false
        self.score = 0
        self.field.removeAll()
        
        for i in 0..<self.maxX {
            self.field.append([])
            for j in 0..<self.maxY {
                self.field[i].append(nil)
                self.freeCells.insert(Point(x: i, y: j))
            }
        }
        self.addRandomFigures(qty: self.newFigureAmt)
    }
    
    func moveFigure(from: Point, to: Point) -> Bool {
        if from == to || self.freeCells.contains(from) || !self.freeCells.contains(to) || !self.checkPath(from: from, to: to) {
            return false
        }
        
        self.field[to.x][to.y] = self.field[from.x][from.y]
        self.field[from.x][from.y] = nil
        
        self.freeCells.remove(to)
        self.freeCells.insert(from)
        
        let lines = reduceFigures(searchPoints: [to]).filter { $0.count >= minFigureSeq }
        
        if lines.isEmpty {
            let points = self.addRandomFigures(qty: self.newFigureAmt)
            
            reduceFigures(searchPoints: points).filter { $0.count >= minFigureSeq }
                .forEach {
                    removeFigures(cells: $0)
                    changeScore(points: $0.count * 2)
                }
            
            self.isGameOver = self.freeCells.isEmpty
        } else {
            lines.forEach {
                removeFigures(cells: $0)
                changeScore(points: $0.count * 2)
            }
        }
        
        return true
    }
    
    func changeScore(points: Int) {
        self.score += points
    }
    
    func addRandomFigures(qty: Int) -> [Point] {
        var points = [Point]()
        let endRange = self.freeCells.count < qty ? freeCells.count : qty
        
        for _ in 0..<endRange {
            if let rndPoint = self.freeCells.randomElement() {
                self.field[rndPoint.x][rndPoint.y] = Ball(color: figureColors.randomElement() ?? .red) as? FigureType
                
                if self.field[rndPoint.x][rndPoint.y] != nil {
                    self.freeCells.remove(rndPoint)
                    points.append(rndPoint)
                }
            }
        }
        return points
    }
    
    func removeFigures(cells: [Point]) {
        cells.forEach {
            self.field[$0.x][$0.y] = nil
            self.freeCells.insert($0)
        }
    }
    
    func isEmpty(point: Point) -> Bool {
        self.freeCells.contains(point)
    }
}

extension ColorLinesViewModel {
    func checkPath(from: Point, to: Point) -> Bool {
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: self.field[0].count), count: self.field.count)
        
        var matrix = self.field
        matrix[from.x][from.y] = nil
        matrix[to.x][to.y] = nil
        
        buildPath(matrix, from.x, from.y, &visited)
        
        return visited[to.x][to.y]
    }
    
    private func buildPath(_ matrix: [[FigureType?]], _ i: Int, _ j: Int, _ visited: inout [[Bool]]) {
        if (i < 0 || i >= maxX || j < 0 || j >= maxY || matrix[i][j] != nil || visited[i][j]) {
            return
        }
        
        visited[i][j] = true
        buildPath(matrix, i-1, j, &visited)
        buildPath(matrix, i+1, j, &visited)
        buildPath(matrix, i, j-1, &visited)
        buildPath(matrix, i, j+1, &visited)
    }
    
    func reduceFigures(searchPoints: [Point]) -> [[Point]] {
        let colors = self.field.map { figures in
            figures.map { figure in
                figure?.color != nil ? figure!.color : nil
            }
        }
        
        var lines = [[Point]]()
        searchPoints.forEach { searchPoint in
            if let searchColor = colors[searchPoint.x][searchPoint.y] {
                findSequences(colors, searchPoint.x, searchPoint.y, searchColor).forEach { points in
                    lines.append(points)
                }
            }
        }
        
        return lines
    }
    
    private func findSequences(_ matrix: [[Color?]], _ i: Int, _ j: Int, _ searchColor: Color) -> [[Point]] {
        var lines = [[Point]]()
        
        let x = [-1, 1, 1, -1, 1, -1, 0, 0]
        let y = [-1, 1, -1, 1, 0, 0, 1, -1]
        
        for dir in 0..<x.count {
            if dir % 2 == 0 {
                lines.append([Point]())
                lines[lines.count-1].append(Point(x: i, y: j))
            }
            
            var rd = i + x[dir]
            var cd = j + y[dir]
            
            repeat {
                if rd >= maxX || rd < 0 || cd >= maxY || cd < 0 {
                    break
                }
                
                guard let mColor = matrix[rd][cd], mColor == searchColor else {
                    break
                }
                
                lines[lines.count-1].append(Point(x: rd, y: cd))
                
                rd += x[dir]
                cd += y[dir]
            } while (rd < maxX || rd > 0 || cd < maxY || cd > 0)
        }
        
        return lines
    }
}
