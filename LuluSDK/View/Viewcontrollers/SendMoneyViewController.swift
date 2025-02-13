
import UIKit
import Alamofire
struct ReceiverDetails:Codable {
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var phoneNumber: String?
    var country: String?
    var country_code: String?
    var receiveMode: String?
    var accountType: String?
    var swiftCode: String?
    var iban: String?
    var routingCode: String?
    var accountNumber: String?
    var chooseInstrument: String?
}

class SendMoneyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var countryList: [(name: String, code: String)] = [
        ("China", "CH"),
        ("Egypt", "EG"),
        ("India", "IN"),
        ("Pakistan", "PK"),
        ("Philippines", "PH"),
        ("Sri Lanka", "SL")
    ]
    
    let countryPhonePatterns: [String: String] = [
        "China": "^(?:\\+86)1[1-9]\\d{9}$", // +86
        "Egypt": "^(?:\\+20)1[0-2,5]{1}[0-9]{8}$", // +20
        "India": "^(?:\\+91)[6-9]\\d{9}$", // +91
        "Pakistan": "^(?:\\+92)3[0-9]{9}$", // +92
        "Philippines": "^(?:\\+63)9[0-9]{9}$", // +63
        "Sri Lanka": "^(?:\\+94)7[0-9]{8}$" // +94
    ]
    
    var receiveModeList: [Receiving_modes]?// { ["Bank", "Cash Pickup"] }
    var accountTypeList: [Account_types]?
    var instrumentList: [Instruments]?
    var selectedReceiveMode: String?
    var showIbanField: Bool = false
    var showAccountType: Bool = false
    var showRoutingField:Bool = false
    var showAccountNumberField:Bool = false
    var showSwiftCodeField:Bool = false
    
    var selectedCountry: String? // Track selected country
    var receiverDetails = ReceiverDetails(firstName: "", middleName: "", lastName: "", phoneNumber: "", country: "", country_code: "", receiveMode: "", accountType: "", swiftCode: "", iban: "", routingCode: "", accountNumber: "", chooseInstrument: "")
    var firstNameField: UITextField?
    var middleNameField: UITextField?
    var lastNameField: UITextField?
    var phoneNumberField: UITextField?
    var countryField: UITextField?  // For the country picker
    var receiveModeField: UITextField? // For the receive mode picker
    var routingCodeField: UITextField?
    var accountNumberField: UITextField?
    var swiftCodeField: UITextField?
    var ibanField: UITextField?
    var chooseAccountTypeField:UITextField?
    var chooseInstrumentField:UITextField?
    var countryPicker : UIPickerView?
    var receivingPicker : UIPickerView?
    var accountTypePicker : UIPickerView?
    var chooseInstrumentPicker:UIPickerView?
    
    var allTextFields: [UITextField?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupHeaderView()
        allTextFields = [firstNameField, middleNameField, lastNameField, phoneNumberField, countryField, receiveModeField, ibanField, swiftCodeField, accountNumberField, routingCodeField, chooseAccountTypeField, chooseInstrumentField]
        
        firstNameField?.delegate = self
        middleNameField?.delegate = self
        lastNameField?.delegate = self
        phoneNumberField?.delegate = self
        countryField?.delegate = self
        receiveModeField?.delegate = self
        swiftCodeField?.delegate = self
        ibanField?.delegate = self
        chooseAccountTypeField?.delegate = self
        accountNumberField?.delegate = self
        routingCodeField?.delegate = self
        chooseInstrumentField?.delegate = self
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        print("Instrument Api call started....")
        getInstruments {
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getAccountType {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getReceivingModes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    func addDoneButtonToTextField(_ textField: UITextField?) {
        guard let textField = textField else { return }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
    }
    
    // Function to dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setupTableView() {
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "TextFieldCell", bundle: bundle), forCellReuseIdentifier: "cellTextField")
            tableView.register(UINib(nibName: "TitleCell", bundle: bundle), forCellReuseIdentifier: "cellTitle")
            tableView.register(UINib(nibName: "ButtonCell", bundle: bundle), forCellReuseIdentifier: "cellbutton")
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.clipsToBounds = false
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInset = .zero
        
        
    }
    
    private func setupHeaderView() {
        if let bundle = Bundle(identifier: "com.finance.LuluSDK"),
           let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {
            
            headerView.lblTitle.text = "Send Money"
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110)
            headerView.btnBack.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
            headerView.viewMain.backgroundColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) ?? .cyan
            tableView.tableHeaderView = headerView
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: tableView.frame.width, height: tableView.frame.height / 5)
            backgroundView.backgroundColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) ?? .cyan
            view.addSubview(backgroundView)
            view.bringSubviewToFront(tableView)
        }
    }
    
    @objc func moveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //    @objc func dismissPicker() {
    //        if countryField?.isFirstResponder == true  {
    //            // Resign first responder and update text before reloading row
    //            countryField?.resignFirstResponder()
    //            // Slight delay to allow the picker dismissal to complete
    ////            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    ////                self.tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
    ////            }
    //        } else if receiveModeField?.isFirstResponder == true {
    //            // Resign first responder and update text before reloading row
    //            receiveModeField?.resignFirstResponder()
    //            // Slight delay to allow the picker dismissal to complete
    ////            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    ////                self.tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .automatic)
    ////            }
    //        }
    //    }
    func isPhoneNumberValid(for country: String, phoneNumber: String) -> Bool {
        guard let pattern = countryPhonePatterns[country] else { return false }
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: phoneNumber.count)
        return regex?.firstMatch(in: phoneNumber, options: [], range: range) != nil
    }
    func isValidPhoneNumber(_ phoneNo: String) -> Bool {
        let phoneNumberRegex = "^(\\+|0)[0-9]{3,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: phoneNo)
    }
    
    // MARK: API
    @objc func Submit() {
        if let firstName = receiverDetails.firstName, firstName.isEmpty {
            showToast(message: "First Name field is required")
        } else if let lastName = receiverDetails.lastName, lastName.isEmpty {
            showToast(message: "Last Name field is required")
        } else if let phoneNumber = receiverDetails.phoneNumber, phoneNumber.isEmpty {
            showToast(message: "Phone Number field is required")
        } else if !isValidPhoneNumber(receiverDetails.phoneNumber ?? "") {
            showToast(message: "Invalid phone number for \(receiverDetails.country)")
        } else if let iban = receiverDetails.iban ,iban.isEmpty && showIbanField {
            showToast(message: "Receiver account number or iban is required!")
            
        } else if let accountNumber = receiverDetails.accountNumber,accountNumber.isEmpty && showAccountNumberField {
            showToast(message: "Receiver account number or iban is required!")
            
        } else if let accountType = receiverDetails.accountType, accountType.isEmpty, showAccountType {
            showToast(message: "Receiver account type is required!")
        } else if let chooseInstrument = receiverDetails.chooseInstrument, chooseInstrument.isEmpty {
            showToast(message: "Instrument is required!")
        } else if let swiftCode = receiverDetails.swiftCode, swiftCode.isEmpty && showSwiftCodeField {
            showToast(message: "Swift/iso code is required!")
        } else if let routingCode = receiverDetails.routingCode, routingCode.isEmpty && showRoutingField {
            showToast(message: "Routing code is required!")
        }
        else{
            let url1 = UserManager.shared.setBaseURL+"/raas/masters/v1/accounts/validation"//?receiving_country_code=PK&receiving_mode=BANK&first_name=first name&middle_name=middle name&last_name=last name&iso_code=ALFHPKKA068&iban=PK12ABCD1234567891234567"
            var params = [String:String?]()
            let receiverdata = UserManager.shared.getReceiverData
            if receiverdata?.receiveMode == "Bank"{
                // For receiving mode with bank transfer
                
                if receiverdata?.country_code == "IN"{
                    // For countries that accept routing code and account number
                    params = ["first_name":receiverDetails.firstName,"last_name":receiverDetails.lastName,"receiving_country_code":self.receiverDetails.country_code,"receiving_mode":self.receiverDetails.receiveMode?.uppercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: ""),"route_code":receiverDetails.routingCode,"account_number":receiverDetails.accountNumber]
                    
                }else if receiverdata?.country_code == "PK" || receiverdata?.country_code == "EG" || receiverdata?.country_code == "LK"{
                    // For countries that accept isoCode(BIC/SWIFT CODE) and iban
                    
                    params = ["first_name":receiverDetails.firstName,"last_name":receiverDetails.lastName,"receiving_country_code":self.receiverDetails.country_code,"receiving_mode":self.receiverDetails.receiveMode?.uppercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: ""),"iso_code":receiverDetails.swiftCode,"iban":receiverDetails.iban]
                    
                }else{
                    // For countries that accept isocode(Bic/Swift Code) and account number
                    params = ["first_name":receiverDetails.firstName,"last_name":receiverDetails.lastName,"receiving_country_code":self.receiverDetails.country_code,"receiving_mode":self.receiverDetails.receiveMode?.uppercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: ""),"iso_code":receiverDetails.swiftCode,"account_number":receiverDetails.accountNumber]
                    
                }
            }else{
                // For receiving mode with Cash pickup or Mobile wallet
                
                params = ["first_name":receiverDetails.firstName,"last_name":receiverDetails.lastName,"receiving_country_code":self.receiverDetails.country_code,"receiving_mode":self.receiverDetails.receiveMode?.uppercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: ""),"iso_code":receiverDetails.swiftCode]
                
            }
            //            let params = ["first_name":receiverDetails.firstName,"last_name":receiverDetails.lastName,"receiving_country_code":self.receiverDetails.country_code,"receiving_mode":self.receiverDetails.receiveMode?.uppercased(),"iso_code":receiverDetails.swiftCode,"iban":receiverDetails.iban,"route_code":receiverDetails.routingCode,"account_number":receiverDetails.accountNumber,"account_type":receiverDetails.accountType?.uppercased()]
            let filteredParams = params.compactMapValues { $0?.isEmpty == true ? nil : $0 }
            
            print(params)
            //            let receiverDetails = ReceiverDetails(firstName: receiverDetails.firstName,middleName: receiverDetails.middleName,lastName: receiverDetails.lastName,phoneNumber: receiverDetails.phoneNumber,country: receiverDetails.country,country_code: receiverDetails.country_code,receiveMode: receiverDetails.receiveMode, accountType: receiverDetails.accountType, swiftCode: receiverDetails.swiftCode, iban: receiverDetails.iban, routingCode: receiverDetails.routingCode, accountNumber: receiverDetails.accountNumber,chooseInstrument: receiverDetails.chooseInstrument)
            
            let headers1:[String:String]? = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
                
            ]
            LoadingIndicatorManager.shared.showLoading(on: self.view)
            APIService.shared.requestParamasCodable(url: url1, method: .get, parameters: filteredParams, headers: headers1) { result in
                LoadingIndicatorManager.shared.hideLoading(on: self.view)
                
                switch result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        UserManager.shared.getReceiverData = self.receiverDetails
                        guard let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "SendReqMoneyViewController") as? SendReqMoneyViewController else { return }
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("Response: \(responseString)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        /*
         
         
         
         let headers1:HTTPHeaders = [
         //                            "Content-Type": "application/x-www-form-urlencoded",
         "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
         
         ]
         LoadingIndicatorManager.shared.showLoading(on: self.view)
         APIService.shared.makeAlamofireRequest(url: url1, parameters: receiverDetails,headers: headers1,encoding: URLEncoding.queryString) { result in
         switch result {
         case .success(let data):
         if let responseString = String(data: data, encoding: .utf8) {
         UserManager.shared.getReceiverData = self.receiverDetails
         guard let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "SendReqMoneyViewController") as? SendReqMoneyViewController else { return }
         vc.hidesBottomBarWhenPushed = true
         self.navigationController?.pushViewController(vc, animated: true)
         print("Response: \(responseString)")
         }
         case .failure(let error):
         print("Error: \(error.localizedDescription)")
         }
         }
         
         }
         
         */
        
    }
    func getReceivingModes(completion: @escaping () -> Void){
        let url1 = UserManager.shared.setBaseURL+"/raas/masters/v1/codes"
        var params = [String:String?]()
        
        
        params = ["code":"RECEIVING_MODES","service_type":"C2C"]
        let filteredParams = params.compactMapValues { $0?.isEmpty == true ? nil : $0 }
        
        print(params)
        //            let receiverDetails = ReceiverDetails(firstName: receiverDetails.firstName,middleName: receiverDetails.middleName,lastName: receiverDetails.lastName,phoneNumber: receiverDetails.phoneNumber,country: receiverDetails.country,country_code: receiverDetails.country_code,receiveMode: receiverDetails.receiveMode, accountType: receiverDetails.accountType, swiftCode: receiverDetails.swiftCode, iban: receiverDetails.iban, routingCode: receiverDetails.routingCode, accountNumber: receiverDetails.accountNumber,chooseInstrument: receiverDetails.chooseInstrument)
        
        let headers1:[String:String]? = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
            
        ]
        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.requestParamasCodable(url: url1, method: .get, parameters: filteredParams, headers: headers1) { result in
            LoadingIndicatorManager.shared.hideLoading(on: self.view)
            
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    do {
                        // Parse the JSON response
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("JsonObject:", jsonObject ?? "nil")
                        
                        // Check if status is "success"
                        if let status = jsonObject?["status"] as? String, status == "success" {
                            // Access the data key
                            if let data = jsonObject?["data"] as? [String: Any] {
                                // Access the 'receiving_modes' array from data
                                if let receivingModesData = data["receiving_modes"] as? [[String: Any]] {
                                    print("Receiving Modes: \(receivingModesData)")
                                    
                                    // Now decode the 'receiving_modes' data
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject: receivingModesData)
                                        let decodedList = try JSONDecoder().decode([Receiving_modes].self, from: jsonData)
                                        print("Decoded Receiving Modes: \(decodedList)")
                                        self.receiveModeList = decodedList
                                        // Here you can update the UI or handle the decoded data
                                        
                                    } catch {
                                        print("Failed to decode receiving modes: \(error)")
                                    }
                                } else {
                                    print("Error: 'receiving_modes' not found in data")
                                }
                            } else {
                                print("Error: 'data' key is missing or malformed")
                            }
                        } else {
                            print("Error: Status is not 'success' or missing")
                        }
                    } catch {
                        print("Error during JSON serialization: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
    }
    func getInstruments(completion: @escaping () -> Void){
        let url1 = UserManager.shared.setBaseURL+"/raas/masters/v1/codes"
        var params = [String:String?]()
        params = ["code":"INSTRUMENTS","service_type":"C2C"]
        let filteredParams = params.compactMapValues { $0?.isEmpty == true ? nil : $0 }
        
        print(params)
        //            let receiverDetails = ReceiverDetails(firstName: receiverDetails.firstName,middleName: receiverDetails.middleName,lastName: receiverDetails.lastName,phoneNumber: receiverDetails.phoneNumber,country: receiverDetails.country,country_code: receiverDetails.country_code,receiveMode: receiverDetails.receiveMode, accountType: receiverDetails.accountType, swiftCode: receiverDetails.swiftCode, iban: receiverDetails.iban, routingCode: receiverDetails.routingCode, accountNumber: receiverDetails.accountNumber,chooseInstrument: receiverDetails.chooseInstrument)
        
        let headers1:[String:String]? = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
            
        ]
        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.requestParamasCodable(url: url1, method: .get, parameters: filteredParams, headers: headers1) { result in
            LoadingIndicatorManager.shared.hideLoading(on: self.view)
            
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    do {
                        // Parse the JSON response
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("JsonObject:", jsonObject ?? "nil")
                        
                        // Check if status is "success"
                        if let status = jsonObject?["status"] as? String, status == "success" {
                            // Access the data key
                            if let data = jsonObject?["data"] as? [String: Any] {
                                // Access the 'receiving_modes' array from data
                                if let receivingModesData = data["instruments"] as? [[String: Any]] {
                                    print("Receiving Modes: \(receivingModesData)")
                                    
                                    // Now decode the 'receiving_modes' data
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject: receivingModesData)
                                        let decodedList = try JSONDecoder().decode([Instruments].self, from: jsonData)
                                        print("Decoded Receiving Modes: \(decodedList)")
                                        self.instrumentList = decodedList
                                        // Here you can update the UI or handle the decoded data
                                        
                                    } catch {
                                        print("Failed to decode receiving modes: \(error)")
                                    }
                                } else {
                                    print("Error: 'receiving_modes' not found in data")
                                }
                            } else {
                                print("Error: 'data' key is missing or malformed")
                            }
                        } else {
                            print("Error: Status is not 'success' or missing")
                        }
                    } catch {
                        print("Error during JSON serialization: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    func getAccountType(completion: @escaping () -> Void){
        let url1 = UserManager.shared.setBaseURL+"/raas/masters/v1/codes"
        var params = [String:String?]()
        
        params = ["code":"ACCOUNT_TYPES","service_type":"C2C"]
        let filteredParams = params.compactMapValues { $0?.isEmpty == true ? nil : $0 }
        
        let headers1:[String:String]? = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
            
        ]
        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.requestParamasCodable(url: url1, method: .get, parameters: filteredParams, headers: headers1) { result in
            LoadingIndicatorManager.shared.hideLoading(on: self.view)
            
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    do {
                        // Parse the JSON response
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        // Check if 'instruments' exists in the response
                        if let receivingModesData = jsonObject?["account_types"] as? [[String: Any]] {
                            print("Instruments Data: \(receivingModesData)")
                            
                            // Attempt to decode the instruments data into an array of Instruments objects
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: receivingModesData)
                                let decodedList = try JSONDecoder().decode([Account_types].self, from: jsonData)
                                self.accountTypeList = decodedList
                                
                                // Reload table view row with the updated data
                                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                                
                                // Call the completion handler
                                completion()
                                
                            } catch {
                                print("Failed to decode instruments data: \(error)")
                            }
                        } else {
                            print("Error: 'instruments' key not found in the response")
                        }
                    } catch {
                        print("Error during JSON serialization: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    //    private func configurePicker(for textField: UITextField?, picker: UIPickerView?, data: [String]) {
    //        guard let textField = textField, let picker = picker else { return }
    //        picker.delegate = self
    //           picker.dataSource = self
    //           picker.tag = textField.tag
    //           textField.inputView = picker
    //
    //           let toolbar = UIToolbar()
    //           toolbar.sizeToFit()
    //           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
    //           toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
    //           textField.inputAccessoryView = toolbar
    //       }
    private func configureCountryPicker() {
        guard let countryField = countryField else { return }
        
        let countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.tag = 100
        self.countryPicker = countryPicker
        
        countryField.inputView = countryPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissCountryPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        countryField.inputAccessoryView = toolbar
    }
    private func configureReceiveModePicker() {
        guard let receiveModeField = receiveModeField else { return }
        
        let receivePicker = UIPickerView()
        receivePicker.delegate = self
        receivePicker.dataSource = self
        receivePicker.tag = 101
        self.receivingPicker = receivePicker
        
        receiveModeField.inputView = receivePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissReceiveModePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        receiveModeField.inputAccessoryView = toolbar
    }
    private func configureAccountTypePicker() {
        guard let accountPicker = accountTypePicker else { return }
        
        let receivePicker = UIPickerView()
        receivePicker.delegate = self
        receivePicker.dataSource = self
        receivePicker.tag = 102
        self.accountTypePicker = receivePicker
        
        chooseAccountTypeField?.inputView = receivePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAccountTypePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        chooseAccountTypeField?.inputAccessoryView = toolbar
    }
    private func configurechooseInstrumentPicker() {
        guard let accountPicker = chooseInstrumentPicker else { return }
        
        let receivePicker = UIPickerView()
        receivePicker.delegate = self
        receivePicker.dataSource = self
        receivePicker.tag = 103
        self.chooseInstrumentPicker = receivePicker
        
        chooseInstrumentField?.inputView = receivePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissinstrumentPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        chooseInstrumentField?.inputAccessoryView = toolbar
    }
    @objc private func dismissinstrumentPicker() {
        chooseInstrumentField?.resignFirstResponder()
        if chooseInstrumentField?.text == ""{
            chooseInstrumentField?.text = instrumentList?[0].code
            receiverDetails.chooseInstrument = instrumentList?[0].code
            
        }
        //        tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
        let sectionIndex = 1 // Replace with the target section number
        tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
    }
    
    @objc private func dismissCountryPicker() {
        countryField?.resignFirstResponder()
        if countryField?.text == ""{
            countryField?.text = countryList[0].name
            receiverDetails.country = countryList[0].name
            receiverDetails.country_code = countryList[0].code
            
            var selectedCountryValue = countryList[0]
            showIbanField = (selectedCountryValue.code == "PK" || selectedCountryValue.code == "EG" || selectedCountryValue.code == "SL")
            showRoutingField = (selectedCountryValue.code == "IN")
            showAccountNumberField = (selectedCountryValue.code == "IN" || selectedCountryValue.code == "CH" || selectedCountryValue.code == "PH" || selectedCountryValue.code == "SL")
            showSwiftCodeField = (selectedCountryValue.code != "IN")
            
        }
        
        //        tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
        //        let sectionIndex = 0 // Replace with the target section number
        //        tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        
    }
    
    @objc private func dismissReceiveModePicker() {
        receiveModeField?.resignFirstResponder()
        if receiveModeField?.text == ""{
            receiveModeField?.text = receiveModeList?[0].code
            receiverDetails.receiveMode = receiveModeList?[0].code
        }
        
        tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .automatic)
        //        let sectionIndex = 0 // Replace with the target section number
        //        tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        
    }
    @objc private func dismissAccountTypePicker() {
        chooseAccountTypeField?.resignFirstResponder()
        if chooseAccountTypeField?.text == ""{
            chooseAccountTypeField?.text = accountTypeList?[0].code
            receiverDetails.accountType = accountTypeList?[0].code
            
            var selectedReceiveModeValue = receiveModeList?[0].code
            showAccountType = (selectedReceiveModeValue == "BANK")
            
        }
        
        //        tableView.reloadRows(at: [IndexPath(row: 7, section: 0)], with: .automatic)
        //        let sectionIndex = 0 // Replace with the target section number
        //        tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        
    }
    
}

