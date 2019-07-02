//
//  ViewController.swift
//  Simon Says
//
//  Created by Louis on 2019/7/2.
//  Copyright © 2019 Louis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [CircularButton]!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet var scoreLabels: [UILabel]!

    var currentPlayer = 0
    var scores = [0, 0]
    
    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsToTap = [Int]()
    
    var gameEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sort the OutletCollection by their tags
        colorButtons = colorButtons.sorted() {
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted() {
            $0.tag < $1.tag
        }
        scoreLabels = scoreLabels.sorted() {
            $0.tag < $1.tag
        }
        createNewGame()
    }
    
    override func viewDidLayoutSubviews() {
        for button in colorButtons {
            button.setCircular(bool: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            gameEnded = false
            createNewGame()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        for button in colorButtons {
            button.alpha = 0.5
            button.isEnabled = false
        }
        
        currentPlayer = 0
        scores = [0, 0]
        scoreLabels[currentPlayer].alpha = 1.0
        playerLabels[currentPlayer].alpha = 1.0
        scoreLabels[1].alpha = 0.75
        playerLabels[1].alpha = 0.75
        updateScoreLabels()
    }
    
    func updateScoreLabels() {
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        scoreLabels[currentPlayer].alpha = 0.75
        playerLabels[currentPlayer].alpha = 0.75
        currentPlayer = currentPlayer == 0 ? 1 : 0
        scoreLabels[currentPlayer].alpha = 1.0
        playerLabels[currentPlayer].alpha = 1.0
    }
    
    func addNewColor() {
        colorSequence.append(Int(arc4random_uniform(4)))
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flash(button: colorButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            // Sequence is over!
            colorsToTap = colorSequence // Arrays are structs, which are copied
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the Circles", for: .normal)
            for button in colorButtons {
                button.isEnabled = true
            }
        }
    }
    
    func flash(button: CircularButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (_) in
            self.playSequence()
        }
    }
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 wins!" : "Player 1 wins!"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true
    }
    
    @IBAction func colorButtonHandler(_ sender: CircularButton) {
        // Right button tapped!
        if sender.tag == colorsToTap.removeFirst() {
            
        } else {
            for button in colorButtons {
                button.isEnabled = false
            }
            endGame()
            return
        }
        if colorsToTap.isEmpty {
            for button in colorButtons {
                button.isEnabled = false
            }
            scores[currentPlayer] += 1
            updateScoreLabels()
            switchPlayers()
            
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
    }
    
    @IBAction func actionButtonHandler(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        addNewColor()
        // Add a 1 second delay so that the user will be ready
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
}

