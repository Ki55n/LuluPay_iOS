//
//  MyStoryboardLoader.swift
//  LuluSDK
//
//  Created by boyapati kumar on 17/01/25.
//

import Foundation
import UIKit

public class MyStoryboardLoader {
    
    /// Instantiates and returns the initial view controller from the "Lulu" storyboard.
    /// - Returns: The initial `UIViewController` from the "Lulu" storyboard.
    public static func instantiateViewController() -> UIViewController {
        // Access the bundle of the framework where this class is located
        let bundle = Bundle(for: MyStoryboardLoader.self)

        // Load the "Lulu" storyboard from the bundle
        let storyboard = UIStoryboard(name: "Lulu", bundle: bundle)

        // Instantiate the initial view controller
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate initial view controller from MyStoryboard.")
        }
        return viewController
    }
    
    /// Retrieves a `UIStoryboard` instance for a given storyboard name.
    /// - Parameter name: The name of the storyboard.
    /// - Returns: A `UIStoryboard` instance if the storyboard exists, otherwise `nil`.
    public static func getStoryboard(name: String) -> UIStoryboard? {
        // Get the bundle where this class is defined
        let bundle = Bundle(for: MyStoryboardLoader.self)
        
        // Return the storyboard instance
        return UIStoryboard(name: name, bundle: bundle)
    }
}
