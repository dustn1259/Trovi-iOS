//
//  DataStructures.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 07/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import Foundation

//Functions에 UID를 보낼 때 필요한 구조체
struct TokenInfo:Encodable {
    let uid:String
}

//JWT토큰을 받을 때 필요한 구조체
struct JWT:Codable {
    let error:Bool?
    let jwt:String?
    let msg:String?
    let uid:String?
    //물음표로 해두고 받아올 필드를 다 적어줘야한다
    
    
}
