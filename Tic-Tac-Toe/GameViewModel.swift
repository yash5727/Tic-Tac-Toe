//
//  Gameswift
//  Tic-Tac-Toe
//
//  Created by Yash Thakkar on 2023-04-21.
//

import SwiftUI

final class GameViewModel: ObservableObject{
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisbaled = false
    @Published var isGameStarted = false
    @Published var alertItem: AlertItem?
    @Published var difficulty: Difficulty = .easy
    @Published var moveSign: MoveSign = .X
    
    func processPlayerMove(for position: Int){
        
        //human move processing
        if isSquareOcuupied(in: moves, forIndex: position){ return }
        moves[position] = Move(player: .human, boardIndex: position,moveSign: moveSign)
        
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            isGameStarted = false
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            isGameStarted = false
            return
        }
        
        isGameBoardDisbaled = true
        
        //computer move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPosition = self.determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition,moveSign: moveSign)
            isGameBoardDisbaled = false
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                isGameStarted = false
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                isGameStarted = false
                return
            }
        }
    }
    
    func isSquareOcuupied(in moves: [Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int{
        if difficulty == .medium || difficulty == .hard{
            // If AI can win, then win
            let winPatterns: Set<Set<Int>> = [[0, 1, 2],[3, 4, 5],[6, 7, 8],[0, 4, 8],[0, 3, 6],[1, 4, 7],[2, 5, 8],[2, 4, 6]]
            
            let computerMoves = moves.compactMap{ $0 }.filter{ $0.player == .computer }
            let computerPositions = Set(computerMoves.map{ $0.boardIndex })
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(computerPositions)
                if winPositions.count == 1{
                    let isAvailable = !isSquareOcuupied(in: moves, forIndex: winPositions.first!)
                    if isAvailable { return winPositions.first! }
                }
            }
            
            // If AI can't win, then block
            let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human }
            let humanPositions = Set(humanMoves.map{ $0.boardIndex })
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(humanPositions)
                if winPositions.count == 1{
                    let isAvailable = !isSquareOcuupied(in: moves, forIndex: winPositions.first!)
                    if isAvailable { return winPositions.first! }
                }
            }
        }
        if difficulty == .hard{
            // If AI can't block, then take middle sqaure
            
            let centerSquare = 4
            if !isSquareOcuupied(in: moves, forIndex: centerSquare){
                return centerSquare
            }
        }
        
        // If AI can't take middle square, then take random available square
        var movePosition = Int.random(in: 0..<9)
        while isSquareOcuupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
        
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0, 1, 2],[3, 4, 5],[6, 7, 8],[0, 4, 8],[0, 3, 6],[1, 4, 7],[2, 5, 8],[2, 4, 6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){ return true }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}
