//////
//////  FUIKakao.swift
//////  FireBaseBasic
//////
//////  Created by 송 종근 on 06/01/2020.
//////  Copyright © 2020 송 종근. All rights reserved.
//////
//
//import UIKit
//import FirebaseUI
//
//import KakaoOpenSDK
//import FirebaseFunctions
//import Alamofire
//import CodableFirebase
//
//class FUIKakaoAuth:NSObject, FUIAuthProvider {
//    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
//    lazy var functions = Functions.functions(region: "us-central1")
//    var providerID: String? = "KakaoTalk"
//    
//    var shortName: String = "KakaoTalk"
//    
//    var signInLabel: String = "Sign in with KakaoTalk"
//    
//    var icon: UIImage = UIImage(named: "btn_kakao")!
//    
//    var buttonBackgroundColor: UIColor = UIColor(red: 255.0/255.0, green: 217.0/255.0, blue: 69.0/255.0, alpha: 1)
//    var buttonTextColor: UIColor = .black
//    
//    var _presentingViewController:UIViewController?
//    var _pendingSignInCallback:FUIAuthProviderSignInCompletionBlock?
//    var uid:String?
//    
//    func signIn(withEmail email: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
//        self.signIn(withDefaultValue: email, presenting: presentingViewController, completion: completion)
//    }
//    
//    func signIn(withDefaultValue defaultValue: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
//        _pendingSignInCallback = completion
//        _presentingViewController = presentingViewController
//        guard let session = KOSession.shared() else {
//            return
//        }
//        if session.isOpen() {
//            session.close()
//        }
//        let activityView = FUIAuthBaseViewController.addActivityIndicator(_presentingViewController!.view)
//        activityView.startAnimating()
//        session.open(completionHandler: { (error) -> Void in
//            NSLog("????")
//            if !session.isOpen() {
//                if let error = error as NSError? {
//                    switch error.code {
//                    case Int(KOErrorCancelled.rawValue):
//                        break
//                    default:
//                        NSLog(error.localizedDescription)
//                    }
//                }
//            }  else {
//                NSLog("kakao complete")
//                KOSessionTask.userMeTask { (error, user_me) in
//                    if let user = user_me {
//                        self.uid = user.id
//                        NSLog("!!DFSF \(self.uid)")
//                        let token_info = TokenInfo(uid: self.uid!)
//                        AF.request("https://us-central1-iosbasic-8e5b5.cloudfunctions.net/getJWT", method: .post, parameters: token_info, encoder: URLEncodedFormParameterEncoder(destination: .httpBody)).responseJSON { (response) in
//                            let decoder = JSONDecoder()
//                            if let jwt = try! decoder.decode(JWT.self, from: response.data!) as? JWT {
//                                Auth.auth().signIn(withCustomToken: jwt.jwt as! String) { (result, data) in
//                                    NSLog("firebase compelte")
//                                    
//                                    activityView.stopAnimating()
//                                    activityView.removeFromSuperview()
//                                    self._presentingViewController?.dismiss(animated: true, completion: nil)
//                                    
//                                        
//                                }
//                            }
//                        }
//                        
//                        
//                        
////                        self.functions.httpsCallable("makeJWT").call(["uid":"1251086907"]) { (result, error) in
////                            if let error = error as NSError? {
////                                NSLog(error.localizedDescription)
////                            }
////                            if let data = (result?.data as? [String:Any]) {
////                                NSLog(data["jwt"] as! String)
////                                Auth.auth().signIn(withCustomToken: data["jwt"] as! String) { (result, data) in
////                                    NSLog("firebase compelte")
////                                    if let callback = self._pendingSignInCallback {
////                                        //callback(nil, error, nil, nil)
////                                        activityView.stopAnimating()
////                                        activityView.removeFromSuperview()
////                                        self._presentingViewController?.dismiss(animated: true, completion: nil)
////
////                                    }
////
////                                }
////                            }
////                        }
//                        
//                    }
//                }
//            }
//        })
//    }
//  
//    func signOut() {
//        if let isOpen = KOSession.shared()?.isOpen() {
//            KOSession.shared()?.close()
//            try! Auth.auth().signOut()
//            NSLog("카카오 로그아웃됨")
//        } else {
//            NSLog("로그인 상태가 아닙니다.")
//        }
//    }
//    
//    var accessToken: String?
//    
//    
//}
