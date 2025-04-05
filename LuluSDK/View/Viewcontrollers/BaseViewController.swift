//
//  BaseViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 05/04/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        // Do any additional setup after loading the view.
    }
    func applyTheme() {
        SDKThemeManager.applyTheme(to: self.view)
        updateThemedUI()
    }

    func updateThemedUI() {
        // Override in subclasses to update buttons, labels etc.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
