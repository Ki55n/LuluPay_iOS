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
//    func testSetCurrentRate() {
//        // 1. Arrange: Create a SendMoneyViewController instance and mock data
//
//        let viewController = SendReqMoneyViewController()
//
//        // Mock ReceiverData
//        var receiverDetails = ReceiverDetails(firstName: "John", middleName: "", lastName: "Doe", phoneNumber: "+923001234567", country: "Pakistan", country_code: "PK", receiveMode: "Bank", accountType: "Savings", swiftCode: "ALFHPKKA068", iban: "PK12ABCD1234567891234567", routingCode: "", accountNumber: "", chooseInstrument: "Remittance")
//        UserManager.shared.getReceiverData = receiverDetails //Sets the receiver data in the view controller
//
//        // Mock getCurrentRateInfo
//        let rate1 = Rates(rate: 75.82357673, toCurrencyName: "PAKISTANI RUPEE", toCurrency: "PKR", fromCurrency: "AED",toCountryName: "Pakistan",toCountry: "PK",receivingMode: "BANK")
////        let rate2 = ExchangeRate(toCountry: "Egypt", fromCurrency: "EGP", toCurrency: "USD", rate: 0.05)
////        let rate3 = ExchangeRate(toCountry: "China", fromCurrency: "CNY", toCurrency: "USD", rate: 0.15)
//        viewController.getCurrentRateInfo = [rate1]
//
//        // 2. Act: Call the code to be tested
//
//        viewController.ReceiverData = UserManager.shared.getReceiverData
//        for i in viewController.getCurrentRateInfo {
//            if i.to_country_name == viewController.ReceiverData?.country {
//                viewController.currentRate = i
//                break
//            }
//        }
//
//        // 3. Assert: Verify the expected outcome
//
//        XCTAssertNotNil(viewController.currentRate, "Current rate should not be nil")
//        XCTAssertEqual(viewController.currentRate?.to_country_name, "Pakistan", "Current rate should be for Egypt")
//        XCTAssertEqual(viewController.currentRate?.from_currency, "AED", "Current from currency should be EGP")
//
//        // Test case where no matching rate is found
//        receiverDetails.country = "Pakistan"
//        UserManager.shared.getReceiverData = receiverDetails //Sets the receiver data in the view controller
//        viewController.getCurrentRateInfo = [rate1] // Reset rates
//        viewController.ReceiverData = UserManager.shared.getReceiverData
//        for i in viewController.getCurrentRateInfo {
//            if i.to_country_name == viewController.ReceiverData?.country {
//                viewController.currentRate = i
//                break
//            }
//        }
//        XCTAssertNil(viewController.currentRate, "Current rate should be nil when no matching rate is found")
//
//        // Clean up mock data
//        UserManager.shared.getReceiverData = nil
//        viewController.getCurrentRateInfo = []
//
//    }
//    func testAccountTypeContainsData() {
//        // 1. Arrange: Create a SendMoneyViewController instance and mock data
//
//        let viewController = SendReqMoneyViewController()
//
//        // Mock ReceiverData with accountType
//        var receiverDetails = ReceiverDetails(firstName: "John", middleName: "", lastName: "Doe", phoneNumber: "1234567890", country: "Egypt", country_code: "EG", receiveMode: "Bank", accountType: "Savings", swiftCode: "", iban: "", routingCode: "", accountNumber: "", chooseInstrument: "")
//        UserManager.shared.getReceiverData = receiverDetails
//
//        // 2. Act: Assign the ReceiverData to the view controller
//
//        viewController.ReceiverData = UserManager.shared.getReceiverData
//
//        // 3. Assert: Check that accountType is not empty
//
//        XCTAssertFalse(viewController.ReceiverData?.accountType.isEmpty ?? true, "Account type should not be empty")
//
//        // Test what happens with a nil value
//        receiverDetails = ReceiverDetails(firstName: "John", middleName: "", lastName: "Doe", phoneNumber: "1234567890", country: "Egypt", country_code: "EG", receiveMode: "Bank", accountType: "", swiftCode: "", iban: "", routingCode: "", accountNumber: "", chooseInstrument: "")
//        UserManager.shared.getReceiverData = receiverDetails
//
//        // 2. Act: Assign the ReceiverData to the view controller
//
//        viewController.ReceiverData = UserManager.shared.getReceiverData
//
//        XCTAssertTrue(viewController.ReceiverData?.accountType.isEmpty ?? true, "Account type should be nil when value does not exist.")
//
//
//        // Cleanup
//        UserManager.shared.getReceiverData = nil
//    }


        func testQuoteModelDecoding() {
            // 1. Sample JSON response from the API
            let jsonString = """
            {
                "status": "success",
                "status_code": 200,
                "data": {
                    "state": "INITIATED",
                    "sub_state": "QUOTE_CREATED",
                    "quote_id": "1279125104126903",
                    "created_at": "2025-02-10T14:15:56.712+04:00",
                    "created_at_gmt": "2025-02-10T10:15:56.712Z",
                    "expires_at": "2025-02-10T15:00:56.712+04:00",
                    "expires_at_gmt": "2025-02-10T11:00:56.712Z",
                    "receiving_country_code": "PK",
                    "receiving_currency_code": "PKR",
                    "sending_country_code": "AE",
                    "sending_currency_code": "AED",
                    "sending_amount": 100,
                    "receiving_amount": 7582.36,
                    "total_payin_amount": 107.35,
                    "fx_rates": [
                        {
                            "rate": 75.82357673,
                            "type": "SELL",
                            "base_currency_code": "AED",
                            "counter_currency_code": "PKR"
                        },
                        {
                            "rate": 0.01318851,
                            "type": "SELL",
                            "base_currency_code": "PKR",
                            "counter_currency_code": "AED"
                        }
                    ],
                    "fee_details": [
                        {
                            "type": "COMMISSION",
                            "model": "OUR",
                            "amount": 7,
                            "description": "Commission",
                            "currency_code": "AED"
                        },
                        {
                            "type": "TAX",
                            "model": "OUR",
                            "amount": 0.35,
                            "description": "Tax",
                            "currency_code": "AED"
                        }
                    ],
                    "settlement_details": [
                        {
                            "value": 0,
                            "charge_type": "COMMISSION",
                            "currency_code": "AED"
                        },
                        {
                            "value": 0,
                            "charge_type": "TREASURYMARGIN",
                            "currency_code": "AED"
                        },
                        {
                            "value": 0.0,
                            "charge_type": "INPUTTAX",
                            "currency_code": "AED"
                        }
                    ],
                    "correspondent_rules": [],
                    "price_guarantee": "FIRM"
                }
            }
            """
            
            // 2. Convert the JSON string into Data
            guard let jsonData = jsonString.data(using: .utf8) else {
                XCTFail("Failed to convert JSON string to Data.")
                return
            }
            
            // 3. Decode the JSON into the QuoteModel
            let decoder = JSONDecoder()
            do {
                let quoteModel = try decoder.decode(QuoteModel.self, from: jsonData)
                
                // 4. Validate the results
                XCTAssertEqual(quoteModel.status, "success")
                XCTAssertEqual(quoteModel.status_code, 200)
                
                // Check QuoteData
                XCTAssertEqual(quoteModel.data?.state, "INITIATED")
                XCTAssertEqual(quoteModel.data?.sub_state, "QUOTE_CREATED")
                XCTAssertEqual(quoteModel.data?.quote_id, "1279125104126903")
                
                // Check date fields
                XCTAssertEqual(quoteModel.data?.created_at, "2025-02-10T14:15:56.712+04:00")
                XCTAssertEqual(quoteModel.data?.expires_at, "2025-02-10T15:00:56.712+04:00")
                
                // Check amounts and values
                XCTAssertEqual(quoteModel.data?.sending_amount, 100)
                XCTAssertEqual(quoteModel.data?.receiving_amount, 7582.36)
                XCTAssertEqual(quoteModel.data?.total_payin_amount, 107.35)
                
                // Check fx_rates
                XCTAssertEqual(quoteModel.data?.fx_rates?.count, 2)
                XCTAssertEqual(quoteModel.data?.fx_rates?[0].rate, 75.82357673)
                
                // Check fee details
                XCTAssertEqual(quoteModel.data?.fee_details?.count, 2)
                XCTAssertEqual(quoteModel.data?.fee_details?[0].type, "COMMISSION")
                
                // Check settlement details
                XCTAssertEqual(quoteModel.data?.settlement_details?.count, 3)
                XCTAssertEqual(quoteModel.data?.settlement_details?[0].charge_type, "COMMISSION")
                
                // Check correspondent rules (empty array case)
                XCTAssertEqual(quoteModel.data?.correspondent_rules?.count, 0)
                
                // Check price guarantee
                XCTAssertEqual(quoteModel.data?.price_guarantee, "FIRM")
                
            } catch {
                XCTFail("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
    
    
    func testTableViewSections() {
        // Instantiate the view controller
        let paymentDetailsVC = PaymentDetailsViewController()

        // Create and assign a programmatic table view instance
        let tableView = UITableView(frame: .zero, style: .grouped)
        paymentDetailsVC.tableView = tableView

        // Register the necessary cells programmatically to avoid outlet crashes
        paymentDetailsVC.tableView?.register(TransactionDetailCell.self, forCellReuseIdentifier: "cellDetail")
        paymentDetailsVC.tableView?.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
        paymentDetailsVC.tableView?.register(TitleCell.self, forCellReuseIdentifier: "titleCell")

        paymentDetailsVC.tableView?.dataSource = paymentDetailsVC
        paymentDetailsVC.tableView?.delegate = paymentDetailsVC
        paymentDetailsVC.loadViewIfNeeded()

        // Mock QuoteData setup
        let mockFXRates = [Fx_rates(rate: 1.2, type: "Fixed", base_currency_code: "USD", counter_currency_code: "EUR"),Fx_rates(rate: 1.2, type: "Fixed", base_currency_code: "USD", counter_currency_code: "EUR")]
        let mockSettlements = [Settlement_details(value: 100, charge_type: "Service Fee", currency_code: "USD"),Settlement_details(value: 100, charge_type: "Service Fee", currency_code: "USD")]

        paymentDetailsVC.getQuote = QuoteData(
            fx_rates: mockFXRates,
            settlement_details: mockSettlements
        )

        // Reload the table view after setting the data
        paymentDetailsVC.tableView?.reloadData()
        RunLoop.main.run(until: Date().addingTimeInterval(1)) // Ensure UI updates

        XCTAssertEqual(paymentDetailsVC.tableView?.numberOfSections, 6, "The table view should have 4 sections.")

        // Assert section 2 row count
        let fxSectionRows = paymentDetailsVC.tableView?.numberOfRows(inSection: 2) ?? 0
        XCTAssertEqual(fxSectionRows, 9, "Section 2 should display 4 rows per FX rate")
//        if let titleCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 0, section: 2)) as? TitleCell {
//            XCTAssertEqual(titleCell.lblTitle.text, "FX Rates", "Section 2 should have a TitleCell with the correct title")
//        } else {
//            XCTFail("First row in section 2 is not a TitleCell")
//        }
        if let titleCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 0, section: 2)) {
            print("Cell at row 0, section 2 is of type: \(type(of: titleCell))")
            
            if let titleCell = titleCell as? TitleCell {
                XCTAssertEqual(titleCell.lblTitle.text, "FX Rates", "Section 2 should have a TitleCell with the correct title")
            } else {
                XCTFail("Expected TitleCell but got \(type(of: TransactionDetailCell.self))")
            }
        } else {
            XCTFail("No cell found at row 0, section 2")
        }

        // Assert section 3 row count
        let settlementSectionRows = paymentDetailsVC.tableView?.numberOfRows(inSection: 4) ?? 0
        XCTAssertEqual(settlementSectionRows, 3, "Section 3 should display 3 rows per settlement entry")

        // Assert section 4 row count
        let buttonSectionRows = paymentDetailsVC.tableView?.numberOfRows(inSection: 5) ?? 0
        XCTAssertEqual(buttonSectionRows, 1, "Section 4 should display 1 row for the button")

        // Verify first row in section 2 is a TitleCell
        if let titleCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 0, section: 2)) as? TitleCell {
            XCTAssertEqual(titleCell.lblTitle.text, "FX Rates", "Section 2 should have a TitleCell with the correct title")
        } else {
            XCTFail("First row in section 2 is not a TitleCell")
        }

        // Verify first row in section 3 is a TitleCell
        if let titleCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 0, section: 3)) as? TitleCell {
            XCTAssertEqual(titleCell.lblTitle.text, "Settlement Details", "Section 3 should have a TitleCell with the correct title")
        } else {
            XCTFail("First row in section 3 is not a TitleCell")
        }

        // Verify first row in section 4 is a TitleCell
        if let titleCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 0, section: 4)) as? TitleCell {
            XCTAssertEqual(titleCell.lblTitle.text, "Proceed", "Section 4 should have a TitleCell with the correct title")
        } else {
            XCTFail("First row in section 4 is not a TitleCell")
        }

        // Verify cell data for section 2
        let fxRateCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 1, section: 2)) as? TransactionDetailCell
        XCTAssertEqual(fxRateCell?.lblTitle.text, "Rate")
        XCTAssertEqual(fxRateCell?.lblValue.text, "1.2")

        // Verify settlement cell data for section 3
        let settlementCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 1, section: 3)) as? TransactionDetailCell
        XCTAssertEqual(settlementCell?.lblTitle.text, "Charge Type")
        XCTAssertEqual(settlementCell?.lblValue.text, "Service Fee")

        // Verify button in section 4
        let buttonCell = paymentDetailsVC.tableView?.cellForRow(at: IndexPath(row: 0, section: 4)) as? ButtonCell
        XCTAssertEqual(buttonCell?.btnTitle.titleLabel?.text, "Proceed")
    }



        func testRemoveNilValues() {
            // Given mock data
            let vc = PaymentDetailsViewController()
            let receiverData = vc.ReceiverData
            let bankDetails = BankDetails(accountTypeCode: "1", isoCode: "ALFHPKKA068", iban: "PK12ABCD1234567891234567", routingCode: "XYZ123")
            
            let senderDetails = Sender(customerNumber: "7841001220007002")
            let receiverDetails = Receiver(
                mobileNumber: receiverData?.phoneNumber ?? "",
                firstName: receiverData?.firstName ?? "",
                lastName: receiverData?.lastName ?? "",
                nationality: receiverData?.country_code ?? "",
                relationCode: "32",
                bankDetails: bankDetails
            )
            
            let transactionDetails = Transaction(
                quoteId: "Q12345",
                agentTransactionRefNumber: "AGENT12345"
            )
            
            let transactionRequest = CreateTransactionRequest(
                type: "TRANSFER",
                sourceOfIncome: "SLRY",
                purposeOfTxn: "SAVG",
                instrument: receiverData?.chooseInstrument?.uppercased() ?? "",
                message: "Agency transaction",
                sender: senderDetails,
                receiver: receiverDetails,
                transaction: transactionDetails
            )
            
            // Remove nil values from the request
            guard let cleanedRequest = vc.removeNilValues(from: transactionRequest) else {
                XCTFail("Nil values were not removed properly.")
                return
            }

            // Test if cleaned request does not contain any nil or empty values
            if let cleanedDict = cleanedRequest as? [String: Any] {
                XCTAssertNil(cleanedDict["receiver.lastName"]) // Last name is empty and should be removed
            }
        }
    

    

}

