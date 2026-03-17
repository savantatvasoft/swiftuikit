//
//  MockAuthDelegate.swift
//  appnavigationTests
//
//  Created by MACM72 on 16/03/26.
//

import XCTest
@testable import appnavigation

final class MockAuthDelegate: AuthenticationViewModelDelegate {

    var loginSuccessCalled = false
    var loginErrorCalled = false
    var errorMessage: String?

    func didLoginSuccessfully() {
        loginSuccessCalled = true
    }

    func didFailLogin(with error: String) {
        loginErrorCalled = true
        errorMessage = error
    }
}

