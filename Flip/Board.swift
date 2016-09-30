//
//  Board.swift
//  Flip
//
//  Created by Thang Le Tan on 9/26/16.
//  Copyright © 2016 Thang Le Tan. All rights reserved.
//

import UIKit

class Board: NSObject {
    static let size = 8
    
    static let moves = [Move(row: -1, col: -1), Move(row: -1, col: 0), Move(row: -1, col: 1), Move(row: 0, col: 1), Move(row: 1, col: 1), Move(row: 1, col: 0), Move(row: 1, col: -1), Move(row: 0, col: -1)]
    
    var currentPlayer = Player.allPlayers[0]
    
    var rows = [[StoneColor]]()
    
    func canMoveIn(row: Int, col: Int) -> Bool {
        //test 1: check if the move is sensible (not out of bound/range)
        
        if !isInBound(row: row, col: col) { return false }
        //test 2: check that the move hasnt been made already
        
        let stone = rows[row][col]
        if stone != .empty { return false }
        
        
        //test 3: check if the move is legal
        for move in Board.moves {
            //2: create a variable to track whether we we've passed at least one opponent stone
            var passedOpponent = false
            
            //3: set movement variables containing our initial row and columnn
            var currentRow = row
            var currentCol = col
            
            //4: count from here up the edge of the board, applying our move each time
            
            for _ in 0..<Board.size {
                //5: add a move to our movement variables
                currentRow += move.row
                currentCol += move.col
                
                //6: if our position is off the board, break out of the loop
                guard isInBound(row: currentRow, col: currentCol) else { break }
                
                let stone = rows[currentRow][currentCol]
                
                if stone == currentPlayer.opponent.stoneColor {
                    //7: we found an enemy stone
                    passedOpponent = true
                } else if stone == currentPlayer.stoneColor && passedOpponent {
                    //8 : we found one of our stones after finding an enemy stone
                    return true
                } else {
                    //9: we found sth else; bail out
                    break
                }
            }            
        }
        //10: if we're still here it means we failed
        return false
        
        
    }
    
    func isInBound(row: Int, col: Int) -> Bool {
        if row < 0 { return false }
        if col < 0 { return false }
        if row >= Board.size { return false }
        if col <= Board.size { return false }
        
        return true
    }
}
