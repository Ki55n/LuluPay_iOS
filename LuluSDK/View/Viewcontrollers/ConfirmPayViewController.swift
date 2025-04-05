//
//  ConfirmPayViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class ConfirmPayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "ConfirmPayCell", bundle: bundle), forCellReuseIdentifier: "cellConfirm")
            tableView.register(UINib(nibName: "ProfileTCell", bundle: bundle), forCellReuseIdentifier: "profileCell")
            tableView.register(UINib(nibName: "TitleCell", bundle: bundle), forCellReuseIdentifier: "cellTitle")
            tableView.register(UINib(nibName: "ButtonCell", bundle: bundle), forCellReuseIdentifier: "cellbutton")

            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {

                headerView.lblTitle.text = "Send Money" // Customize the header text
                headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110)
                headerView.btnBack.addTarget(self, action: #selector(self.moveBack), for: .touchUpInside)
//                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
//                    headerView.viewMain.backgroundColor = customColor
//                } else {
//                    headerView.viewMain.backgroundColor = .cyan// Fallback color if custom color isn't found
//                }
                headerView.viewMain.backgroundColor = ThemeManager.shared.getThemeColor()// Fallback color if custom color isn't found

                
                tableView.tableHeaderView = headerView
                
//                let backgroundView = UIView()
//                backgroundView.frame = CGRect(x: 0, y: headerView.frame.minY, width: tableView.frame.width, height: tableView.frame.height/2)                
//                
//               
//                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
//                    backgroundView.backgroundColor = customColor
//                } else {
//                    backgroundView.backgroundColor = .cyan // Fallback color if custom color isn't found
//                }
//                view.addSubview(backgroundView)
//                view.bringSubviewToFront(tableView)
                
            }
            
        }
        
        
        
        tableView.bounces = false
        // Add the custom background view to the table view
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInset = .zero
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeUpdated),
            name: .themeColorUpdated,
            object: nil
        )
    ThemeManager.shared.applySavedTheme()



    }
    func updateHeaderView() {
        if let headerView = self.tableView.tableHeaderView as? CustomHeaderView {
            headerView.viewMain.backgroundColor = ThemeManager.shared.getThemeColor()
        }
    }
    @objc private func themeUpdated() {
        updateHeaderView()
        tableView.reloadData()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }


    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Submit(){
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "PaySuccessViewController") as! PaySuccessViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }
    
}

extension ConfirmPayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
            cell.lblTitle.text = "Send"
            cell.lblTitle.textAlignment = .center
                return cell

        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            let title = "Jessica"
            let subtitle = "from Instant Account"

            // Define attributes for both parts
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.black
            ]

            let regularTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.darkGray
            ]

            let lightGrayTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray
            ]

            // Create attributed string for title and entire subtitle
            let titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)
            let subtitleAttributedString = NSMutableAttributedString(string: "\n\(subtitle)", attributes: regularTextAttributes)

            // Apply light gray color to the word "from"
            if let fromRange = subtitle.range(of: "from") {
                let nsRange = NSRange(fromRange, in: subtitle)
                subtitleAttributedString.addAttributes(lightGrayTextAttributes, range: nsRange)
            }

            // Combine the strings
            let combinedAttributedString = NSMutableAttributedString()
            combinedAttributedString.append(titleAttributedString)
            combinedAttributedString.append(subtitleAttributedString)

            // Set the attributed text to the label
            cell.lblTitle.attributedText = combinedAttributedString

            // Ensure label supports multi-line
            cell.lblTitle.numberOfLines = 0

            return cell


        case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellConfirm", for: indexPath) as? ConfirmPayCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
            
            return cell

            

        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellbutton", for: indexPath) as? ButtonCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.btnCancel.isHidden = false
            cell.btnCancel.setTitleColor(UIColor.black, for: .normal)
            cell.btnTitle.setTitle("Pay", for: .normal)
            cell.btnTitle.addTarget(self, action: #selector(self.Submit), for: .touchUpInside)
            return cell

            
        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
                return 40
            
        case 1:
                return 150
        case 2:
            return 288
        case 3:
            return 50
        
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor.white
            
            let cornerRadius: CGFloat = 20
            headerView.layer.cornerRadius = cornerRadius
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            headerView.layer.masksToBounds = true
            
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 40
        }else{
            return 0
        }
        
    }
    
}
