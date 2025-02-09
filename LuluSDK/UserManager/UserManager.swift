//
//  UserManager.swift
//  LuluSDK
//
//  Created by Praveen Sehgal on 03/02/2025.
//

import Foundation

class UserManager {
    static let shared = UserManager() // Shared instance
    private init() {}
    var loginModel: LoginModel?
    var getCodesData: GetCodesData?
    var getServiceCorridorData: [ServiceCorriderData]?
    var getCurrentRate:[ExchangeRate]?
    var getReceiverData:ReceiverDetails?
}
