
import UIKit
struct ReceiverDetails {
    var firstName: String
    var middleName: String
    var lastName: String
    var phoneNumber: String
    var country: String
    var receiveMode: String
    var accountType: String
    var swiftCode: String
    var iban: String
    var routingCode: String
    var accountNumber: String
    var chooseInstrument: String
}

class SendMoneyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var countryList: [String] { ["BD", "EG", "IN", "PH"] }
    var receiveModeList: [String] { ["Bank", "Cash Pickup"] }
    var accountTypeList: [String] { ["Savings"] }
    var instrumentList: [String] { ["Remittance"] }
    var selectedReceiveMode: String?
    var showIbanField: Bool = false
    var showAccountType: Bool = false
    var showRoutingField:Bool = false
    var showAccountNumberField:Bool = false
    var selectedCountry: String? // Track selected country
    var receiverDetails = ReceiverDetails(firstName: "", middleName: "", lastName: "", phoneNumber: "", country: "", receiveMode: "", accountType: "", swiftCode: "", iban: "", routingCode: "", accountNumber: "", chooseInstrument: "")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupHeaderView()
        
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

    @objc func Submit() {
        let url1 = "https://drap-sandbox.digitnine.com/raas/masters/v1/accounts/validation?receiving_country_code=PK&receiving_mode=BANK&first_name=first name&middle_name=middle name&last_name=last name&iso_code=ALFHPKKA068&iban=PK12ABCD1234567891234567"

        let headers1 = [
//                            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
        ]
        APIService.shared.request(url: url1, method: .get, parameters: [:], headers: headers1) { result in
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    guard let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "PaySuccessViewController") as? PaySuccessViewController else { return }
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    print("Response: \(responseString)")
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
            chooseInstrumentField?.text = instrumentList[0]
            receiverDetails.chooseInstrument = instrumentList[0]

        }
//        tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
        tableView.reloadData()
    }

    @objc private func dismissCountryPicker() {
        countryField?.resignFirstResponder()
        if countryField?.text == ""{
            countryField?.text = countryList[0]
            receiverDetails.country = countryList[0]

        }
//        tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
        tableView.reloadData()
    }

    @objc private func dismissReceiveModePicker() {
        receiveModeField?.resignFirstResponder()
        if receiveModeField?.text == ""{
            receiveModeField?.text = receiveModeList[0]
            receiverDetails.receiveMode = receiveModeList[0]
        }

//        tableView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .automatic)
        tableView.reloadData()
    }
    @objc private func dismissAccountTypePicker() {
        chooseAccountTypeField?.resignFirstResponder()
        if chooseAccountTypeField?.text == ""{
            chooseAccountTypeField?.text = accountTypeList[0]
            receiverDetails.accountType = accountTypeList[0]
        }

//        tableView.reloadRows(at: [IndexPath(row: 7, section: 0)], with: .automatic)
        tableView.reloadData()
    }

}

extension SendMoneyViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            var rowCount = 8
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
       case 2:
            cell.txtFieldAmount.placeholder = "Receiver Middle Name"
            cell.txtFieldAmount.text = receiverDetails.middleName // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateMiddleName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 2
            middleNameField = cell.txtFieldAmount
        case 3:
            cell.txtFieldAmount.placeholder = "Receiver Last Name"
            cell.txtFieldAmount.text = receiverDetails.lastName // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateLastName(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 3
            lastNameField = cell.txtFieldAmount
        case 4:
            cell.txtFieldAmount.placeholder = "Receiver Phone Number"
            cell.txtFieldAmount.text = receiverDetails.phoneNumber // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updatePhoneNumber(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 4
            phoneNumberField = cell.txtFieldAmount
        case 5:
            cell.txtFieldAmount.placeholder = "Choose Country"
            cell.txtFieldAmount.text = receiverDetails.country // Use model value
            cell.txtFieldAmount.tag = 100
            countryField = cell.txtFieldAmount
            countryField?.delegate = self
            self.countryPicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))

