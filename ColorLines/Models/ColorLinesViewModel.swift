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
    func increaseScore(points: Int)
    func generateRandomFigures(qty: Int)
    func revertFailedMove()
    func addRandomFigures(qty: Int) -> [Point]
    func removeFigures(points: [Point])
    func isEmptyCell(point: Point) -> Bool
    var isGameOver: Bool { get set }
}

class ColorLinesViewModel<FigureType: Figure>: Game {
    @Published private(set) var gameModel = GameModel<FigureType>()
    var prevGameModel: GameModel<FigureType> = GameModel<FigureType>()
    
    init() {
        self.startNewGame()
    }
    
    func startNewGame() {
        gameModel = GameModel<FigureType>()
        prevGameModel = gameModel
        
        gameModel.field = [[FigureType?]](repeating: [FigureType?](repeating: nil, count: gameModel.fieldSize), count: gameModel.fieldSize)
        
        self.generateRandomFigures(qty: gameModel.newFigureAmt)
        self.addRandomFigures(qty: gameModel.newFigureAmt)
        self.generateRandomFigures(qty: gameModel.newFigureAmt)
        
        gameModel.moveComment = MoveComments.startGame.randomElement()!
        SoundManager.play(.startGame)
    }
    
    func moveFigure(from: Point, to: Point) -> Bool {
        if !self.checkPath(from: from, to: to) {
            SoundManager.play(.failedMove)
            return false
        }
        
        SoundManager.play(.successfulMove)
        
        prevGameModel = gameModel
        
        gameModel.field[to.x][to.y] = gameModel.field[from.x][from.y]
        gameModel.field[from.x][from.y] = nil
        return true
    }
    
    func reduceFigures(from: Point) {
        var lines = buildReduceLines(searchPoints: [from]).filter { $0.count >= gameModel.minFigureSeq }
        
        if lines.isEmpty {
            gameModel.isRevertAllowed = true
            lines = buildReduceLines(searchPoints: self.addRandomFigures(qty: gameModel.newFigureAmt)).filter { $0.count >= gameModel.minFigureSeq }
            
            if lines.isEmpty && isGameOver {
                SoundManager.play(.gameOver)
                gameModel.moveComment = MoveComments.gameOver.randomElement()!
            } else {
                gameModel.moveComment = MoveComments.missedMoves.randomElement()!
            }
            
            self.generateRandomFigures(qty: gameModel.newFigureAmt)
        } else {
            SoundManager.play(.ballReduced)
            gameModel.isRevertAllowed = false
        }
        
        lines.forEach {
            removeFigures(points: $0)
            let points = rewardFormula(lineLength: $0.count)
            increaseScore(points: points)
            
            gameModel.moveComment = String(format: MoveComments.successfulMoves.randomElement()!, String($0.count), String(points))
        }
    }
    
    func increaseScore(points: Int) {
        gameModel.score += points
    }
    
    func generateRandomFigures(qty: Int) {
        gameModel.nextFigures.removeAll()
        for _ in 0..<qty {
            gameModel.nextFigures.append(Ball(color: figureColors.randomElement() ?? .red) as! FigureType)
        }
    }
    
    func revertFailedMove() {
        SoundManager.play(.revertMove)
        gameModel = prevGameModel
        self.generateRandomFigures(qty: gameModel.newFigureAmt)
        gameModel.isRevertAllowed = false
        gameModel.moveComment = MoveComments.revertedMoves.randomElement()!
    }
    
    func addRandomFigures(qty: Int) -> [Point] {
        var points = [Point]()
        let endRange = gameModel.freeCells.count < qty ? gameModel.freeCells.count : qty
        
        for i in 0..<endRange {
            if let rndPoint = gameModel.freeCells.randomElement() {
                gameModel.field[rndPoint.x][rndPoint.y] = gameModel.nextFigures[i]
                
                if gameModel.field[rndPoint.x][rndPoint.y] != nil {
                    points.append(rndPoint)
                }
            }
        }
        return points
    }
    
    func removeFigures(points: [Point]) {
        points.forEach {
            gameModel.field[$0.x][$0.y] = nil
        }
    }
    
    func isEmptyCell(point: Point) -> Bool {
        gameModel.freeCells.contains(point)
    }
    
    var isGameOver: Bool {
        get {
            gameModel.freeCells.isEmpty
        }
        set {
            gameModel.isGameOver = newValue
        }
    }
}

private extension ColorLinesViewModel {
    func rewardFormula(lineLength: Int) -> Int {
        (lineLength - gameModel.minFigureSeq + 1) * lineLength
    }
    
    func checkPath(from: Point, to: Point) -> Bool {
        if from == to || gameModel.freeCells.contains(from) || !gameModel.freeCells.contains(to) {
            return false
        }
        
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: gameModel.field[0].count), count: gameModel.field.count)
        
        var matrix = gameModel.field
        matrix[from.x][from.y] = nil
        matrix[to.x][to.y] = nil
        
        buildPath(matrix, from.x, from.y, &visited)
        
        return visited[to.x][to.y]
    }
    
    func buildPath(_ matrix: [[FigureType?]], _ i: Int, _ j: Int, _ visited: inout [[Bool]]) {
        if (i < 0 || i >= gameModel.fieldSize || j < 0 || j >= gameModel.fieldSize || matrix[i][j] != nil || visited[i][j]) {
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
    
    func findSequences(_ matrix: [[Color?]], _ i: Int, _ j: Int, _ searchColor: Color) -> [[Point]] {
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
                if rd >= gameModel.fieldSize || rd < 0 || cd >= gameModel.fieldSize || cd < 0 {
                    break
                }
                
                guard let color = matrix[rd][cd], color == searchColor else {
                    break
                }
                
                lines[lines.count-1].append(Point(x: rd, y: cd))
                
                rd += x[dir]
                cd += y[dir]
            } while (rd < gameModel.fieldSize || rd > 0 || cd < gameModel.fieldSize || cd > 0)
        }
        
        return lines
    }
}
