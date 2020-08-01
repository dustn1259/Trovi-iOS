//
//  TableViewController.swift
//  kakaoFirebase
//
//  Created by swuad_38 on 15/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//
//
//import UIKit
//import FirebaseAuth
//import FirebaseUI
//import FirebaseDatabase
//import CodableFirebase
//
//
//class profileTableView: UITableViewController  {
//    
//    var dbRef:DatabaseReference!
//
//    var data:[Diary] = []
//    var diary_data:Diary?
//
////    var Data = [
////        ["Name":"How To Use Firebase Crashlytics In Swift 4", "DepartureDate": "2020-2-11","ArriveDate":"2020-2-14","ImageName":"1"],
////        ["Name":"How To Use Firebase Crashlytics In Swift 4", "DepartureDate": "2020-2-10","ArriveDate":"2020-2-16","ImageName":"0"]]
////
//
//
//
//    //TableView Methods
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "profilecell", for: indexPath) as! TableViewCell
//        let IndexPath = data[indexPath.row]
//
//        cell.titleLabel.text = self.data[indexPath.row].title
//         let date_home = NSDate(timeIntervalSince1970: self.data[indexPath.row].date!) as Date
//        //timeInterval -> Date 객체로 변환
//
//        cell.userNameLabel.text = self.data[indexPath.row].uid
//        cell.hashtagLabel.text = self.data[indexPath.row].hashtag
//
//        cell.standardnum.text = self.data[indexPath.row].count
//
//
//
//
//        //date formater 만들기
//        let date_formatter_home = DateFormatter()
//        date_formatter_home.dateFormat = "yyyy-MM-dd, hh:mm a"
//
//
//      //  cell.departureLabel?.text = date_formatter_home.string(from: date)
////        cell.departureLabel.text = IndexPath["DepartureDate"]
////        cell.arriveLabel.text = IndexPath["ArriveDate"]
////        cell.userImage.image = UIImage(named: IndexPath["ImageName"]!)
//        return cell
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //self.navigationController?.navigationBar.isHidden = true
//        dbRef = Database.database().reference()
//        getData()
//
//
//    }
//
//    func getData() {
//        //데이터 불러오기
//        if let userID = Auth.auth().currentUser?.uid {
//            let postRef = dbRef.child("diary")
//            postRef.observeSingleEvent(of: .value){
//                (snapshot) in
//                debugPrint(snapshot.value)
//                let users = snapshot.children.allObjects as! [DataSnapshot]
//                for user in users {
//                    let diaries = user.children.allObjects as! [DataSnapshot]
//
//                    for diary in diaries {
//                        let record = try! FirebaseDecoder().decode(Diary.self, from: diary.value)
//                        self.data.append(record)
//                    }
//                }
//                self.tableView.reloadData()
//            }
//            //시간순 정렬코드 queryOrdered~~.
//
//
//            }
//        }
//
//
//}
