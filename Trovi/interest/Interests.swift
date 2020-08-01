//
//  Interests.swift
//  kakaoFirebase
//
//  Created by swuad_38 on 14/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit

class Interests {
    var title = " "
    var featuredImage: UIImage
    var color: UIColor
    
    init(title:String, featuredImage:UIImage, color:UIColor)
    {
        self.title = title
        self.featuredImage = featuredImage
        self.color = color
    }
    
    static func fetchInterests() -> [Interests]
    {
        return [
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8)),
            Interests(title: "Traveling Around the World", featuredImage: UIImage(named: "0")!, color: UIColor(red: 63/255.0, green:71/255.0, blue: 80/255.0, alpha: 0.8))
        
        ]
    }
}
