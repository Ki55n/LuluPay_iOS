//
//  SettingsViewController.swift
//  Sample
//
//  Created by Swathiga on 20/01/25.
//

import UIKit

class SettingsViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak var tblList: UITableView!
    let sectionKeys = ["General", "Account Action"]
    let arrsections: [String: [[String: String]]] = [
        "General": [
            ["title": "Privacy and security", "image": "security"],
            ["title": "Notifications", "image": "notify"]
        ],
        "Account Action": [
            ["title": "Link To Card", "image": "link"],
            ["title": "Appearance", "image": "appearance"],
            ["title": "Rate us", "image": "rate_us"],
            ["title": "Password", "image": "password"],
            ["title": "Our agreements", "image": "agreements"],
            ["title": "Close account", "image": "close"]
        ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            let headerNib = UINib(nibName: "CustomHeaderView", bundle: bundle)
            tblList.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")

            // Register cell
            let cellNib = UINib(nibName: "SettingsCell", bundle: bundle)
            tblList.register(cellNib, forCellReuseIdentifier: "settingsCell")
            
            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {
                headerView.lblTitle.text = "Settings" // Customize the header text
                headerView.frame = CGRect(x: 0, y: 0, width: tblList.frame.width, height: 110)

//                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
//                    headerView.viewMain.backgroundColor = customColor
//                } else {
//                    headerView.viewMain.backgroundColor = .cyan// Fallback color if custom color isn't found
//                }
                headerView.viewMain.backgroundColor = ThemeManager.shared.getThemeColor()// Fallback color if custom color isn't found

                
                tblList.tableHeaderView = headerView
                
//                let backgroundView = UIView()
//                backgroundView.frame = CGRect(x: 0, y: headerView.frame.minY, width: tblList.frame.width, height: tblList.frame.height/2)
//                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
//                    backgroundView.backgroundColor = customColor
//                } else {
//                    backgroundView.backgroundColor = .cyan // Fallback color if custom color isn't found
//                }
//                view.addSubview(backgroundView)
//                view.bringSubviewToFront(tblList)

            }
            
        }
  
        tblList.bounces = false
        tblList.sectionHeaderTopPadding = 0
        // Add the custom background view to the table view
        tblList.backgroundColor = .clear
        tblList.delegate = self
        tblList.dataSource = self
        tblList.clipsToBounds = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeUpdated),
            name: .themeColorUpdated,
            object: nil
        )
    ThemeManager.shared.applySavedTheme()


    }
    func updateHeaderView() {
        if let headerView = tblList.tableHeaderView as? CustomHeaderView {
            headerView.viewMain.backgroundColor = ThemeManager.shared.getThemeColor()
        }
    }
    @objc private func themeUpdated() {
        updateHeaderView()
        tblList.reloadData()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

        func numberOfSections(in tableView: UITableView) -> Int {
            return arrsections.keys.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionKey = sectionKeys[section]
            return arrsections[sectionKey]?.count ?? 0
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 1{
askForCustomColor()
            }
        }
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }

            // Get section title and row data
            let sectionKey = sectionKeys[indexPath.section]
            if let rowData = arrsections[sectionKey]?[indexPath.row] {
                cell.lblTitle.text = rowData["title"]
                if let imageName = rowData["image"] {
                    cell.imgIcon.image = UIImage(named: imageName)
                }
                cell.imgArrow.image = UIImage(systemName: "chevron.right")
            }

            return cell
        }
    func askForCustomColor() {
        let alert = UIAlertController(title: "Enter a HEX color code (e.g., #FF5733)",
                                      message: "Change Header Color and button Color",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "#RRGGBB"
            textField.keyboardType = .default
        }
        
        let submitAction = UIAlertAction(title: "Apply", style: .default) { _ in
            if let hex = alert.textFields?.first?.text {
                print("color saved",hex)
                ThemeManager.shared.saveThemeColor(hex: hex)  // Save color
                ThemeManager.shared.applySavedTheme()
                // Apply theme globally
                self.tblList.reloadData()
                self.updateHeaderView()
                DispatchQueue.main.async {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }

            }
        }
        
        alert.addAction(submitAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    func applyCustomThemeColor(hex: String) {
        guard let color = UIColor(hexString: hex) else {
            showInvalidColorAlert()
            return
        }

        // Save color in UserDefaults
        ThemeManager.shared.saveThemeColor(hex: hex)
        // Apply theme color globally
        UINavigationBar.appearance().barTintColor = color
        UITabBar.appearance().barTintColor = color
        view.backgroundColor = color
        if let window = UIApplication.shared.windows.first {
            window.subviews.forEach { $0.removeFromSuperview(); window.addSubview($0) }
            window.rootViewController?.view.setNeedsLayout()
            window.rootViewController?.view.layoutIfNeeded()
        }

        tblList.reloadData() // Refresh UI
    }

    func showInvalidColorAlert() {
        let alert = UIAlertController(title: "Invalid Color",
                                      message: "Please enter a valid hex code (e.g., #FF5733).",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

        // MARK: - TableView Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tblList.frame.width, height: 100))
        headerView.backgroundColor = UIColor.white
        if section == 0{
            let cornerRadius: CGFloat = 30.0
            headerView.layer.cornerRadius = cornerRadius
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            headerView.layer.masksToBounds = true
            headerView.backgroundColor = ThemeManager.shared.getThemeColor()
        }
        // Create a UILabel
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = sectionKeys[section] // Use your data source for the section title
            
            // Add the label to the header view
            headerView.addSubview(label)
            
        var constraints: [NSLayoutConstraint] = []

        if section == 0 {
            
            constraints = [
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10), // Padding from bottom
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
            ]

        } else {
            constraints = [
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
            ]

        }

        // Activate the constraints
        NSLayoutConstraint.activate(constraints)
            return headerView

            
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return section==0 ? 0 : 30
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return CGFloat.leastNormalMagnitude
    }


}
import UIKit

extension UIViewController {
    func setStatusBar(backgroundColor: UIColor, style: UIStatusBarStyle) {
        // Update the status bar style
        UIApplication.shared.statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Add or update the status bar background view
        if let existingStatusBarView = self.view.viewWithTag(999) {
            existingStatusBarView.backgroundColor = backgroundColor
        } else {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: statusBarHeight))
            statusBarView.backgroundColor = backgroundColor
            statusBarView.tag = 999 // Unique tag to identify the status bar view
            self.view.addSubview(statusBarView)
        }
    }
}

