//
//  MyChatViewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 14/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import Alamofire
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase
import FirebaseStorage
import Eureka
import Kingfisher

class MyChatViewController:UIViewController,UITableViewDataSource,FUIAuthDelegate, UISearchBarDelegate {
        // tableViewCell의 데이터소스를 뷰 컨트롤러랑 연결한 후 UITableVIewDataSource 써주고 error메시지 뜨면 fix 누르기
        //firebaseui import하고 fuiauthdelegate추가
        
        var dbRef:DatabaseReference!
        
    
        @IBOutlet weak var tableView: UITableView!
        //만들어놓은 구조체 Diary를 이용해 배열을 만들어줌
       var data:[String] = []
        
        
        override func viewDidLoad() {
             super.viewDidLoad()
             dbRef = Database.database().reference()
            getData()
            //Auth.auth().addStateDidChangeListener {(auth, user) in
                /*
                if let user = user {
                    //로그인 한 상태
                    self.navigationItem.leftBarButtonItem?.title = "Logout"
                } else {
                    self.navigationItem.leftBarButtonItem?.title = "Login"
                }
            
            }
     */
         }
        
        

        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.data.count //업로드 한만큼 테이블 뷰 셀 설정됨
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatListCell", for : indexPath)
            cell.textLabel?.text = self.data[indexPath.row]
            //timeInterval -> Date 객체로 변환
            //date formater 만들기
            return cell
        }
        
  
        
          func getData() {
              if let userID = Auth.auth().currentUser?.uid {
                NSLog("1")
                let userRef = self.dbRef.child("chat").child("\(userID)/")
                 NSLog("2")
                NSLog("\(userID)/")
                  let refHandle = userRef.observe(DataEventType.value) {(snapshot) in
                     NSLog("3")
                    debugPrint(snapshot)
                    let chat_list = snapshot.children.allObjects as! [DataSnapshot]
                     NSLog("4")
                    for chat in chat_list {
                        self.data.append(chat.value as! String)
                    }
                     NSLog("5")
                      self.tableView.reloadData()
                  }
              }
          }
     
    
}


