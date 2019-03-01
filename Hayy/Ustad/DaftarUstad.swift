//
//  DaftarUstad.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 28/01/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit

class DaftarUstad: UITableViewCell {
    
    
    
    
    @IBOutlet weak var avatarUstad: UIImageView!
    
    @IBOutlet weak var namaUstad: UILabel!
    
    
    var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //configure_avatarUstad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure_avatarUstad() {
        avatarUstad.makeRounded()
    }
    
    

}


