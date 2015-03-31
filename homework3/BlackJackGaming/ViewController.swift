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
//        dealerView.layer.borderWidth = 1
//        dealerView.layer.borderColor = UIColor.redColor().CGColor
//        playerView.layer.borderWidth = 1
//        dealerView.layer.borderColor = UIColor.blueColor().CGColor
        resultLabel1.hidden = true
        resultLabel2.hidden = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var dealerView: UIView!
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
    
    
    var playID = 0
    var sharedData:Singleton = Singleton.sharedInstance
    var playerList: [Player] = []
    var playerNum = 2
    var deckNum = 2
    var deck: [Card]?
    var dealerCards: [Card]?
    var playerCards: [Card]?
    var dealerCardLabel: UILabel?
    var shoe: Shoe?
    var AIPlayer = true
    var resultLabels: [UILabel]?

    var firstCard = Card()
    var secondCard = Card()
    var cardLabels = [UILabel]()
    var playerLabels = [UILabel]()
    var playerImages = [UIImageView]()
    var cardImages = [UIImageView]()
    var money = 100
    var currentBetMoney = 1
    var turn = 4
    var currentPlayer = Player(name: "")
    var playerCardImages = [UIImageView]()
    var dealerCardImages = [UIImageView]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPlayerAndShoe() {
        
        for i in 0..<playerNum {
            if i == 1 && AIPlayer == true {
                sharedData.players[i].name = "AI"
            }
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
    
//    func addCardView(label: UILabel, count: Int, height: Int) {
//        
//        label.textAlignment = NSTextAlignment.Center
//        label.layer.borderWidth = 2.0
//        var gap = self.view.bounds.size.width-10*2-35*8
//        gap = gap/7
//        label.frame = CGRectMake(10+(35+gap)*CGFloat(count), CGFloat(height), 35, 55)
//        self.view.addSubview(label)
//        cardLabels.append(label)
//    }
//
//    func addImage(imageView: UIImageView, count: Int, height: Int) {
//        
//        imageView.frame = CGRectMake(30+20*CGFloat(count), CGFloat(height), 60, 100)
//        //imageView.center = CGPointMake(self.view.bounds.width/2, 200)
//        self.view.addSubview(imageView)
//        cardImages.append(imageView)
//    }
    
    func addImageInView(thisView: UIView, imageView: UIImageView, count: Int) {
        
        var selfWidth = thisView.bounds.width/3
        var selfHeight = selfWidth*87/57
        var gap = selfWidth/4
        var yCor = (thisView.bounds.height - selfHeight)/2
        if selfHeight > thisView.bounds.height {
            selfHeight = thisView.bounds.height
            selfWidth = selfHeight*57/87
            gap = selfWidth/4
            yCor = (thisView.bounds.height - selfHeight)/2
        }
        imageView.frame = CGRectMake(gap*CGFloat(count), yCor, selfWidth, selfHeight)
        thisView.addSubview(imageView)
        cardImages.append(imageView)

        //        var heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: thisView, attribute: NSLayoutAttribute.Height, multiplier: 0.5, constant: 0)
        //        var widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: thisView, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
        //        var yConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: thisView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //        var xConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: thisView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        //        thisView.addConstraint(xConstraint)
        //        thisView.addConstraint(heightConstraint)
        //        thisView.addConstraint(widthConstraint)
        //        thisView.addConstraint(yConstraint)
        //        thisView.addConstraint(xConstraint)
        //        thisView.addConstraint(yConstraint)
    }
    
    func reSetImage(view: UIView, imageViews: [UIImageView]) {
        
        var selfWidth = view.bounds.width/3
        var selfHeight = selfWidth*87/57
        var gap = selfWidth/4
        var yCor = (view.bounds.height - selfHeight)/2
        if selfHeight > view.bounds.height {
            selfHeight = view.bounds.height
            selfWidth = selfHeight*57/87
            gap = selfWidth/4
            yCor = (view.bounds.height - selfHeight)/2
        }

        var count = 0
        for imageView in imageViews {
            imageView.frame = CGRectMake(gap*CGFloat(count), yCor, selfWidth, selfHeight)
            count++
        }
    }

    func dealerAddCard() {
    
        if dealerCards!.count < 2 {
            var card1 = shoe!.cards.removeLast()
            firstCard = card1
            var card2 = shoe!.cards.removeLast()
            secondCard = card2
            dealerCards!.append(card1)
            dealerCards!.append(card2)
            var imageView = UIImageView()
            imageView.image = UIImage(named: "cardBack.png")
            addImageInView(dealerView, imageView: imageView, count: 0)
            addImageInView(dealerView, imageView: card2.cardImageView, count: 1)
            dealerCardImages.append(imageView)
            dealerCardImages.append(card2.cardImageView)
        } else {
            var card = shoe!.cards.removeLast()
            dealerCards!.append(card)
            var count = dealerCards!.count - 1
            addImageInView(dealerView, imageView: card.cardImageView, count: count)
            dealerCardImages.append(card.cardImageView)
        }
        cardLeft()
    }
    
    func playerAddCard() {
        
        if playerList[playID].hands[0].cards.count < 2 {
            var card1 = shoe!.cards.removeLast()
            var card2 = shoe!.cards.removeLast()
            playerList[playID].hands[0].cards.append(card1)
            playerList[playID].hands[0].cards.append(card2)
            playerImages.append(card1.cardImageView)
            playerImages.append((card2.cardImageView))
            addImageInView(playerView, imageView: card1.cardImageView, count: 0)
            addImageInView(playerView, imageView: card2.cardImageView, count: 1)
            playerCardImages.append(card1.cardImageView)
            playerCardImages.append(card2.cardImageView)
        } else {
            var card = shoe!.cards.removeLast()
            playerList[playID].hands[0].cards.append(card)
            var count = playerList[playID].hands[0].cards.count - 1
            playerImages.append(card.cardImageView)
            addImageInView(playerView, imageView: card.cardImageView, count: count)
            playerCardImages.append(card.cardImageView)
        }
        cardLeft()
        recommend()
    }
    
    func AIPlay() {
        
        playerAddCard()
        while playerList[playID].hands[0].sumHand() <= 21 {
            if recommendLabel.text == "Advice: Hit" {
                hitButtonPressed(hitButton)
                println("Hit once")
                if playerList[playID].hands[0].sumHand() > 21 {
                    bustButtonPressed(bustButton)
                    println("Bust once")
                    println("---------")
                    break
                }
            }
            else if recommendLabel.text == "Advice: Stand"{
                stayButtonPressed(stayButton)
                println("Stay once")
                println("---------")
                break
            }
        }
    }
    
    func nextPlayer() {
        
        playID++
        
        for image in playerImages {
            image.removeFromSuperview()
        }
        if playID >= playerNum {
            playID = 0
            endGame()
        } else {
            showCurrentPlayer()
            if playID == 1 && AIPlayer == true {
                AIPlay()
            }
            else {
                playerAddCard()
            }
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
    
    func endGame(){
        
        
        for i in 0..<dealerCards!.count {
            if i == 0 {
                addImageInView(dealerView, imageView: firstCard.cardImageView, count: i)
                dealerCardImages[0].removeFromSuperview()
                dealerCardImages[0] = firstCard.cardImageView
            } else {
                addImageInView(dealerView, imageView: dealerCards![i].cardImageView, count: i)
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
    }
    
    
    @IBAction func stayButtonPressed(sender: AnyObject) {
        
        
        if isBlackJack(playerList[playID].hands[0].cards) {
            playerList[playID].hands[0].score = 22
        } else {
            playerList[playID].hands[0].score = playerList[playID].hands[0].sumHand()
        }
        nextPlayer()
    }
    
    @IBAction func againButtonPressed(sender: AnyObject) {
        
        dealerScoreLabel.text = ""
        recommendLabel.text = ""
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
            dealerCardImages.removeAll(keepCapacity: true)
            playerCardImages.removeAll(keepCapacity: true)
            for image in cardImages {
                image.removeFromSuperview()
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
        
        var betMoney = Int(moneySlider.value)
        playerList[playID].hands[0].bet = betMoney
        playerList[playID].money -= betMoney
        playID++
        if playID == 1 && AIPlayer == true {
            playID = 0
            playerList[1].hands[0].bet = playerList[1].money / 10
            playerList[1].money -= playerList[1].hands[0].bet
            startPlay()
        } else if playID >= playerNum {
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        dispatch_async(dispatch_get_main_queue()) {

            self.reSetImage(self.dealerView, imageViews: self.dealerCardImages)
            self.reSetImage(self.playerView, imageViews: self.playerCardImages)
        }
    }
}

