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
    var getQuotesData: QuoteData?
    
    /// Stores reference text information.
    var getReferenceText: String?
    
    /// Stores detailed rate data.
    var getRatesData: RatesData?
    
    /// Stores the selected transfer type (send/receive).
    var gettransferType: TransferType?
    
    /// Stores transactional data for the created transaction.
    var getTransactionalData: CreateTransactionData?
    
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
