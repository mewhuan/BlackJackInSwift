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
    
    @IBOutlet weak var playWithATButton: UIButton!
    @IBOutlet weak var playWithFriendButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playwithfriend" {
            let controller = segue.destinationViewController as ViewController
            controller.AIPlayer = false
        }
        else if segue.identifier == "playwithai" {
            let controller = segue.destinationViewController as ViewController
            controller.AIPlayer = true
        }
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
