//
//  User.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 07/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

struct UserClass:Codable {
    let name:String
    let email:String
    
    init(name:String, email:String){
    self.name = name
    self.email = email
    //추가하고싶은 것 더 추가하기
}
}
