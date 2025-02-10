//
//  PaymentDetailsViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class PaymentDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var getQuote : QuoteData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "TransactionDetailCell", bundle: bundle), forCellReuseIdentifier: "cellDetail")
            tableView.register(UINib(nibName: "PaymentDetailCell", bundle: bundle), forCellReuseIdentifier: "cellPaymentDetail")
            tableView.register(UINib(nibName: "TitleCell", bundle: bundle), forCellReuseIdentifier: "cellTitle")
            tableView.register(UINib(nibName: "ButtonCell", bundle: bundle), forCellReuseIdentifier: "cellbutton")

            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {

                headerView.lblTitle.text = "Sending Money" // Customize the header text
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
        
        
        self.getQuote = UserManager.shared.getQuotesData
        tableView.bounces = true
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
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "ConfirmPayViewController") as! ConfirmPayViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }
    

}
extension PaymentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func emojiToImage(emoji: String, size: CGFloat = 40) -> UIImage? {
        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: size)
        label.sizeToFit()
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        label.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
            return 10
        case 2:
            return ((getQuote?.fx_rates?.count ?? 0) * 4) + 1
        case 3:
            return ((getQuote?.fee_details?.count ?? 0) * 5) + 1
        case 4:
            return ((getQuote?.settlement_details?.count ?? 0) * 3) + 1
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
                cell.lblAmount.text = String(self.getQuote?.sending_amount ?? 0)
                cell.lblTitle.text = "Amount"
                cell.lblCurrencyCode.text = self.getQuote?.receiving_country_code
                if let countryCode = self.getQuote?.receiving_country_code {
                    var emoji = ""
                    switch countryCode {
                    case "CH":
                        emoji = "🇨🇳" // China flag emoji
                    case "EG":
                        emoji = "🇪🇬" // Egypt flag emoji
                    case "PH":
                        emoji = "🇵🇭" // Philippines flag emoji
                    case "SL":
                        emoji = "🇱🇰" // Sri Lanka flag emoji
                    case "PK":
                        emoji = "🇵🇰" // Pakistan flag emoji
                    default:
                        emoji = "🏳️" // Default emoji
                    }
                    cell.imgCurrency.image = emojiToImage(emoji: emoji)
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
                if let quote = getQuote {
                    let keys = ["sending_country_code", "receiving_country_code", "sending_currency_code", "receiving_currency_code", "sending_amount", "receiving_amount", "total_paying_amount", "reference", "price_guarantee"]
                    
                    if (indexPath.row - 1) >= 0 && (indexPath.row - 1) < keys.count {
                        let key = keys[indexPath.row - 1]  // Corrected index access

                        switch key {
                        case "sending_country_code":
                            cell.lblTitle.text = "Sending Country:"
                            cell.lblValue.text = quote.sending_country_code
                        case "sending_currency_code":
                            cell.lblTitle.text = "Sending Currency:"
                            cell.lblValue.text = quote.sending_currency_code
                            
                        case "receiving_country_code":
                            cell.lblTitle.text = "Receiving Country:"
                            cell.lblValue.text = quote.receiving_country_code
                            
                        case "receiving_currency_code":
                            cell.lblTitle.text = "Receiving Currency:"
                            cell.lblValue.text = quote.receiving_currency_code
                            
                        case "sending_amount":
                            cell.lblTitle.text = "Sending Amount"
                            cell.lblValue.text = String(quote.sending_amount ?? Int(0.0))
                            
                        case "receiving_amount":
                            cell.lblTitle.text = "Receiving Amount"
                            cell.lblValue.text = String(quote.receiving_amount ?? 0.0)
                            
                        case "total_paying_amount":
                            cell.lblTitle.text = "Total Amount"
                            cell.lblValue.text = String(quote.total_payin_amount ?? 0.0)
                            
                        case "reference":
                            cell.lblTitle.text = "Reference"
                            cell.lblValue.text = UserManager.shared.getReferenceText
                        case "price_guarantee":
                            cell.lblTitle.text = "Price Guarantee"
                            cell.lblValue.text = quote.price_guarantee

                        default:
                            break
                        }
                    }
                }
                return cell
                
            }
        case 2:
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblTitle.text = "FX Rates"
                return cell
                
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as? TransactionDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                
                let fxRateIndex = (indexPath.row-1) / 4 //0,1/4, 2/4, 3/4, 4/4, 5/4, 6/4, 7/4, 8/4
                if indexPath.row>0, fxRateIndex >= 0, let quote = self.getQuote?.fx_rates?[fxRateIndex] {
                    // Determine the key to show based on the remainder
                    let keyIndex = indexPath.row % 4
                    let keys = [
                        "rate", "type", "base_currency_code", "counter_currency_code"
                    ]
                    
                    if keyIndex < keys.count {
                        let key = keys[keyIndex]
                        
                        switch key {
                        case "rate":
                            cell.lblTitle.text = "Rate"
                            cell.lblValue.text = String(quote.rate ?? 0.0)
                        case "type":
                            cell.lblTitle.text = "Type"
                            cell.lblValue.text = quote.type

                        case "base_currency_code":
                            cell.lblTitle.text = "Base Currency Code"
                            cell.lblValue.text = quote.base_currency_code
                        case "counter_currency_code":
                            cell.lblTitle.text = "Counter Currency Code"
                            cell.lblValue.text = quote.counter_currency_code
                        default:
                            break
                        }
                    }
                }
                return cell
            }
        case 3:
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblTitle.text = "Settlement"
                
                return cell
                
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as? TransactionDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                let settlementIndex = (indexPath.row - 1) / 3  // Subtract 1 to account for the title row
                if settlementIndex >= 0, settlementIndex < (self.getQuote?.settlement_details?.count ?? 0),
                   let settlement = self.getQuote?.settlement_details?[settlementIndex] {
                    // Determine the key to show based on the remainder
                    let keyIndex = (indexPath.row - 1) % 3  // Subtract 1 to skip the title row
                    let keys = ["value", "charge_type", "currency_code"]
                    
                    if keyIndex < keys.count {
                        let key = keys[keyIndex]
                        
                        switch key {
                        case "charge_type":
                            cell.lblTitle.text = "Charge Type"
                            cell.lblValue.text = settlement.charge_type

                        case "value":
                            cell.lblTitle.text = "Value"
                            cell.lblValue.text = String(settlement.value ?? 0)

                        case "currency_code":
                            cell.lblTitle.text = "Currency Code"
                            cell.lblValue.text = settlement.currency_code
                        default:
                            break
                        }
                    }
                }

                return cell
            }

            

            case 4:
            
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
