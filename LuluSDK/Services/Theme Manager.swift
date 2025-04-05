//
//  Theme Manager.swift
//  LuluSDK
//
//  Created by Swathiga on 02/04/25.
//

import Foundation
import UIKit

class ThemeManager {
    
    static let shared = ThemeManager() // Singleton instance
    
    private init() {} // Prevent instantiation
    
    // Save Theme Color
    func saveThemeColor(hex: String) {
        UserDefaults.standard.set(hex, forKey: "themeColorHex")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .themeColorUpdated, object: nil)
    }
    
    // Get Theme Color
    func getThemeColor() -> UIColor {
        let hex = UserDefaults.standard.string(forKey: "themeColorHex") ?? "#007AFF" // Default Blue
        return UIColor(hexString: hex) ?? .white
    }
    
    // Apply Saved Theme Globally
    func applySavedTheme() {
        let savedColor = getThemeColor()
        
        // Update appearance proxies
        UINavigationBar.appearance().barTintColor = savedColor
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = savedColor
        UITabBar.appearance().tintColor = .white
        UIButton.appearance().tintColor = savedColor
        
        // Update all existing windows
        DispatchQueue.main.async {
                    if #available(iOS 15.0, *) {
                        let scenes = UIApplication.shared.connectedScenes
                        let windowScene = scenes.first as? UIWindowScene
                        windowScene?.windows.forEach { window in
                            window.tintColor = savedColor
                            window.rootViewController?.view.tintColor = savedColor
                            // Update nav and tab bars as before
                            if let navController = window.rootViewController as? UINavigationController {
                                navController.navigationBar.barTintColor = savedColor
                                navController.navigationBar.tintColor = .white
                            }
                            if let tabController = window.rootViewController as? UITabBarController {
                                tabController.tabBar.barTintColor = savedColor
                                tabController.tabBar.tintColor = .white
                            }
                            window.rootViewController?.view.setNeedsLayout()
                            window.rootViewController?.view.layoutIfNeeded()
                        }
                    } else {
                        UIApplication.shared.windows.forEach { window in
                            window.tintColor = savedColor
                            window.rootViewController?.view.tintColor = savedColor
                            
                            if let navController = window.rootViewController as? UINavigationController {
                                navController.navigationBar.barTintColor = savedColor
                                navController.navigationBar.tintColor = .white
                            }
                            
                            if let tabController = window.rootViewController as? UITabBarController {
                                tabController.tabBar.barTintColor = savedColor
                                tabController.tabBar.tintColor = .white
                            }
                            
                            window.rootViewController?.view.setNeedsLayout()
                            window.rootViewController?.view.layoutIfNeeded()
                        }
                    }
        }
    }
}
// Notification Name for Theme Update
