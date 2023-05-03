//
//  GameScene.swift
//  MyChallengeDay66
//
//  Created by Георгий Евсеев on 18.09.22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var scoreLabel: SKLabelNode!

    var possibleEnemies = ["penguinEvil", "penguinGood", "ball"]
    var gameTimer: Timer?
    var isGameOver = false

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 36)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }

    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        guard let enemyTwo = possibleEnemies.randomElement() else { return }
        guard let enemyThree = possibleEnemies.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: enemy)
        let spriteTwo = SKSpriteNode(imageNamed: enemyTwo)
        let spriteThree = SKSpriteNode(imageNamed: enemyThree)

        sprite.position = CGPoint(x: 1200, y: 650)

        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0

        spriteTwo.position = CGPoint(x: 0, y: 380)

        addChild(spriteTwo)

        spriteTwo.physicsBody = SKPhysicsBody(texture: spriteTwo.texture!, size: spriteTwo.size)
        spriteTwo.physicsBody?.categoryBitMask = 1
        spriteTwo.physicsBody?.velocity = CGVector(dx: 300, dy: 0)
        spriteTwo.physicsBody?.angularVelocity = 5
        spriteTwo.physicsBody?.linearDamping = 0
        spriteTwo.physicsBody?.angularDamping = 0

        spriteThree.position = CGPoint(x: 1200, y: 150)

        addChild(spriteThree)

        spriteThree.physicsBody = SKPhysicsBody(texture: spriteThree.texture!, size: spriteThree.size)
        spriteThree.physicsBody?.categoryBitMask = 1
        spriteThree.physicsBody?.velocity = CGVector(dx: -450, dy: 0)
        spriteThree.physicsBody?.angularVelocity = 5
        spriteThree.physicsBody?.linearDamping = 0
        spriteThree.physicsBody?.angularDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            // they shouldn't have whacked this penguin
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()

            if node.name == "charFriend" {
                score -= 5

                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                // they should have whacked this one
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1

                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
