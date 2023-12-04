@testable import ios_bitcoin_hold
import XCTest

final class UserCredentialTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenValidEmailShouldReturnTrueWhenInsertEmail() throws {
        let validEmail = "email@email.com"
        
        XCTAssertTrue(UserCredential.validateEmail(email: validEmail))
    }

    func testGivenValidEmailShouldReturnTrueWhenInsertEmail() throws {
        let validEmail = "email@email.com"
        XCTAssertTrue(UserCredential.validateEmail(email: validEmail))
    }

}
