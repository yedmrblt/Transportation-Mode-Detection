//
//  MyTBC.swift
//  Traveler
//
//  Created by YED on 07/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import UIKit

class MyTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = support.hexStringToUIColor(hex: "#2B2E3A")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
