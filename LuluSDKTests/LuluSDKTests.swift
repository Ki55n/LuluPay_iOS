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

}
