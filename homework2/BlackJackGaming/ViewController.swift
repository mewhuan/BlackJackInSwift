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
        cardsLeft.text = "\(52 * deckNum)"
        initPlayerAndShoe()
        hitButton.enabled = false
        stayButton.enabled = false
        againButton.enabled = false
        bustButton.hidden = true
        resultLabel1.hidden = true
        resultLabel2.hidden = true
        resultLabel3.hidden = true
        resultLabel4.hidden = true
        resultLabel5.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var moneySlider: UISlider!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var bustButton: UIButton!
    @IBOutlet weak var dealerScoreLabel: UILabel!
    @IBOutlet weak var cardsLeft: UILabel!
    @IBOutlet weak var recommendLabel: UILabel!

    @IBOutlet weak var resultLabel1: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var resultLabel3: UILabel!
    @IBOutlet weak var resultLabel4: UILabel!
    @IBOutlet weak var resultLabel5: UILabel!
    
    var playID = 0
    var sharedData:Singleton = Singleton.sharedInstance
    var playerList: [Player] = []
    var playerNum = 3
    var deckNum = 0
    var deck: [Card]?
    var dealerCards: [Card]?
    var playerCards: [Card]?
    var dealerCardLabel: UILabel?
    var shoe: Shoe?
    var resultLabels: [UILabel]?
    
    var firstCard = Card()
    var secondCard = Card()
    var cardLabels = [UILabel]()
    var playerLabels = [UILabel]()
    var money = 100
    var currentBetMoney = 1
    var turn = 4
    var currentPlayer = Player(name: "")
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPlayerAndShoe() {
        for i in 0..<playerNum {
            playerList.append(sharedData.players[i])
        }
        playerLabel.text = playerList[0].name
        shoe = Shoe(numOfDecks: deckNum)
        shoe!.makeNewDeck()
        shoe!.shuffle()
        initResultLabels()
    }
    
    func initResultLabels() {
        resultLabels = []
        resultLabels!.append(resultLabel1)
        resultLabels!.append(resultLabel2)
        resultLabels!.append(resultLabel3)
        resultLabels!.append(resultLabel4)
        resultLabels!.append(resultLabel5)
    }
    
    func startPlay() {
        
        dealerCards = [Card]()
        playerCards = [Card]()
        hitButton.enabled = true
        stayButton.enabled = true
        betButton.enabled = false
        if turn == 4 {
            shoe!.makeNewShoe()
            shoe!.shuffle()
            turn = 0
        } else {
            turn++
        }
        playerAddCard()
        dealerAddCard()
    }
    
    func cardLeft() {
        if shoe!.cards.count <= 0 {
            shoe!.makeNewShoe()
            shoe!.shuffle()
        }
        cardsLeft.text = "\(shoe!.cards.count)"
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
        
//        if dealerCards!.count < 2 {
//            var card1 = deck!.removeLast()
//            firstCard = card1
//            var card2 = deck!.removeLast()
//            dealerCards!.append(card1)
//            dealerCards!.append(card2)
//            var label1 = card1.cardLabel
//            label1.text = ""
//            var label2 = card2.cardLabel
//            addCardView(label1, count: 0, height: 70)
//            addCardView(label2, count: 1, height: 70)
//        } else {
//            var card = deck!.removeLast()
//            dealerCards!.append(card)
//            var count = dealerCards!.count - 1
//            var newLabel = card.cardLabel
//            addCardView(newLabel, count: count, height: 70)
//        }
        if dealerCards!.count < 2 {
            var card1 = shoe!.cards.removeLast()
            firstCard = card1
            var card2 = shoe!.cards.removeLast()
            secondCard = card2
            dealerCards!.append(card1)
            dealerCards!.append(card2)
            var label1 = card1.cardLabel
            label1.text = ""
            var label2 = card2.cardLabel
            addCardView(label1, count: 0, height: 70)
            addCardView(label2, count: 1, height: 70)
        } else {
            var card = shoe!.cards.removeLast()
            dealerCards!.append(card)
            var count = dealerCards!.count - 1
            var newLabel = card.cardLabel
            addCardView(newLabel, count: count, height: 70)
        }
        cardLeft()
    }
    
    func playerAddCard() {
        
        if playerList[playID].hands[0].cards.count < 2 {
            var card1 = shoe!.cards.removeLast()
            var card2 = shoe!.cards.removeLast()
            playerList[playID].hands[0].cards.append(card1)
            playerList[playID].hands[0].cards.append(card2)
            var label1 = card1.cardLabel
            var label2 = card2.cardLabel
            addCardView(label1, count: 0, height: 400)
            addCardView(label2, count: 1, height: 400)
            playerLabels.append(label1)
            playerLabels.append(label2)
        } else {
            var card = shoe!.cards.removeLast()
            playerList[playID].hands[0].cards.append(card)
            var count = playerList[playID].hands[0].cards.count - 1
            var newLabel = card.cardLabel
            addCardView(newLabel, count: count, height: 400)
            playerLabels.append(newLabel)
        }
        cardLeft()
        recommend()
    }
    
    func nextPlayer() {
        
        playID++
        
        for label in playerLabels {
            label.removeFromSuperview()
        }
        if playID >= playerNum {
            playID = 0
            endGame(true)
        } else {
            showCurrentPlayer()
            playerAddCard()
        }

        //showCurrentPlayer()
    }
    
    func isSoft() -> Bool {
        var sum = playerList[playID].hands[0].sumHand()
        var softSum = 0
        var numOfAce = 0
        for card in playerList[playID].hands[0].cards {
            if card.rank.values.second != nil {
                numOfAce++
            }
            softSum += card.rank.values.first
        }
        if numOfAce != 0 && sum != softSum {
            return true
        }
        return false
    }
    
    func recommend() {
        var dealerValue = secondCard.rank.values.first
        var sum = playerList[playID].hands[0].sumHand()
        if isSoft() {
            if sum <= 17 {
                recommendLabel.text = "Advice: Hit"
            } else if sum >= 19 && sum <= 21 {
                recommendLabel.text = "Advice: Stand"
            } else if sum == 18 {
                if dealerValue >= 2 && dealerValue <= 8 {
                    recommendLabel.text = "Advice: Stand"
                } else {
                    recommendLabel.text = "Advice: Hit"
                }
            }
        } else {
            if sum <= 11 {
                recommendLabel.text = "Advice: Hit"
            } else if sum >= 17 && sum <= 21 {
                recommendLabel.text = "Advice: Stand"
            } else if sum == 12 {
                if dealerValue >= 4 && dealerValue <= 6 {
                    recommendLabel.text = "Advice: Stand"
                } else {
                    recommendLabel.text = "Advice: Hit"
                }
            } else if sum >= 13 && sum <= 16 {
                if dealerValue >= 2 && dealerValue <= 6 {
                    recommendLabel.text = "Advice: Stand"
                } else {
                    recommendLabel.text = "Advice: Hit"
                }
            }
        }
    }
    
    func showCurrentPlayer() {
        
        playerLabel.text = playerList[playID].name
        moneyLabel.text = "$\(playerList[playID].money)"
    }
    
    
