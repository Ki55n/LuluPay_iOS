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

struct CreateTransactionRequest: Codable {
    let type: String
    let sourceOfIncome: String
    let purposeOfTxn: String
    let instrument: String
    let message: String
    let sender: Sender
    let receiver: Receiver
    let transaction: Transaction
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case sourceOfIncome = "source_of_income"
        case purposeOfTxn = "purpose_of_txn"
        case instrument = "instrument"
        case message = "message"
        case sender = "sender"
        case receiver = "receiver"
        case transaction = "transaction"
    }

}

struct Sender: Codable {
    var customerNumber: String
    var agentCustomerNumber: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case customerNumber = "customer_number"
        case agentCustomerNumber = "agent_customer_number"
    }
    init(customerNumber: String, agentCustomerNumber: String? = nil) {
        self.customerNumber = customerNumber
        self.agentCustomerNumber = agentCustomerNumber
    }

}

struct Receiver: Codable {
    let agentReceiverId: String?
    let mobileNumber: String
    let firstName: String
    let lastName: String
    let middleName: String?
    let dateOfBirth: String?
    let gender: String?
    let receiverAddress: [ReceiverAddress]?
    let receiverId: [String]?
    let nationality: String
    let relationCode: String
    let name: String?
    let typeOfBusiness: String?
    let bankDetails: BankDetails?
    let mobileWalletDetails: MobileWalletDetails?
    let cashPickupDetails: CashPickupDetails?
    let agentReceiverNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case agentReceiverId = "agent_receiver_id"
        case mobileNumber = "mobile_number"
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case dateOfBirth = "date_of_birth"
        case gender = "gender"
        case receiverAddress = "receiver_address"
        case receiverId = "receiver_id"
        case nationality = "nationality"
        case relationCode = "relation_code"
        case name = "name"
        case typeOfBusiness = "type_of_business"
        case bankDetails = "bank_details"
        case mobileWalletDetails = "mobileWallet_details"
        case cashPickupDetails = "cashPickup_details"
        case agentReceiverNumber = "agent_receiver_number"
    }
    
    init(
        agentReceiverId: String? = nil,
        mobileNumber: String,
        firstName: String,
        lastName: String,
        middleName: String? = nil,
        dateOfBirth: String? = nil,
        gender: String? = nil,
        receiverAddress: [ReceiverAddress]? = nil,
        receiverId: [String]? = nil,
        nationality: String,
        relationCode: String,
        name: String? = nil,
        typeOfBusiness: String? = nil,
        bankDetails: BankDetails? = nil,
        mobileWalletDetails: MobileWalletDetails? = nil,
        cashPickupDetails: CashPickupDetails? = nil,
        agentReceiverNumber: String? = nil
    ) {
        self.agentReceiverId = agentReceiverId
        self.mobileNumber = mobileNumber
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.receiverAddress = receiverAddress
        self.receiverId = receiverId
        self.nationality = nationality
        self.relationCode = relationCode
        self.name = name
        self.typeOfBusiness = typeOfBusiness
        self.bankDetails = bankDetails
        self.mobileWalletDetails = mobileWalletDetails
        self.cashPickupDetails = cashPickupDetails
        self.agentReceiverNumber = agentReceiverNumber
    }
}

struct ReceiverAddress: Codable {
    let addressType: String?
    let addressLine: String?
    let streetName: String?
    let buildingNumber: String?
    let postCode: String?
    let pobox: String?
    let townName: String?
    let countrySubdivision: String?
    let countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case addressType = "address_type"
        case addressLine = "address_line"
        case streetName = "street_name"
        case buildingNumber = "building_number"
        case postCode = "post_code"
        case pobox = "pobox"
        case townName = "town_name"
        case countrySubdivision = "country_subdivision"
        case countryCode = "country_code"
    }
    
}

struct BankDetails: Codable {
    var accountTypeCode: String?
    var accountNumber: String?
    var isoCode: String?
    var iban: String?
    var routingCode: String?
    enum CodingKeys: String, CodingKey {
        case accountTypeCode = "account_type_code"
        case accountNumber = "account_number"
        case isoCode = "iso_code"
        case iban = "iban"
        case routingCode = "routing_code"
    }
    init(
            accountTypeCode: String? = nil,
            accountNumber: String? = nil,
            isoCode: String? = nil,
            iban: String? = nil,
            routingCode: String? = nil
        ) {
            self.accountTypeCode = accountTypeCode
            self.accountNumber = accountNumber
            self.isoCode = isoCode
            self.iban = iban
            self.routingCode = routingCode
        }
}

struct CashPickupDetails: Codable {
    var correspondentId: String?
    var correspondent: String?
    var correspondentLocationId: String?
    
    enum CodingKeys: String, CodingKey {
        case correspondentId = "correspondent_id"
        case correspondent = "correspondent"
        case correspondentLocationId = "correspondent_location_id"
    }
    init(
        correspondentId: String? = nil,
        correspondent: String? = nil,
        correspondentLocationId: String? = nil
    ) {
        self.correspondentId = correspondentId
        self.correspondent = correspondent
        self.correspondentLocationId = correspondentLocationId
    }
}

struct MobileWalletDetails: Codable {
    var walletId: String?
    var correspondent: String?
    var bankId: String?
    var branchId: String?
    
    enum CodingKeys: String, CodingKey {
        case walletId = "wallet_id"
        case correspondent = "correspondent"
        case bankId = "bank_id"
        case branchId = "branch_id"
    }
    init(
          walletId: String? = nil,
          correspondent: String? = nil,
          bankId: String? = nil,
          branchId: String? = nil
      ) {
          self.walletId = walletId
          self.correspondent = correspondent
          self.bankId = bankId
          self.branchId = branchId
      }
}

struct Transaction: Codable {
    var quoteId: String
    var agentTransactionRefNumber: String
    var receivingMode: String?
    var sendingCountryCode: String?
    var sendingCurrencyCode: String?
    var receivingCountryCode: String?
    var receivingCurrencyCode: String?
    var sendingAmount: Decimal?
    var receivingAmount: Decimal?
    var paymentMode: String?
    
    enum CodingKeys: String, CodingKey {
        case quoteId = "quote_id"
        case agentTransactionRefNumber = "agent_transaction_ref_number"
        case receivingMode = "receiving_mode"
        case sendingCountryCode = "sending_country_code"
        case sendingCurrencyCode = "sending_currency_code"
        case receivingCountryCode = "receiving_country_code"
        case receivingCurrencyCode = "receiving_currency_code"
        case sendingAmount = "sending_amount"
        case receivingAmount = "receiving_amount"
        case paymentMode = "payment_mode"
    }
    init(
        quoteId: String,
            agentTransactionRefNumber: String,
            receivingMode: String? = nil,
            sendingCountryCode: String? = nil,
            sendingCurrencyCode: String? = nil,
            receivingCountryCode: String? = nil,
            receivingCurrencyCode: String? = nil,
            sendingAmount: Decimal? = nil,
            receivingAmount: Decimal? = nil,
            paymentMode: String? = nil
        ) {
            self.quoteId = quoteId
            self.agentTransactionRefNumber = agentTransactionRefNumber
            self.receivingMode = receivingMode
            self.sendingCountryCode = sendingCountryCode
            self.sendingCurrencyCode = sendingCurrencyCode
            self.receivingCountryCode = receivingCountryCode
            self.receivingCurrencyCode = receivingCurrencyCode
            self.sendingAmount = sendingAmount
            self.receivingAmount = receivingAmount
            self.paymentMode = paymentMode
        }
}
