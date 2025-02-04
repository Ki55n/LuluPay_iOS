//
//  ProfileViewController.swift
//  Sample
//
//  Created by Swathiga on 21/01/25.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblList: UITableView!
    
    let arrList = [
        ["title": "Personal Details", "image": "person"],
        ["title": "Help", "image": "Help"],
        ["title": "Log out", "image": "Log_out"]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            let headerNib = UINib(nibName: "CustomHeaderView", bundle: bundle)
            tblList.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
            let cellNib = UINib(nibName: "ProfileTCell", bundle: bundle)
            tblList.register(cellNib, forCellReuseIdentifier: "profileCell")
            let settingcellNib = UINib(nibName: "SettingsCell", bundle: bundle)
            tblList.register(settingcellNib, forCellReuseIdentifier: "settingsCell")
            let profilecellNib = UINib(nibName: "ProfileTCell", bundle: bundle)
            tblList.register(profilecellNib, forCellReuseIdentifier: "profileCell")
            
            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {
                headerView.lblTitle.text = "Profile" // Customize the header text
                headerView.frame = CGRect(x: 0, y: 0, width: tblList.frame.width, height: 110)

                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
                    headerView.viewMain.backgroundColor = customColor
                } else {
                    headerView.viewMain.backgroundColor = .cyan// Fallback color if custom color isn't found
                }

                
                tblList.tableHeaderView = headerView
                
                let backgroundView = UIView()
                backgroundView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: tblList.frame.width, height: tblList.frame.height/5)
                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
                    backgroundView.backgroundColor = customColor
                } else {
                    backgroundView.backgroundColor = .cyan // Fallback color if custom color isn't found
                }
                view.addSubview(backgroundView)
                view.bringSubviewToFront(tblList)

            }
        }
        

       
        
        tblList.bounces = false
        // Add the custom background view to the table view
        tblList.backgroundColor = .clear
        tblList.delegate = self
        tblList.dataSource = self
        tblList.clipsToBounds = false

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTCell else {
                return UITableViewCell()
            }
            let cornerRadius: CGFloat = 30
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.masksToBounds = true
            
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.contentView.layer.masksToBounds = true

            cell.backgroundColor = .red
            
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
       return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }

            if let rowData = arrList[indexPath.row-1] as? [String:String]{
                cell.lblTitle.text = rowData["title"]
                if let imageName = rowData["image"] {
                    cell.imgIcon.image = UIImage(named: imageName)
                }
                cell.imgArrow.image = UIImage(systemName: "chevron.right")
            }

            return cell

        }

    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tblList.frame.width, height: 60))
//        headerView.backgroundColor = UIColor.white
////        if section == 0{
////            let cornerRadius: CGFloat = 30
////            headerView.layer.cornerRadius = cornerRadius
////            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
////            headerView.layer.masksToBounds = true
////        }
//        return headerView
//    }
//    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        }
        return 40
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
}
