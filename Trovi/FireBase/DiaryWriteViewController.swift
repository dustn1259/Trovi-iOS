//
//  DiaryArrayVIewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 10/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import Eureka

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore

class DiaryWriteViewController:FormViewController {
    var dbRef:DatabaseReference!
    var spinner = SpinnerViewController()
    //이미지를 저장할 스토리지 생성
    let storage = Storage.storage()
    
    private let db = Firestore.firestore()
    
    private var channelReference: CollectionReference {
      return db.collection("channels")
    }
    
    
    @IBOutlet weak var uploadbtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터베이스 연결 초기화
        dbRef = Database.database().reference()
        
        
        
        self.navigationController?.navigationBar.topItem?.title = "" //공백 만들어서 back글자 지우게
        form +++ Section("")
            <<< TextRow() { row in
                row.tag = "title"
                row.title = "제목"
                row.placeholder = "제목을 입력하세요."
        }
            <<< DateRow() {
                $0.tag = "date"
                $0.value = Date()
                $0.title = "모임 시작"
        }
            
            <<< DateRow() {
                           $0.tag = "date_arrival"
                           $0.value = Date()
                           $0.title = "모임 종료"
                   }
            
        
            +++ Section(" ")
                <<< ImageRow() {
                    $0.tag = "image"
                    $0.title = "사진"
                    
            }
            
        +++ Section("일기 내용")
            <<< TextAreaRow("내용") {
                $0.tag = "content"
                $0.placeholder = "모임 상세 내용 입력"
                $0.textAreaHeight = .dynamic(initialTextViewHeight:60)
        }
        
        +++ Section("해시태그")
                   <<< TextAreaRow("해시태그를 입력하세요") {
                       $0.tag = "hashtag"
                       $0.placeholder = "해시태그 입력"
                       $0.textAreaHeight = .dynamic(initialTextViewHeight:25)
               }
        
        +++ Section("인원 수")
            <<< ActionSheetRow<String>() {
                $0.tag = "count"
                $0.title = "인원 수"
                $0.selectorTitle = "여행을 동행할 인원수를 입력하세요"
                $0.options = ["1","2","3","4","5","6","7","8"]
                $0.value = "1"    // initially selected
            }
        
        +++ Section("모임 위치 지정")
        <<< ButtonRow("지도") { (row: ButtonRow) in
            row.title = row.tag
            //row.presentationMode = .SegueName(segueName: "AccesoryViewControllerSegue", completionCallback: nil)
        }
        .onCellSelection({ (cell, row) in
//            self.performSegue(withIdentifier: "mapnavi", sender: self)
           
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapnavigation") as! UINavigationController
            guard let mapVC  = vc.viewControllers[0] as? Maps else {return}
            mapVC.delegate = self
            self.present(vc, animated: true, completion: nil)
            
        })
        
            <<< LabelRow { row in
                row.title = "모임 위치"
                row.tag = "meetArea"
                row.value = "\(Maps().address)" as String
        }
        
    }
    
    @IBAction func leftBtn(_ sender: UIButton) {
        self.navigationController?.navigationBack(sender: self)
    }
    
