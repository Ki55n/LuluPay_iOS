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
    var loginInfo: LoginModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn {
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
            LoadingIndicatorManager.shared.showLoading(on: self.view)

            APIService.shared.request(url: url, method: .post, parameters: parameters, headers: headers) { result in
                LoadingIndicatorManager.shared.hideLoading(on: self.view)
                switch result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        DispatchQueue.main.async {
                            let jsonDecoder = JSONDecoder()
                            self.loginInfo = try? jsonDecoder.decode(LoginModel.self, from: data)
                            UserManager.shared.loginModel = self.loginInfo
                            let dic = ["username":"testagentae"]
                            UserManager.shared.getLoginUserData = dic
                            UserDefaults.standard.setValue(true, forKey: "isUserLoggedIn")
    //                        let parameters1 = [
    //
    //                            "receiving_country_code": "PK",
    //                            "receiving_mode": "BANK",
    //                            "first_name": "first name",
    //                            "middle_name": "middle name",
    //                            "last_name": "last name",
    //                            "iso_code": "ALFHPKKA068",
    //                            "iban": "PK12ABCD1234567891234567"
    //                        ]
                            
                                        let storyboard = MyStoryboardLoader.getStoryboard(name: "Lulu")
                                        // Instantiate the initial view controller
                                        guard let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "mainTabbar") as? UITabBarController else {
                                            fatalError("Could not instantiate initial view controller from MyStoryboard.")
                                        }
                                        self.navigationController?.navigationBar.isHidden = true
                                        self.navigationController?.pushViewController(tabbarVC, animated: true)
                                    
                        }
                        
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
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
        LoadingIndicatorManager.shared.showLoading(on: self.view)

        APIService.shared.request(url: url, method: .post, parameters: parameters, headers: headers) { result in
            LoadingIndicatorManager.shared.hideLoading(on: self.view)
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    DispatchQueue.main.async {
                        let jsonDecoder = JSONDecoder()
                        self.loginInfo = try? jsonDecoder.decode(LoginModel.self, from: data)
                        UserManager.shared.loginModel = self.loginInfo
                        let dic = ["username":"testagentae"]
                        UserManager.shared.getLoginUserData = dic
                        UserDefaults.standard.setValue(true, forKey: "isUserLoggedIn")
//                        let parameters1 = [
//                                           
//                            "receiving_country_code": "PK",
//                            "receiving_mode": "BANK",
//                            "first_name": "first name",
//                            "middle_name": "middle name",
//                            "last_name": "last name",
//                            "iso_code": "ALFHPKKA068",
//                            "iban": "PK12ABCD1234567891234567"
//                        ]
                        
                                    let storyboard = MyStoryboardLoader.getStoryboard(name: "Lulu")
                                    // Instantiate the initial view controller
                                    guard let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "mainTabbar") as? UITabBarController else {
                                        fatalError("Could not instantiate initial view controller from MyStoryboard.")
                                    }
                                    self.navigationController?.navigationBar.isHidden = true
                                    self.navigationController?.pushViewController(tabbarVC, animated: true)
                                
                    }
                    
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    

}
