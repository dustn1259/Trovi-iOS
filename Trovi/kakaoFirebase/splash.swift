//
//  splash.swift
//  kakaoFirebase
//
//  Created by swuad_33 on 20/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import SwiftyGif

class splash: UIViewController, SwiftyGifDelegate {
    
    
    @IBOutlet weak var img_gif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        do {
//            let gif = try UIImage(gifName: "스플래시")
//            self.img_gif.setGifImage(gif)
//            self.img_gif.loopCount = 1
//            self.img_gif.startAnimating()
//            self.img_gif.delegate = self
//        } catch {
//            print("gif 없음")
//        }
    }
    
    func gifDidStop(sender: UIImageView) {
        NSLog("gif stop will move to second View")
        let secondVC = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        secondVC.modalPresentationStyle = .fullScreen
        present(secondVC, animated: true, completion: nil)
    }
}
