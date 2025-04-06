//
//  UserManager.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 03/02/2025.
//

import Foundation

/// Enum representing the type of transfer.
enum TransferType: String {
    case send = "SEND"      /// Represents a send transfer.
    case receive = "RECEIVE" /// Represents a receive transfer.
}

/// Singleton class to manage user-related data and shared states.
class UserManager {
    
    /// Shared instance of `UserManager` to implement singleton pattern.
    static let shared = UserManager()
    
    /// Private initializer to prevent external instantiation.
    private init() {}
    
    /// Stores login information of the user.
    var loginModel: LoginModel?
    
    /// Stores codes-related data.
    var getCodesData: GetCodesData?
    
    /// Stores service corridor data.
    var getServiceCorridorData: [ServiceCorriderData]?
    
    /// Stores current exchange rates.
    var getCurrentRate: [Rates]?
    
    /// Stores receiver details.
    var getReceiverData: ReceiverDetails?
    
    /// Stores quote data.
    var getQuotesData: QuoteData? {
            get {
                guard let storedData = SecureStorageManager.shared.retrieveDataFromKeychain(key: Constants.kQuotesData),
                      let quoteData = try? JSONDecoder().decode(QuoteData.self, from: storedData) else {
                    return nil
                }
                return quoteData
            }
            set {
                if let newValue = newValue,
                   let encodedData = try? JSONEncoder().encode(newValue) {
                    SecureStorageManager.shared.saveDataToKeychain(key: Constants.kQuotesData, value: encodedData)
                } else {
                    SecureStorageManager.shared.deleteFromKeychain(key: Constants.kQuotesData)
                }
            }
        }
    
    /// Stores reference text information.
    var getReferenceText: String?
    
    /// Stores detailed rate data.
    var getRatesData: RatesData?
    
    /// Stores the selected transfer type (send/receive).
    var gettransferType: TransferType?
    
    /// Stores transactional data for the created transaction.
    var getTransactionalData: CreateTransactionData? {
        get {
            guard let storedData = SecureStorageManager.shared.retrieveDataFromKeychain(key: Constants.kCreateTrnData),
                  let transactionData = try? JSONDecoder().decode(CreateTransactionData.self, from: storedData) else {
                return nil
            }
            return transactionData
        }
        set {
            if let newValue = newValue,
               let encodedData = try? JSONEncoder().encode(newValue) {
                SecureStorageManager.shared.saveDataToKeychain(key: Constants.kCreateTrnData, value: encodedData)
            } else {
                SecureStorageManager.shared.deleteFromKeychain(key: Constants.kCreateTrnData)
            }
        }
    }
    /// stores tansactional ref numbers to get history
    var refNumbers: [String] {
        get {
            guard let data = SecureStorageManager.shared.retrieveDataFromKeychain(key: "refNumbers") else {
                return []
            }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
//            if let encoded = try? JSONEncoder().encode(newValue) {
//                SecureStorageManager.shared.saveDataToKeychain(key: "refNumbers", value: encoded)
//            } else {
//                SecureStorageManager.shared.deleteFromKeychain(key: "refNumbers")
//            }
            // Keep only the last 6 items
            let trimmed = Array(newValue.suffix(6))
            
            if let encoded = try? JSONEncoder().encode(trimmed) {
                SecureStorageManager.shared.saveDataToKeychain(key: "refNumbers", value: encoded)
            } else {
                SecureStorageManager.shared.deleteFromKeychain(key: "refNumbers")
            }
        }

        
    }

    /// Stores login user data in a dictionary with key-value pairs.
    var getLoginUserData: [String: String]?
    
    /// Stores a list of master banks.
    var getBankList: MasterBanksList?
    
    /// Base URL for API calls.
    /// - Note: Uncomment the production URL when needed.
    // var setBaseURL = "https://drap.digitnine.com"   // Production URL
    
    /// Development base URL.
    var setBaseURL = "https://drap-sandbox.digitnine.com" // Dev URL
    var accountTypes : [Account_types]?
}
