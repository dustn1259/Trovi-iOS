//
//  UploadController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 09/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit

class UploadController:UIViewController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
    @IBOutlet weak var AddressBtn: UILabel!

 
    @IBAction func MapBtn(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "mapnavigation") as! UINavigationController //컨트롤러 연결할때 쓰는 코드
   
              //self.navigationController?.pushViewController(destination, animated: true)
        destination.modalPresentationStyle = .fullScreen //보여주는 스타일 바꾸는 코드 (show/modal같은거)
        destination.delegate = self
        self.present(destination, animated: true, completion: nil)
              
               
    }
    
    
    
}
