//
//  LoginViewController.swift
//  LuluSDK
//
//  Created by boyapati kumar on 01/02/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginBtnAction(_sender: UIButton) {
        let url = "https://drap-sandbox.digitnine.com/auth/realms/cdp/protocol/openid-connect/token"

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters = [
            "username": "testagentae",
            "password": "Admin@123",
            "grant_type": "password",
            "client_id": "cdp_app",
            "client_secret": "mSh18BPiMZeQqFfOvWhgv8wzvnNVbj3Y"
        ]

        APIService.shared.request(url: url, method: .post, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    
                    let storyboard = MyStoryboardLoader.getStoryboard(name: "Lulu")
                    // Instantiate the initial view controller
                    guard let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "mainTabbar") as? UITabBarController else {
                        fatalError("Could not instantiate initial view controller from MyStoryboard.")
                    }
                    self.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.pushViewController(tabbarVC, animated: true)
                    
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    

}
