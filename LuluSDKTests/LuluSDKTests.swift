//
//  LuluSDKTests.swift
//  LuluSDKTests
//
//  Created by boyapati kumar on 17/01/25.
//

import XCTest
@testable import LuluSDK

final class LuluSDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testCustomHeaderViewLoading() throws {
        // Ensure the correct bundle identifier
        guard let bundle = Bundle(identifier: "com.finance.LuluSDK") else {
            XCTFail("Bundle not found")
            return
        }
        
        // Load the nib and instantiate the view
        guard let headerView = UINib(nibName: "CustomHeaderView", bundle: bundle)
            .instantiate(withOwner: nil, options: nil)
            .first as? CustomHeaderView else {
            XCTFail("Failed to load CustomHeaderView from nib")
            return
        }

        // Assert that the view and its subviews are properly connected
        XCTAssertNotNil(headerView, "CustomHeaderView should not be nil")
        XCTAssertNotNil(headerView.lblTitle, "lblTitle outlet should be connected")
        XCTAssertNotNil(headerView.btnBack, "btnBack outlet should be connected")
        
        // Test default or configured values
        headerView.lblTitle.text = "Test Title"
        XCTAssertEqual(headerView.lblTitle.text, "Test Title", "lblTitle should display the correct text")
    }
    func testBundleIdentifierExists() {
        let bundle = Bundle(identifier: "com.finance.LuluSDK")
        XCTAssertNotNil(bundle, "Bundle should exist for identifier com.finance.LuluSDK")
    }
    
    func testPhoneNumberValidation() {
        let sendMoneyVC = SendMoneyViewController() // Instantiate your view controller

        // Pakistan
        XCTAssertTrue(sendMoneyVC.isPhoneNumberValid(for: "Pakistan", phoneNumber: "+923001234567"), "Pakistan: Valid number failed")
        XCTAssertFalse(sendMoneyVC.isPhoneNumberValid(for: "Pakistan", phoneNumber: "+924001234567"), "Pakistan: Invalid number passed")

        // India
        XCTAssertTrue(sendMoneyVC.isPhoneNumberValid(for: "India", phoneNumber: "+916000000000"), "India: Valid number failed")
        XCTAssertFalse(sendMoneyVC.isPhoneNumberValid(for: "India", phoneNumber: "+915000000000"), "India: Invalid number passed")

        // Add tests for other countries...
    }
    func testSetCurrentRate() {
        // 1. Arrange: Create a SendMoneyViewController instance and mock data

        let viewController = SendReqMoneyViewController()

        // Mock ReceiverData
        var receiverDetails = ReceiverDetails(firstName: "John", middleName: "", lastName: "Doe", phoneNumber: "+923001234567", country: "Pakistan", country_code: "PK", receiveMode: "Bank", accountType: "Savings", swiftCode: "ALFHPKKA068", iban: "PK12ABCD1234567891234567", routingCode: "", accountNumber: "", chooseInstrument: "Remittance")
        UserManager.shared.getReceiverData = receiverDetails //Sets the receiver data in the view controller

        // Mock getCurrentRateInfo
        let rate1 = ExchangeRate(rate: 75.82357673, toCurrencyName: "PAKISTANI RUPEE", toCurrency: "PKR", fromCurrency: "AED",toCountryName: "Pakistan",toCountry: "PK",receivingMode: "BANK")
//        let rate2 = ExchangeRate(toCountry: "Egypt", fromCurrency: "EGP", toCurrency: "USD", rate: 0.05)
//        let rate3 = ExchangeRate(toCountry: "China", fromCurrency: "CNY", toCurrency: "USD", rate: 0.15)
        viewController.getCurrentRateInfo = [rate1]

        // 2. Act: Call the code to be tested

        viewController.ReceiverData = UserManager.shared.getReceiverData
        for i in viewController.getCurrentRateInfo {
            if i.toCountryName == viewController.ReceiverData?.country {
                viewController.currentRate = i
                break
            }
        }

        // 3. Assert: Verify the expected outcome

        XCTAssertNotNil(viewController.currentRate, "Current rate should not be nil")
        XCTAssertEqual(viewController.currentRate?.toCountryName, "Pakistan", "Current rate should be for Egypt")
        XCTAssertEqual(viewController.currentRate?.fromCurrency, "AED", "Current from currency should be EGP")

        // Test case where no matching rate is found
        receiverDetails.country = "Pakistan"
        UserManager.shared.getReceiverData = receiverDetails //Sets the receiver data in the view controller
        viewController.getCurrentRateInfo = [rate1] // Reset rates
        viewController.ReceiverData = UserManager.shared.getReceiverData
        for i in viewController.getCurrentRateInfo {
            if i.toCountryName == viewController.ReceiverData?.country {
                viewController.currentRate = i
                break
            }
        }
        XCTAssertNil(viewController.currentRate, "Current rate should be nil when no matching rate is found")

        // Clean up mock data
        UserManager.shared.getReceiverData = nil
        viewController.getCurrentRateInfo = []

    }
    func testAccountTypeContainsData() {
        // 1. Arrange: Create a SendMoneyViewController instance and mock data

        let viewController = SendReqMoneyViewController()

        // Mock ReceiverData with accountType
        var receiverDetails = ReceiverDetails(firstName: "John", middleName: "", lastName: "Doe", phoneNumber: "1234567890", country: "Egypt", country_code: "EG", receiveMode: "Bank", accountType: "Savings", swiftCode: "", iban: "", routingCode: "", accountNumber: "", chooseInstrument: "")
        UserManager.shared.getReceiverData = receiverDetails

        // 2. Act: Assign the ReceiverData to the view controller

        viewController.ReceiverData = UserManager.shared.getReceiverData

        // 3. Assert: Check that accountType is not empty

        XCTAssertFalse(viewController.ReceiverData?.accountType.isEmpty ?? true, "Account type should not be empty")

        // Test what happens with a nil value
        receiverDetails = ReceiverDetails(firstName: "John", middleName: "", lastName: "Doe", phoneNumber: "1234567890", country: "Egypt", country_code: "EG", receiveMode: "Bank", accountType: "", swiftCode: "", iban: "", routingCode: "", accountNumber: "", chooseInstrument: "")
        UserManager.shared.getReceiverData = receiverDetails

        // 2. Act: Assign the ReceiverData to the view controller

        viewController.ReceiverData = UserManager.shared.getReceiverData

        XCTAssertTrue(viewController.ReceiverData?.accountType.isEmpty ?? true, "Account type should be nil when value does not exist.")


        // Cleanup
        UserManager.shared.getReceiverData = nil
    }


}
