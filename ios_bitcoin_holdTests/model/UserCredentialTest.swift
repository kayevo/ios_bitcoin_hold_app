@testable import ios_bitcoin_hold
import XCTest

final class UserCredentialTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenValidEmailShouldReturnTrueWhenValidateEmail() throws {
        let validEmail = "email@email.com"
        XCTAssertTrue(UserCredential.validateEmail(email: validEmail))
    }

    func testGivenInvalidEmailShouldReturnFalseWhenValidateEmail() throws {
        let invalidEmail = "e"
        XCTAssertFalse(UserCredential.validateEmail(email: invalidEmail))
    }
    
    func testGivenStrongPasswordShouldReturnTrueWhenValidatePassword() throws {
        // Strong password: at least 5 characters and one special character
        let strongPassword = "password@"
        XCTAssertTrue(UserCredential.validatePassword(password: strongPassword))
    }

    
    func testGivenWeakPasswordShouldReturnFalseWhenValidatePassword() throws {
        // Strong password: at least 5 characters and one special character
        let weakPassword = "p"
        XCTAssertFalse(UserCredential.validatePassword(password: weakPassword))
    }
}
