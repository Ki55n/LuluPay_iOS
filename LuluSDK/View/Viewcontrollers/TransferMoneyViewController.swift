//
//  TransferMoneyViewController.swift
//  Sample
//
//  Created by Swathiga on 27/01/25.
//

import UIKit

class TransferMoneyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "RequestMoneyCell", bundle: bundle), forCellReuseIdentifier: "cellReq")
            if let headerView = bundle.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.first as? CustomHeaderView {
                headerView.lblTitle.text = "Transfer Money" // Customize the header text
                headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110)
                headerView.btnBack.addTarget(self, action: #selector(self.moveBack), for: .touchUpInside)
//                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
//                    headerView.viewMain.backgroundColor = customColor
//                } else {
//                    headerView.viewMain.backgroundColor = .cyan// Fallback color if custom color isn't found
//                }
                headerView.viewMain.backgroundColor = ThemeManager.shared.getThemeColor()// Fallback color if custom color isn't found

                tableView.tableHeaderView = headerView
//                let backgroundView = UIView()
//                backgroundView.frame = CGRect(x: 0, y: headerView.frame.minY, width: tableView.frame.width, height: 160)
//                if let customColor = UIColor(named: "customCyanColor", in: bundle, compatibleWith: nil) {
//                    backgroundView.backgroundColor = customColor
//                } else {
//                    backgroundView.backgroundColor = .cyan // Fallback color if custom color isn't found
//                }
//                view.addSubview(backgroundView)
//                view.bringSubviewToFront(tableView)
            }
        }
        tableView.bounces = false
        // Add the custom background view to the table view
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        tableView.sectionHeaderTopPadding = 0
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeUpdated),
            name: .themeColorUpdated,
            object: nil
        )
    ThemeManager.shared.applySavedTheme()

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
    }

    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
extension TransferMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Header, Card, Exchange Rates
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Header and Card have one cell each
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellReq", for: indexPath) as? RequestMoneyCell else {
            fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
        }
        cell.lblTitle.text = "Send Money"
        let cornerRadius: CGFloat = 30
        cell.layer.cornerRadius = cornerRadius
        cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.layer.masksToBounds = true
        
        cell.contentView.layer.cornerRadius = cornerRadius
        cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.contentView.layer.masksToBounds = true
        
        cell.viewmain.layer.cornerRadius = cornerRadius
        cell.viewmain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.viewmain.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        cell.viewSendMoney.addGestureRecognizer(tapGesture)
        cell.viewSendMoney.tag = 1
        cell.viewSendMoney.isUserInteractionEnabled = true  // Ensure the view is tappable
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        cell.viewRequestMoney.addGestureRecognizer(tapGesture1)
        cell.viewRequestMoney.tag = 2
        cell.viewRequestMoney.isUserInteractionEnabled = true  // Ensure the view is tappable
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    @objc func handleTapGesture(_ gesture:UITapGestureRecognizer) {
        // Handle your action here
        if gesture.view?.tag == 1{
            UserManager.shared.gettransferType = .send
        }else{
            UserManager.shared.gettransferType = .receive
        }
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "ContactListViewController") as! ContactListViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "ContactListViewController") as! ContactListViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
