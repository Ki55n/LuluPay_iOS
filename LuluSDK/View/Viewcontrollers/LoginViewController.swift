//
//  LoginViewController.swift
//  LuluSDK
//
//  Created by boyapati kumar on 01/02/25.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var loginInfo: LoginModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isUserLoggedIn {
            let url = "https://drap-sandbox.digitnine.com/auth/realms/cdp/protocol/openid-connect/token"
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters = [
                "username": SecureStorageManager.shared.retrieveFromKeychain(key: Constants.kUserName),
                "password": SecureStorageManager.shared.retrieveFromKeychain(key: Constants.kPassword),
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
                            
                            SecureStorageManager.shared.saveToKeychain(key: Constants.kUserName, value: self.usernameTF.text ?? "")
                            SecureStorageManager.shared.saveToKeychain(key: Constants.kPassword, value: self.passwordTF.text ?? "")
                            
                            UserManager.shared.loginModel = self.loginInfo
                            
                            UserDefaults.standard.setValue(true, forKey: "isUserLoggedIn")
                            
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
    @objc func dismissKeyboard() {
        self.view.endEditing(true) // Dismiss the keyboard
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTF:
            // Move to the password field when the user presses return on the username field
            passwordTF.becomeFirstResponder()
        case passwordTF:
            // Dismiss the keyboard when the user presses return on the password field
            passwordTF.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @IBAction func loginBtnAction(_sender: UIButton) {
        if usernameTF.text == "" || passwordTF.text == ""{
            showToast(message: "Please enter username and password")
        }else{
            let url = UserManager.shared.setBaseURL+"/auth/realms/cdp/protocol/openid-connect/token"
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters = [
                "username": usernameTF.text ?? "",
                "password": passwordTF.text ?? "",
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
                            SecureStorageManager.shared.saveToKeychain(key: Constants.kUserName, value: self.usernameTF.text ?? "")
                            SecureStorageManager.shared.saveToKeychain(key: Constants.kPassword, value: self.passwordTF.text ?? "")
                            
                            UserDefaults.standard.setValue(true, forKey: "isUserLoggedIn")
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
}
