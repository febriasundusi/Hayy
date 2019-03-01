//
//  HomeNoPicCell.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 12/02/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit

class HomeNoPicCell: UITableViewCell {
    
    
    @IBOutlet weak var avaImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textPost: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var titlePost: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}