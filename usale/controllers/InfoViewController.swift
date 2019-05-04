//
//  InfoViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/30/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class InfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About Us"
        
    }
    @IBAction func playVideo(_ sender: Any) {
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
}