//            configurePicker(for: cell.txtFieldAmount, picker: self.countryPicker, data: countryList)
            configureCountryPicker()
            
        case 6:
            cell.txtFieldAmount.placeholder = "Choose Receive Mode"
            cell.txtFieldAmount.text = receiverDetails.receiveMode // Use model value
            cell.txtFieldAmount.tag = 101
            receiveModeField = cell.txtFieldAmount
            receiveModeField?.delegate = self
            self.receivingPicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
            
//            configurePicker(for: cell.txtFieldAmount, picker: self.receivingPicker, data: receiveModeList)
            configureReceiveModePicker()
        case 7:
//            if showAccountType{
                cell.txtFieldAmount.placeholder = "Choose Account Type"
                cell.txtFieldAmount.text = receiverDetails.accountType // Use model value
                cell.txtFieldAmount.tag = 102
                chooseAccountTypeField = cell.txtFieldAmount
                chooseAccountTypeField?.delegate = self
                self.accountTypePicker = UIPickerView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
                
                //            configurePicker(for: cell.txtFieldAmount, picker: self.receivingPicker, data: receiveModeList)
                configureAccountTypePicker()
//            }else{
//                cell.isHidden = true
//            }
        case 8:
            cell.txtFieldAmount.placeholder = "BIC/Swift code"
            cell.txtFieldAmount.text = receiverDetails.swiftCode // Use model value
            cell.txtFieldAmount.addTarget(self, action: #selector(updateSwiftCode(_:)), for: .editingChanged)
            cell.txtFieldAmount.tag = 5
            swiftCodeField = cell.txtFieldAmount
        case 9:
//            if showIbanField {
                cell.txtFieldAmount.placeholder = "IBAN"
                cell.txtFieldAmount.text = receiverDetails.iban // Use model value
                cell.txtFieldAmount.addTarget(self, action: #selector(updateIban(_:)), for: .editingChanged)
                cell.txtFieldAmount.tag = 6
                ibanField = cell.txtFieldAmount
//            } else {
//                cell.isHidden = true
//            }
        case 10:
//            if showRoutingField {
                cell.txtFieldAmount.placeholder = "Routing Code"
                cell.txtFieldAmount.text = receiverDetails.routingCode // Use model value
                cell.txtFieldAmount.addTarget(self, action: #selector(updateRoutingCode(_:)), for: .editingChanged)
                cell.txtFieldAmount.tag = 7
                routingCodeField = cell.txtFieldAmount
                
//            } else {
//                cell.isHidden = true
//            }

        case 11:
//            if showAccountNumberField {
                cell.txtFieldAmount.placeholder = "Account Number"
                cell.txtFieldAmount.text = receiverDetails.accountNumber // Use model value
                cell.txtFieldAmount.addTarget(self, action: #selector(updateAccountNumber(_:)), for: .editingChanged)
                cell.txtFieldAmount.tag = 8
                accountNumberField = cell.txtFieldAmount
                
//            } else {
//                cell.isHidden = true
//            }


        default:
            break
        }
        cell.txtFieldAmount.setLeftPadding(10)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            // For rows controlled by flags, return 0 if the flag is false, otherwise use automatic dimension
            switch indexPath.row {
            case 9: // Iban Field
                return showIbanField ? UITableView.automaticDimension : 0
            case 7: // Account Type Field
                return showAccountType ? UITableView.automaticDimension : 0
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
            return receiveModeList.count
        case accountTypePicker:
            return accountTypeList.count
        case chooseInstrumentPicker:
            return instrumentList.count

        default:
            return 0 // Or handle the case where it's an unknown picker
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case countryPicker:
            return countryList[row]
        case receivingPicker:
            return receiveModeList[row]
        case accountTypePicker:
            return accountTypeList[row]
        case chooseInstrumentPicker:
            return instrumentList[row]

        default:
            return nil
        }
    }
    //remove these functions as they are redundant

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if pickerView == countryPicker {
               let selectedCountryValue = countryList[row]
               receiverDetails.country = selectedCountryValue
               countryField?.text = selectedCountryValue
               // Show IBAN field for multiple countries (PK, UK, AE, EG)
               showIbanField = (selectedCountryValue == "PK" || selectedCountryValue == "UK" || selectedCountryValue == "AE" || selectedCountryValue == "EG")
               showRoutingField = (selectedCountryValue == "BD" || selectedCountryValue == "IN" || selectedCountryValue == "LK" || selectedCountryValue == "PH")
               showAccountNumberField = (selectedCountryValue == "NP" || selectedCountryValue == "IN" || selectedCountryValue == "LK" || selectedCountryValue == "PH" || selectedCountryValue == "ID" || selectedCountryValue == "BD")
               
//               tableView.reloadData()
           } else if pickerView == receivingPicker {
               let selectedReceiveModeValue = receiveModeList[row]
               receiverDetails.receiveMode = selectedReceiveModeValue
               receiveModeField?.text = selectedReceiveModeValue
               // Show account type field if "Bank Account" is selected
               showAccountType = (selectedReceiveModeValue == "Bank")

//               tableView.reloadData()
           }else if pickerView == accountTypePicker {
               let selectedReceiveModeValue = accountTypeList[row]
               receiverDetails.accountType = selectedReceiveModeValue
               chooseAccountTypeField?.text = selectedReceiveModeValue

//               tableView.reloadData()
           }else if pickerView == chooseInstrumentPicker {
               let selectedReceiveModeValue = instrumentList[row]
               receiverDetails.chooseInstrument = selectedReceiveModeValue
               chooseInstrumentField?.text = selectedReceiveModeValue

//               tableView.reloadData()
           }
       }

    @objc private func updateFirstName(_ textField: UITextField) {
        receiverDetails.firstName = textField.text ?? ""
    }

    @objc private func updateMiddleName(_ textField: UITextField) {
        receiverDetails.middleName = textField.text ?? ""
    }

    @objc private func updateLastName(_ textField: UITextField) {
        receiverDetails.lastName = textField.text ?? ""
    }

    @objc private func updatePhoneNumber(_ textField: UITextField) {
        receiverDetails.phoneNumber = textField.text ?? ""
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
    }


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
        return textField == countryField || textField == receiveModeField || textField == chooseAccountTypeField || textField == chooseInstrumentField

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
            
        }
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            middleNameField?.becomeFirstResponder()
        case middleNameField:
            lastNameField?.becomeFirstResponder()
        case lastNameField:
            phoneNumberField?.becomeFirstResponder()
        case phoneNumberField:
            countryField?.becomeFirstResponder()
        case countryField:
            receiveModeField?.becomeFirstResponder() // Close the keyboard for the last field
        case receiveModeField:
            ibanField?.becomeFirstResponder() // Close the keyboard for the last field
        case ibanField:
            swiftCodeField?.becomeFirstResponder() // Close the keyboard for the last field
        case swiftCodeField:
            view.endEditing(true) // Close the keyboard for the last field

        default:
            textField.resignFirstResponder()
        }
        return false
    }
    @objc func doneButtonTappedForCountry() {
        let selectedCountry = countryList[countryPicker?.selectedRow(inComponent: 0) ?? 0]
        receiverDetails.country = selectedCountry
        countryField?.text = selectedCountry
        countryField?.resignFirstResponder()  // Close the picker
    }

    @objc func doneButtonTappedForReceiveMode() {
        let selectedReceiveMode = receiveModeList[receivingPicker?.selectedRow(inComponent: 0) ?? 0]
        receiverDetails.receiveMode = selectedReceiveMode
        receiveModeField?.text = selectedReceiveMode
        receiveModeField?.resignFirstResponder()  // Close the picker
    }
    @objc func doneButtonTappedForAccountType() {
        let selectedReceiveMode = accountTypeList[accountTypePicker?.selectedRow(inComponent: 0) ?? 0]
        receiverDetails.accountType = selectedReceiveMode
        chooseAccountTypeField?.text = selectedReceiveMode
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