import XCTest

class TransactionRequestTests: XCTestCase {

    func testTransactionRequestCreation() {
        // Test Data Setup
        
        let vc = PaymentDetailsViewController()
        
        let receiverData = ReceiverDetails(
            firstName: "Swathi", lastName: "L", phoneNumber: "+923001234567", country_code: "PK", receiveMode: "Bank", accountType: "Savings", swiftCode: "SWIFT123", iban: "IBAN12345", routingCode: "ROUTING123", accountNumber: "1234567890",
            chooseInstrument: "Remittance"
        )
        let unique_id = vc.generateUniqueId()
        // Sender Details (provided static values)
        let senderDetails = Sender(customerNumber: "7841001220007002", agentCustomerNumber: "AGENT" + unique_id)

        // Transaction Details (provided static values)
        let transactionDetails = Transaction(
            quoteId: "1279125104358279",
            agentTransactionRefNumber: "1279125104358279"
        )

        // Begin setting up the Receiver Details
        var bankDetails: BankDetails?
        var mobileWalletDetails: MobileWalletDetails?
        var cashPickupDetails: CashPickupDetails?

        // Set bank details only if all fields are non-nil
        if let receiveMode = receiverData.receiveMode, receiveMode.contains("Bank") {
            bankDetails = BankDetails()

            bankDetails?.accountNumber = (receiverData.accountNumber?.isEmpty ?? true) ? nil : receiverData.accountNumber
            bankDetails?.accountTypeCode = "1" // Setting default value for accountTypeCode
            bankDetails?.iban = (receiverData.iban?.isEmpty ?? true) ? nil : receiverData.iban
            bankDetails?.isoCode = (receiverData.swiftCode?.isEmpty ?? true) ? nil : receiverData.swiftCode
            bankDetails?.routingCode = (receiverData.routingCode?.isEmpty ?? true) ? nil : receiverData.routingCode
        }

        // Setting up the Receiver details (with bankDetails populated if necessary)
        let receiverDetails = Receiver(
            mobileNumber: receiverData.phoneNumber ?? "",
            firstName: receiverData.firstName ?? "",
            lastName: receiverData.lastName ?? "",
            nationality: receiverData.country_code ?? "",
            relationCode: "32",
            bankDetails: bankDetails,
            cashPickupDetails: cashPickupDetails
        )

        // Transaction Request setup
        let transactionRequest = CreateTransactionRequest(
            type: "SEND",
            sourceOfIncome: "SLRY",
            purposeOfTxn: "SAVG",
            instrument: receiverData.chooseInstrument?.uppercased() ?? "",
            message: "Agency transaction",
            sender: senderDetails,
            receiver: receiverDetails,
            transaction: transactionDetails
        )

        // Printing the payload for inspection
        print("Payload: \(transactionRequest)")

        // Remove Nil Values from transactionRequest and test
        guard let cleanedRequest = vc.removeNilValues(from: transactionRequest) else {
            XCTFail("Failed to clean the request due to nil values")
            return
        }
//        XCTAssertNil(bankDetails,"bankdetails")
        // Assertions
        // Test that the bankDetails are set only when values are non-nil
        XCTAssertNotNil(bankDetails?.accountNumber, "Account number should not be nil")
        XCTAssertNotNil(bankDetails?.iban, "IBAN should not be nil")
        XCTAssertNotNil(bankDetails?.isoCode, "ISO code should not be nil")
        XCTAssertNotNil(bankDetails?.routingCode, "Routing code should not be nil")
        
        
    }
}


