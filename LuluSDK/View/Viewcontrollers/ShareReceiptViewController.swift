//
//  ShareReceiptViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit
import SwiftUI
import PDFKit

class ShareReceiptViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bundle = Bundle(identifier: "com.finance.LuluSDK") {
            tableView.register(UINib(nibName: "TransactionDetailCell", bundle: bundle), forCellReuseIdentifier: "cellDetail")
            tableView.register(UINib(nibName: "PaymentDetailCell", bundle: bundle), forCellReuseIdentifier: "cellPaymentDetail")
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

    }
    @objc func moveBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Submit(){
        let url = UserManager.shared.setBaseURL+"/api/v1_0/ras/transaction-receipt"

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")",
            "sender": UserManager.shared.getLoginUserData?["username"] ?? "",
            "channel": "Direct",
            "company": "784825",
            "branch": "784826"
        ]

        let parameters: [String: Any] = [
            "transaction_ref_number": UserManager.shared.getTransactionalData?.transaction_ref_number ?? "",
        ]
        LoadingIndicatorManager.shared.showLoading(on: self.view)

        APIService.shared.newRequestPdfData(url: url, method: .get, parameters: parameters, headers: headers) { result in
            LoadingIndicatorManager.shared.hideLoading(on: self.view)
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    DispatchQueue.main.async {
                        // Patientname_YYYY_MM_DD T HH:MM:SS
                        let fileName = "Receipt"
                        if let fileURL = self.savePDFToFile(pdfData: data, fileName: "\(fileName).pdf") {
                            //                                                                shareAndDownloadPDF(pdfData: pdfData, fileName: "\(fileName).pdf")
                            let pdfViewer = PDFViewer(url: fileURL)
                            let hostingController = UIHostingController(rootView: pdfViewer)
                            if let windowScene = UIApplication.shared.connectedScenes
                                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                               let rootViewController = windowScene.windows.first?.rootViewController {
                                rootViewController.present(hostingController, animated: true, completion: nil)
                            } else {
                                print("Failed to find an active UIWindowScene or rootViewController")
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
//        let vc = MyStoryboardLoader.getStoryboard(name: "Lulu")?.instantiateViewController(withIdentifier: "RequestNewCardController") as! RequestNewCardController
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.popToRootViewController(animated: true)

    }

    func savePDFToFile(pdfData: Data, fileName: String) -> URL? {
        do {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                try pdfData.write(to: fileURL)
                print("PDF saved to: \(fileURL)")
                return fileURL
            }
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
        }
        return nil
    }
   

}
extension ShareReceiptViewController: UITableViewDelegate, UITableViewDataSource {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
            return 8
        case 2:
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
                let getQuote = UserManager.shared.getQuotesData
            
                cell.lblAmount.text = String(getQuote?.receiving_amount ?? 0)
                cell.lblTitle.text = "Amount"
                cell.lblCurrencyCode.text = getQuote?.receiving_country_code
                if let countryCode = getQuote?.receiving_country_code {
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
                    
                    if indexPath.row == 1{
                        cell.lblTitle.text = "Transaction Number"
                        cell.lblValue.text = "#"+(UserManager.shared.getTransactionalData?.transaction_ref_number ?? "")
                        cell.lblValue.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                    } else if indexPath.row == 2{
                        cell.lblTitle.text = "Transaction Date"
                        cell.lblValue.text = UserManager.shared.getTransactionalData?.transaction_date

                    }else if indexPath.row == 3{
                        cell.lblTitle.text = "Transaction Receipient"
                        cell.lblValue.text = UserManager.shared.getTransactionalData?.transaction_date

                    }else if indexPath.row == 4{
                        cell.lblTitle.text = "Amount"
                        cell.lblValue.text = String(UserManager.shared.getQuotesData?.sending_amount ?? 0)

                    }else if indexPath.row == 5{
                        cell.lblTitle.text = "Commission Fee"
                        if let feeDetails = UserManager.shared.getQuotesData?.fee_details {
                            if let commissionDetail = feeDetails.first(where: { $0.type as? String == "COMMISSION" }) {
                                if let amount = commissionDetail.amount as? Double {
                                    print("Commission amount: \(amount)")
                                    cell.lblValue.text = String(amount)

                                } else {
                                    print("Commission amount not found")
                                }
                            } else {
                                print("No commission type found in fee_details")
                            }
                        }


                    }else if indexPath.row == 6{
                        cell.lblTitle.text = "Processing Fee"
                        if let feeDetails = UserManager.shared.getQuotesData?.fee_details {
                            if let commissionDetail = feeDetails.first(where: { $0.type as? String == "TAX" }) {
                                if let amount = commissionDetail.amount as? Double {
                                    print("Tax amount: \(amount)")
                                    cell.lblValue.text = String(amount)

                                } else {
                                    print("Commission amount not found")
                                }
                            } else {
                                print("No commission type found in fee_details")
                            }
                        }

                    }else if indexPath.row == 7{
                        cell.lblTitle.text = "Total Amount"
                        cell.lblValue.text = String(UserManager.shared.getQuotesData?.total_payin_amount ?? 0)
                        cell.lblValue.font = UIFont.systemFont(ofSize: 15, weight: .bold)


                    }else{
                        cell.lblTitle.text = "Reference Number"
                        cell.lblValue.text = "REF12345567"

                    }
                    return cell

                
            }

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellbutton", for: indexPath) as? ButtonCell else {
                fatalError("Unable to dequeue HeaderViewCell with identifier 'cellHeader'")
            }
            cell.btnCancel.isHidden = true
            cell.btnTitle.setTitle("Share receipt", for: .normal)
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
                return 60
            }
        case 1:
            if indexPath.row == 0{
                return 40
            }else{
                return 60
            }
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

struct PDFViewer: View {
    let url: URL
    
    var body: some View {
        VStack {
            if let pdfDocument = PDFDocument(url: url) {
                PDFKitView(pdfDocument: pdfDocument)
            } else {
                Text("Failed to load PDF")
            }
            
            HStack {
                Button(action: {
                    sharePDF()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .frame(width: 24, height: 24)
                }
                .padding()
            }
        }
    }
    
    private func sharePDF() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let viewController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
                viewController.present(activityViewController, animated: true, completion: nil)
            } else if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func downloadPDF() {
        // PDF is already saved to url when this function is called
        print("PDF saved to: \(url)")
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // No update necessary
    }
}
