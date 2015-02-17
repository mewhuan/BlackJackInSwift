//
//  ViewController.swift
//  BlackJackGaming
//
//  Created by Dong Li on 2/16/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hitButton.enabled = false
        stayButton.enabled = false
        againButton.enabled = false
        doubleButton.enabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var doubleButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var moneySlider: UISlider!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!

    var deck: [Card]?
    var dealerCards: [Card]?
    var playerCards: [Card]?
    var dealerCardLabel: UILabel?
    
    var firstCard = Card()
    var cardLabels = [UILabel]()
    var money = 100
    var currentBetMoney = 1
    var turn = 4
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startPlay() {
        
        dealerCards = [Card]()
        playerCards = [Card]()
        hitButton.enabled = true
        stayButton.enabled = true
        doubleButton.enabled = true
        betButton.enabled = false
        if turn == 4 {
            shuffleDeck()
            turn = 0
        } else {
            turn++
        }
        playerAddCard()
        dealerAddCard()
    }
    
    func shuffleDeck() {
        
        deck = [Card]()
        for suit in Card.Suit.allSuits {
            for rank in Card.Rank.allRanks {
                deck!.append(Card(rank: rank, suit: suit))
            }
        }
        let count = countElements(deck!)
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            var c = Card()
            c = deck![i]
            deck![i] = deck![j]
            deck![j] = c
        }
    }
    
    func sumCards(cards: [Card]) -> Int{
        var sum = 0
        var numOfAce = 0
        for card in cards {
            if card.rank.values.second != nil {
                numOfAce++
                sum += 11
            } else {
                sum += card.rank.values.first
            }
        }
        while sum > 21 && numOfAce > 0 {
            sum -= 10
            numOfAce--
        }
        return sum
    }
    
    func addCardView(label: UILabel, count: Int, height: Int) {
        
        label.textAlignment = NSTextAlignment.Center
        label.layer.borderWidth = 2.0
        var gap = self.view.bounds.size.width-10*2-35*8
        gap = gap/7
        label.frame = CGRectMake(10+(35+gap)*CGFloat(count), CGFloat(height), 35, 55)
        self.view.addSubview(label)
        cardLabels.append(label)
    }
    
    func dealerAddCard() {
        
        if dealerCards!.count < 2 {
            var card1 = deck!.removeLast()
            firstCard = card1
            var card2 = deck!.removeLast()
            dealerCards!.append(card1)
            dealerCards!.append(card2)
            var label1 = card1.cardLabel
            label1.text = ""
            var label2 = card2.cardLabel
            addCardView(label1, count: 0, height: 70)
            addCardView(label2, count: 1, height: 70)
        } else {
            var card = deck!.removeLast()
            dealerCards!.append(card)
            var count = dealerCards!.count - 1
            var newLabel = card.cardLabel
            addCardView(newLabel, count: count, height: 70)
        }
    }
    
    func playerAddCard() {
        
        if playerCards!.count < 2 {
            var card1 = deck!.removeLast()
            var card2 = deck!.removeLast()
            playerCards!.append(card1)
            playerCards!.append(card2)
            var label1 = card1.cardLabel
            var label2 = card2.cardLabel
            addCardView(label1, count: 0, height: 400)
            addCardView(label2, count: 1, height: 400)
        } else {
            var card = deck!.removeLast()
            playerCards!.append(card)
            var count = playerCards!.count - 1
            var newLabel = card.cardLabel
            addCardView(newLabel, count: count, height: 400)
        }
        if currentBetMoney > money {
            doubleButton.enabled = false
        }
    }
    
    func gameOver(win: Bool, blackJack: Bool = false) {
        
        infoLabel.text = win ? "You win!" : "You Lose!"
        if blackJack {
            money += currentBetMoney * 3
        } else if win {
            money += currentBetMoney * 2
        }
        moneyLabel.text = "$\(money)"
        hitButton.enabled = false
        stayButton.enabled = false
        doubleButton.enabled = false
        againButton.enabled = true
        for i in 0..<dealerCards!.count {
            if i == 0 {
                var newLabel = UILabel()
                newLabel.text = firstCard.description
                newLabel.font = UIFont(name: "Arial", size: 15)
                addCardView(newLabel, count: 0, height: 70)
            } else {
                addCardView(dealerCards![i].cardLabel, count: i, height: 70)
            }
        }
    }
    
    func isBlackJack(cards: [Card]) -> Bool {
        
        if cards.count == 2 && sumCards(cards) == 21 {
            return true
        }
        return false
    }

    func dealerDraw() {
        
        while sumCards(dealerCards!) < 17 {
            dealerAddCard()
        }
        while sumCards(dealerCards!) <= 21 && sumCards(playerCards!) <= 21 && sumCards(dealerCards!) < sumCards(playerCards!) {
            dealerAddCard()
        }
    }
    
    @IBAction func hitButtonPressed(sender: AnyObject) {

        playerAddCard()
        if sumCards(playerCards!) > 21 {
            dealerDraw()
            if sumCards(dealerCards!) > 21 {
                money += currentBetMoney
                gameOver(false)
                infoLabel.text = "Draw!"
            } else {
                gameOver(false)
            }
        }
    }
    
    @IBAction func doubleButtonPressed(sender: AnyObject) {
        
        money -= currentBetMoney
        currentBetMoney *= 2
        moneyLabel.text = "$\(money)"
        playerAddCard()
        if sumCards(playerCards!) > 21 {
            dealerDraw()
            if sumCards(dealerCards!) > 21 {
                money += currentBetMoney
                gameOver(false)
                infoLabel.text = "Draw!"
            } else {
                gameOver(false)
            }
        }
    }
    
    @IBAction func stayButtonPressed(sender: AnyObject) {
        
        dealerDraw()
        if isBlackJack(playerCards!) && isBlackJack(dealerCards!) {
            money += currentBetMoney
            gameOver(false)
        } else if isBlackJack(playerCards!) {
            gameOver(true, blackJack: true)
        } else if isBlackJack(dealerCards!) {
            gameOver(false)
        } else {
            var playerSum = sumCards(playerCards!)
            var dealerSum = sumCards(dealerCards!)
            if dealerSum > 21 || playerSum > dealerSum {
                gameOver(true)
            } else if playerSum == dealerSum {
                money += currentBetMoney
                gameOver(false)
                infoLabel.text = "Draw!"
            } else {
                gameOver(false)
            }
        }
    }
    
    @IBAction func againButtonPressed(sender: AnyObject) {
        
        if money == 0 {
            infoLabel.text = "No Money!"
            betButton.enabled = false
            againButton.enabled = false
        } else {
            dealerCards!.removeAll(keepCapacity: true)
            playerCards!.removeAll(keepCapacity: true)
            for label in cardLabels {
                label.removeFromSuperview()
            }
            infoLabel.text = "Gambling"
            moneySlider.maximumValue = Float(money)
            betButton.enabled = true
            againButton.enabled = false
            hitButton.enabled = false
            doubleButton.enabled = false
            stayButton.enabled = false
        }
    }

    @IBAction func betButtonPressed(sender: AnyObject) {
        
        var betMoney = Int(moneySlider.value)
        money -= betMoney
        moneyLabel.text = "$\(money)"
        currentBetMoney = betMoney
        startPlay()
    }
    
    @IBAction func betAmount(sender: UISlider) {
        var amount = Int(sender.value)
        betLabel.text = "\(amount)"
    }
    
}

