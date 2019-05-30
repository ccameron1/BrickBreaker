//
//  GameScene.swift
//  BrickBreaker
//
//  Created by Carly Cameron on 5/30/19.
//  Copyright © 2019 Carly Cameron. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Brick : UInt32 = 0b1
    static let Ball : UInt32 = 0b10
    static let Paddle : UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let paddle = SKSpriteNode(imageNamed: "black")
    var brick = SKSpriteNode(imageNamed: "greenBrick")
    let ball = SKSpriteNode(imageNamed: "ball1")
    var posX = 0
    var posY = 0
    
    override func didMove(to view: SKView) {
        paddle.size = CGSize(width: 25, height: 100)
        
        backgroundColor = SKColor.white
        paddle.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(paddle)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.Paddle
        paddle.physicsBody?.collisionBitMask = PhysicsCategory.None
        paddle.physicsBody?.usesPreciseCollisionDetection = true
        
        brick.size = CGSize(width: 30, height: (size.width - 45) / 20)
        brick.position = CGPoint(x: size.width - 70, y: 45)
        addChild(brick)
        
        posX = Int(brick.position.x)
        posY = Int(brick.position.y)
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = true
        brick.physicsBody?.categoryBitMask = PhysicsCategory.Brick
        brick.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        brick.physicsBody?.collisionBitMask = PhysicsCategory.None
        brick.physicsBody?.usesPreciseCollisionDetection = true
        
        for i in 0...6 {
            addBrick()
        }
        
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.sequence([SKAction.run(addBall), SKAction.wait(forDuration: 0.5)]))
        
        
//        let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
//        backgroundMusic.autoplayLooped = true
//        addChild(backgroundMusic)
    }
    
    func addBall() {
        
        ball.size = CGSize(width: 10, height: 10)
        ball.position = CGPoint(x: 200, y: 200)
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Brick
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        ball.physicsBody?.friction = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.velocity.dx = 200
        ball.physicsBody?.velocity.dy = 0
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3))
        
            
        addChild(ball)
//
//        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
//        let actionMove = SKAction.move(to: CGPoint(x: -ball.size.width, y: actualY), duration: TimeInterval(actualDuration))
//        let actionMoveDone = SKAction.removeFromParent()
//        ball.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func didCollideWithEnemy(nodeA: SKSpriteNode, nodeB: SKSpriteNode) {
        print("hit")
        if nodeA.physicsBody?.velocity.dx != 0
        {
        changeTrajectory(nodeA: nodeA)
        print(nodeA.physicsBody?.velocity.dx)
        nodeA.physicsBody?.velocity.dx = -(nodeA.physicsBody?.velocity.dx)!
        
        nodeB.removeFromParent()
        }
        else {
            changeTrajectory(nodeA: nodeB)
            print(nodeB.physicsBody?.velocity.dx)
            nodeB.physicsBody?.velocity.dx = -(nodeB.physicsBody?.velocity.dx)!
            
            nodeA.removeFromParent()
        }
    }
    
    func changeTrajectory(nodeA: SKSpriteNode)
    {
        let offset = ball.position
        if offset.x < 0 {
            return
        }
        let direction = offset.normalized()
        let shotDistance = direction * 1000
        let realDestination = shotDistance + ball.position
        let actionThrow = SKAction.move(to: realDestination, duration: 2.0)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if let ball = firstBody.node as? SKSpriteNode,
            let brick = secondBody.node as? SKSpriteNode {
            didCollideWithEnemy(nodeA: brick, nodeB: ball)
            print("print")
        }
        
    }
    
    func random() -> CGFloat {
        return CGFloat.random(in: 0...5)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addBrick() {
        let bricks = SKSpriteNode(imageNamed: "greenBrick")
        bricks.size = CGSize(width: 30, height: (size.width - 45) / 20)
        posY = posY + Int(bricks.size.height) + 7
        bricks.position = CGPoint(x: posX , y: posY)
        addChild(bricks)
        bricks.physicsBody = SKPhysicsBody(rectangleOf: bricks.size)
        bricks.physicsBody?.isDynamic = true
        bricks.physicsBody?.categoryBitMask = PhysicsCategory.Brick
        bricks.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        bricks.physicsBody?.collisionBitMask = PhysicsCategory.None
        bricks.physicsBody?.usesPreciseCollisionDetection = true
        print("add")
        
        
    }
}

