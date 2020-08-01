//
//  EvaluateController.swift
//  kakaoFirebase
//
//  Created by 손예린 on 2020/01/21.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit

class EvaluateController:UIViewController {
    override func viewDidLoad(){
    super.viewDidLoad()
    }
    @IBAction func btn1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btn5(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
    }
    @IBAction func btn4(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btn3(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func brn2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func StoreBtn(_ sender: UIButton) {
        let alert = UIAlertController(title:"평가가 저장되었습니다.",message:"",preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
