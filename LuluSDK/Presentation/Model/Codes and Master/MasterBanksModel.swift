//
//  MasterBanksModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 28/01/2025.
//

import Foundation

struct GetBankListRequest:Codable{
    let receiving_country_code:String?
    let receiving_mode:String?
    enum CodingKeys: String, CodingKey {
        case receiving_country_code = "receiving_country_code"
        case receiving_mode = "receiving_mode"
    }

}
struct MasterBanksModel : Codable {
    let status : String?
    let status_code : Int?
    let data : MasterBanksData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(MasterBanksData.self, forKey: .data)
    }

}

struct MasterBanksData : Codable {
    let records : Int?
    let list : [MasterBanksList]?
    let total_records : Int?
    let total_page : Int?
    let current_page : Int?

    enum CodingKeys: String, CodingKey {

        case records = "records"
        case list = "list"
        case total_records = "total_records"
        case total_page = "total_page"
        case current_page = "current_page"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        records = try values.decodeIfPresent(Int.self, forKey: .records)
        list = try values.decodeIfPresent([MasterBanksList].self, forKey: .list)
        total_records = try values.decodeIfPresent(Int.self, forKey: .total_records)
        total_page = try values.decodeIfPresent(Int.self, forKey: .total_page)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
    }

}

struct MasterBanksList : Codable {
    let bank_id : String?
    let bank_name : String?

    enum CodingKeys: String, CodingKey {

        case bank_id = "bank_id"
        case bank_name = "bank_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bank_id = try values.decodeIfPresent(String.self, forKey: .bank_id)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
    }

}

struct MasterBanksIDModel : Codable {
    let status : String?
    let status_code : Int?
    let data : MasterBanksIDData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(MasterBanksIDData.self, forKey: .data)
    }

}

struct MasterBanksIDData : Codable {
    let records : Int?
    let list : [MasterBanksIDList]?
    let total_records : Int?
    let total_page : Int?
    let current_page : Int?

    enum CodingKeys: String, CodingKey {

        case records = "records"
        case list = "list"
        case total_records = "total_records"
        case total_page = "total_page"
        case current_page = "current_page"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        records = try values.decodeIfPresent(Int.self, forKey: .records)
        list = try values.decodeIfPresent([MasterBanksIDList].self, forKey: .list)
        total_records = try values.decodeIfPresent(Int.self, forKey: .total_records)
        total_page = try values.decodeIfPresent(Int.self, forKey: .total_page)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
    }

}

struct MasterBanksIDList : Codable {
    let bank_id : String?
    let bank_name : String?

    enum CodingKeys: String, CodingKey {

        case bank_id = "bank_id"
        case bank_name = "bank_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bank_id = try values.decodeIfPresent(String.self, forKey: .bank_id)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
    }

}
