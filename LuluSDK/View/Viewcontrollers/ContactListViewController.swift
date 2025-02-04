//
//  ContactListViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class ContactListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "ContactListTableViewCell", bundle: bundle), forCellReuseIdentifier: "cellContact")
            tableView.register(UINib(nibName: "SearchCell", bundle: bundle), forCellReuseIdentifier: "cellSearch")
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

    @objc func addContact(){
        addContactView()
    }
    
    
    func addContactView() {
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayView.tag = 1001

        // Add tap gesture to dismiss on outside touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlayView))
        overlayView.addGestureRecognizer(tapGesture)

        // Form Container
        let formView = UIView(frame: CGRect(x: 40, y: (self.view.frame.height / 2) - 150, width: self.view.frame.width - 80, height: 250))
        formView.backgroundColor = .white
        formView.layer.cornerRadius = 12
        formView.clipsToBounds = true
        overlayView.addSubview(formView)

        // Title Label
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 10, width: formView.frame.width - 32, height: 30))
        titleLabel.text = "Add New Contact"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        formView.addSubview(titleLabel)

        // Full Name TextField
        let nameTextField = UITextField(frame: CGRect(x: 16, y: 50, width: formView.frame.width - 32, height: 40))
        nameTextField.placeholder = "Full Name"
        nameTextField.borderStyle = .roundedRect
        formView.addSubview(nameTextField)

        // Account Number TextField
        let accountNumberTextField = UITextField(frame: CGRect(x: 16, y: 110, width: formView.frame.width - 32, height: 40))
        accountNumberTextField.placeholder = "Enter Account Number"
        accountNumberTextField.keyboardType = .numberPad
        accountNumberTextField.borderStyle = .roundedRect
        formView.addSubview(accountNumberTextField)

        // Submit Button
        let submitButton = UIButton(frame: CGRect(x: 16, y: 170, width: formView.frame.width - 32, height: 40))
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        formView.addSubview(submitButton)

        // Add the overlay to the main view
        self.view.addSubview(overlayView)

        // Animate the appearance
        overlayView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            overlayView.alpha = 1
        }
    }

    @objc func dismissOverlayView() {
        if let overlayView = self.view.viewWithTag(1001) {
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
    }

    @objc func handleSubmit() {
        print("Submit button pressed")
        dismissOverlayView()
    }

}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Header, Card, Exchange Rates
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            //use titleCell for title like - Recent, Alphabets
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellSearch", for: indexPath) as? SearchCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            return cell

        case 1:
            if indexPath.row == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblTitle.text = "Recent"
                return cell

            }else{
                //use titleCell for title like - Recent, Alphabets
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellContact", for: indexPath) as? ContactListTableViewCell else {
                    fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
                }
                cell.lblName.text = "Rogers"
                cell.lblAccountNumber.text = "1234 **** ****"
                //            cell.profileImageView.backgroundColor = .red
                return cell

            }
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellbutton", for: indexPath) as? ButtonCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.btnCancel.isHidden = true
            cell.btnTitle.setTitle("Add new contact", for: .normal)
            cell.btnTitle.addTarget(self, action: #selector(self.addContact), for: .touchUpInside)
            return cell

        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "SendReqMoneyViewController") as! SendReqMoneyViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 100
        case 1:
            if indexPath.row == 0{
                return 50
            }
            return 80
        case 2:
            return 55
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
