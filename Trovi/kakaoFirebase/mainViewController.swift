//
//  mainViewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 07/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase



class mainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    
    @IBAction func GoLogout(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        do {
            try Auth.auth().signOut()
            NSLog("로그아웃 성공")
        } catch{
            NSLog("로그아웃 실패")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.modalPresentationStyle = .fullScreen
        
    }

    
}


