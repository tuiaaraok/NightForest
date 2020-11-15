//
//  MainViewController.swift
//  Night forest
//
//  Created by Айсен Шишигин on 15/11/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import Foundation
import  SpriteKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
           super.viewDidLoad()
//        startButton.setImage(#imageLiteral(resourceName: "start2.png"), for: .normal)
//           if Model.sharedInstance.sound == true {
//            SKTAudio.sharedInstance().playBackgroundMusic(filename: "backgroundMusic.mp3")
//           }
           
       }
    
    @IBAction func startGame(_ sender: UIButton) {
//        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        if let storyboard = storyboard {
            let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
    
       override var prefersStatusBarHidden: Bool {
           return true
       }
       
}
