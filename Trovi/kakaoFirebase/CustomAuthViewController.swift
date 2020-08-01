//
//  CustomAuthViewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 07/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import FirebaseUI
 
class customAuthViewController:FUIAuthPickerViewController{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: nibBundleOrNil, authUI: authUI)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 스크린사이즈 읽어와서 그에 맞춰서 이미지 넣기
    override func viewDidLoad() {
        super.viewDidLoad()
        // 화면 크기 읽기
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
           
        // 읽은 크기로 이미지 사이지 지정
        let backgroundImageView = UIImageView (frame: CGRect(x:0, y:0, width: width, height: height))
        // 크기 바뀐 이미지, 이미지 뷰에 지정
        backgroundImageView.image = UIImage(named: "로그인")
        backgroundImageView.contentMode = .scaleAspectFill
        // 스크린에 넣기
        self.view.insertSubview(backgroundImageView, at: 0)  // 메인 보드에서 view 부터 0123...이고 view 내부는 0(view index)의 0123...
        self.view.subviews[1].backgroundColor = UIColor.clear // clear:투명
        self.view.subviews[1].subviews[0].backgroundColor = UIColor.clear // clear:투명
        /*
         view -> backgroundImageView
         -> scrollview(ㅊㅓ음 투명으로 바꾼 애) -> view(두번째로 바꾼 애)
         */
        
        
    }
   
    
}
