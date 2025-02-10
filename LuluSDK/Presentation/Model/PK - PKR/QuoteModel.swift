//
//  QuoteModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 28/01/2025.
//

import Foundation

struct QuoteModel : Codable {
    let status : String?
    let status_code : Int?
    let data : QuoteData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(QuoteData.self, forKey: .data)
    }

}

struct QuoteData : Codable {
    let state : String?
    let sub_state : String?
    let quote_id : String?
    let created_at : String?
    let created_at_gmt : String?
    let expires_at : String?
    let expires_at_gmt : String?
    let receiving_country_code : String?
    let receiving_currency_code : String?
    let sending_country_code : String?
    let sending_currency_code : String?
    let sending_amount : Int?
    let receiving_amount : Double?
    let total_payin_amount : Double?
    let fx_rates : [Fx_rates]?
    let fee_details : [Fee_details]?
    let settlement_details : [Settlement_details]?
    let correspondent_rules : [[String:String]]?
    let price_guarantee : String?

    enum CodingKeys: String, CodingKey {

        case state = "state"
        case sub_state = "sub_state"
        case quote_id = "quote_id"
        case created_at = "created_at"
        case created_at_gmt = "created_at_gmt"
        case expires_at = "expires_at"
        case expires_at_gmt = "expires_at_gmt"
        case receiving_country_code = "receiving_country_code"
        case receiving_currency_code = "receiving_currency_code"
        case sending_country_code = "sending_country_code"
        case sending_currency_code = "sending_currency_code"
        case sending_amount = "sending_amount"
        case receiving_amount = "receiving_amount"
        case total_payin_amount = "total_payin_amount"
        case fx_rates = "fx_rates"
        case fee_details = "fee_details"
        case settlement_details = "settlement_details"
        case correspondent_rules = "correspondent_rules"
        case price_guarantee = "price_guarantee"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        sub_state = try values.decodeIfPresent(String.self, forKey: .sub_state)
        quote_id = try values.decodeIfPresent(String.self, forKey: .quote_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        created_at_gmt = try values.decodeIfPresent(String.self, forKey: .created_at_gmt)
        expires_at = try values.decodeIfPresent(String.self, forKey: .expires_at)
        expires_at_gmt = try values.decodeIfPresent(String.self, forKey: .expires_at_gmt)
        receiving_country_code = try values.decodeIfPresent(String.self, forKey: .receiving_country_code)
        receiving_currency_code = try values.decodeIfPresent(String.self, forKey: .receiving_currency_code)
        sending_country_code = try values.decodeIfPresent(String.self, forKey: .sending_country_code)
        sending_currency_code = try values.decodeIfPresent(String.self, forKey: .sending_currency_code)
        sending_amount = try values.decodeIfPresent(Int.self, forKey: .sending_amount)
        receiving_amount = try values.decodeIfPresent(Double.self, forKey: .receiving_amount)
        total_payin_amount = try values.decodeIfPresent(Double.self, forKey: .total_payin_amount)
        fx_rates = try values.decodeIfPresent([Fx_rates].self, forKey: .fx_rates)
        fee_details = try values.decodeIfPresent([Fee_details].self, forKey: .fee_details)
        settlement_details = try values.decodeIfPresent([Settlement_details].self, forKey: .settlement_details)
        correspondent_rules = try values.decodeIfPresent([[String:String]].self, forKey: .correspondent_rules)
        price_guarantee = try values.decodeIfPresent(String.self, forKey: .price_guarantee)
    }
    
    init(
            state: String? = nil,
            sub_state: String? = nil,
            quote_id: String? = nil,
            created_at: String? = nil,
            created_at_gmt: String? = nil,
            expires_at: String? = nil,
            expires_at_gmt: String? = nil,
            receiving_country_code: String? = nil,
            receiving_currency_code: String? = nil,
            sending_country_code: String? = nil,
            sending_currency_code: String? = nil,
            sending_amount: Int? = nil,
            receiving_amount: Double? = nil,
            total_payin_amount: Double? = nil,
            fx_rates: [Fx_rates]? = nil,
            fee_details: [Fee_details]? = nil,
            settlement_details: [Settlement_details]? = nil,
            correspondent_rules: [[String: String]]? = nil,
            price_guarantee: String? = nil
        ) {
            self.state = state
            self.sub_state = sub_state
            self.quote_id = quote_id
            self.created_at = created_at
            self.created_at_gmt = created_at_gmt
            self.expires_at = expires_at
            self.expires_at_gmt = expires_at_gmt
            self.receiving_country_code = receiving_country_code
            self.receiving_currency_code = receiving_currency_code
            self.sending_country_code = sending_country_code
            self.sending_currency_code = sending_currency_code
            self.sending_amount = sending_amount
            self.receiving_amount = receiving_amount
            self.total_payin_amount = total_payin_amount
            self.fx_rates = fx_rates
            self.fee_details = fee_details
            self.settlement_details = settlement_details
            self.correspondent_rules = correspondent_rules
            self.price_guarantee = price_guarantee
        }
    
}

struct Fx_rates: Codable {
    let rate: Double?
    let type: String?
    let base_currency_code: String?
    let counter_currency_code: String?

    init(
        rate: Double? = nil,
        type: String? = nil,
        base_currency_code: String? = nil,
        counter_currency_code: String? = nil
    ) {
        self.rate = rate
        self.type = type
        self.base_currency_code = base_currency_code
        self.counter_currency_code = counter_currency_code
    }
}

struct Fee_details: Codable {
    let type: String?
    let model: String?
    let amount: Double?
    let description: String?
    let currency_code: String?

    init(
        type: String? = nil,
        model: String? = nil,
        amount: Double? = nil,
        description: String? = nil,
        currency_code: String? = nil
    ) {
        self.type = type
        self.model = model
        self.amount = amount
        self.description = description
        self.currency_code = currency_code
    }
}

struct Settlement_details: Codable {
    let value: Int?
    let charge_type: String?
    let currency_code: String?

    init(
        value: Int? = nil,
        charge_type: String? = nil,
        currency_code: String? = nil
    ) {
        self.value = value
        self.charge_type = charge_type
        self.currency_code = currency_code
    }
}
