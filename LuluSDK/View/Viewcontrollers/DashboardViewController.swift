//
//  DashboardViewController.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit
import LocalAuthentication
class DashboardViewController: BaseViewController {
    var getCodeInfo: GetCodesModel?
    var getRatesInfo: RatesModel?
    var getServiceCorriderInfo: ServiceCorriderModel?
    @IBOutlet weak var tableView: UITableView!
    var exchangeRates = [ExchangeRate]()
    var blurEffectView: UIVisualEffectView?
    var biometricAuthenticated: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.kBiometricLogged)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.kBiometricLogged)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.shared.applySavedTheme()
        // Observe theme changes
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(themeUpdated),
                name: .themeColorUpdated,
                object: nil
            )

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            // Register custom cells
            tableView.register(UINib(nibName: "HeaderViewCell", bundle: bundle), forCellReuseIdentifier: "cellHeader")
//            tableView.register(UINib(nibName: "ExchangeRateCell", bundle: bundle), forCellReuseIdentifier: "rateExchange")
            tableView.register(UINib(nibName: "TransferCell", bundle: bundle), forCellReuseIdentifier: "cellTransfer")
            tableView.register(UINib(nibName: "RecentTransactionCell", bundle: bundle), forCellReuseIdentifier: "cellTransaction")

            let TitlecellNib = UINib(nibName: "TitleCell", bundle: bundle)
            tableView.register(TitlecellNib, forCellReuseIdentifier: "cellTitle")

            tableView.delegate = self
            tableView.dataSource = self
        } else {
            print("Error: SDK Bundle not found.")
        }
//        getRates()
        print(biometricAuthenticated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

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

        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @objc func appDidBecomeActive() {
        // Check if user is logged in and if biometric authentication is enabled
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            if !biometricAuthenticated {
                showBlurEffect()
                authenticateWithBiometrics()
            }
        }else {
            // Optionally prompt user for manual login if needed
            self.showLoginScreen()
        }
    }
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate to proceed") { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication was successful, navigate to the home screen
//                        self?.navigateToHomeScreen()
                        self?.biometricAuthenticated = true

                    } else {
                        // Biometric authentication failed, show a message or allow retry
                        print("Biometric authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                        // Optionally prompt user for manual login if needed
                        self?.showLoginScreen()
                    }
                    self?.removeBlurEffect()
                }
            }
        } else {
            print("Biometric authentication not available.")
            // If biometrics are not available, fall back to manual login or handle accordingly
            self.showLoginScreen()
            self.removeBlurEffect()
        }
    }

    func navigateToHomeScreen() {
        // Navigate to the home screen (first tab) only after successful biometric authentication
//        self.selectedIndex = 0  // Select the first tab (index 0)

        // No need to change rootViewController here; it could interfere with the existing view hierarchy.
        // Instead, ensure that the user is shown the appropriate tab screen after login
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0 // Optionally, set the tab you want after successful login
        }
    }

    func showLoginScreen() {
        // Show login screen if user isn't logged in or biometric authentication fails
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    func showBlurEffect() {
        // Add a visual effect view with blur effect
        let blurEffect = UIBlurEffect(style: .dark)  // Choose style as per your design
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        if let blurEffectView = blurEffectView {
            // Adjust the frame to cover the whole screen including the tab bar
            blurEffectView.frame = self.view.frame
            self.view.addSubview(blurEffectView)
            self.view.bringSubviewToFront(blurEffectView)  // Ensure it's on top
        }
    }

    func removeBlurEffect() {
        // Remove the blur effect view if it's added
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }

//MARK: API
    func getRates() {
        let url = UserManager.shared.setBaseURL+"/raas/masters/v1/rates"

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
        ]

        let parameters: [String: String] = [:]

        // Make the request using the APIService
        APIService.shared.request(url: url, method: .get, parameters: parameters, headers: headers) { (result: Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                
                // Successfully received the data
                DispatchQueue.main.async {
                    do {
                        let jsonDecoder = JSONDecoder()
                        // Decoding the response data into RatesModel
                        self.getRatesInfo = try jsonDecoder.decode(RatesModel.self, from: data)
                        UserManager.shared.getRatesData = self.getRatesInfo?.data
                        
                        // Map the rates data into exchangeRates
                        if let rates = UserManager.shared.getRatesData?.rates {
                            self.exchangeRates = rates.map { ex in
                                ExchangeRate(
                                    flag: self.flagEmoji(for: ex.to_country ?? ""),
                                    currency: ex.to_currency ?? "",
                                    buy: String(format: "%.2f", ex.rate ?? 0.0),
                                    sell: "85,583"
                                )
                            }
                        } else {
                            self.exchangeRates = []
                        }
                        
                        // Reload the table view with updated data
                        self.tableView.reloadData()
                    } catch {
                        print("Failed to decode JSON: \(error.localizedDescription)")
                    }
                }

            case .failure(let error):
                // Handle failure and show an error message
                print("Error: \(error.localizedDescription)")
                // Optionally, show an alert or update the UI to reflect the failure
            }
        }
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
            return 0//exchangeRates.count
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
            cell.viewMain.backgroundColor = ThemeManager.shared.getThemeColor()
            cell.greetingLabel.text = "Welcome John Doe!"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransfer", for: indexPath) as! TransferCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTransferTap(_:)))
            cell.viewTransfer.isUserInteractionEnabled = true
            cell.viewTransfer.addGestureRecognizer(tapGesture)
            cell.viewScan.isUserInteractionEnabled = true
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleViewScanTap(_:)))
            cell.viewScan.addGestureRecognizer(tapGesture1)

            
            return cell

