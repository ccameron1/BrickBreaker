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
    static let Paddle : UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let paddle = SKSpriteNode(imageNamed: "black")
    var brick = SKSpriteNode(imageNamed: "greenBrick")

    var posX = 0
    var posY = 0
    
    override func didMove(to view: SKView) {
        paddle.size = CGSize(width: 25, height: 100)
        
        backgroundColor = SKColor.white
        paddle.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(paddle)
        
        brick.size = CGSize(width: 30, height: (size.width - 45) / 20)
        brick.position = CGPoint(x: size.width - 70, y: 45)
        addChild(brick)
        
        posX = Int(brick.position.x)
        posY = Int(brick.position.y)
        
        
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
        let ball = SKSpriteNode(imageNamed: "ball1")
        ball.size = CGSize(width: 10, height: 10)
        let actualY = random(min: ball.size.height / 2, max: size.height - ball.size.height / 2)
        ball.position = CGPoint(x: size.width + ball.size.width / 2, y: actualY)
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Brick
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(ball)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: -ball.size.width, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        ball.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func didCollideWithEnemy(nodeA: SKSpriteNode, nodeB: SKSpriteNode) {
        print("hit")
        nodeA.removeFromParent()
        nodeB.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if let enemy = firstBody.node as? SKSpriteNode,
            let star = secondBody.node as? SKSpriteNode {
            didCollideWithEnemy(nodeA: star, nodeB: enemy)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        run(SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false))
        
        guard let touch = touches.first else  {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let brick = SKSpriteNode(imageNamed: "red")
        brick.position = paddle.position
        let offset = touchLocation - brick.position
        if offset.x < 0 {
            return
        }

        brick.physicsBody = SKPhysicsBody(circleOfRadius: brick.size.width / 2)
        brick.physicsBody?.isDynamic = true
        brick.physicsBody?.categoryBitMask = PhysicsCategory.Brick
        brick.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        brick.physicsBody?.collisionBitMask = PhysicsCategory.None
        brick.physicsBody?.usesPreciseCollisionDetection = true

        addChild(brick)
        let direction = offset.normalized()
        let shotDistance = direction * 1000
        let realDestination = shotDistance + brick.position
        let actionThrow = SKAction.move(to: realDestination, duration: 2.0)
        let actionThrowDone = SKAction.removeFromParent()
        brick.run(SKAction.sequence([actionThrow, actionThrowDone]))
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
        print("add")
        
    }
}

