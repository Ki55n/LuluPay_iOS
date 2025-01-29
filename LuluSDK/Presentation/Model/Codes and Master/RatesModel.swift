//
//  RatesModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 28/01/2025.
//

import Foundation
struct RatesModel : Codable {
    let status : String?
    let status_code : Int?
    let data : RatesData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(RatesData.self, forKey: .data)
    }

}

struct RatesData : Codable {
    let rates : [Rates]?

    enum CodingKeys: String, CodingKey {

        case rates = "rates"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rates = try values.decodeIfPresent([Rates].self, forKey: .rates)
    }

}

struct Rates : Codable {
    let rate : Double?
    let to_currency_name : String?
    let to_currency : String?
    let from_currency : String?
    let to_country_name : String?
    let to_country : String?
    let receiving_mode : String?

    enum CodingKeys: String, CodingKey {

        case rate = "rate"
        case to_currency_name = "to_currency_name"
        case to_currency = "to_currency"
        case from_currency = "from_currency"
        case to_country_name = "to_country_name"
        case to_country = "to_country"
        case receiving_mode = "receiving_mode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
        to_currency_name = try values.decodeIfPresent(String.self, forKey: .to_currency_name)
        to_currency = try values.decodeIfPresent(String.self, forKey: .to_currency)
        from_currency = try values.decodeIfPresent(String.self, forKey: .from_currency)
        to_country_name = try values.decodeIfPresent(String.self, forKey: .to_country_name)
        to_country = try values.decodeIfPresent(String.self, forKey: .to_country)
        receiving_mode = try values.decodeIfPresent(String.self, forKey: .receiving_mode)
    }

}
