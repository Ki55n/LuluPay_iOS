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
        DispatchQueue.main.async {
            if self.activityIndicator == nil {
                self.activityIndicator = UIActivityIndicatorView(style: .large)
                self.activityIndicator?.color = .gray
                self.activityIndicator?.center = view.center
                self.activityIndicator?.startAnimating()
                view.addSubview(self.activityIndicator!)
                // Center the activity indicator
                if let activityIndicator = self.activityIndicator {
                    NSLayoutConstraint.activate([
                        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                    ])
                }

            }
        }
    }

    func hideLoading(on view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
}