class MockAPIService: APIService {
    var shouldReturnError = false
    var mockData: Data?

    // Add an accessible initializer
    public init(mockData: Data? = nil, shouldReturnError: Bool = false) {
        super.init()
        self.mockData = mockData
        self.shouldReturnError = shouldReturnError
    }

    func requestParamasCodable(url: String, method: LuHTTPMethod, parameters: [String: String], headers: [String: String]?, completion: @escaping (Result<Data, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Mock API Error"])))
        } else if let mockData = mockData {
            completion(.success(mockData))
        } else {
            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No mock data"])))
        }
    }
}

class GetAccountTypeTests: XCTestCase {
    var viewController: SendMoneyViewController!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        viewController = SendMoneyViewController()
        // Initialize MockAPIService with mock data or error condition as needed
        mockAPIService = MockAPIService(mockData: nil, shouldReturnError: false)
        
        // Replace the real service with the mock
        APIService.shared = mockAPIService
    }

    override func tearDown() {
        viewController = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testGetAccountType_Success() {
        let jsonResponse = """
        {
            "instruments": [
                {"id": "1", "name": "Savings"},
                {"id": "2", "name": "Current"}
            ]
        }
        """.data(using: .utf8)!

        mockAPIService.mockData = jsonResponse

        let expectation = self.expectation(description: "Completion handler invoked")

        viewController.getAccountType {
            XCTAssertFalse(((self.viewController.accountTypeList?.isEmpty) != nil), "Account types should be populated")
            XCTAssertEqual(self.viewController.accountTypeList?.count, 2, "Should contain 2 account types")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testGetAccountType_Failure() {
        mockAPIService.shouldReturnError = true

        let expectation = self.expectation(description: "Completion handler invoked")

        viewController.getAccountType {
            XCTAssertTrue(((self.viewController.accountTypeList?.isEmpty) != nil), "Account types should be empty on failure")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
    }
}
import XCTest

class SettingsViewControllerTests: XCTestCase {

    var viewController: SettingsViewController!

    override func setUpWithError() throws {
        super.setUp()
        let bundle = Bundle(identifier: "com.finance.LuluSDK") // Replace with your bundle identifier
        let storyboard = UIStoryboard(name: "Lulu", bundle: bundle) // This will not be optional

        viewController = storyboard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController
        viewController.loadViewIfNeeded() // Load the view
    }

    override func tearDownWithError() throws {
        viewController = nil
        super.tearDown()
    }

    func testHeaderViewColorChanges() {
        // Given: A new theme color
        let newHexColor = "#FF5733"
        ThemeManager.shared.saveThemeColor(hex: newHexColor)
        
        // When: Applying the saved theme
        ThemeManager.shared.applySavedTheme()
        
        // Force the view to layout on the main thread
        DispatchQueue.main.async {
            self.viewController.view.setNeedsLayout()
            self.viewController.view.layoutIfNeeded()
            
            // Then: Verify the header view's background color is updated
            guard let headerView = self.viewController.tblList.tableHeaderView else {
                XCTFail("Header view is nil")
                return
            }
            
            // Log to debug
            print("Header view background color: \(String(describing: headerView.backgroundColor))")
            
            let expectedColor = UIColor(hexString: newHexColor)
            headerView.backgroundColor = .blue
            // Compare the colors by extracting RGB components
            guard let headerColorComponents = headerView.backgroundColor?.getRGBComponents() else {
                XCTFail("Header view background color is nil")
                return
            }
            
            let expectedColorComponents = expectedColor?.getRGBComponents()
            
            XCTAssertEqual(headerColorComponents, expectedColorComponents, "Header view background color did not update correctly")
        }
    }
}

