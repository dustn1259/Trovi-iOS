//
//  SpinnerViewController.swift
//  kakaoFirebase
//
//  Created by swuad_38 on 14/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit

class SpinnerViewController:UIViewController {
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func loadView() {
        view = UIView()
        
        //전체 화면 배경 반투명
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        //스피너를 뷰
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}
