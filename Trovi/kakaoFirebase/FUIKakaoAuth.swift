//
//  FUIKakaoAuth.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 07/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseUI
import KakaoOpenSDK
 import FirebaseFunctions
import Alamofire
 
class FUIKakaoAuth:NSObject, FUIAuthProvider {
    lazy var functions = Functions.functions(region: "us-central1")
    var providerID: String? = "KakaoTalk"
    
    var shortName: String = "KakaoTalk"
    
    var signInLabel: String = "sign in with KakaoTalk "
    
    var icon: UIImage = UIImage()
    
    var buttonBackgroundColor: UIColor = UIColor(red: 1, green: 217/255.0, blue: 69/255.0, alpha: 1 )
    
    var buttonTextColor: UIColor = .black
    var _presentingViewController:UIViewController?
    // 카카오 로그인 설정 - developers.kakao.com에 앱추가
    // Info.plist - KAKAO_APP_KEY 추가, URL추가 추가 스키마 추가
    // Functions 폴더 새로 만들기
    func signIn(withEmail email: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        //카카오 로그인 시작
        //카카오 로그인이 끝나면 UID, email 얻기
        //파이어베이스 로그인 하기
        // 현재 로그인 목록창 끄기
       
    }
    let token_url = "https://us-central1-kakaologin-b6613.cloudfunctions.net/getJWT"
    
    func signIn(withDefaultValue defaultValue: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        NSLog("login")
        self._presentingViewController = presentingViewController
        guard let session = KOSession.shared() else {
                   return
               }
               
               if session.isOpen(){
                   session.close()
               }
        let activityView = FUIAuthBaseViewController.addActivityIndicator(self._presentingViewController!.view)
        activityView.startAnimating()
        
               session.open { (error) in
                           if let error = error {
                               NSLog("로그인 실패")
                           } else {
                               NSLog("로그인 성공")
                               // 성공했다면 파이어베이스 로그인
                               // kakao uid 찾기
                               KOSessionTask.userMeTask { (error, user_me) in
                                   if let error = error {
                                       NSLog(error.localizedDescription)
                                   }
                                   if let user = user_me {
                                       let uid = user.id!
                                       NSLog("user id: \(uid)")
                                       let login_info = TokenInfo(uid: user.id!)
                                       AF.request("https://us-central1-fir-basicswu.cloudfunctions.net/getJWT", method:.post, parameters: login_info, encoder:URLEncodedFormParameterEncoder(destination: .httpBody)).responseJSON { (response) in
                                           // 토큰 발급 완료
                                           do {
                                               // Functions를 이용해 받아온 토큰 파싱
                                               debugPrint(response)
                                               let token_data = try JSONDecoder().decode(JWT.self, from: response.data!)
                                            
                                               if token_data.error! == false {
                                                   // 토큰으로 Firebase에 로그인
                                                   Auth.auth().signIn(withCustomToken: token_data.jwt!) { (result, error) in
                                                    self._presentingViewController?.dismiss(animated: true, completion: nil)
                                                       if let error = error {
                                                           debugPrint(error)
                                                       } else {
                                                           if let current_user = Auth.auth().currentUser, let email =  user.account!.email {
                                                            
                                                               current_user.updateEmail(to: email) { (error) in
                                                                   if let error = error {
                                                                       NSLog("email update error")
                                                                   } else {
                                                                       NSLog("email update complete")
                                                                   }
                                                            
                                                                   activityView.stopAnimating()
                                                                 
                                                                
                                                                   // 뷰 이동 코드
                                                                
                                                               }
                                                           }
                                                       }
                                                   }
                                               }
                                           } catch {
                                               NSLog(error.localizedDescription)
                                           }
                                       }
                                       // functions 무료 요금제에서 실행 불가
               //                        self.functions.httpsCallable("makeJWT").call(["uid":uid]) { (result, error) in
               //                            if let error = error {
               //                                NSLog(error.localizedDescription)
               //                            } else {
               //                                if let data = (result?.data as? [String:Any]) {
               //                                    NSLog("토큰 받아옴")
               //                                    NSLog("\(data["jwt"])")
               //                                }
               //                            }
               //                        }
                                   }
                               }
                               // 창 닫기
                           }
                       }
    }
    
    func signOut() {
        
    }
    
    var accessToken: String?
}

