//
//  TableViewController.swift
//  kakaoFirebase
//
//  Created by swuad_38 on 15/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase
import Eureka
import Kingfisher


class TableViewController: UITableViewController  {
    
    var dbRef:DatabaseReference!
   var delegate:TableViewCell!
    
    @IBOutlet weak var tablecells: TableViewCell!
    var data:[Diary] = []
    var diary_data:Diary?
    
//    var Data = [
//        ["Name":"How To Use Firebase Crashlytics In Swift 4", "DepartureDate": "2020-2-11","ArriveDate":"2020-2-14","ImageName":"1"],
//        ["Name":"How To Use Firebase Crashlytics In Swift 4", "DepartureDate": "2020-2-10","ArriveDate":"2020-2-16","ImageName":"0"]]
//
    
    var Headerview: UIView!
    var NewHeaderLayer: CAShapeLayer!
    
    private let Headerheight : CGFloat = 420
    private let Headercut : CGFloat = 50
    
    private let sections: [String] = ["최근 게시물 목록"]
    
   
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination
//        destination.modalPresentationStyle = .fullScreen
//
        guard let destination = segue.destination as? troviDetailView else {return}
        //print(self.tableView.indexPathForSelectedRow?.row) //몇번셀을 선택했는지 print
        let index = self.tableView.indexPathForSelectedRow!.row
        
        destination.modalPresentationStyle = .fullScreen
        destination.diary_data_trovi = self.data[index]
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //TableView Methods

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! TableViewCell
        let IndexPath = data[indexPath.row]
        
        cell.titleLabel.text = self.data[indexPath.row].title
         let date_home = NSDate(timeIntervalSince1970: self.data[indexPath.row].date!) as Date
        //timeInterval -> Date 객체로 변환
//        let date_arrive = NSDate(timeIntervalSince1970: self.data[indexPath.row].date_arrival!) as Date
        
        cell.userNameLabel.text = self.data[indexPath.row].uid
        cell.hashtagLabel.text = self.data[indexPath.row].hashtag
        cell.standardnum.text = self.data[indexPath.row].count
        cell.meetArea.text = self.data[indexPath.row].meetArea
        setContent()
    
        cell.meetArea.layer.masksToBounds = true
               cell.meetArea.layer.cornerRadius = 5
        
        
        //date formater 만들기
        let date_formatter_home = DateFormatter()
        date_formatter_home.dateFormat = "yyyy-MM-dd"
        
        let date_formatter_arrival = DateFormatter()
        date_formatter_arrival.dateFormat = "yyyy-MM-dd"

        cell.departureLabel?.text = date_formatter_home.string(from: date_home)
//        cell.arriveLabel.text = date_formatter_arrival.string(from: date_arrive)

        return cell
    }
    
    
    
//    @IBAction func Search(_ sender: UIButton) {
//          let destination = self.storyboard?.instantiateViewController(withIdentifier: "gosearch") as! UINavigationController //컨트롤러 연결할때 쓰는 코드
//        
//                   //self.navigationController?.pushViewController(destination, animated: true)
//             destination.modalPresentationStyle = .fullScreen //보여주는 스타일 바꾸는 코드 (show/modal같은거)
//             
//             self.present(destination, animated: true, completion: nil)
//    }
//    

       func setContent(){
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! TableViewCell
        
           guard let current_user = Auth.auth().currentUser else {return}
           let path = "profile/\(current_user.uid)"
           // 1. path를 이용해서 firebase db 에서 프로필 이미지 주소 받아오기
           // ProfileImage.image
           // 2. kingfisher를 이용해서 이미지 적용하기
           //데이터 불러오기
           let profileRef = dbRef.child("profile/\(current_user.uid)")
           let refHandle = profileRef.queryOrdered(byChild: "profile").observe(DataEventType.value) {(snapshot) in
               
               guard let profile_data = snapshot.value as? [String:AnyObject] else {return}
               let image_url = profile_data["image_url"] as! String
              
                         var imageView = UIImageView()
                         
                         let url = URL(string: image_url)
//            let processor = DownsamplingImageProcessor(size: cell.userImage.bounds.size)
//                                      >> RoundCornerImageProcessor(cornerRadius: 20)
//            cell.userImage.kf.indicatorType = .activity
//            cell.userImage.kf.setImage(
//                             with: url,
//                             options: [
//                                 .processor(processor),
//                                 .scaleFactor(UIScreen.main.scale),
//                                 .transition(.fade(1)),
//                                 .cacheOriginalImage
//                             ])
//                         {
//                             result in
//                             switch result {
//                             case .success(let value):
//                                 print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                             case .failure(let error):
//                                 print("Job failed: \(error.localizedDescription)")
//                             }
//                         }
//                     }
       }
    }
       
      
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.UpdateView()
        //self.navigationController?.navigationBar.isHidden = true
        dbRef = Database.database().reference()
        getData()

        
    }
    
  
    
    func getData() {
        //데이터 불러오기
        if let userID = Auth.auth().currentUser?.uid {
            let postRef = dbRef.child("diary")
            postRef.observeSingleEvent(of: .value){
                (snapshot) in
                debugPrint(snapshot.value)
                let users = snapshot.children.allObjects as! [DataSnapshot]
                for user in users {
                    let diaries = user.children.allObjects as! [DataSnapshot]
                    
                    for diary in diaries {
                        let record = try! FirebaseDecoder().decode(Diary.self, from: diary.value)
                        self.data.append(record)
                    }
                }
                self.tableView.reloadData()
            }
            //시간순 정렬코드 queryOrdered~~.
            
             
            }
        }
    
    @IBAction func loggout(_ sender: Any) {
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

    
    func UpdateView() {
        tableView.backgroundColor = UIColor.white
        Headerview = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(Headerview)
        
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        Headerview.layer.mask = NewHeaderLayer
        
        let newheight = Headerheight - Headercut / 2
        tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newheight)
        
        self.Setupnewview()
    }
    func Setupnewview() {
        let newheight = Headerheight - Headercut / 2
        var getheaderframe = CGRect(x: 0, y: -newheight, width: tableView.bounds.width, height: Headerheight)
        if tableView.contentOffset.y < newheight
        {
            getheaderframe.origin.y = tableView.contentOffset.y
            getheaderframe.size.height = -tableView.contentOffset.y + Headercut / 2
        }
        
        Headerview.frame = getheaderframe
        let cutdirection = UIBezierPath()
        cutdirection.move(to: CGPoint(x: 0, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: getheaderframe.height))
        cutdirection.addLine(to: CGPoint(x: 0, y: getheaderframe.height - Headercut))
        NewHeaderLayer.path = cutdirection.cgPath
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.Setupnewview()
//
//        var offset = scrollView.contentOffset.y / 150
//        if offset > -0.5
//        {
//            UIView.animate(withDuration: 0.2, animations: {
//                offset = 1
//                let color = UIColor.init(red: 1, green: 1, blue: 1, alpha: offset)
//
//                UIApplication.shared.statusBarView?.backgroundColor = color
//
//
//            })
//        }
//        else
//        {
//            UIView.animate(withDuration: 0.2, animations: {
//                let color = UIColor.init(red: 1, green: 1, blue: 1, alpha: offset)
//                 UIApplication.shared.statusBarView?.backgroundColor = color
//            })
//        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Tableview Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    @IBAction func homesearchBtn(_ sender: Any) {

    }
    


    
}
    

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
