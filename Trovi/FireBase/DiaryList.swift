//
//  DiaryList.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 10/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import CodableFirebase

class DiaryList:UIViewController,UITableViewDataSource,FUIAuthDelegate {
    // tableViewCell의 데이터소스를 뷰 컨트롤러랑 연결한 후 UITableVIewDataSource 써주고 error메시지 뜨면 fix 누르기
    //firebaseui import하고 fuiauthdelegate추가
    
    var dbRef:DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    //만들어놓은 구조체 Diary를 이용해 배열을 만들어줌
    var data:[Diary] = []
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var leftBtn = self.navigationItem.leftBarButtonItem
        //self.navigationItem.leftBarButtonItem?.title = "<"
        leftBtn?.title = "<"
 
    }
    

    @IBAction func leftBtn(_ sender: Any) {
//        let destination_h = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! TableViewController
//         self.navigationController?.pushViewController(destination_h, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count //업로드 한만큼 테이블 뷰 셀 설정됨
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for : indexPath)
        cell.textLabel?.text = self.data[indexPath.row].title
        //timeInterval -> Date 객체로 변환
        let date = NSDate(timeIntervalSince1970: self.data[indexPath.row].date!) as Date
        //date formater 만들기
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy-MM-dd, hh:mm a"
        cell.detailTextLabel?.text = date_formatter.string(from: date)
        return cell
    }
    

    
    func getData() {
        //데이터 불러오기
        if let userID = Auth.auth().currentUser?.uid {
            let postRef = dbRef.child("diary").child("\(userID)")
            //시간순 정렬코드 queryOrdered~~.
            let refHandle = postRef.queryOrdered(byChild: "date").observe(DataEventType.value) {(snapshot) in
                
                let snapshot_data = snapshot.children.allObjects as! [DataSnapshot]
                for diary in snapshot_data {
                    let diary = try! FirebaseDecoder().decode(Diary.self, from: diary.value)
                    self.data.append(diary)
                }
  
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue : UIStoryboardSegue, sender:Any?) {
        NSLog("화면 전환 전")
        // 다음 화면으로 어떤 데이터를 전달할지 실행
        // 데이터는 다음 나타날 화면의 인스턴스에 세팅한다.
        guard let destination = segue.destination as? DiaryDetailViewController else {return}
        //print(self.tableView.indexPathForSelectedRow?.row) //몇번셀을 선택했는지 print
        let index = self.tableView.indexPathForSelectedRow!.row
        destination.diary_data = self.data[index]
    }
    
}