extension SendMoneyViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            var rowCount = 7
            if showIbanField {
                rowCount += 1 // Add 1 row for IBAN
            }
            
            if showRoutingField {
                rowCount += 1 // Add 1 row for Routing code
            }
            
            if showAccountNumberField {
                rowCount += 1 // Add 1 row for Account number
            }
            if showAccountType{
                rowCount += 1
            }
            if showSwiftCodeField{
                rowCount += 1
            }
            
            
            return 12
            
            //            return showIbanField ? 9 : 8
            
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue TitleCell")
                }
                cell.lblTitle.text = "Receiver Details"
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTextField", for: indexPath) as? TextFieldCell else {
                    fatalError("Unable to dequeue TextFieldCell")
                }
                configureField(cell, at: indexPath.row)
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue TitleCell")
                }
                cell.lblTitle.text = "Transaction Details"
                return cell
            } else if indexPath.row == 1{
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTextField", for: indexPath) as? TextFieldCell else {
                    fatalError("Unable to dequeue TextFieldCell")
                }
                
                cell.txtFieldAmount.placeholder = "Choose an instrument"
                cell.txtFieldAmount.text = receiverDetails.chooseInstrument // Use model value
                cell.txtFieldAmount.tag = 103
                chooseInstrumentField = cell.txtFieldAmount
                chooseInstrumentField?.delegate = self
                self.chooseInstrumentPicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
                
                //            configurePicker(for: cell.txtFieldAmount, picker: self.receivingPicker, data: receiveModeList)
                configurechooseInstrumentPicker()
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellbutton", for: indexPath) as? ButtonCell else {
                    fatalError("Unable to dequeue ButtonCell")
                }
                cell.btnCancel.isHidden = true
                cell.btnTitle.setTitle("Validate Account", for: .normal)
                cell.btnTitle.addTarget(self, action: #selector(Submit), for: .touchUpInside)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    private func configureField(_ cell: TextFieldCell, at row: Int) {
        cell.txtFieldAmount.inputView = nil
        cell.isHidden = false
        
        
        switch row {
        case 1:
            cell.txtFieldAmount.placeholder = "Receiver First Name"
            cell.txtFieldAmount.text = receiverDetails.firstName // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 1
            firstNameField = cell.txtFieldAmount
            addDoneButtonToTextField(firstNameField)
            
        case 2:
            cell.txtFieldAmount.placeholder = "Receiver Middle Name"
            cell.txtFieldAmount.text = receiverDetails.middleName // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 2
            middleNameField = cell.txtFieldAmount
            addDoneButtonToTextField(middleNameField)
            
        case 3:
            cell.txtFieldAmount.placeholder = "Receiver Last Name"
            cell.txtFieldAmount.text = receiverDetails.lastName // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 3
            lastNameField = cell.txtFieldAmount
            addDoneButtonToTextField(lastNameField)
            
        case 4:
            cell.txtFieldAmount.placeholder = "Receiver Phone Number"
            cell.txtFieldAmount.text = receiverDetails.phoneNumber // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 4
            phoneNumberField = cell.txtFieldAmount
            addDoneButtonToTextField(phoneNumberField)
            
        case 5:
            cell.txtFieldAmount.placeholder = "Choose Country"
            cell.txtFieldAmount.text = receiverDetails.country // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 100
            countryField = cell.txtFieldAmount
            countryField?.delegate = self
            self.countryPicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
            addDoneButtonToTextField(countryField)
            
            //            configurePicker(for: cell.txtFieldAmount, picker: self.countryPicker, data: countryList)
            configureCountryPicker()
            
        case 6:
            cell.txtFieldAmount.placeholder = "Choose Receive Mode"
            cell.txtFieldAmount.text = receiverDetails.receiveMode // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            
            cell.txtFieldAmount.tag = 101
            receiveModeField = cell.txtFieldAmount
            receiveModeField?.delegate = self
            self.receivingPicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
            addDoneButtonToTextField(receiveModeField)
            
            //            configurePicker(for: cell.txtFieldAmount, picker: self.receivingPicker, data: receiveModeList)
            configureReceiveModePicker()
        case 7:
            //            if showAccountType{
            cell.txtFieldAmount.placeholder = "Choose Account Type"
            cell.txtFieldAmount.text = receiverDetails.accountType // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            
            cell.txtFieldAmount.tag = 102
            chooseAccountTypeField = cell.txtFieldAmount
            chooseAccountTypeField?.delegate = self
            self.accountTypePicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
            addDoneButtonToTextField(chooseAccountTypeField)
            
            //            configurePicker(for: cell.txtFieldAmount, picker: self.receivingPicker, data: receiveModeList)
            configureAccountTypePicker()
            //            }else{
            //                cell.isHidden = true
            //            }
        case 8:
            
            cell.txtFieldAmount.placeholder = "BIC/Swift code"
            cell.txtFieldAmount.text = receiverDetails.swiftCode // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 5
            swiftCodeField = cell.txtFieldAmount
            addDoneButtonToTextField(swiftCodeField)
            
        case 9:
            //            if showIbanField {
            cell.txtFieldAmount.placeholder = "IBAN"
            cell.txtFieldAmount.text = receiverDetails.iban // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 6
            ibanField = cell.txtFieldAmount
            addDoneButtonToTextField(ibanField)
            
            //            } else {
            //                cell.isHidden = true
            //            }
        case 10:
            //            if showRoutingField {
            cell.txtFieldAmount.placeholder = "Routing Code"
            cell.txtFieldAmount.text = receiverDetails.routingCode // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 7
            routingCodeField = cell.txtFieldAmount
            addDoneButtonToTextField(routingCodeField)
            
            //            } else {
            //                cell.isHidden = true
            //            }
            
        case 11:
            //            if showAccountNumberField {
            cell.txtFieldAmount.placeholder = "Account Number"
            cell.txtFieldAmount.text = receiverDetails.accountNumber // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateFirstName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 8
            accountNumberField = cell.txtFieldAmount
            addDoneButtonToTextField(accountNumberField)
            
            //            } else {
            //                cell.isHidden = true
            //            }
            
            
        default:
            break
        }
        cell.txtFieldAmount.setLeftPadding(10)
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if indexPath.section == 0 {
    //            if indexPath.row == 6{
    //                getReceivingModes()
    //            }
    //        }else
    //        {
    //            if indexPath.row == 0{
    //                getInstruments()
    //            }
    //        }
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            // For rows controlled by flags, return 0 if the flag is false, otherwise use automatic dimension
            switch indexPath.row {
            case 9: // Iban Field
                return showIbanField ? UITableView.automaticDimension : 0
            case 7: // Account Type Field
                return showAccountType ? UITableView.automaticDimension : 0
            case 8: // Account Type Field
                return showSwiftCodeField ? UITableView.automaticDimension : 0
            case 10: // Routing Field
                return showRoutingField ? UITableView.automaticDimension : 0
            case 11: // Account Number Field
                return showAccountNumberField ? UITableView.automaticDimension : 0
                
            default:
                return UITableView.automaticDimension
            }
            
            
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
        }
        
        //        return UITableView.automaticDimension
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.countryPicker {
            return 1
        }
        else if pickerView == self.receivingPicker {
            return 1
        }else if pickerView == self.accountTypePicker {
            return 1
        }else if pickerView == self.chooseInstrumentPicker {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case countryPicker:
            return countryList.count
        case receivingPicker:
            return receiveModeList?.count ?? 0
        case accountTypePicker:
            return accountTypeList?.count ?? 0
        case chooseInstrumentPicker:
            return instrumentList?.count ?? 0
            
        default:
            return 0 // Or handle the case where it's an unknown picker
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case countryPicker:
            return countryList[row].name
        case receivingPicker:
            return receiveModeList?[row].code
        case accountTypePicker:
            return accountTypeList?[row].code
        case chooseInstrumentPicker:
            return instrumentList?[row].code
            
        default:
            return nil
        }
    }
    //remove these functions as they are redundant
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker {
            let selectedCountryValue = countryList[row]
            receiverDetails.country = selectedCountryValue.name
            receiverDetails.country_code = selectedCountryValue.code
            countryField?.text = selectedCountryValue.name
            // Show IBAN field for multiple countries (PK, CH, IN, EG, SL, PH)
            showIbanField = (selectedCountryValue.code == "PK" || selectedCountryValue.code == "EG" || selectedCountryValue.code == "SL")
            showRoutingField = (selectedCountryValue.code == "IN")
            showAccountNumberField = (selectedCountryValue.code == "IN" || selectedCountryValue.code == "CH" || selectedCountryValue.code == "PH" || selectedCountryValue.code == "SL")
            showSwiftCodeField = (selectedCountryValue.code != "IN")
            //               tableView.reloadData()
            let sectionIndex = 0 // Replace with the target section number
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
            
        } else if pickerView == receivingPicker {
            let selectedReceiveModeValue = receiveModeList?[row]
            receiverDetails.receiveMode = selectedReceiveModeValue?.code
            receiveModeField?.text = selectedReceiveModeValue?.code
            // Show account type field if "Bank Account" is selected
            showAccountType = (selectedReceiveModeValue?.code == "BANK")
            //               tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .automatic)
            
            let sectionIndex = 0 // Replace with the target section number
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        }else if pickerView == accountTypePicker {
            let selectedReceiveModeValue = accountTypeList?[row]
            receiverDetails.accountType = selectedReceiveModeValue?.code
            chooseAccountTypeField?.text = selectedReceiveModeValue?.code
            
            //               tableView.reloadData()
            tableView.reloadRows(at: [IndexPath(row: 7, section: 0)], with: .automatic)
            
        }else if pickerView == chooseInstrumentPicker {
            let selectedReceiveModeValue = instrumentList?[row]
            receiverDetails.chooseInstrument = selectedReceiveModeValue?.code
            chooseInstrumentField?.text = selectedReceiveModeValue?.code
            
            //               tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    @objc private func updateFirstName(_ textField: UITextField) {
        if textField == self.firstNameField{
            receiverDetails.firstName = textField.text ?? ""
        }else if textField == self.middleNameField{
            receiverDetails.middleName = textField.text ?? ""
        }else if textField == self.lastNameField{
            receiverDetails.lastName = textField.text ?? ""
        }else if textField == self.phoneNumberField{
            receiverDetails.phoneNumber = textField.text ?? ""
        }else if textField == self.countryField{
            receiverDetails.country = textField.text ?? ""
        }else if textField == self.ibanField{
            receiverDetails.iban = textField.text ?? ""
        }else if textField == self.accountNumberField{
            receiverDetails.accountNumber = textField.text ?? ""
        }else if textField == self.receiveModeField{
            receiverDetails.receiveMode = textField.text ?? ""
        }else if textField == self.swiftCodeField{
            receiverDetails.swiftCode = textField.text ?? ""
        }else if textField == self.routingCodeField{
            receiverDetails.routingCode = textField.text ?? ""
        }else if textField == self.chooseInstrumentField{
            receiverDetails.chooseInstrument = textField.text ?? ""
        }else if textField == self.chooseAccountTypeField{
            receiverDetails.accountType = textField.text ?? ""
        }
    }
    
    /*  @objc private func updateMiddleName(_ textField: UITextField) {
     
     receiverDetails.middleName = textField.text ?? ""
     }
     
     @objc private func updateLastName(_ textField: UITextField) {
     receiverDetails.lastName = textField.text ?? ""
     }
     
     @objc private func updatePhoneNumber(_ textField: UITextField) {
     receiverDetails.phoneNumber = textField.text ?? ""
     }
     @objc private func updateCountry(_ textField: UITextField) {
     receiverDetails.country = textField.text ?? ""
     }
     
     
     @objc private func updateIban(_ textField: UITextField) {
     receiverDetails.iban = textField.text ?? ""
     }
     
     @objc private func updateSwiftCode(_ textField: UITextField) {
     receiverDetails.swiftCode = textField.text ?? ""
     }
     @objc private func updateRoutingCode(_ textField: UITextField) {
     receiverDetails.routingCode = textField.text ?? ""
     }
     @objc private func updateAccountNumber(_ textField: UITextField) {
     receiverDetails.accountNumber = textField.text ?? ""
     } */
    
    
    //remove redundant functions since you assigned them programatically
    //    @objc private func updateChoosePaymentMode(_ textField: UITextField) {
    //        receiverDetails.receiveMode = textField.text ?? ""
    //    }
    //@objc private func updateChoosecountry(_ textField: UITextField) {
    //   receiverDetails.country = textField.text ?? ""
    //}
    //MARK:  TextField
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Prevent manual editing of these text fields
        return textField == countryField || textField == receiveModeField || textField == chooseAccountTypeField || textField == chooseInstrumentField || textField == firstNameField || textField == middleNameField || textField == lastNameField || textField == phoneNumberField || textField == ibanField || textField == swiftCodeField || textField == routingCodeField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        if textField.tag == 1 {
            textField.resignFirstResponder()
            self.receiverDetails.firstName = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 2 {
            textField.resignFirstResponder()
            self.receiverDetails.middleName = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 3 {
            textField.resignFirstResponder()
            self.receiverDetails.lastName = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 4 {
            textField.resignFirstResponder()
            self.receiverDetails.phoneNumber = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 5 {
            textField.resignFirstResponder()
            self.receiverDetails.swiftCode = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 6 {
            textField.resignFirstResponder()
            self.receiverDetails.iban = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 100 {
            textField.resignFirstResponder()
            self.receiverDetails.country = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 101 {
            textField.resignFirstResponder()
            self.receiverDetails.receiveMode = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 102 {
            textField.resignFirstResponder()
            self.receiverDetails.accountType = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 7 {
            textField.resignFirstResponder()
            self.receiverDetails.routingCode = textField.text ?? ""
            textField.resignFirstResponder()
            
        }else if textField.tag == 8 {
            textField.resignFirstResponder()
            self.receiverDetails.accountNumber = textField.text ?? ""
            textField.resignFirstResponder()
            
        }
        
        
    }
    
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //
    //    }
    
    @objc func doneButtonTappedForCountry() {
        let selectedCountry = countryList[countryPicker?.selectedRow(inComponent: 0) ?? 0]
        receiverDetails.country = selectedCountry.name
        countryField?.text = selectedCountry.name
        countryField?.resignFirstResponder()  // Close the picker
    }
    
    @objc func doneButtonTappedForReceiveMode() {
        let selectedReceiveMode = receiveModeList?[receivingPicker?.selectedRow(inComponent: 0) ?? 0]
        receiverDetails.receiveMode = selectedReceiveMode?.code
        receiveModeField?.text = selectedReceiveMode?.code
        receiveModeField?.resignFirstResponder()  // Close the picker
    }
    @objc func doneButtonTappedForAccountType() {
        let selectedReceiveMode = accountTypeList?[accountTypePicker?.selectedRow(inComponent: 0) ?? 0]
        receiverDetails.accountType = selectedReceiveMode?.code
        chooseAccountTypeField?.text = selectedReceiveMode?.code
        chooseAccountTypeField?.resignFirstResponder()  // Close the picker
    }
    
    @objc func cancelButtonTappedForCountry() {
        countryField?.resignFirstResponder()  // Close the picker without making changes
    }
    
    @objc func cancelButtonTappedForReceiveMode() {
        receiveModeField?.resignFirstResponder()  // Close the picker without making changes
    }
    private func createPickerToolbar(for textField: UITextField, doneAction: Selector, cancelAction: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: doneAction)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelAction)
        
        toolbar.setItems([cancelButton, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        
        return toolbar
    }
    
}
