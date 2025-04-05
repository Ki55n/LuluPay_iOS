//
//  LoginViewController.swift
//  LuluSDK
//
//  Created by boyapati kumar on 01/02/25.
//

import UIKit
import LocalAuthentication

class LoginViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var viewBiometric: UIView!
    @IBOutlet weak var btnLogin: UIButton!

    
    var loginInfo: LoginModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: Constants.kuserLogginIn)
        if isUserLoggedIn {
            self.viewBiometric.isHidden = false

            self.authenticateWithBiometrics()
        }else{
            self.viewBiometric.isHidden = true
        }
        //  Add observer to check when user returns from settings
//        NotificationCenter.default.addObserver(self, selector: #selector(appCameBackFromSettings), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    @objc func appCameBackFromSettings() {
        print("Returned from Settings")

        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric is now enabled → Ask for authentication
            self.authenticateWithBiometrics()
        } else {
            self.viewBiometric.isHidden = true
            // Biometric still not available → Show alert again
            let alert = UIAlertController(
                title: "Biometrics Not Available",
                message: "Face ID / Touch ID is still not set up. You can enable it in settings.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login using Face ID / Touch ID") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.setValue(true, forKey: Constants.kBiometricLogged)
                        self.autologinApi()
                    } else {
                        print("Biometric authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                        self.viewBiometric.isHidden = false
                        //  Show alert but let user manually log in
                        let alert = UIAlertController(
                            title: "Authentication Failed",
                            message: "Face ID / Touch ID failed. Please log in using your username and password.",
                            preferredStyle: .alert
                        )
                        
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            print("Biometric authentication not available.")
            self.viewBiometric.isHidden = false
            //  Show alert asking user to enable biometrics
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Enable Biometrics",
                    message: "Biometric authentication is not set up on your device. You can enable Face ID / Touch ID for faster login in your device settings.",
                    preferredStyle: .alert
                )
                
                let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(settingsAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
            }
        }
    }

    func autologinApi(){
        let url = "https://drap-sandbox.digitnine.com/auth/realms/cdp/protocol/openid-connect/token"
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let username = SecureStorageManager.shared.retrieveFromKeychain(key: Constants.kUserName)
        let password = SecureStorageManager.shared.retrieveFromKeychain(key: Constants.kPassword)

        // Check if either username or password is empty
        if username?.isEmpty ?? true || password?.isEmpty ?? true {
            print("Username or password is empty")
            self.viewBiometric.isHidden = true
            showToast(message: "Face ID Authication failed, Please login by entering username and password.")
            return
            // Handle the case where either username or password is empty
        } else {
            print("Username and password are available")
            // Proceed with login or other actions
        }

        let parameters = [
            "username": username,
            "password": password,
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
                        UserDefaults.standard.setValue(true, forKey: Constants.kBiometricLogged)

                        UserDefaults.standard.setValue(true, forKey: Constants.kuserLogginIn)
                        
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
    @IBAction func loginManualBtnAction(_sender: UIButton) {
        self.viewBiometric.isHidden = true
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
                            UserDefaults.standard.setValue(true, forKey: Constants.kBiometricLogged)

                            UserDefaults.standard.setValue(true, forKey: Constants.kuserLogginIn)
                            if !UserDefaults.standard.bool(forKey: Constants.kbiometricEnabled) {
                                self.promptBiometricSetup()
                            } else {
                                self.navigateToHomeScreen()
                            }

                            
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func promptBiometricSetup() {
        let context = LAContext()
        var error: NSError?
        
        //  Check if Biometric Authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let alert = UIAlertController(title: "Enable Biometric Login?",
                                          message: "Would you like to use Face ID / Touch ID for faster login?",
                                          preferredStyle: .alert)
            
            let enableAction = UIAlertAction(title: "Enable", style: .default) { _ in
                UserDefaults.standard.setValue(true, forKey: Constants.kbiometricEnabled)
                self.navigateToHomeScreen()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.navigateToHomeScreen()
            }
            
            alert.addAction(enableAction)
            alert.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        } else {
            //  Biometric Not Available → Show Alert & Move to Home
            let unavailableAlert = UIAlertController(title: "Biometric Not Available",
                                                     message: "Please set up Face ID / Touch ID in your iPhone settings.",
                                                     preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigateToHomeScreen()
            }
            
            unavailableAlert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(unavailableAlert, animated: true)
            }
        }
    }

    func navigateToHomeScreen() {
        let storyboard = MyStoryboardLoader.getStoryboard(name: "Lulu")
        guard let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "mainTabbar") as? UITabBarController else {
            fatalError("Could not instantiate main tab bar.")
        }
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }

}
