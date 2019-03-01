//
//  JsonModel.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 29/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JsonModel{
var name: String = ""
var image: String = ""
    var id = Int()
    var user_id: String = ""
    var posts = Int()
    var following = Int()
    var followers = Int()
    
    

init(){
    
}

init(json: JSON){
    name = json["name"].stringValue
    image = json["image"].stringValue
    id = json["id"].intValue
    user_id = json["user_id"].stringValue
    posts = json["posts"].intValue
    following = json["following"].intValue
    followers = json["followers"].intValue
    
    
}
}
