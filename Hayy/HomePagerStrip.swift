//
//  HomePagerStrip.swift
//  Hayy
//
//  Created by Herlangga Wibi Yandi Nasution on 18/02/19.
//  Copyright © 2019 PT. Buana Kebenaran Informatika. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Floaty

class HomePagerStrip: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        configureButtonBar()
       
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        
        settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
        settings.style.buttonBarItemTitleColor = .gray
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .orange
        
        // Changing item text color on swipe
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .orange
        }
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeID") as! HomeVC
        
        
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivateID") as! PrivateVC
       
        
        return [child1, child2]
    }

    

}
