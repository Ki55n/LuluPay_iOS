//
//  BranchSearchModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 28/01/2025.
//

import Foundation

struct BranchSearchModel : Codable {
    let status : String?
    let status_code : Int?
    let data : BranchSearchData?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent(BranchSearchData.self, forKey: .data)
    }

}

struct BranchSearchData : Codable {
    let records : Int?
    let list : [BranchSearchList]?
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
        list = try values.decodeIfPresent([BranchSearchList].self, forKey: .list)
        total_records = try values.decodeIfPresent(Int.self, forKey: .total_records)
        total_page = try values.decodeIfPresent(Int.self, forKey: .total_page)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
    }

}

struct BranchSearchList : Codable {
    let bank_id : String?
    let branch_id : String?
    let branch_name : String?
    let branch_full_name : String?
    let address : String?
    let country_code : String?
    let routing_code : String?
    let iso_code : String?
    let sort : String?

    enum CodingKeys: String, CodingKey {
        case bank_id = "bank_id"
        case branch_id = "branch_id"
        case branch_name = "branch_name"
        case branch_full_name = "branch_full_name"
        case address = "address"
        case country_code = "country_code"
        case routing_code = "routing_code"
        case iso_code = "iso_code"
        case sort = "sort"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bank_id = try values.decodeIfPresent(String.self, forKey: .bank_id)
        branch_id = try values.decodeIfPresent(String.self, forKey: .branch_id)
        branch_name = try values.decodeIfPresent(String.self, forKey: .branch_name)
        branch_full_name = try values.decodeIfPresent(String.self, forKey: .branch_full_name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        routing_code = try values.decodeIfPresent(String.self, forKey: .routing_code)
        iso_code = try values.decodeIfPresent(String.self, forKey: .iso_code)
        sort = try values.decodeIfPresent(String.self, forKey: .sort)
    }

}
