//
//  TabViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 22/01/25.
//

import UIKit
import LocalAuthentication
class TabViewController: UITabBarController {
    var blurEffectView: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(named: "customCyanColor") // Selected tab icon color
        tabBar.unselectedItemTintColor = UIColor.black // Unselected tab icon color
        
//        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @objc func appDidBecomeActive() {
        // Check if user is logged in and if biometric authentication is enabled
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            showBlurEffect()
            authenticateWithBiometrics()
        }else {
            // Optionally prompt user for manual login if needed
            self.showLoginScreen()
        }
    }
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate to proceed") { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication was successful, navigate to the home screen
//                        self?.navigateToHomeScreen()
                    } else {
                        // Biometric authentication failed, show a message or allow retry
                        print("Biometric authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                        // Optionally prompt user for manual login if needed
                        self?.showLoginScreen()
                    }
                    self?.removeBlurEffect()
                }
            }
        } else {
            print("Biometric authentication not available.")
            // If biometrics are not available, fall back to manual login or handle accordingly
            self.showLoginScreen()
            self.removeBlurEffect()
        }
    }

    func navigateToHomeScreen() {
        // Navigate to the home screen (first tab) only after successful biometric authentication
//        self.selectedIndex = 0  // Select the first tab (index 0)

        // No need to change rootViewController here; it could interfere with the existing view hierarchy.
        // Instead, ensure that the user is shown the appropriate tab screen after login
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0 // Optionally, set the tab you want after successful login
        }
    }

    func showLoginScreen() {
        // Show login screen if user isn't logged in or biometric authentication fails
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    func showBlurEffect() {
        // Add a visual effect view with blur effect
        let blurEffect = UIBlurEffect(style: .dark)  // Choose style as per your design
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        if let blurEffectView = blurEffectView {
            // Adjust the frame to cover the whole screen including the tab bar
            blurEffectView.frame = self.view.frame
            self.view.addSubview(blurEffectView)
            self.view.bringSubviewToFront(blurEffectView)  // Ensure it's on top
        }
    }

    func removeBlurEffect() {
        // Remove the blur effect view if it's added
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }

}
