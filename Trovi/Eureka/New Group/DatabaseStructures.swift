//
//  DatabaseStructures.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 10/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import Foundation

struct Diary:Codable {
    
    let uid:String?
    let title:String?
    let date:TimeInterval?
    let content:String?
    let image_url:String?
    let hashtag:String?
    let count:String?
    let meetArea:String?
    let date_arrival:TimeInterval?
    let chat_key:String?
}
