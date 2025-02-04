//
//  PaymentDetailsViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class PaymentDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "TransactionDetailCell", bundle: bundle), forCellReuseIdentifier: "cellDetail")
            tableView.register(UINib(nibName: "PaymentDetailCell", bundle: bundle), forCellReuseIdentifier: "cellPaymentDetail")
            tableView.register(UINib(nibName: "TitleCell", bundle: bundle), forCellReuseIdentifier: "cellTitle")
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
                backgroundView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: tableView.frame.width, height: tableView.frame.height/5)
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

    }
    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Submit(){
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "ConfirmPayViewController") as! ConfirmPayViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }
    

}
extension PaymentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
            return 6
        case 2:
            return 1
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblTitle.text = "Payment Details"
                return cell

            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPaymentDetail", for: indexPath) as? PaymentDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                
                return cell

            }
        case 1:
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblTitle.text = "Transaction Details"
                return cell

            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as? TransactionDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                if indexPath.row == 1{
                    cell.lblTitle.text = "Amount"
                }else if indexPath.row == 2{
                    cell.lblTitle.text = "Commission Amount"
                }else if indexPath.row == 3{
                    cell.lblTitle.text = "Processing Fee"
                }else if indexPath.row == 4{
                    cell.lblTitle.text = "Total Amount"
                }else if indexPath.row == 5{
                    cell.lblTitle.text = "Reference"
                }
            
            return cell

            }

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellbutton", for: indexPath) as? ButtonCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.btnCancel.isHidden = true
            cell.btnTitle.setTitle("Proceed", for: .normal)
            cell.btnTitle.addTarget(self, action: #selector(self.Submit), for: .touchUpInside)
            return cell

            
        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            if indexPath.row == 0{
                return 40
            }else{
                return 50
            }
            
        case 1:
                return 40
        case 2:
            return 50
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
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
