//
//  CardsMangementViewController.swift
//  Sample
//
//  Created by Swathiga on 21/01/25.
//

import UIKit

class CardsMangementViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblList: UITableView!
    
    
    var arrList = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrList = [["id":"1","card_number":"12345 678980"]]
        // Register header view
        
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            // Register custom cells
            let headerNib = UINib(nibName: "CustomHeaderView", bundle: bundle)
            tblList.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")

            // Register cell
            let cellNib = UINib(nibName: "SettingsCell", bundle: bundle)
            tblList.register(cellNib, forCellReuseIdentifier: "settingsCell")
           
            // Register cell
            let cardcellNib = UINib(nibName: "CardCell", bundle: bundle)
            tblList.register(cardcellNib, forCellReuseIdentifier: "cellCard")
            
            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {
                headerView.lblTitle.text = "LuLu Virtual Cards" // Customize the header text
                headerView.frame = CGRect(x: 0, y: 0, width: tblList.frame.width, height: 100)

                tblList.tableHeaderView = headerView

                let backgroundView = UIView()
                backgroundView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: tblList.frame.width, height: 160)
                backgroundView.backgroundColor = UIColor(named: "customCyanColor") // Set your desired background color here
                view.addSubview(backgroundView)
                view.bringSubviewToFront(tblList)

            }
        } else {
            print("Error: SDK Bundle not found.")
        }

        tblList.bounces = false
        // Add the custom background view to the table view
        tblList.backgroundColor = .clear
        tblList.delegate = self
        tblList.dataSource = self
        tblList.clipsToBounds = false

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }
            
           
                cell.lblTitle.text = "Request a new virtual Card"
                
                cell.imgIcon.image = UIImage(systemName: "card")
                
                cell.imgArrow.image = UIImage(systemName: "chevron.right")
            

            cell.viewShadow.layer.shadowColor = UIColor.lightGray.cgColor
            cell.viewShadow.layer.shadowOpacity = 0.5 // Subtle shadow
            cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
            cell.viewShadow.layer.shadowRadius = 10 // Blurred shadow
            cell.viewShadow.layer.masksToBounds = false // Allow shadow to be visible outside

            // Configure `viewMain`
            cell.viewMain.backgroundColor = .white
            cell.viewMain.layer.cornerRadius = 10
            cell.viewMain.layer.masksToBounds = true // Ensure content is clipped inside the rounded corners


            return cell
            
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCard", for: indexPath) as? CardCell else {
                return UITableViewCell()
            }
            if let rowData = arrList[indexPath.row] as? [String:String]{
                cell.lblCardNo.text = rowData["card_number"]
            }
            return cell

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "RequestNewCardController") as! RequestNewCardController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }else{
            return 200
        }
        
    }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0{
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tblList.frame.width, height: 30))
                headerView.backgroundColor = UIColor.white
                
                let cornerRadius: CGFloat = 15
                headerView.layer.cornerRadius = cornerRadius
                headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                headerView.layer.masksToBounds = true
                
                return headerView
            }
            return nil
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 30
        }else{
            return 0
        }
        
    }
}
