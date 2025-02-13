//
//  Extensions.swift
//  LuluSDK
//
//  Created by Swathiga on 08/02/25.
//

import Foundation

import UIKit

extension UIViewController {
    /// Displays a toast message at the bottom of the screen.
    ///
    /// - Parameters:
    ///   - message: The text to display in the toast.
    ///   - duration: The time (in seconds) for which the toast remains visible. Default is 2.0 seconds.
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        // Calculate the toast size with padding
        let padding: CGFloat = 16
        let maxWidth = self.view.frame.size.width - 2 * padding
        let textSize = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        // Set the frame of the toast label
        toastLabel.frame = CGRect(
            x: (self.view.frame.size.width - min(maxWidth, textSize.width + 32)) / 2,
            y: self.view.frame.size.height - 100,
            width: min(maxWidth, textSize.width + 32),
            height: textSize.height + 16
        )
        
        self.view.addSubview(toastLabel)
        // Animate the toast appearance
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