//        case 2:
//            if indexPath.row == 0 {
//                let titleCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! TitleCell
//                titleCell.lblTitle.text = "Exchange Rates"
//                return titleCell
//            } else if indexPath.row < exchangeRates.count {
//                let rateCell = tableView.dequeueReusableCell(withIdentifier: "rateExchange", for: indexPath) as! ExchangeRateCell
//                let rate = exchangeRates[indexPath.row]
//                if indexPath.row == 1{
//                    rateCell.viewHeader.isHidden = false
//                }else{
//                    rateCell.viewHeader.isHidden = true
//                }
//                return rateCell
//            } else {
//                return UITableViewCell() // Fallback for unexpected rows
//            }

        case 2:
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
//        case 2:
//            if indexPath.row == 0{
//               return 40
//            }else if indexPath.row == 1{
//                return 60
//            }else{
//                return 30
//            }
        case 2:
            if indexPath.row == 0{
               return 40
            }else{
                return 80
            }
        default:
            return 30
        }

    }
    @objc func handleViewScanTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @objc func handleViewTransferTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let url = UserManager.shared.setBaseURL+"/raas/masters/v1/codes?"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
        ]

        let parameters: [String: String] = [:]
        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.request(url: url, method: .get, parameters: parameters, headers: headers) { result in

            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        let jsonDecoder = JSONDecoder()
                        self.getCodeInfo = try? jsonDecoder.decode(GetCodesModel.self, from: data)
                        UserManager.shared.getCodesData = self.getCodeInfo?.data
                        let url1 = UserManager.shared.setBaseURL+"/raas/masters/v1/service-corridor"
                        
                        let headers1 = [
                            "Content-Type": "application/x-www-form-urlencoded",
                            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
                        ]
                        
                        let parameters1: [String: String] = [:]
                        APIService.shared.request(url: url1, method: .get, parameters: parameters1, headers: headers1) { result in
                            LoadingIndicatorManager.shared.hideLoading(on: self.view)
                            

                            switch result {
                            case .success(let data):
                                if let responseString = String(data: data, encoding: .utf8) {
                                    DispatchQueue.main.async {
                                        let jsonDecoder = JSONDecoder()
                                        self.getServiceCorriderInfo = try? jsonDecoder.decode(ServiceCorriderModel.self, from: data)
                                        UserManager.shared.getServiceCorridorData = self.getServiceCorriderInfo?.data
                                        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "TransferMoneyViewController") as! TransferMoneyViewController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    
                                }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}
