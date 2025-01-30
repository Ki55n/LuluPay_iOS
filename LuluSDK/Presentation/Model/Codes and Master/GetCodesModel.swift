//
//  GetCodesModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 27/01/2025.
//

import Foundation

struct GetCodesModel : Codable {
    let status : String?
    let status_code : Int?
    let data : GetCodesData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(GetCodesData.self, forKey: .data)
    }

}

struct GetCodesData : Codable {
    let relationships : [Relationships]?
    let id_types : [Id_types]?
    let sources_of_incomes : [Sources_of_incomes]?
    let purposes_of_transactions : [Purposes_of_transactions]?
    let professions : [Professions]?
    let account_types : [Account_types]?
    let payment_modes : [Payment_modes]?
    let visa_types : [Visa_types]?
    let instruments : [Instruments]?
    let address_types : [Address_types]?
    let receiving_modes : [Receiving_modes]?
    let fee_types : [Fee_types]?
    let transaction_states : [Transaction_states]?
    let income_types : [Income_types]?
    let income_range_types : [Income_range_types]?
    let cancel_reason_codes : [Cancel_reason_codes]?
    let transaction_count_per_month : [Transaction_count_per_month]?
    let transaction_volume_per_month : [Transaction_volume_per_month]?
    let correspondents : [Correspondents]?
    let business_types : [Business_types]?
    let document_types : [Document_types]?
    let proof_content_types : [Proof_content_types]?

    enum CodingKeys: String, CodingKey {

        case relationships = "relationships"
        case id_types = "id_types"
        case sources_of_incomes = "sources_of_incomes"
        case purposes_of_transactions = "purposes_of_transactions"
        case professions = "professions"
        case account_types = "account_types"
        case payment_modes = "payment_modes"
        case visa_types = "visa_types"
        case instruments = "instruments"
        case address_types = "address_types"
        case receiving_modes = "receiving_modes"
        case fee_types = "fee_types"
        case transaction_states = "transaction_states"
        case income_types = "income_types"
        case income_range_types = "income_range_types"
        case cancel_reason_codes = "cancel_reason_codes"
        case transaction_count_per_month = "transaction_count_per_month"
        case transaction_volume_per_month = "transaction_volume_per_month"
        case correspondents = "correspondents"
        case business_types = "business_types"
        case document_types = "document_types"
        case proof_content_types = "proof_content_types"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        relationships = try values.decodeIfPresent([Relationships].self, forKey: .relationships)
        id_types = try values.decodeIfPresent([Id_types].self, forKey: .id_types)
        sources_of_incomes = try values.decodeIfPresent([Sources_of_incomes].self, forKey: .sources_of_incomes)
        purposes_of_transactions = try values.decodeIfPresent([Purposes_of_transactions].self, forKey: .purposes_of_transactions)
        professions = try values.decodeIfPresent([Professions].self, forKey: .professions)
        account_types = try values.decodeIfPresent([Account_types].self, forKey: .account_types)
        payment_modes = try values.decodeIfPresent([Payment_modes].self, forKey: .payment_modes)
        visa_types = try values.decodeIfPresent([Visa_types].self, forKey: .visa_types)
        instruments = try values.decodeIfPresent([Instruments].self, forKey: .instruments)
        address_types = try values.decodeIfPresent([Address_types].self, forKey: .address_types)
        receiving_modes = try values.decodeIfPresent([Receiving_modes].self, forKey: .receiving_modes)
        fee_types = try values.decodeIfPresent([Fee_types].self, forKey: .fee_types)
        transaction_states = try values.decodeIfPresent([Transaction_states].self, forKey: .transaction_states)
        income_types = try values.decodeIfPresent([Income_types].self, forKey: .income_types)
        income_range_types = try values.decodeIfPresent([Income_range_types].self, forKey: .income_range_types)
        cancel_reason_codes = try values.decodeIfPresent([Cancel_reason_codes].self, forKey: .cancel_reason_codes)
        transaction_count_per_month = try values.decodeIfPresent([Transaction_count_per_month].self, forKey: .transaction_count_per_month)
        transaction_volume_per_month = try values.decodeIfPresent([Transaction_volume_per_month].self, forKey: .transaction_volume_per_month)
        correspondents = try values.decodeIfPresent([Correspondents].self, forKey: .correspondents)
        business_types = try values.decodeIfPresent([Business_types].self, forKey: .business_types)
        document_types = try values.decodeIfPresent([Document_types].self, forKey: .document_types)
        proof_content_types = try values.decodeIfPresent([Proof_content_types].self, forKey: .proof_content_types)
    }

}

struct Income_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Payment_modes : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Professions : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Address_types : Codable {
    let code : String?
    let name : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

struct Cancel_reason_codes : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Purposes_of_transactions : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Account_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Transaction_volume_per_month : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Relationships : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Income_range_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Fee_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Correspondents : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Document_types : Codable {
    let code : String?
    let name : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

struct Proof_content_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Receiving_modes : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Instruments : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Transaction_count_per_month : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Transaction_states : Codable {
    let state : String?
    let sub_states : [Sub_states]?

    enum CodingKeys: String, CodingKey {

        case state = "state"
        case sub_states = "sub_states"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        sub_states = try values.decodeIfPresent([Sub_states].self, forKey: .sub_states)
    }

}

struct Business_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Sources_of_incomes : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Sub_states : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Id_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Visa_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
