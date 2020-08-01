//
//  ViewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 06/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import Alamofire
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase
import NMapsMap
import GoogleMaps

class ViewController: UIViewController,FUIAuthDelegate{
 
    let authUI = FUIAuth.defaultAuthUI()
    let token_url = "https://us-central1-kakaologin-b6613.cloudfunctions.net/getJWT"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(kakaoSessionChange), name: NSNotification.Name.KOSessionDidChange, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        //1. 지도의 중앙을 어디로 할 것이냐?
        //let coor = NMFLocationManager.locationUpdateAuthorization(self)
        
        
           }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         if let user = Auth.auth().currentUser {
                    
                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabView") as! UITabBarController
                   // NSLog(user.uid)
                    mainViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(mainViewController, animated: true)
                    
                    
                } else {
                    //로그인 하지않으면? 어쩌구
                let providers:[FUIAuthProvider] = [
                    FUIGoogleAuth(),
                    FUIFacebookAuth(),
                    FUIKakaoAuth()
                ]
                
                self.authUI!.providers = providers
                self.authUI?.delegate = self
                
                // 밑에 두 줄 수정 될 예정
        //        let authViewController = self.authUI!.authViewController()
                let authViewController = customAuthViewController(authUI: self.authUI!)
                authViewController.modalPresentationStyle = .fullScreen
                
                self.present(authViewController, animated: true, completion: nil)
                }
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            NSLog(error.localizedDescription)
            return
        }
        if let user = Auth.auth().currentUser {
            let user_id = user.uid
            var ref = Database.database().reference()
            ref.child("users").child(user_id).observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let value = snapshot.value {
                    do {
                        let user = try FirebaseDecoder().decode(UserClass.self, from: value)
                        NSLog("정보 있음")
                        dump(user)
                    } catch let error {
                        NSLog(error.localizedDescription)
                        NSLog("추가 정보 입력 필요")
                        let currentUser = Auth.auth().currentUser
                        currentUser?.displayName
                        currentUser?.email
                        
                        
                        let user = UserClass(name:"test", email:"test@test.com")
                        let data = try! FirebaseEncoder().encode(user)
                        ref.child("users").child(user_id).setValue(data)
                    }
                }
            }) {
                (error) in NSLog(error.localizedDescription)
            }
        }
    }
           
           @objc func kakaoSessionChange() {
               guard let isOpened = KOSession.shared()?.isOpen() else {
                   return
               }
               if isOpened{
                NSLog("로그인 상태")
                //1.uid찾아내기
                KOSessionTask.userMeTask{(error, user_me) in
                    if let user = user_me {
                        NSLog("\(user.id!)")
                        let login_info = TokenInfo(uid: user.id!)
                        AF.request(self.token_url, method:.post, parameters: login_info,
                                   encoder:URLEncodedFormParameterEncoder(destination: .httpBody)).responseJSON{(response) in
                                    debugPrint(response)
                                    debugPrint(response.data)
                                    do{
                                        //functions를 이용해 받아온 토큰 피싱
                                        let token_data = try JSONDecoder().decode(JWT.self,from: response.data!)
                                        if token_data.error! == false {
                                            NSLog(token_data.jwt!)
                                            //토큰으로 파이어베이스로그인
                                            Auth.auth().signIn(withCustomToken: token_data.jwt!)
                                            { (result, error) in
                                                if let error = error {
                                                    NSLog("로그인 실패")
                                                } else {
                                                    NSLog("파이어 베이스 로그인 성공 ")
                                                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                          changeRequest?.displayName = user.account!.profile?.nickname
                                                    
                                                    changeRequest?.commitChanges{(error) in
                                                        guard let error = error else {
                                                            
                                                            return}
                                                        
                                                        NSLog(error.localizedDescription)
                                                    }
                                                    
                                                    if let current_user =
                                                        Auth.auth().currentUser ,
                                                        let email = user.account!.email{ current_user.updateEmail(to: user.account!.email!) { (error) in
                                                            if let error = error {
                                                                NSLog("email update error")
                                                            } else {
                                                                NSLog("email update complete")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }catch {
                                        NSLog(error.localizedDescription)
                                    }
                        }
                    }
                }
                //2.jwt토큰 받아오기
                //3.Firebase에 로그인시키기
               } else {
                   NSLog("로그아웃 상태")
               }
           }
    
    @IBAction func LogoutBtn(_ sender: Any) {
        guard let session = KOSession.shared() else {
                     return
                 }
              session.logoutAndClose{
                  (success, error) in
                  if success {
                      NSLog("로그아웃성공")
                  } else {
                      debugPrint(error?.localizedDescription)
                  }
              }
    }
    
    @IBAction func PrintUser(_ sender: Any) {
        guard let session = KOSession.shared() else {
                  return
              }
              if session.isOpen(){
                  KOSessionTask.userMeTask{(error, Kouserme) in
                      if let me = Kouserme {
                          if let email = me.account!.email {
                              NSLog(email)
                          } else if(me.account!.emailNeedsAgreement) {
                              NSLog("동의 필요")
                              
                          }
                      }
              }
              }else {
                  NSLog("로그아웃 상태")
              }
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        guard let session = KOSession.shared() else {
                return
            }
            if session.isOpen(){
                session.close()
            }
            session.open(completionHandler: {
                (error) -> Void in
                if !session.isOpen() {
                dump(error?.localizedDescription)
            }
            })
        }
    
    
    

    
    


        
    }