//    @objc func backAction(){
//        //print("Back Button Clicked")
//        self.tabBarController?.selectedIndex = 0
//    }
    
  /*
    func createChat(_ name:String) {
             let channel = Channel(name: name)
             var ref: DocumentReference? = nil
             ref = channelReference.addDocument(data: channel.representation) { error in
               if let e = error {
                 print("Error saving channel: \(e.localizedDescription)")
               } //채널만들기가 끝났을 때
                 print(ref?.documentID)
                 self.dbRef = Database.database().reference()
                 guard let userID = Auth.auth().currentUser?.uid else {return} //uid받아옴
                 guard let chat_key = self.dbRef.child("chat/\(userID)/").childByAutoId().key else {return}
                 self.dbRef.child(chat_key).setValue(ref?.documentID) { }
                
                 
                 //데이터베이스에 넣어준다 (user밑에)
             }
         }*/
         
    
    @IBAction func doUpload(_ sender: Any) {
        NSLog("된다")
        if let title_row = form.rowBy(tag: "title") as? TextRow,
                   let date_row = form.rowBy(tag: "date") as? DateRow,
            let date_row_arrival = form.rowBy(tag: "date_arrival") as? DateRow,
                   let image_row = form.rowBy(tag: "image") as? ImageRow,
                   let content_row = form.rowBy(tag: "content") as? TextAreaRow,
            let hashtag_row = form.rowBy(tag: "hashtag") as? TextAreaRow,
            let count_row = form.rowBy(tag: "count") as? ActionSheetRow<String>,
            let meet_row = form.rowBy(tag:  "meetArea") as? LabelRow{
                   print(title_row.value ?? "", date_row.value ?? "")
                    //있으면 이거 없으면 이거
                   let timestamp = date_row.value?.timeIntervalSince1970
            
            let timestamp_arrival = date_row_arrival.value?.timeIntervalSince1970
            
            guard let userID = Auth.auth().currentUser?.uid else
                   {return} //uid받아옴
          
                
                   //키 값 만들기
                   guard let key = dbRef.child("diary/\(userID)/").childByAutoId().key else
                   {
                       NSLog("error")
                       return
                   }
                   let path = "/diary/\(userID)/\(key)"
                   //저장
                   //이미지를 저장할 경우와 그렇지 않을 경우를 분리해줌
                showSpinner()
                   var post:[String:Any] = [
                    "uid": userID ?? "",
                       "title": title_row.value ?? "",
                       "date": timestamp ?? TimeInterval(),
                       "content": content_row.value ?? "",
                    "hashtag":hashtag_row.value ?? "",
                    "count":count_row.value ?? "",
                    "meetArea":meet_row.value ?? "",
                    "date_arrival": timestamp_arrival ?? TimeInterval()
                   ]
                   if let image = image_row.value {
                       let storageRef = storage.reference()
                       let imageRef = storageRef.child("diary/images/\(key)/post_image.jpg")
                       
                       //선택한 이미지의 jpeg 데이터를 뽑아낼 수 있을 때
                       
                       if let imageData = image.jpegData(compressionQuality: 1) {
                           //1 : 불러온 데이터가 있다
                           let metadata = StorageMetadata()
                           metadata.contentType = "image/jpeg"
                           //업로드 시작
                        _ = imageRef.putData(imageData,metadata: metadata) {
                               (metadata, error) in
                            guard metadata != nil else {return}
                               imageRef.downloadURL{
                                   (url, error) in
                                   //diary 데이터 작성 후 데이터베이스에 추가하기
                                   guard let downloadURL = url else {return}
                                   post["image_url"] = downloadURL.absoluteString
                                   self.postUpload(path, post)
                               }
                           }
                       }
                   } else {
                       //이미지가 없을 때 데이터베이스에 추가하기
                       self.postUpload(path, post)
                   }
                  
               }
       
    }
    
    
   
    func postUpload(_ path:String, _ post:[String:Any]) {
        dbRef.child(path).setValue(post) {
        (error, ref) in
            if let error = error {
            NSLog(error.localizedDescription)
            return
            }
            //목록 화면으로 돌아가기
//            let destination = self.storyboard?.instantiateViewController(withIdentifier: "list") as! DiaryList
//            self.navigationController?.pushViewController(destination, animated: true)
            self.tabBarController?.selectedIndex = 0
            self.hideSpinner()
            
            //전 화면으로 돌아가기
            //1.네비게이션 컨트롤러
           // self.navigationController?.popViewController(animated: true)
            //2. present()로 덮어졌을 때 :
            //self.dismiss(animated: true)
        }
    
    }
    
    func showSpinner(){
        //현재 화면에 스피너 추가
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
    }
    
    func hideSpinner(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
