//
//  OpenViewController.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/2/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

//
//  OpenViewController.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/1/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var deckSlider: UISlider!
    @IBOutlet weak var playerNumLabel: UILabel!
    @IBOutlet weak var deckNumLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "play" {
            let controller = segue.destinationViewController as ViewController
            controller.playerNum = Int(playerSlider.value)
            controller.deckNum = Int(deckSlider.value)
        }
    }
    
    @IBAction func showPlayerNumber(sender: UISlider) {
        var number = Int(sender.value)
        playerNumLabel.text = "\(number)"
    }
    @IBAction func showDeckNumber(sender: UISlider) {
        var number = Int(sender.value)
        deckNumLabel.text = "\(number)"
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
