import UIKit

class AmountEntryViewController: UIViewController {
    var transactionRef: String = ""
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Enter Amount"
        
        view.addSubview(amountTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            amountTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amountTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            amountTextField.widthAnchor.constraint(equalToConstant: 200),
            
            sendButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 100),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    @objc private func sendTapped() {
        guard let amount = amountTextField.text, !amount.isEmpty else { return }
        
        let url = UserManager.shared.setBaseURL+"/amr/ras/api/v1_0/ras/confirmtransaction"
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.loginModel?.access_token ?? "")"
        ]
        let parameters: [String: Any] = [
            "transaction_ref_number": transactionRef,
            "amount": amount
        ]
        
        LoadingIndicatorManager.shared.showLoading(on: self.view)
        APIService.shared.request(url: url, method: .post, parameters: parameters, headers: headers,isJsonRequest: true) { result in
            DispatchQueue.main.async {
                LoadingIndicatorManager.shared.hideLoading(on: self.view)
                switch result {
                case .success(let data):
                    print(result)
                    print("Data Response-",data)
                    let alert = UIAlertController(title: "Success", message: "Transaction completed.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                case .failure(let error):
                    print("Transaction error: \(error.localizedDescription)")
                }
            }
        }
    }
}
