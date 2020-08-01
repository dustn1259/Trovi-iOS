//
//  Profile.swift
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

class Profile:UIViewController,UITableViewDataSource,FUIAuthDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var user_data:User?
    var dbRef:DatabaseReference!
    var spinner = SpinnerViewController()
      //이미지를 저장할 스토리지 생성
    let storage = Storage.storage()
    
     
    let picker = UIImagePickerController()
    var user = Auth.auth().currentUser
      
    var data:[Diary] = []
    var diary_data:Diary?
    
            

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
 

    
    override  func viewDidLoad() {
        //데이터베이스 연결초기화
       dbRef = Database.database().reference()
        super.viewDidLoad()
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        getData()
        setContent()
    
        self.tableView.rowHeight = 150
        self.navigationItem.title = "프로필"
        
    }
    
    
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.data.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "profilecell", for: indexPath) as! profileTableCell
                  
        let IndexPath = data[indexPath.row]
                  
                  cell.profilecellTitle.text = self.data[indexPath.row].title
                   let date_home = NSDate(timeIntervalSince1970: self.data[indexPath.row].date!) as Date
                  //timeInterval -> Date 객체로 변환
                  
//                  cell.profilecellName.text = self.data[indexPath.row].uid
                  cell.profilecellHashtag.text = self.data[indexPath.row].hashtag
               
                  cell.profilecellStandardCount.text = self.data[indexPath.row].count
        
                  //date formater 만들기
                  let date_formatter_home = DateFormatter()
                  date_formatter_home.dateFormat = "yyyy-MM-dd, hh:mm a"
                  
                  
                //  cell.departureLabel?.text = date_formatter_home.string(from: date)
          //        cell.departureLabel.text = IndexPath["DepartureDate"]
          //        cell.arriveLabel.text = IndexPath["ArriveDate"]
          //        cell.userImage.image = UIImage(named: IndexPath["ImageName"]!)
                  return cell
      }
      

    @IBOutlet weak var PProfileImage: UIImageView!
    @IBOutlet weak var Namelabel: UILabel!
    @IBOutlet weak var email: UILabel!

    
    
    
    func setContent(){
        self.Namelabel.text = user?.displayName
        self.email.text = user?.email
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
            self.setProfileImage(image_url)
        }
    }
    
    
    func setProfileImage(_ image_url:String) {
        var imageView = UIImageView()
        
        let url = URL(string: image_url)
        let processor = DownsamplingImageProcessor(size: self.PProfileImage.bounds.size)
                     >> RoundCornerImageProcessor(cornerRadius: 20)
        self.PProfileImage.kf.indicatorType = .activity
        self.PProfileImage.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
        
    @IBAction func LogoutBtn(_ sender: Any) {
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
    
    
 
    
    @IBAction func ChangeImage(_ sender: UIButton) {
        let alert =  UIAlertController(title: "프로필 이미지", message: "프로필 사진 바꾸기", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
        picker.sourceType = .camera
                    present(picker, animated: false, completion: nil)
                }
                else{
                    print("Camera not available")
                }
     
        
    }
 
}

extension Profile: UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :
        Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    PProfileImage.image = image
            //스토리지에 저장된다.
            guard let userID = Auth.auth().currentUser?.uid else
                              {return} //uid받아옴
            guard let profile_key = dbRef.child("profile/\(userID)/").childByAutoId().key else
            {
                NSLog("error")
                return
            }
             let path = "/profile/\(userID)/"
            var post:[String:Any] = [
                                  "uid":userID ]
            //storage 저장
            let storageRef = storage.reference()
                                     let imageRef = storageRef.child("profile/images/\(image)/post_image.jpg") //storage생성
                                     
                                     //선택한 이미지의 jpeg 데이터를 뽑아낼 수 있을 때
                                     
                                     if let imageData = image.jpegData(compressionQuality: 1) {
                                         //1 : 불러온 데이터가 있다
                                         let metadata = StorageMetadata()
                                         metadata.contentType = "image/jpeg"
                                         //업로드 시작 (storage)
                                      _ = imageRef.putData(imageData,metadata: metadata) {
                                             (metadata, error) in
                                        //storage 생성 ->한것
                                        //storage ->database 할걳
                                        //database 내용 불러오기 할것
                                        NSLog("File upload complete")
                                          guard metadata != nil else {return}
                                             imageRef.downloadURL{
                                                 (url, error) in
                                                NSLog("get fileurl")
                                                // 어떻게 가지고 올지 결정
                                                // uid/
                                                // profile_image_url = "asdfasdf"
                                                // 어떻게 올려둘지
                                                // ui/profile_image_url
                                                //
                                                guard let downloadURL = url else {return}
                                                post["image_url"] = downloadURL.absoluteString
                                                //데이터베이스에 저장하기
                                                //url을 storageurl => database에 넣기
                                                NSLog("post")
                                                self.postUpload(path, post)
                                                 //diary 데이터 작성 후 데이터베이스에 추가하기
                                                
                                          
                                                
                             }
            //데이터베이스에서 스토리지 주소를 불러온다
            //불로온 데이터를 보여준다.
}
}
            
        }
        dismiss(animated: true, completion: nil)
}
      func postUpload(_ path:String, _ post:[String:Any]) {
          dbRef.child(path).setValue(post) {
          (error, ref) in
              if let error = error {
              NSLog(error.localizedDescription)
              return
              }
//              //목록 화면으로 돌아가기
//              let destination = self.storyboard?.instantiateViewController(withIdentifier: "list") as! DiaryList
//              self.navigationController?.pushViewController(destination, animated: true)
            
              
              //전 화면으로 돌아가기
              //1.네비게이션 컨트롤러
             // self.navigationController?.popViewController(animated: true)
              //2. present()로 덮어졌을 때 :
              //self.dismiss(animated: true)
          }
      
      }
    
}

