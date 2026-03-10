//
//  MockAuthenticationDelegate.swift
//  appnavigationTests
//
//  Created by MACM72 on 06/03/26.
//

import XCTest

@testable import appnavigation

class MockAuthenticationDelegate: AuthenticationViewModelDelegate {

    var didLoginCalled = false
    var didFailCalled = false
    var errorMessage: String?

    func didLoginSuccessfully() {
        didLoginCalled = true
    }

    func didFailLogin(with error: String) {
        didFailCalled = true
        errorMessage = error
    }
}
