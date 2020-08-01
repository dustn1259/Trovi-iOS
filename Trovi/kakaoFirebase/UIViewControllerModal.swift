//
//  UIViewControllerModal.swift
//  kakaoFirebase
//
//  Created by 손예린 on 2020/01/20.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import ObjectiveC


public extension UIViewController {
    
    @IBAction func modalDismiss(sender : AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modalDismissPush(sender : AnyObject){
        var destVC : UIViewController! = nil
        if let presentingVC = self.presentingViewController as? UITabBarController {
            if let tempVC = presentingVC.selectedViewController as? UINavigationController {
                destVC = tempVC.topViewController
            } else {
                destVC = self.presentingViewController
            }
        } else if let presentingVC = self.presentingViewController as? UINavigationController {
            destVC = presentingVC.topViewController
        } else {
            destVC = self.presentingViewController
        }
        
        destVC.performSegue(withIdentifier: "ModalDismissPush", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigationBack(sender : AnyObject){
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        }
    }

    @IBAction func navigationBackToRoot(sender : AnyObject){
        if self.navigationController != nil {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