//    func gameOver(win: Bool, blackJack: Bool = false) {
//
//        var money = playerList[playID].money
//        if blackJack {
//            money += playerList[playID].hands[0].bet * 3
//        } else if win {
//            money += playerList[playID].hands[0].bet * 2
//        }
//    }
    
    func endGame(win: Bool, blackJack: Bool = false){
        
//        infoLabel.text = win ? "You win!" : "You Lose!"
//        if blackJack {
//            money += currentBetMoney * 3
//        } else if win {
//            money += currentBetMoney * 2
//        }
//        moneyLabel.text = "$\(money)"
//        hitButton.enabled = false
//        stayButton.enabled = false
//        againButton.enabled = true
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
        var dealSum = 0
        dealerDraw()
        if isBlackJack(dealerCards!) {
            dealSum = 22
            dealerScoreLabel.text = "BJ"
        } else {
            dealSum = sumCards(dealerCards!)
            dealerScoreLabel.text = "\(dealSum)"
            if dealSum > 21 {
                dealSum = 0
                dealerScoreLabel.text = "Bust"
            }
        }
//        for player in playerList {
//            if player.hands[0].score > dealSum {
//                player.result = "Win"
//            } else if player.hands[0].score == dealSum {
//                player.result = "Draw"
//            }
//            println(player.name)
//            result += "\(player.name) \(player.result) \(player.money)"
//        }
//        resultLabel.text = result
//        resultLabel.hidden = false
        for i in 0..<playerList.count {
            var result: String = "\(playerList[i].name) "
            var bj = false
            if playerList[i].hands[0].score > dealSum {
                playerList[i].hands[0].result = "Win"
                if playerList[i].hands[0].score == 22 {
                    playerList[i].money += playerList[i].hands[0].bet * 3
                    bj = true
                } else {
                    playerList[i].money += playerList[i].hands[0].bet * 2
                }
            } else if playerList[i].hands[0].score == dealSum {
                playerList[i].hands[0].result = "Draw"
                playerList[i].money += playerList[i].hands[0].bet
            } else if playerList[i].hands[0].score < dealSum {
                playerList[i].hands[0].result = "Lose"
            }
            result += "\(playerList[i].hands[0].result) $\(playerList[i].money) "
            if bj {
                result += " BJ! "
            } else if playerList[i].hands[0].score == 0 {
                result += " Bust "
            } else {
                result += " \(playerList[i].hands[0].score) "
            }
            result += playerList[i].hands[0].cards.description
            resultLabels![i].text = result
            resultLabels![i].font = UIFont(name: "Arial", size: 12)
            resultLabels![i].hidden = false
        }
        hitButton.enabled = false
        stayButton.enabled = false
        againButton.enabled = true
        playerLabel.text = "END"
        moneyLabel.text = ""
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
    }
    
    @IBAction func hitButtonPressed(sender: AnyObject) {
        
        playerAddCard()

        if playerList[playID].hands[0].sumHand() > 21 {
            playerList[playID].hands[0].score = 0
            bustButton.hidden = false
            hitButton.enabled = false
            stayButton.enabled = false
            recommendLabel.hidden = true
        }
        recommend()
//        playerAddCard()
//        if sumCards(playerCards!) > 21 {
//            dealerDraw()
//            if sumCards(dealerCards!) > 21 {
//                money += currentBetMoney
//                gameOver(false)
//                infoLabel.text = "Draw!"
//            } else {
//                gameOver(false)
//            }
//        }
    }
    
    
    @IBAction func stayButtonPressed(sender: AnyObject) {
        
//        dealerDraw()
//        if isBlackJack(playerCards!) && isBlackJack(dealerCards!) {
//            money += currentBetMoney
//            gameOver(false)
//        } else if isBlackJack(playerCards!) {
//            gameOver(true, blackJack: true)
//        } else if isBlackJack(dealerCards!) {
//            gameOver(false)
//        } else {
//            var playerSum = sumCards(playerCards!)
//            var dealerSum = sumCards(dealerCards!)
//            if dealerSum > 21 || playerSum > dealerSum {
//                gameOver(true)
//            } else if playerSum == dealerSum {
//                money += currentBetMoney
//                gameOver(false)
//                infoLabel.text = "Draw!"
//            } else {
//                gameOver(false)
//            }
//        }
        if isBlackJack(playerList[playID].hands[0].cards) {
            playerList[playID].hands[0].score = 22
        } else {
            playerList[playID].hands[0].score = playerList[playID].hands[0].sumHand()
        }
        nextPlayer()
    }
    
    @IBAction func againButtonPressed(sender: AnyObject) {
        
//        if money == 0 {
//            infoLabel.text = "No Money!"
//            betButton.enabled = false
//            againButton.enabled = false
//        } else {
//            dealerCards!.removeAll(keepCapacity: true)
//            playerCards!.removeAll(keepCapacity: true)
//            for label in cardLabels {
//                label.removeFromSuperview()
//            }
//            infoLabel.text = "Gambling"
//            moneySlider.maximumValue = Float(money)
//            betButton.enabled = true
//            againButton.enabled = false
//            hitButton.enabled = false
//            stayButton.enabled = false
//        }
        var indexToRemove = [Int]()
        for i in 0..<playerList.count {
            playerList[i].hands[0].cards.removeAll(keepCapacity: true)
            resultLabels![i].hidden = true
            if playerList[i].money <= 0 {
                playerNum--
                indexToRemove.append(i)
            }
        }
        var removeCount = 0
        for i in indexToRemove {
            playerList.removeAtIndex(i - removeCount)
            removeCount++
        }
        if playerNum <= 0 {
            againButton.enabled = false
            betButton.enabled = false
        } else {
            dealerCards!.removeAll(keepCapacity: true)
            for label in cardLabels {
                label.removeFromSuperview()
            }
            moneySlider.maximumValue = Float(playerList[0].money)
            betButton.enabled = true
            againButton.enabled = false
            hitButton.enabled = false
            stayButton.enabled = false
            moneyLabel.text = "\(playerList[0].money)"
            playerLabel.text = playerList[0].name
        }

    }


    @IBAction func bustButtonPressed(sender: AnyObject) {
       
        bustButton.hidden = true
        hitButton.enabled = true
        stayButton.enabled = true
        recommendLabel.hidden = false
        nextPlayer()
    }
  
    @IBAction func betButtonPressed(sender: AnyObject) {
        

//        var betMoney = Int(moneySlider.value)
//
//        playID++
//        if playID >= playerNum {
//            playID = 0
//            playerLabel.text = playerList[0].name
//            startPlay()
//        }
//        else {
//            playerLabel.text = playerList[playID].name
//            moneyLabel.text = "$\(playerList[playID].money)"
//            playerList[playID-1].money -= betMoney
//            println("\(playerList[playID-1].money)")
//        }
        var betMoney = Int(moneySlider.value)
        playerList[playID].hands[0].bet = betMoney
        playerList[playID].money -= betMoney
        playID++
        if playID >= playerNum {
            playID = 0
            playerLabel.text = playerList[0].name
            moneyLabel.text = "\(playerList[0].money)"
            startPlay()
        }
        else {
            playerLabel.text = playerList[playID].name
            moneyLabel.text = "$\(playerList[playID].money)"
            moneySlider.maximumValue = Float(playerList[playID].money)
        }
    }
    
    @IBAction func betAmount(sender: UISlider) {
        var amount = Int(sender.value)
        betLabel.text = "\(amount)"
    }
    
}

