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
import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else { return nil }
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
extension Notification.Name {
    static let themeColorUpdated = Notification.Name("themeColorUpdated")
}

// UIViewController extension remains the same
extension UIViewController {
    func updateTableHeaderFooterBackground(with color: UIColor) {
        if let tableView = view as? UITableView {
            tableView.tableHeaderView?.backgroundColor = color
            tableView.tableFooterView?.backgroundColor = color
            tableView.reloadData()
        }
    }
}
