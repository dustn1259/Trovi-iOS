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
import SwiftUI


class SearchViewController :UIViewController,UITableViewDataSource,FUIAuthDelegate, UISearchBarDelegate {
    // tableViewCell의 데이터소스를 뷰 컨트롤러랑 연결한 후 UITableVIewDataSource 써주고 error메시지 뜨면 fix 누르기
    //firebaseui import하고 fuiauthdelegate추가
    
    var dbRef:DatabaseReference!
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var original_data:[Diary] = []
    var filtered_data:[Diary] = []
    
    
    // 테이블 뷰에 보여질 기본 데이터
    var data:[DataSnapshot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        dbRef = Database.database().reference()
        self.tableView.rowHeight = 150
        getData()
    }
    
    @IBAction func leftBtn(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered_data.count //업로드 한만큼 테이블 뷰 셀 설정됨
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for : indexPath) as! searchCell
        var column_data = self.filtered_data[indexPath.row]
        
        cell.titles?.text = "\(column_data.title!)"
        //timeInterval -> Date 객체로 변환
        let date = NSDate(timeIntervalSince1970: column_data.date!) as Date
//        let date_arrival = NSDate(timeIntervalSince1970: column_data.date_arrival!) as Date
        //date formater 만들기
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy-MM-dd, hh:mm a"
        cell.standardNum.text = self.filtered_data[indexPath.row].count
        
     
        
  
        //timeInterval -> Date 객체로 변환
      
        
        
        let date_formatter_home = DateFormatter()
              date_formatter_home.dateFormat = "yyyy-MM-dd"
              
              let date_formatter_arrival = DateFormatter()
              date_formatter_arrival.dateFormat = "yyyy-MM-dd"
        
              cell.meetDate?.text = date_formatter_home.string(from: date)
//              cell.byeDate.text = date_formatter_arrival.string(from: date_arrival)
        cell.meetArea.text = self.filtered_data[indexPath.row].meetArea
        cell.hashtag.text = self.filtered_data[indexPath.row].hashtag
        cell.userN.text = self.filtered_data[indexPath.row].uid
        
        cell.meetArea.layer.masksToBounds = true
        cell.meetArea.layer.cornerRadius = 5
       
//        cell.detailTextLabel?.text = date_formatter.string(from: date)
        
        return cell
    }
    

    
    func getData() {
        //데이터 불러오기
        if let userID = Auth.auth().currentUser?.uid {
            let postRef = dbRef.child("diary")
            postRef.observeSingleEvent(of: .value) { (snapshot) in
                debugPrint(snapshot.value)
                self.original_data = []
                let users = snapshot.children.allObjects as! [DataSnapshot]
                for user in users {
                    let diaries = user.children.allObjects as! [DataSnapshot]
                    
                    for diary in diaries {
                        let record = try! FirebaseDecoder().decode(Diary.self, from: diary.value)
                        self.original_data.append(record)
                    }
                    
                }
                self.filtered_data = self.original_data
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 서치바에 있는 취소 버튼을 눌렀을 때
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        //go home
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "mainTrovi") as! TableViewController
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //사용자ㅣ가검색어를 입력하ㅐㅅ을때
        // 원본 데이터에서 필터링한 결과를 적용하기
        NSLog(searchText)  // 검색어임
        // 원본데이터에소 검색오를 포함한 데이터만 filtered_data에할당하기
        if searchText == "" {
            self.filtered_data = self.original_data
        } else {
            self.filtered_data = self.original_data.filter({ (diary) -> Bool in
                return diary.title?.contains(searchText) ?? false
            })
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue : UIStoryboardSegue, sender:Any?) {
        NSLog("화면 전환 전")
        // 다음 화면으로 어떤 데이터를 전달할지 실행
        // 데이터는 다음 나타날 화면의 인스턴스에 세팅한다.
        guard let destination = segue.destination as? DiaryDetailViewController else {return}
        //print(self.tableView.indexPathForSelectedRow?.row) //몇번셀을 선택했는지 print
        let index = self.tableView.indexPathForSelectedRow!.row
        destination.diary_data = self.filtered_data[index]
    }
}

