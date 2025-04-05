//
//  ScanViewController.swift
//  LuluSDK
//
//  Created by Swathiga on 04/04/25.
//

import UIKit
import Photos
import PhotosUI
import CoreImage

class ScanViewController: UIViewController {
    private let scanButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Scan and Pay", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let resultLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Lulu SDK mock config (replace with actual details)
        private let luluApiConfig = [
            "baseUrl": "https://api.lulu.com", // Hypothetical
            "accessToken": "your_access_token_here" // Replace with real token
        ]
    var transactiondata : ConfirmTransactionModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
                title = "Scan and Pay"
                
                setupUI()
                setupActions()
        
    }
    
    private func setupUI() {
            view.addSubview(scanButton)
            view.addSubview(resultLabel)
            
            NSLayoutConstraint.activate([
                scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
                scanButton.widthAnchor.constraint(equalToConstant: 150),
                scanButton.heightAnchor.constraint(equalToConstant: 50),
                
                resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                resultLabel.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20),
                resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }
        
        private func setupActions() {
            scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        }
    
    @objc private func scanButtonTapped() {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        }
}
extension ScanViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self, let image = object as? UIImage, error == nil else {
                DispatchQueue.main.async { self?.resultLabel.text = "Error loading image" }
                return
            }
            
            DispatchQueue.main.async {
                self.scanAndPay(from: image)
            }
        }
    }
}

// QR Scanning and Payment
extension ScanViewController {
//    private func scanAndPay(from image: UIImage) {
//        guard let ciImage = CIImage(image: image),
//              let detector = CIDetector(ofType: CIDetectorTypeQRCode,
//                                      context: nil,
//                                      options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
//              let features = detector.features(in: ciImage) as? [CIQRCodeFeature],
//              let transactionRef = features.first?.messageString else {
//            resultLabel.text = "No QR code detected"
//            return
//        }
//        
//        resultLabel.text = "Transaction: \(transactionRef)\nProcessing payment..."
//        
//        let url = UserManager.shared.setBaseURL+"/amr/ras/api/v1_0/ras/confirmtransaction"
//        let headers = [
//            "Content-Type": "application/json",
//            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
//        ]
//
//        let parameters: [String: String] = ["transaction_ref_number":transactionRef]
//        LoadingIndicatorManager.shared.showLoading(on: self.view)
//        APIService.shared.request(url: url, method: .post, parameters: parameters, headers: headers) { result in
//
//            switch result {
//            case .success(let data):
//                if let responseString = String(data: data, encoding: .utf8) {
//                    DispatchQueue.main.async {
//                        let jsonDecoder = JSONDecoder()
//                        self.transactiondata = try? jsonDecoder.decode(ConfirmTransactionModel.self, from: data)
//                        let url1 = UserManager.shared.setBaseURL+"/amr/ras/api/v1_0/ras/authorize-clearance"
//                        
//                        let headers1 = [
//                            "Content-Type": "application/json",
//                            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
//                        ]
//                        
//                        let parameters1: [String: String] = ["transaction_ref_number":transactionRef]
//                        APIService.shared.request(url: url1, method: .post, parameters: parameters1, headers: headers1) { result in
//                            LoadingIndicatorManager.shared.hideLoading(on: self.view)
//                            
//
//                            switch result {
//                            case .success(let data):
//                                if let responseString = String(data: data, encoding: .utf8) {
//                                    DispatchQueue.main.async {
//                                        let jsonDecoder = JSONDecoder()
//                                        let alert = UIAlertController(title: "Success", message: "Transaction Completed successfully.", preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                                            self.navigationController?.popViewController(animated: true)
//                                        }))
//                                        self.present(alert, animated: true)
//
//                                    }
//                                    
//                                }
//                            case .failure(let error):
//                                print("Error: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func scanAndPay(from image: UIImage) {
        guard let ciImage = CIImage(image: image),
              let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: nil,
                                        options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature],
              let rawString = features.first?.messageString else {
            resultLabel.text = "No QR code detected"
            return
        }
        print("Scanned: \(rawString)")
//        resultLabel.text = "Scanned: \(rawString)"
        
        struct TransactionRefModel: Codable {
            let transaction_ref_number: String
        }
        
        if let data = rawString.data(using: .utf8) {
            do {
                let model = try JSONDecoder().decode(TransactionRefModel.self, from: data)
                let extractedRef = model.transaction_ref_number
                
                DispatchQueue.main.async {
                    let amountVC = AmountEntryViewController()
                    amountVC.transactionRef = extractedRef
                    self.navigationController?.pushViewController(amountVC, animated: true)
                }
            } catch {
                print("JSON decode failed, passing raw string")
                // Fallback: Push raw string if not JSON
                DispatchQueue.main.async {
                    let amountVC = AmountEntryViewController()
                    amountVC.transactionRef = rawString
                    self.navigationController?.pushViewController(amountVC, animated: true)
                }
            }
        }
    }


}
