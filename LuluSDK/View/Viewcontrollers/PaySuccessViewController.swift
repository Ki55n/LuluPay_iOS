//
//  PaySuccessViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class PaySuccessViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "ProfileTCell", bundle: bundle), forCellReuseIdentifier: "profileCell")
            tableView.register(UINib(nibName: "ButtonCell", bundle: bundle), forCellReuseIdentifier: "cellbutton")

            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {

                headerView.lblTitle.text = "Send Money" // Customize the header text
                headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110)
                headerView.btnBack.addTarget(self, action: #selector(self.moveBack), for: .touchUpInside)
                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
                    headerView.viewMain.backgroundColor = customColor
                } else {
                    headerView.viewMain.backgroundColor = .cyan// Fallback color if custom color isn't found
                }

                
                tableView.tableHeaderView = headerView
                
                let backgroundView = UIView()
                backgroundView.frame = CGRect(x: 0, y: headerView.frame.minY, width: tableView.frame.width, height: tableView.frame.height/2)                
                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
                    backgroundView.backgroundColor = customColor
                } else {
                    backgroundView.backgroundColor = .cyan // Fallback color if custom color isn't found
                }
                view.addSubview(backgroundView)
                view.bringSubviewToFront(tableView)
                
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



    }
    
    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Submit(){
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "ShareReceiptViewController") as! ShareReceiptViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }

   

}
extension PaySuccessViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            
            let title = "Payment Done"
            let subtitle = "\nYou’ve successfully sent \(UserManager.shared.getQuotesData?.receiving_amount ?? 0) \nto \(UserManager.shared.getReceiverData?.firstName ?? "") \(UserManager.shared.getReceiverData?.lastName ?? "")"
            cell.imgPrtofile.image = UIImage(named: "CheckCircle")

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
            cell.imgPrtofile.image = UIImage(named:"CheckCircle")
            
            return cell



        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellbutton", for: indexPath) as? ButtonCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.btnCancel.isHidden = true
            cell.btnTitle.setTitle("Receipt", for: .normal)
            cell.btnTitle.addTarget(self, action: #selector(self.Submit), for: .touchUpInside)
            return cell

            
        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 200
            
        case 1:
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
