//
//  LoginModel.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 27/01/2025.
//

import Foundation
struct LoginModel : Codable {
    let access_token : String?
    let expires_in : Int?
    let refresh_expires_in : Int?
    let refresh_token : String?
    let token_type : String?
    let not_before_policy : Int?
    let session_state : String?
    let scope : String?

    enum CodingKeys: String, CodingKey {

        case access_token = "access_token"
        case expires_in = "expires_in"
        case refresh_expires_in = "refresh_expires_in"
        case refresh_token = "refresh_token"
        case token_type = "token_type"
        case not_before_policy = "not-before-policy"
        case session_state = "session_state"
        case scope = "scope"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        expires_in = try values.decodeIfPresent(Int.self, forKey: .expires_in)
        refresh_expires_in = try values.decodeIfPresent(Int.self, forKey: .refresh_expires_in)
        refresh_token = try values.decodeIfPresent(String.self, forKey: .refresh_token)
        token_type = try values.decodeIfPresent(String.self, forKey: .token_type)
        not_before_policy = try values.decodeIfPresent(Int.self, forKey: .not_before_policy)
        session_state = try values.decodeIfPresent(String.self, forKey: .session_state)
        scope = try values.decodeIfPresent(String.self, forKey: .scope)
    }

}
