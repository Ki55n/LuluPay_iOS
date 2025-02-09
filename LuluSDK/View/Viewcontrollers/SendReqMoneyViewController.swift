//
//  SendReqMoneyViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class SendReqMoneyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
//    private var footerView = ReferenceCell()
    
    var getCurrentRateInfo: [ExchangeRate] = []
    let footerView = UIView()
    
    var currentRate : ExchangeRate?
    var ReceiverData : ReceiverDetails?
    var txtFieldAmount:UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "TextFieldCell", bundle: bundle), forCellReuseIdentifier: "cellTextField")
            tableView.register(UINib(nibName: "ProfileTCell", bundle: bundle), forCellReuseIdentifier: "profileCell")
            tableView.register(UINib(nibName: "TitleCell", bundle: bundle), forCellReuseIdentifier: "cellTitle")

//            tableView.regiLuluSDK.frameworkster(UINib(nibName: "ReferenceCell", bundle: bundle), forCellReuseIdentifier: "cellReference")

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
            
//            if let footerView = UINib(nibName: "ReferenceCell", bundle: bundle).instantiate(withOwner: self, options: nil).first as? ReferenceCell {
//                footerView.txtFieldRef.setLeftPadding(10)
//                footerView = footerView
//                footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
//                tableView.tableFooterView = footerView
//            }

        }
        
        
        setupFooterView()
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
        getRates()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    @objc func moveToNext(){
        self.moveToNextAlert()

    }
    private func setupFooterView() {
        footerView.backgroundColor = .white
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create text field and button
        let referenceTextField = UITextField()
        referenceTextField.borderStyle = .roundedRect
        referenceTextField.placeholder = "Add Reference (Optional)"
        referenceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(self.moveToNext), for: .touchUpInside)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add elements to footer view
        footerView.addSubview(referenceTextField)
        footerView.addSubview(nextButton)
        view.addSubview(footerView)
        
        NSLayoutConstraint.activate([
            // Footer view constraints
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // TextField constraints
            referenceTextField.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            referenceTextField.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            referenceTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Button constraints
            nextButton.leadingAnchor.constraint(equalTo: referenceTextField.trailingAnchor, constant: 8),
            nextButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            nextButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Ensure text field and button share horizontal alignment
            referenceTextField.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.65)
        ])
    }
    @objc private func moveToNextAlert() {
        let paymentAlert = UIAlertController(
            title: "Choose Payment Mode",
            message: "Select your payment mode",
            preferredStyle: .actionSheet
        )
        
        // Payment mode options
        let agencyPaymentAction = UIAlertAction(title: "Agency Payment", style: .default) { _ in
            print("Agency Payment selected")
            // Perform related tasks here
            
            let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "PaymentDetailsViewController") as! PaymentDetailsViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add actions to the alert
        paymentAlert.addAction(agencyPaymentAction)
        paymentAlert.addAction(cancelAction)
        
        // Present the alert
        self.present(paymentAlert, animated: true)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.footerView.frame.origin.y = self.view.frame.height - keyboardHeight - self.footerView.frame.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.footerView.frame.origin.y = self.view.frame.height - self.footerView.frame.height
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }


   

}
extension SendReqMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 3
        default:
            return 0
        }
        
        
        
    }
    func getRates() {
        
        let url = "https://drap-sandbox.digitnine.com/raas/masters/v1/rates"
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
        ]
        
        let parameters: [String: String] = [:]
        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.request(url: url, method: .get, parameters: parameters, headers: headers) { result in
            DispatchQueue.main.async {
                LoadingIndicatorManager.shared.hideLoading(on: self.view)
            }
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    DispatchQueue.main.async {
                        let jsonDecoder = JSONDecoder()
                        let decodedData = try? jsonDecoder.decode(ExchangeRateResponse.self, from: data)
                        self.getCurrentRateInfo = decodedData?.data.rates ?? []
                        UserManager.shared.getCurrentRate = self.getCurrentRateInfo
                        self.ReceiverData = UserManager.shared.getReceiverData
                        print("UserManager.shared.getCodesData: ", UserManager.shared.getCodesData ?? nil)
                        for i in self.getCurrentRateInfo{
                            if i.toCountryName == self.ReceiverData?.country{
                                self.currentRate = i
                                break
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
//            if let arrRate = UserManager.shared.getCurrentRate{
//                
//                for i in arrRate{
//                    if i.toCountry == "PK"{
//                        cell.lblTitle.text = "Current Exchange Rate \n1 AED = \(i.rate)"
//                    }
//                }
//            }
            let rate:String = String(currentRate?.rate ?? 0.0)
            cell.lblTitle.text = "Current Exchange Rate \n1 AED = \(rate)"
            cell.lblTitle.numberOfLines = 0
            cell.lblTitle.textAlignment = .center
            cell.lblTitle.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        return cell

        case 1:
            //use titleCell for title like - Recent, Alphabets
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            let firstName = self.ReceiverData?.firstName ?? ""
            let middleName = self.ReceiverData?.middleName ?? ""
            let lastName = self.ReceiverData?.lastName ?? ""
            let accountType = self.ReceiverData?.accountType ?? ""
            print(accountType,ReceiverData?.accountType)
            let title = "\(firstName) \(middleName) \(lastName)".trimmingCharacters(in: .whitespaces)
            let subtitle = "from \(accountType)".trimmingCharacters(in: .whitespaces)

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
            cell.lblTitle.lineBreakMode = .byWordWrapping
            return cell

        case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTextField", for: indexPath) as? TextFieldCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
            cell.txtFieldAmount.textAlignment = .center
            
            cell.txtFieldAmount.text = (currentRate?.fromCurrency ?? "AED") + " - "
            self.txtFieldAmount = cell.txtFieldAmount
            cell.txtFieldAmount.setLeftPadding(10)
            return cell

            

        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 120
        case 1:
            return 130
        case 2:
            return 60
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1. Get the current text
        let currentText = textField.text ?? ""

        // 2. Check if the user is deleting the "AED - " prefix
        if range.location < 6 && range.length > 0 {
            // Prevent deleting the prefix
            textField.text = "AED - "
            return false
        }

        // 3. Extract only the numeric part of the text
        var numericText = currentText
        if numericText.starts(with: "AED - ") {
            numericText.removeFirst(6)
        }

        // 4. Calculate the new text after the user's input
        let newText = (numericText as NSString).replacingCharacters(in: range, with: string)

        // 5. Update the text field's text with the "AED - " prefix
        textField.text = "AED - " + newText

        // 6. Prevent the default change
            return false
        }
    

    
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
