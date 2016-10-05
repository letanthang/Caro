//
//  Board.swift
//  Flip
//
//  Created by Thang Le Tan on 9/26/16.
//  Copyright © 2016 Thang Le Tan. All rights reserved.
//

import UIKit
import GameplayKit

class Board: NSObject, GKGameModel {
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
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
        if col >= Board.size { return false }
        
        return true
    }
    
    func makeMove(player: Player, row: Int, col: Int) -> [Move] {
        //1: create an array to hold all the captured stones
        var didCapture = [Move]()
        //2: place the stone in the requested position
        rows[row][col] = player.stoneColor
        
        didCapture.append(Move(row: row, col: col))
        
        for move in Board.moves {
            //3: look in this direction for  captured stones
            var mightCapture = [Move]()
            var currentRow = row
            var currentCol = col
            
            for _ in 0 ..< Board.size {
                currentRow += move.row
                currentCol += move.col
                
                //5: make sure this is a sensible position to move to
                
                guard isInBound(row: currentRow, col: currentCol) else { break }
                let stone = rows[currentRow][currentCol]
                
                if stone == player.opponent.stoneColor {
                    //6: we found an enemy stone - add it to the list of possible captures
                    mightCapture.append(Move(row: currentRow, col: currentCol))
                    
                } else if stone == player.stoneColor {
                    //7: we found one of our stones, add the might capture to did capture array
                    didCapture.append(contentsOf: mightCapture)
                    //8: change all stones to the player color, then exit the loop because we're finished in this direction
                    mightCapture.forEach {
                        rows[$0.row][$0.col] = player.stoneColor
                    }
                    break
                    
                } else {
                    //9: we found sth else bail out
                    break
                }
            }
            
        }
        //10: send back the list of of captured stones
        return didCapture
    }
    
    func getScores() -> (black: Int, white: Int) {
        var black = 0
        var white = 0
        
        rows.forEach {
            $0.forEach {
                if $0 == .black {
                    black += 1
                } else if $0 == .white {
                    white += 1
                }
            }
        }
        return (black, white)
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let playerObject = player as? Player else { return false }
        
        let scores = getScores()
        
        if playerObject.stoneColor == .black {
            return scores.black > scores.white + 10
        } else {
            return scores.white > scores.black + 10
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        //safely unwrap the player object
        guard let playerObject = player as? Player else { return nil }
        
        //if the game is over, exit now
        if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
            return nil
        }
        
        
        //if we're still here prepare to send back a list of moves
        
        var moves = [Move]()
        
        //try every column in every row
        for row in  0 ..< Board.size {
            for col in 0 ..< Board.size {
                if canMoveIn(row: row, col: col) {
                    moves.append(Move(row: row, col: col))
                }
            }
        }
        
        return moves
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else { return }
        
        _ = makeMove(player: currentPlayer, row: move.row, col: move.col)
        
        currentPlayer = currentPlayer.opponent
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        guard let board = gameModel as? Board else { return }
        
        currentPlayer = board.currentPlayer
        
        rows = board.rows
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        
        copy.setGameModel(self)
        
        return copy
    }
    
    
}
