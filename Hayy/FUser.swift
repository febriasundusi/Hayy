//
//  FUser.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 28/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit

class FUser: Codable {
    var name: String
    var image: String
    
    
    init(name : String, image: String) {
        
        self.name = name
        self.image = image
        
    }
    
}
