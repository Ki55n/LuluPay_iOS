//
//  LoadingIndicatorManager.swift
//  LuluSDK
//
//  Created by Swathiga on 07/02/25.
//

import Foundation
import UIKit

class LoadingIndicatorManager {
    
    // Singleton instance to access the methods globally
    static let shared = LoadingIndicatorManager()
    private var activityIndicator: UIActivityIndicatorView?

        func showLoading(on view: UIView) {
            if activityIndicator == nil {
                activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator?.color = .gray
                activityIndicator?.center = view.center
                activityIndicator?.startAnimating()
                view.addSubview(activityIndicator!)
            }
        }

        func hideLoading(on view: UIView) {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
}
