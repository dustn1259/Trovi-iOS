//
//  LogoAnimationView.swift
//  kakaoFirebase
//
//  Created by 손예린 on 2020/01/20.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit

class LogoAnimationView: UIView {

    let logoGifImageView = UIImageView(image: UIImage(gifName: "finalSplash.gif"), highlightedImage: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
    }
}
