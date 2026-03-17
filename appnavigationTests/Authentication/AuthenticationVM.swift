//
//  AuthenticationVM.swift
//  appnavigationTests
//
//  Created by MACM72 on 06/03/26.
//

import XCTest

@testable import appnavigation

final class AuthenticationVMTests: XCTestCase {

    private var sut: AuthenticationVM!
    var mockDelegate: MockAuthDelegate!

//    override func setUpWithError() throws {
//        print("---- setUpWithError run : ----")
//        sut = AuthenticationVM()
//        mockDelegate = MockAuthDelegate()
//        sut.delegate = mockDelegate
//    }

    override func setUp() {
        print("---- setUp : ----")
        sut = AuthenticationVM()
        mockDelegate = MockAuthDelegate()
        sut.delegate = mockDelegate

        // Clear UserDefaults before each test
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "apple_user_id")
        defaults.removeObject(forKey: "user_email")
    }

    //MARK: Called before each test method
    override func tearDown() {
        sut = nil
        mockDelegate =  nil
        print("Class tearDown called ✅")
        super.tearDown()

    }

    //MARK: Called after each test method
    override func tearDownWithError() throws {
        sut = nil
        mockDelegate =  nil
        print("Class tearDown called ✅")
    }


    func test_handleAppleUserSuccess() throws {
        sut.handleAppleUser(userId: "11345", email: "test23@mail.com")
        XCTAssertTrue(mockDelegate.loginSuccessCalled, "Success delegate should be called")

        //MARK: XCTest executes this when test_handleAppleUserSuccess() ends.
        addTeardownBlock {
            print("--------")
            print("---- test_handleAppleUserSuccess ----")
            print("--------")
        }

    }
    func test_UserSavedInUserDefaults() throws {
        let userId = "abc123"
        let userEmail = "user@test.com"
        sut.handleAppleUser(userId: userId, email: userEmail)

        let defaults = UserDefaults.standard
        let savedId = defaults.string(forKey: "apple_user_id")
        let savedEmail = defaults.string(forKey: "user_email")

        XCTAssertEqual(savedId, userId, "User ID should be saved")
        XCTAssertEqual(savedEmail, userEmail, "User email should be saved")


        //MARK: XCTest executes this when test_UserSavedInUserDefaults() ends.
        addTeardownBlock {
            print("--------")
            print("---- test_UserSavedInUserDefaults ----")
            print("--------")
        }
    }

    func testExistingUser() throws {
        let defaults = UserDefaults.standard
        defaults.set("existing_user", forKey: "apple_user_id")

        sut.handleAppleUser(userId: "existing_user", email: "new@mail.com")

        let savedId = defaults.string(forKey: "apple_user_id")
        let savedEmail = defaults.string(forKey: "user_email")

        XCTAssertEqual(savedId, "existing_user", "Existing user ID should not be overwritten")
        XCTAssertNil(savedEmail, "Email should remain nil if user exists")
    }

    func testLoginFailureDelegate() throws {
        sut.delegate?.didFailLogin(with: "Login Failed")
        XCTAssertTrue(mockDelegate.loginErrorCalled, "Failure delegate should be called")
        XCTAssertEqual(mockDelegate.errorMessage, "Login Failed", "Error message should match")
    }

}
