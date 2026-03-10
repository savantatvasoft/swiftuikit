//
//  AuthenticationVM.swift
//  appnavigationTests
//
//  Created by MACM72 on 06/03/26.
//

import XCTest

@testable import appnavigation

final class AuthenticationVM: XCTestCase {

    private var sut: AuthenticationVM!

    override func setUpWithError() throws {
        sut = AuthenticationVM()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
}
