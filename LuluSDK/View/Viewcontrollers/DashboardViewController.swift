//
//  DashboardViewController.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var exchangeRates = [ExchangeRate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            // Register custom cells
            tableView.register(UINib(nibName: "HeaderViewCell", bundle: bundle), forCellReuseIdentifier: "cellHeader")
            tableView.register(UINib(nibName: "ExchangeRateCell", bundle: bundle), forCellReuseIdentifier: "rateExchange")
            tableView.register(UINib(nibName: "TransferCell", bundle: bundle), forCellReuseIdentifier: "cellTransfer")
            tableView.register(UINib(nibName: "RecentTransactionCell", bundle: bundle), forCellReuseIdentifier: "cellTransaction")

            let TitlecellNib = UINib(nibName: "TitleCell", bundle: bundle)
            tableView.register(TitlecellNib, forCellReuseIdentifier: "cellTitle")

            tableView.delegate = self
            tableView.dataSource = self
        } else {
            print("Error: SDK Bundle not found.")
        }
        exchangeRates = [
            ExchangeRate(flag: flagEmoji(for: "PK"), currency: "PKR", buy: "86,246", sell: "85,583"),
            ExchangeRate(flag: flagEmoji(for: "IN"), currency: "INR", buy: "86,246", sell: "85,583"),
            ExchangeRate(flag: flagEmoji(for: "EG"), currency: "EGP", buy: "86,246", sell: "85,583")
        ]
    
    }
    
    func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397 // Regional Indicator Symbol base code
        var flagString = ""
        
        for scalar in countryCode.uppercased().unicodeScalars {
            guard let unicodeValue = UnicodeScalar(base + scalar.value) else { continue }
            flagString.append(String(unicodeValue))
        }
        
        return flagString
    }

    

}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Header, Card, Exchange Rates
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1 // Header and Card have one cell each
        }
        else if section == 2{
            return exchangeRates.count
        }// Exchange Rates is dynamic
        else{
            return 2
        }
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader", for: indexPath) as? HeaderViewCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.greetingLabel.text = "Welcome John Doe!"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransfer", for: indexPath) as! TransferCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTransferTap(_:)))
            cell.viewTransfer.isUserInteractionEnabled = true
            cell.viewTransfer.addGestureRecognizer(tapGesture)
            return cell

        case 2:
            if indexPath.row == 0 {
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! TitleCell
                titleCell.lblTitle.text = "Exchange Rates"
                return titleCell
            } else if indexPath.row < exchangeRates.count {
                let rateCell = tableView.dequeueReusableCell(withIdentifier: "rateExchange", for: indexPath) as! ExchangeRateCell
                let rate = exchangeRates[indexPath.row]
                if indexPath.row == 1{
                    rateCell.viewHeader.isHidden = false
                }else{
                    rateCell.viewHeader.isHidden = true
                }
                rateCell.flagImageView.image = UIImage(named: rate.flag)
                rateCell.currencyLabel.text = rate.currency
                rateCell.buyRateLabel.text = rate.buy
                rateCell.sellRateLabel.text = rate.sell
                return rateCell
            } else {
                return UITableViewCell() // Fallback for unexpected rows
            }

        case 3:
            if indexPath.row == 0 {
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! TitleCell
                titleCell.lblTitle.text = "Recent Transactions"
                return titleCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath) as! RecentTransactionCell
                
                return cell
            }

        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return 110
        case 2:
            if indexPath.row == 0{
               return 40
            }else if indexPath.row == 1{
                return 60
            }else{
                return 30
            }
        case 3:
            if indexPath.row == 0{
               return 40
            }else{
                return 80
            }
        default:
            return 30
        }

    }
    @objc func handleViewTransferTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        
        // Perform actions when viewTransfer is tapped
        print("viewTransfer tapped: \(view)")
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "TransferMoneyViewController") as! TransferMoneyViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

        // Example: Navigate to another screen
        // navigationController?.pushViewController(NextViewController(), animated: true)
        
        
    }

}
