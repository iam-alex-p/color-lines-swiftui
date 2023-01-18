//
//  ColorLinesViewModel.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

protocol Game: ObservableObject {
    associatedtype FigureType: Figure
    
    func startNewGame()
    func moveFigure(from: Point, to: Point) -> Bool
    func reduceFigures(from: Point)
    func changeScore(points: Int)
    func generateRandomFigures(qty: Int)
    func revertFailedMove()
    func addRandomFigures(qty: Int) -> [Point]
    func removeFigures(cells: [Point])
    func isEmptyCell(point: Point) -> Bool
    func isGameOver() -> Bool
}

class ColorLinesViewModel<FigureType: Figure>: Game {
    @Published private(set) var gameModel = GameModel<FigureType>()
    
    init() {
        self.startNewGame()
    }
    
    func startNewGame() {
        gameModel = GameModel<FigureType>()
        
        for i in 0..<gameModel.maxX {
            gameModel.field.append([])
            for j in 0..<gameModel.maxY {
                gameModel.field[i].append(nil)
                gameModel.freeCells.insert(Point(x: i, y: j))
            }
        }
        
        self.generateRandomFigures(qty: gameModel.newFigureAmt)
        self.addRandomFigures(qty: gameModel.newFigureAmt)
        self.generateRandomFigures(qty: gameModel.newFigureAmt)
    }
    
    func moveFigure(from: Point, to: Point) -> Bool {
        if from == to || gameModel.freeCells.contains(from) || !gameModel.freeCells.contains(to) || !self.checkPath(from: from, to: to) {
            return false
        }
        
        gameModel.prevFieldState = gameModel.field
        gameModel.prevFreeCells = gameModel.freeCells
        
        gameModel.field[to.x][to.y] = gameModel.field[from.x][from.y]
        gameModel.field[from.x][from.y] = nil
        
        gameModel.freeCells.remove(to)
        gameModel.freeCells.insert(from)
        return true
    }
    
    func reduceFigures(from: Point) {
        var lines = buildReduceLines(searchPoints: [from]).filter { $0.count >= gameModel.minFigureSeq }
        
        if lines.isEmpty {
            gameModel.isFailedMove = true
            lines = buildReduceLines(searchPoints: self.addRandomFigures(qty: gameModel.newFigureAmt)).filter { $0.count >= gameModel.minFigureSeq }
            
            gameModel.isGameOver = gameModel.freeCells.isEmpty
            self.generateRandomFigures(qty: gameModel.newFigureAmt)
        } else {
            gameModel.isFailedMove = false
        }
        
        lines.forEach {
            removeFigures(cells: $0)
            changeScore(points: $0.count * 2)
        }
    }
    
    func changeScore(points: Int) {
        gameModel.score += points
    }
    
    func generateRandomFigures(qty: Int) {
        gameModel.nextFigures.removeAll()
        for _ in 0..<qty {
            gameModel.nextFigures.append(Ball(color: figureColors.randomElement() ?? .red) as? FigureType)
        }
    }
    
    func revertFailedMove() {
        gameModel.field = gameModel.prevFieldState
        gameModel.freeCells = gameModel.prevFreeCells
        
        self.generateRandomFigures(qty: gameModel.newFigureAmt)
        gameModel.isFailedMove.toggle()
    }
    
    func addRandomFigures(qty: Int) -> [Point] {
        var points = [Point]()
        let endRange = gameModel.freeCells.count < qty ? gameModel.freeCells.count : qty
        
        for i in 0..<endRange {
            if let rndPoint = gameModel.freeCells.randomElement() {
                gameModel.field[rndPoint.x][rndPoint.y] = gameModel.nextFigures[i]
                
                if gameModel.field[rndPoint.x][rndPoint.y] != nil {
                    gameModel.freeCells.remove(rndPoint)
                    points.append(rndPoint)
                }
            }
        }
        return points
    }
    
    func removeFigures(cells: [Point]) {
        cells.forEach {
            gameModel.field[$0.x][$0.y] = nil
            gameModel.freeCells.insert($0)
        }
    }
    
    func isEmptyCell(point: Point) -> Bool {
        gameModel.freeCells.contains(point)
    }
    
    func isGameOver() -> Bool {
        gameModel.freeCells.isEmpty
    }
}

extension ColorLinesViewModel {
    func checkPath(from: Point, to: Point) -> Bool {
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: gameModel.field[0].count), count: gameModel.field.count)
        
        var matrix = gameModel.field
        matrix[from.x][from.y] = nil
        matrix[to.x][to.y] = nil
        
        buildPath(matrix, from.x, from.y, &visited)
        
        return visited[to.x][to.y]
    }
    
    private func buildPath(_ matrix: [[FigureType?]], _ i: Int, _ j: Int, _ visited: inout [[Bool]]) {
        if (i < 0 || i >= gameModel.maxX || j < 0 || j >= gameModel.maxY || matrix[i][j] != nil || visited[i][j]) {
            return
        }
        
        visited[i][j] = true
        buildPath(matrix, i-1, j, &visited)
        buildPath(matrix, i+1, j, &visited)
        buildPath(matrix, i, j-1, &visited)
        buildPath(matrix, i, j+1, &visited)
    }
    
    func buildReduceLines(searchPoints: [Point]) -> [[Point]] {
        let colors = gameModel.field.map { figures in
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
                if rd >= gameModel.maxX || rd < 0 || cd >= gameModel.maxY || cd < 0 {
                    break
                }
                
                guard let mColor = matrix[rd][cd], mColor == searchColor else {
                    break
                }
                
                lines[lines.count-1].append(Point(x: rd, y: cd))
                
                rd += x[dir]
                cd += y[dir]
            } while (rd < gameModel.maxX || rd > 0 || cd < gameModel.maxY || cd > 0)
        }
        
        return lines
    }
}
