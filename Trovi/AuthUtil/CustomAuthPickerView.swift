//
//  CustomAuthPickerView.swift
//  FireBaseBasic
//
//  Created by 송 종근 on 02/01/2020.
//  Copyright © 2020 송 종근. All rights reserved.
//

import UIKit
import FirebaseUI

class CustomAuthPickerView:FUIAuthPickerViewController {


    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "background")

        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        view.insertSubview(imageViewBackground, at: 0)
        view.subviews[1].backgroundColor = UIColor.clear
        view.subviews[1].subviews[0].backgroundColor = UIColor.clear
    }

}
