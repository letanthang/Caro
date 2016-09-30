//
//  GameScene.swift
//  Flip
//
//  Created by Thang Le Tan on 9/20/16.
//  Copyright © 2016 Thang Le Tan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var rows = [[Stone]]()
    
    var board: Board!
    
    private var label: SKSpriteNode?
    private var spinnyNode: SKShapeNode?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.blendMode = .replace
        background.zPosition = 1
        addChild(background)
        
        let gameBoard = SKSpriteNode(imageNamed: "board")
        gameBoard.name = "board"
        gameBoard.zPosition = 2
        
        addChild(gameBoard)
        
        board = Board()
        
        //1: Set up the constants for positioning
        
        let offsetX = -280
        let offsetY = 281
        let stoneSize = 80
        
        for row in 0 ..< Board.size {
            //2: count from 0 to 7, creating a new array of the stones
            var colArray = [Stone]()
            for col in 0 ..< Board.size {
                //3: create from 0 to 7, creating a new stone object
                let stone = Stone(color: UIColor.clear, size: CGSize(width: stoneSize, height: stoneSize))
                //4: place the stone at the correct position
                stone.position = CGPoint(x: offsetX + (col * stoneSize), y: offsetY + (row * stoneSize))
                //5: tell the stone its row and column
                stone.row = row
                stone.col = col
                //6: 
                
                gameBoard.addChild(stone)
                colArray.append(stone)
            }
            
            board.rows.append([StoneColor](repeatElement(.empty, count: Board.size)))
            rows.append(colArray)
            
        }
        
        
        
        rows[4][3].setPlayer(.white)
        rows[4][2].setPlayer(.black)
        rows[4][1].setPlayer(.white)
        rows[3][2].setPlayer(.black)
        
        board.rows[4][3] = .white
        board.rows[4][2] = .black
        board.rows[4][1] = .white
        board.rows[3][2] = .black
        
    }
    
    
    override func sceneDidLoad() {

    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1: unwrap the first touch
        guard let touch = touches.first else { return }
        
        //2: find the gameboard, or return if it somehow couldn't be found
        guard let gameBoard = childNode(withName: "board") else { return }
        //3: figure out where on the game board the touch landed
        let location = touch.location(in: gameBoard)
        
        //4: pull out an array of all nodes in that locaiton
        let nodesAtPoint = self.nodes(at: location)
        
        //5: filter out all nodes that arent Stone
        let tappedStones = nodesAtPoint.filter { $0 is Stone }
        
        //6: if no stone was tapped, bail out
        guard tappedStones.count > 0 else { return }
        let tappedStone = tappedStones[0] as! Stone
        
        //7: pass the tapped stones row and column into  canMoveOn()
        if board.canMoveIn(row: tappedStone.row, col: tappedStone.col) {
            //8: print a message if the move is legal
            print("Move is legal")
        } else {
            print("Move is illegal")
        }
        
        
        
        
        
        
    }
    
}
