//
//  ServiceCorriderModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 27/01/2025.
//

import Foundation
struct ServiceCorriderModel : Codable {
    let status : String?
    let status_code : Int?
    let data : [ServiceCorriderData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent([ServiceCorriderData].self, forKey: .data)
    }

}

struct ServiceCorriderData : Codable {
    let instrument : String?
    let transaction_type : String?
    let receiving_mode : String?
    let sending_country : String?
    let sending_country_code : String?
    let receiving_country : String?
    let receiving_country_code : String?
    let limit_currency : String?
    let limit_currency_code : String?
    let limit_min_amount : Int?
    let limit_per_transaction : Int?
    let send_min_amount : Int?
    let send_max_amount : Int?
    let corridor_currencies : [Corridor_currencies]?

    enum CodingKeys: String, CodingKey {

        case instrument = "instrument"
        case transaction_type = "transaction_type"
        case receiving_mode = "receiving_mode"
        case sending_country = "sending_country"
        case sending_country_code = "sending_country_code"
        case receiving_country = "receiving_country"
        case receiving_country_code = "receiving_country_code"
        case limit_currency = "limit_currency"
        case limit_currency_code = "limit_currency_code"
        case limit_min_amount = "limit_min_amount"
        case limit_per_transaction = "limit_per_transaction"
        case send_min_amount = "send_min_amount"
        case send_max_amount = "send_max_amount"
        case corridor_currencies = "corridor_currencies"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        instrument = try values.decodeIfPresent(String.self, forKey: .instrument)
        transaction_type = try values.decodeIfPresent(String.self, forKey: .transaction_type)
        receiving_mode = try values.decodeIfPresent(String.self, forKey: .receiving_mode)
        sending_country = try values.decodeIfPresent(String.self, forKey: .sending_country)
        sending_country_code = try values.decodeIfPresent(String.self, forKey: .sending_country_code)
        receiving_country = try values.decodeIfPresent(String.self, forKey: .receiving_country)
        receiving_country_code = try values.decodeIfPresent(String.self, forKey: .receiving_country_code)
        limit_currency = try values.decodeIfPresent(String.self, forKey: .limit_currency)
        limit_currency_code = try values.decodeIfPresent(String.self, forKey: .limit_currency_code)
        limit_min_amount = try values.decodeIfPresent(Int.self, forKey: .limit_min_amount)
        limit_per_transaction = try values.decodeIfPresent(Int.self, forKey: .limit_per_transaction)
        send_min_amount = try values.decodeIfPresent(Int.self, forKey: .send_min_amount)
        send_max_amount = try values.decodeIfPresent(Int.self, forKey: .send_max_amount)
        corridor_currencies = try values.decodeIfPresent([Corridor_currencies].self, forKey: .corridor_currencies)
    }

}

struct Corridor_currencies : Codable {
    let correspondent : String?
    let anywhere : Int?
    let sending_currency : String?
    let sending_currency_code : String?
    let receiving_currency : String?
    let receiving_currency_code : String?
    let correspondent_name : String?

    enum CodingKeys: String, CodingKey {

        case correspondent = "correspondent"
        case anywhere = "anywhere"
        case sending_currency = "sending_currency"
        case sending_currency_code = "sending_currency_code"
        case receiving_currency = "receiving_currency"
        case receiving_currency_code = "receiving_currency_code"
        case correspondent_name = "correspondent_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        correspondent = try values.decodeIfPresent(String.self, forKey: .correspondent)
        anywhere = try values.decodeIfPresent(Int.self, forKey: .anywhere)
        sending_currency = try values.decodeIfPresent(String.self, forKey: .sending_currency)
        sending_currency_code = try values.decodeIfPresent(String.self, forKey: .sending_currency_code)
        receiving_currency = try values.decodeIfPresent(String.self, forKey: .receiving_currency)
        receiving_currency_code = try values.decodeIfPresent(String.self, forKey: .receiving_currency_code)
        correspondent_name = try values.decodeIfPresent(String.self, forKey: .correspondent_name)
    }

}
