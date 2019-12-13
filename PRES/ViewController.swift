//
//  ViewController.swift
//  PRES
//
//  Created by Nikita on 22/11/2019.
//  Copyright © 2019 Radon Code. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var backgroundDark: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Function to show that if the CardViewController is presented, the background UI becomes unresponsive
    @IBAction func changeBackgeound (_ sender: UIButton) {
        backgroundDark = !backgroundDark
        view.backgroundColor = backgroundDark ? .lightGray : .white
    }
    
    // Present the CardViewController over current ViewController
    @IBAction func presentAction(_ sender: UIButton) {
        let cardVC = CardViewController()
        cardVC.modalPresentationStyle = .overCurrentContext
        cardVC.modalTransitionStyle = .coverVertical
        present(cardVC, animated: true, completion: nil)
    }

}

