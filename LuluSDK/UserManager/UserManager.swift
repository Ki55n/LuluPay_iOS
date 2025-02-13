//
//  UserManager.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 03/02/2025.
//

import Foundation
enum TransferType: String {
    case send = "SEND"
    case receive = "RECEIVE"
}
class UserManager {
    static let shared = UserManager() // Shared instance
    private init() {}
    var loginModel: LoginModel?
    var getCodesData: GetCodesData?
    var getServiceCorridorData: [ServiceCorriderData]?
    var getCurrentRate:[Rates]?
    var getReceiverData:ReceiverDetails?
    var getQuotesData:QuoteData?
    var getReferenceText:String?
    var getRatesData: RatesData?
    var gettransferType:TransferType?
    var getTransactionalData:CreateTransactionData?
    var getLoginUserData:[String:String]?
    var getBankList:MasterBanksList?
}
