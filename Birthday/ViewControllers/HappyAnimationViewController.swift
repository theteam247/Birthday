//
//  HappyAnimationViewController.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit
import AVFoundation

class HappyAnimationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var happyLabel: UILabel!
    
    var player: AVAudioPlayer?
    
    // MARK: - Life Cycle

    static func storyboardInstance() -> HappyAnimationViewController?{
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as?  HappyAnimationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.loadGif(name: "happy")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playSound()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopPlaySound()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Interaction Event Handler

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Private Method

    func playSound() {
        if let url = Bundle.main.url(forResource: "happy", withExtension: "m4a") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
                player.prepareToPlay()
                player.numberOfLoops = 10
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
        
    }
    func stopPlaySound() {
        guard let player = player else { return }
        player.stop()
        self.player = nil
    }
}
