//
//  RequestNewCardController.swift
//  Sample
//
//  Created by Swathiga on 22/01/25.
//

import UIKit

class RequestNewCardController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tblList: UITableView!
    
    
    var arrList = [[String:String]]()
    
    var isCheckboxSelected = false // Track checkbox state
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            // Register header view
            let headerNib = UINib(nibName: "CustomHeaderView", bundle: bundle)
            tblList.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")

            let TitlecellNib = UINib(nibName: "TitleCell", bundle: bundle)
            tblList.register(TitlecellNib, forCellReuseIdentifier: "cellTitle")

            let InstantcellNib = UINib(nibName: "InstantAccountCell", bundle: bundle)
            tblList.register(InstantcellNib, forCellReuseIdentifier: "cellInstant")
         
            let ButtoncellNib = UINib(nibName: "Buttoncell", bundle: bundle)
            tblList.register(ButtoncellNib, forCellReuseIdentifier: "cellButton")
            
            let TermscellNib = UINib(nibName: "Termscell", bundle: bundle)
            tblList.register(TermscellNib, forCellReuseIdentifier: "cellTerms")
            
            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {
                headerView.lblTitle.text = "Request a new card" // Customize the header text
                headerView.btnBack.addTarget(self, action: #selector(self.moveBack), for: .touchUpInside)
                headerView.frame = CGRect(x: 0, y: 0, width: tblList.frame.width, height: 150)

                tblList.tableHeaderView = headerView

                let backgroundView = UIView()
                backgroundView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: tblList.frame.width, height: 160)
                backgroundView.backgroundColor = UIColor(named: "customCyanColor") // Set your desired background color here
                view.addSubview(backgroundView)
                view.bringSubviewToFront(tblList)

            }
        }
        

        
       
        
        tblList.bounces = false
        // Add the custom background view to the table view
        tblList.backgroundColor = .clear
        tblList.delegate = self
        tblList.dataSource = self
        tblList.clipsToBounds = false
        addFooterView()
        
    }
    
    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as? TitleCell else {
                return UITableViewCell()
            }
            cell.lblTitle.text = "From Account"
            cell.lblTitle.contentMode = .left
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellInstant", for: indexPath) as? InstantAccountCell else {
                return UITableViewCell()
            }

            return cell

        }
    }
    // MARK: - Add Footer View

    func addFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tblList.frame.width, height: 150))
        footerView.backgroundColor = .white

        // Checkbox button
        let checkboxButton = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        footerView.addSubview(checkboxButton)

        // Description label with underlined Terms & Conditions
        let descriptionLabel = UILabel()
        let text = "By checking this box, I acknowledge that I have read and agree to the Terms & Conditions for Card requests"
        let attributedString = NSMutableAttributedString(string: text)
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemCyan, range: termsRange) // Cyan color
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange) // Underline
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: text.count))
        // Add a tap gesture recognizer to make the "Terms & Conditions" clickable
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsButtonTapped))
        descriptionLabel.addGestureRecognizer(tapGesture)

        descriptionLabel.attributedText = attributedString
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0 // Allow multiple lines
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.isUserInteractionEnabled = true
        // Adjust frame dynamically
        let maxWidth = footerView.frame.width - 70
        let labelSize = descriptionLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        descriptionLabel.frame = CGRect(x: 50, y: 20, width: maxWidth, height: labelSize.height)
        footerView.addSubview(descriptionLabel)


        // Submit button
        let submitButton = UIButton(frame: CGRect(x: 20, y: descriptionLabel.frame.maxY + 20, width: footerView.frame.width - 40, height: 40))
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor(named: "customCyanColor")
        submitButton.layer.cornerRadius = 8
        submitButton.isEnabled = false // Initially disabled
        submitButton.alpha = 0.5
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        footerView.addSubview(submitButton)
        submitButton.tag = 2
        // Adjust footer view height dynamically
        footerView.frame.size.height = submitButton.frame.maxY + 20

        tblList.tableFooterView = footerView
    }
    

    // MARK: - Actions

    @objc func checkboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isCheckboxSelected = sender.isSelected

        // Enable/disable submit button
        if let footerView = tblList.tableFooterView,
           let submitButton = footerView.viewWithTag(2) as? UIButton {
            submitButton.isEnabled = isCheckboxSelected
            submitButton.alpha = isCheckboxSelected ? 1.0 : 0.5
        }
    }

    @objc func termsButtonTapped() {
        print("Terms & Conditions tapped")
        // Navigate to Terms & Conditions page or show an alert
    }

    @objc func submitButtonTapped() {
        print("Submit button tapped")
        // Handle form submission
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "RequestAuthorizationViewController") as! RequestAuthorizationViewController
        navigationController?.pushViewController(vc, animated: true)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        }else{
            return 200
        }
        
    }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0{
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tblList.frame.width, height: 30))
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
