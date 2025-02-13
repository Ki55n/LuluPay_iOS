//
//  TabViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 22/01/25.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(named: "customCyanColor") // Selected tab icon color
        tabBar.unselectedItemTintColor = UIColor.black // Unselected tab icon color
    }
    
}
