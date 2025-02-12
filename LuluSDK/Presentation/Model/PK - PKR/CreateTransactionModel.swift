//
//  CreateTransactionModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 28/01/2025.
//

import Foundation

//MARK: - Store Data
struct CreateTransactionModel : Codable {
    let status : String?
    let status_code : Int?
    let data : CreateTransactionData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(CreateTransactionData.self, forKey: .data)
    }

}

struct CreateTransactionData : Codable {
    let state : String?
    let sub_state : String?
    let transaction_ref_number : String?
    let transaction_date : String?
    let transaction_gmt_date : String?
    let expires_at : String?
    let expires_at_gmt : String?

    enum CodingKeys: String, CodingKey {

        case state = "state"
        case sub_state = "sub_state"
        case transaction_ref_number = "transaction_ref_number"
        case transaction_date = "transaction_date"
        case transaction_gmt_date = "transaction_gmt_date"
        case expires_at = "expires_at"
        case expires_at_gmt = "expires_at_gmt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        sub_state = try values.decodeIfPresent(String.self, forKey: .sub_state)
        transaction_ref_number = try values.decodeIfPresent(String.self, forKey: .transaction_ref_number)
        transaction_date = try values.decodeIfPresent(String.self, forKey: .transaction_date)
        transaction_gmt_date = try values.decodeIfPresent(String.self, forKey: .transaction_gmt_date)
        expires_at = try values.decodeIfPresent(String.self, forKey: .expires_at)
        expires_at_gmt = try values.decodeIfPresent(String.self, forKey: .expires_at_gmt)
    }

}

struct ConfirmTransactionModel : Codable {
    let status : String?
    let status_code : Int?
    let data : ConfirmTransactionData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(ConfirmTransactionData.self, forKey: .data)
    }

}

struct ConfirmTransactionData : Codable {
    let state : String?
    let sub_state : String?
    let transaction_ref_number : String?

    enum CodingKeys: String, CodingKey {

        case state = "state"
        case sub_state = "sub_state"
        case transaction_ref_number = "transaction_ref_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        sub_state = try values.decodeIfPresent(String.self, forKey: .sub_state)
        transaction_ref_number = try values.decodeIfPresent(String.self, forKey: .transaction_ref_number)
    }

}

// MARK: - Request Models

//struct CreateTransactionRequest: Codable {
//    let type: String?
//    let sourceOfIncome: String?
//    let purposeOfTxn: String?
//    let instrument: String?
//    let message: String?
//    let sender: Sender?
//    let receiver: Receiver?
//    let transaction: Transaction?
//
//    enum CodingKeys: String, CodingKey {
//        case type
//        case sourceOfIncome = "source_of_income"
//        case purposeOfTxn = "purpose_of_txn"
//        case instrument
//        case message
//        case sender
//        case receiver
//        case transaction
//    }
//}

//struct Sender: Codable {
//    let customerNumber: String?
//    let agentCustomerNumber: String?
//
//    enum CodingKeys: String, CodingKey {
//        case customerNumber = "customer_number"
//        case agentCustomerNumber = "agent_customer_number"
//    }
//}

//struct Receiver: Codable {
//    let mobileNumber: String?
//    let firstName: String?
//    let lastName: String?
//    let nationality: String?
//    let bankDetails: BankDetails?
//    let mobileWalletDetails: MobileWalletDetails?
//    let cashPickupDetails: CashPickupDetails?
//
//    enum CodingKeys: String, CodingKey {
//        case mobileNumber = "mobile_number"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case nationality
//        case bankDetails = "bank_details"
//        case mobileWalletDetails = "mobileWallet_details"
//        case cashPickupDetails = "cashPickup_details"
//    }
//}

//struct BankDetails: Codable {
//    let accountTypeCode: String?
//    let accountNumber: String?
//    let isoCode: String?
//    let iban: String?
//    let routingCode: String?
//
//    enum CodingKeys: String, CodingKey {
//        case accountTypeCode = "account_type_code"
//        case accountNumber = "account_number"
//        case isoCode = "iso_code"
//        case iban
//        case routingCode = "routing_code"
//    }
//}

struct MobileWalletDetails: Codable {
    let walletId: String?
    let correspondent: String?
    let bankId: String?
    let branchId: String?

    enum CodingKeys: String, CodingKey {
        case walletId = "wallet_id"
        case correspondent
        case bankId = "bank_id"
        case branchId = "branch_id"
    }
}

struct CashPickupDetails: Codable {
    let correspondentId: String?
    let correspondent: String?
    let correspondentLocationId: String?

    enum CodingKeys: String, CodingKey {
        case correspondentId = "correspondent_id"
        case correspondent
        case correspondentLocationId = "correspondent_location_id"
    }
}

//struct Transaction: Codable {
//    let quoteId: String?
//    let agentTransactionRefNumber: String?
//
//    enum CodingKeys: String, CodingKey {
//        case quoteId = "quote_id"
//        case agentTransactionRefNumber = "agent_transaction_ref_number"
//    }
//}
