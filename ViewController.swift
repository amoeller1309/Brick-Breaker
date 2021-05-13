//
//  ViewController.swift
//  Games 2
//
//  Created by period6 on 4/27/21.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var brick1: UIView!
    @IBOutlet weak var brick2: UIView!
    @IBOutlet weak var brick3: UIView!
    @IBOutlet weak var brick4: UIView!
    
    
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var paddleView: UIView!
    
    var dynamicAnimator: UIDynamicAnimator!
    var pushBehavior: UIPushBehavior!
    var collisionBehavior: UICollisionBehavior!
    var bricks = [UIView]()
    var ballDynamicBehavior: UIDynamicItemBehavior!
    var paddleDynamicBehavior: UIDynamicItemBehavior!
    var bricksDynamicBehavior: UIDynamicItemBehavior!
    var brickCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ballView.layer.masksToBounds = true
        ballView.layer.cornerRadius = ballView.bounds.width / 2
        bricks = [brick1, brick2, brick3, brick4]
        dynamicBehaviors()
        
        //FIXED IT!!!! LET'S GO!!!!!!!!!!!!!!!!  WES!!!!!!!!!!!!!!!
    }
    
    @IBAction func movePaddle(_ sender: UIPanGestureRecognizer) {
        paddleView.center = CGPoint(x: sender.location(in: view).x, y: paddleView.center.y)
        dynamicAnimator.updateItem(usingCurrentState: paddleView)
    }
    
    func dynamicBehaviors(){
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        pushBehavior = UIPushBehavior(items: [ballView], mode: .instantaneous)
        pushBehavior.active = true
        pushBehavior.pushDirection = CGVector(dx: 0.3, dy: 0.6)
        pushBehavior.magnitude = 0.4
        dynamicAnimator.addBehavior(pushBehavior)
        
        collisionBehavior = UICollisionBehavior(items: [ballView, paddleView] + bricks)
        collisionBehavior.collisionMode = .everything
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
        ballDynamicBehavior = UIDynamicItemBehavior(items: [ballView])
        ballDynamicBehavior.elasticity = 1
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.allowsRotation = true
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddleView])
        paddleDynamicBehavior.allowsRotation = false
        paddleDynamicBehavior.density = 1000
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        bricksDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        bricksDynamicBehavior.allowsRotation = false
        bricksDynamicBehavior.density = 1000
        dynamicAnimator.addBehavior(bricksDynamicBehavior)
        
        collisionBehavior.addItem(ballView)
        collisionBehavior.addItem(paddleView)
        
        collisionBehavior.collisionDelegate = self
        
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if p.y > paddleView.center.y {
            alert()
        }
    }
    
    func alert() {
        let loseAlert = UIAlertController(title: "You Lose", message: nil, preferredStyle: .alert)
        let newGameButton = UIAlertAction(title: "New Game", style: .default) {
            _ in
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        loseAlert.addAction(newGameButton)
        loseAlert.addAction(cancelButton)
        present(loseAlert, animated: true, completion: nil)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        for wes in bricks {
            if item1.isEqual(ballView) && item2.isEqual(wes) {
                wes.isHidden = true
                collisionBehavior.removeItem(wes)
                brickCount -= 1
                print (brickCount)
            }
        }
        if  brickCount == 0 {
            winnerAlert()
            self.ballView.isHidden = true
            self.paddleView.isHidden = true
            collisionBehavior.removeItem(ballView)
        }
        
    }
    
    func winnerAlert() {
        let winner = UIAlertController(title: "You Won", message: nil, preferredStyle: .alert)
        let newGame = UIAlertAction(title: "New Game", style: .default) { (action) in
            self.brickCount = 4
            
        }
        
        winner.addAction(newGame)
        present(winner, animated: true, completion: nil)
    }
    
}

