//
//  PaymentDetailsViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit
import Alamofire

class PaymentDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var getQuote : QuoteData?
    var ReceiverData : ReceiverDetails?
//    var getQuote:getQuote?
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
        self.ReceiverData = UserManager.shared.getReceiverData
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
        
        createTransactionID()

    }

    func generateUniqueId() -> String {
        return UUID().uuidString // Using UUID to generate a unique ID
    }

    func createTransactionID() {
        let url = UserManager.shared.setBaseURL+"/amr/ras/api/v1_0/ras/createtransaction"
        
        let headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")",
                "sender": UserManager.shared.getLoginUserData?["username"] ?? "",
                "channel": "Direct",
                "company": "784825",
                "branch": "784826"
            ] //let headers:[String:String]?
        guard let receiverData = ReceiverData else {
            print("Invalid ReceiverData or missing input values.")
            return
        }
        
        var bankDetails: BankDetails?
        var mobileWalletDetails: MobileWalletDetails?
        var cashPickupDetails: CashPickupDetails?

        if let receiveMode = receiverData.receiveMode, receiveMode.contains("BANK") {
             bankDetails = BankDetails()

                // If at least one field has value, create bankDetails
            bankDetails?.accountNumber = (receiverData.accountNumber?.isEmpty ?? true) ? nil : receiverData.accountNumber
            bankDetails?.accountTypeCode = "1"
            bankDetails?.iban = (receiverData.iban?.isEmpty ?? true) ? nil : receiverData.iban
            bankDetails?.isoCode = (receiverData.swiftCode?.isEmpty ?? true) ? nil : receiverData.swiftCode
            bankDetails?.routingCode = (receiverData.routingCode?.isEmpty ?? true) ? nil : receiverData.routingCode
            
        }

        if let receiveMode = receiverData.receiveMode, receiveMode.contains("CASHPICKUP") {
            let correspondent = UserManager.shared.getServiceCorridorData?.first?.corridor_currencies?.first?.correspondent ?? ""

            cashPickupDetails = CashPickupDetails(
                correspondentId: "11232",
                correspondent: correspondent,
                correspondentLocationId: "213505"
            )
        }
        
        let senderDetails = Sender(customerNumber: "7841001220007002", agentCustomerNumber: "AGENT" + generateUniqueId())
        
        let receiverDetails = Receiver(
            mobileNumber: receiverData.phoneNumber ?? "",
            firstName: receiverData.firstName ?? "",
            lastName: receiverData.lastName ?? "",
            nationality: receiverData.country_code ?? "",
            relationCode: "32",
            bankDetails: bankDetails,
            cashPickupDetails: cashPickupDetails
        )

        let transactionDetails = Transaction(
            quoteId: getQuote?.quote_id ?? "",
            agentTransactionRefNumber: getQuote?.quote_id ?? ""
        )

        let transactionRequest = CreateTransactionRequest(
            type: UserManager.shared.gettransferType?.rawValue ?? "",
            sourceOfIncome: "SLRY",
            purposeOfTxn: "SAVG",
            instrument: receiverData.chooseInstrument?.uppercased() ?? "",
            message: UserManager.shared.getReferenceText ?? "Agency transaction",
            sender: senderDetails,
            receiver: receiverDetails,
            transaction: transactionDetails
        )

        // Send this transactionRequest to your API endpoint

        print("Payload: \(transactionRequest)")
        guard let cleanedRequest = removeNilValues(from: transactionRequest) else { return }

        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.requestParamasCodable(url: url,method: .post,parameters: cleanedRequest,headers: headers,isJsonRequest: true) { result in
            LoadingIndicatorManager.shared.hideLoading(on: self.view)
            switch result {
            case .success(let data):
                print("Success: \(data)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                
                DispatchQueue.main.async {
                    let jsonDecoder = JSONDecoder()
                    
                    do {
                        let decodedData = try jsonDecoder.decode(CreateTransactionModel.self, from: data)
                        UserManager.shared.getTransactionalData = decodedData.data
                        DispatchQueue.main.async {
                            self.showTransferConfirmationAlert()
                        }
                        
                    } catch {
                        print("Failed to decode JSON: \(error.localizedDescription)")
                    }
                }

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.showToast(message: error.localizedDescription)

            }

        }
    }
    func createConfirmTransaction() {
        let url = UserManager.shared.setBaseURL+"/amr/ras/api/v1_0/ras/confirmtransaction"
        
        let headers:[String:String]? = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")",
                "sender": UserManager.shared.getLoginUserData?["username"] ?? "",
                "channel": "Direct",
                "company": "784825",
                "branch": "784826"
            ]
        guard ReceiverData != nil else {
            print("Invalid ReceiverData or missing input values.")
            return
        }

        let requestBody: [String: Any] = [
            "transaction_ref_number": UserManager.shared.getTransactionalData?.transaction_ref_number ?? ""
        ]
       
        if let cleanedRequest = removeNilValues(from: requestBody) {
            print("Payload: \(cleanedRequest)")
            LoadingIndicatorManager.shared.showLoading(on: self.view)

            APIService.shared.request(url: url, method: .post, parameters: requestBody, headers: headers, isJsonRequest: true) { result in
                   
                LoadingIndicatorManager.shared.hideLoading(on: self.view)
                
                
                switch result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    
                    DispatchQueue.main.async {
                        let jsonDecoder = JSONDecoder()
                        
                        do {
                            let decodedData = try jsonDecoder.decode(CreateTransactionModel.self, from: data)
                            UserManager.shared.getTransactionalData = decodedData.data
                           
                            let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "PaySuccessViewController") as! PaySuccessViewController
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            
                        } catch {
                            print("Failed to decode JSON: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.showToast(message: error.localizedDescription)

                }
            }

        } else {
            print("Error: Unable to remove nil values or clean parameters.")
        }

    }

    func showTransferConfirmationAlert() {
        let alertController = UIAlertController(
            title: "TransferConfirmation",
            message: "We are about to debit your account and confirm the transaction.",
            preferredStyle: .alert
        )
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Transaction canceled.")
            // Handle cancel action
        }
        
        // Pay button
        let payAction = UIAlertAction(title: "Pay And Confirm", style: .default) { _ in
            print("Pay button tapped.")
            // Handle pay action
            self.createConfirmTransaction()
            
        }
        
        
        // Add actions to alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(payAction)
        
        // Present the alert
        if let topController = getTopViewController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    func getTopViewController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedVC = topController?.presentedViewController {
            topController = presentedVC
        }
        
        return topController
    }

    func removeNilValues(from parameters: Any) -> Any? {
        // Case 1: If parameters are a dictionary [String: Any]
        if let dictParameters = parameters as? [String: Any] {
            return dictParameters.compactMapValues { (value: Any) -> Any? in
                // Check if value is a string and remove empty strings
                if let value = value as? String, value.isEmpty {
                    return nil // Remove empty strings
                }
                return value // Keep non-nil and non-empty values
            }
        }

        // Case 2: If parameters are a Codable object
        if let codableParameters = parameters as? Encodable {
            do {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                let jsonData = try encoder.encode(codableParameters)
                guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    return nil // Return nil if serialization fails
                }

                // Filter out nil values from the dictionary
                return jsonDict.compactMapValues { (value: Any) -> Any? in
                    // Check if value is a string and remove empty strings
                    if let value = value as? String, value.isEmpty {
                        return nil // Remove empty strings
                    }
                    return value // Keep non-nil and non-empty values
                }
            } catch {
                print("Error encoding Codable: \(error)")
                return nil
            }
        }

        return nil // Return nil if it's neither a dictionary nor a Codable object
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
        return 6
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
        case 5:
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
                cell.lblTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)

                return cell
                
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPaymentDetail", for: indexPath) as? PaymentDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblAmount.text = String(self.getQuote?.receiving_amount ?? 0)
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
                cell.lblTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)

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
                cell.lblTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)

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
                cell.lblTitle.text = "Fee Details"
                cell.lblTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)

                return cell
                
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as? TransactionDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                let settlementIndex = (indexPath.row - 1) / 5  // Subtract 1 to account for the title row
                if settlementIndex >= 0, settlementIndex < self.getQuote?.fee_details?.count ?? 0,
                   let settlement = self.getQuote?.fee_details?[settlementIndex] {
                    // Determine the key to show based on the remainder
                    let keyIndex = (indexPath.row - 1) % 5  // Subtract 1 to skip the title row
                    let keys = ["type", "model", "amount", "description", "currency_code"]
                    
                    if keyIndex < keys.count {
                        let key = keys[keyIndex]
                        switch key {
                        case "type":
                            cell.lblTitle.text = "Type"
                            cell.lblValue.text = settlement.type

                        case "model":
                            cell.lblTitle.text = "Model"
                            cell.lblValue.text = settlement.model

                        case "amount":
                            cell.lblTitle.text = "Amount"
                            cell.lblValue.text = String(settlement.amount ?? 0.0)
                        case "description":
                            cell.lblTitle.text = "Description"
                            cell.lblValue.text = settlement.description
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
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblTitle.text = "Settlement Details"
                cell.lblTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                return cell
                
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as? TransactionDetailCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                let settlementIndex = (indexPath.row - 1) / 3  // Subtract 1 to account for the title row
                if settlementIndex >= 0, settlementIndex < self.getQuote?.settlement_details?.count ?? 0,
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


            case 5:
            
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
                return 70
            }
            
        case 1...4:
                return 40
        case 5:
            return 50
        default:
            return UITableView.automaticDimension
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

