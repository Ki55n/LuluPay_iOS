//
//  CreateTransactionModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 28/01/2025.
//

import Foundation
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
