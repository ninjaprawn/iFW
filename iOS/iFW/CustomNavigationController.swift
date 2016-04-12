//
//  CustomNavigationController.swift
//  iFW
//
//  Created by George Dan on 12/04/2016.
//  Copyright © 2016 George Dan. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationBar.barTintColor = UIColor(red: 65/255, green: 131/255, blue: 215/255, alpha: 1.0)
		self.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(18)]
    }

}
