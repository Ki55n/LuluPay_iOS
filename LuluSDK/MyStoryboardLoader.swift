//
//  MyStoryboardLoader.swift
//  LuluSDK
//
//  Created by boyapati kumar on 17/01/25.
//

import Foundation
import UIKit

public class MyStoryboardLoader {
    public static func instantiateViewController() -> UIViewController {
        // Access the bundle of the framework
        let bundle = Bundle(for: MyStoryboardLoader.self)

        // Load the storyboard
        let storyboard = UIStoryboard(name: "Lulu", bundle: bundle)

        // Instantiate the initial view controller
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate initial view controller from MyStoryboard.")
        }
        return viewController
    }
}
