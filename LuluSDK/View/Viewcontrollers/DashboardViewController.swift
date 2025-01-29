//
//  DashboardViewController.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var exchangeRates = [
        ExchangeRate(flag: "pkr", currency: "PKR", buy: "86,246", sell: "85,583"),
        ExchangeRate(flag: "inr", currency: "INR", buy: "86,246", sell: "85,583"),
        ExchangeRate(flag: "egp", currency: "EGP", buy: "86,246", sell: "85,583")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register custom cells
        tableView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "cellHeader")
        tableView.register(UINib(nibName: "ExchangeRateCell", bundle: nil), forCellReuseIdentifier: "rateExchange")
//        tableView.register(UINib(nibName: "cellCardBalance", bundle: nil), forCellReuseIdentifier: "CardBalanceCell")
        tableView.register(UINib(nibName: "TransferCell", bundle: nil), forCellReuseIdentifier: "cellTransfer")

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

    

}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Header, Card, Exchange Rates
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2{
            return 1 // Header and Card have one cell each
        }
        else {
            return exchangeRates.count
        }// Exchange Rates is dynamic
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Header Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader", for: indexPath) as? HeaderViewCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.greetingLabel.text = "Welcome John Doe!"
//            cell.profileImageView.backgroundColor = .red
            return cell
            
        // Uncomment this section if you decide to use the CardBalanceCell
    //    case 1: // Card Balance Section
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCardBalance", for: indexPath) as! CardBalanceCell
    //        cell.accountBalanceLabel.text = "Account Balance"
    //        cell.balanceValueLabel.text = "****"
    //        cell.cardLogoImageView.image = UIImage(named: "cardLogo")
    //        return cell
            
        case 1:
            // Exchange Rates Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "rateExchange", for: indexPath) as! ExchangeRateCell
            let rate = exchangeRates[indexPath.row]
            
            // Show header only for the first row
            cell.viewHeader.isHidden = indexPath.row != 0
            cell.flagImageView.image = UIImage(named: rate.flag)
            cell.currencyLabel.text = rate.currency
            cell.buyRateLabel.text = rate.buy
            cell.sellRateLabel.text = rate.sell
            return cell
            
        case 2:
            // Exchange Rates Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransfer", for: indexPath) as! TransferCell
            // Add Tap Gesture Recognizer to `viewTransfer`
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTransferTap(_:)))
            cell.viewTransfer.isUserInteractionEnabled = true
            cell.viewTransfer.addGestureRecognizer(tapGesture)

            
            return cell

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
            return indexPath.row == 0 ? 60 : 30
        case 2:
            return 110
        default:
            return 30
        }

    }
    @objc func handleViewTransferTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        
        // Perform actions when viewTransfer is tapped
        print("viewTransfer tapped: \(view)")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransferMoneyViewController") as! TransferMoneyViewController
        navigationController?.pushViewController(vc, animated: true)

        // Example: Navigate to another screen
        // navigationController?.pushViewController(NextViewController(), animated: true)
        
        
    }

}
