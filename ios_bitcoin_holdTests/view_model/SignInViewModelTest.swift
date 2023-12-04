@testable import ios_bitcoin_hold
import XCTest
import Foundation

final class SignInViewModelTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGivenCreatedUserShouldSignInWhenClickSignIn() throws {
        let service = MockLoginServiceImpl(result: .success(true))
        let viewModel = SignInViewModel(loginService: service)
        let expectation = XCTestExpectation(description: "User signed in")

        let cancellable = viewModel.$isUserSignedIn.compactMap { $0 }
            .sink { isUserSignedIn in
                XCTAssertTrue(isUserSignedIn)
                XCTAssertTrue(!viewModel.signInFailed)
                expectation.fulfill()
            }

        viewModel.signIn(email: "abc", password: "abc")

        wait(for: [expectation], timeout: 5)
        
        cancellable.cancel() // Cancel the Combine subscription to avoid memory leaks
    }

    func testGivenNotCreatedUserShouldDontSignInWhenClickSignIn() throws {
        let service = MockLoginServiceImpl(result: .success(false))
        let viewModel = SignInViewModel(loginService: service)
        let expectation = XCTestExpectation(description: "User signed in")
        
        let cancellable = viewModel.$isUserSignedIn.compactMap { $0 }
            .sink { isUserSignedIn in
                XCTAssertFalse(viewModel.signInFailed)
                XCTAssertFalse(isUserSignedIn)
                expectation.fulfill()
            }
        
        viewModel.signIn(email: "abcInvalid", password: "abcInvalid")
        
        
        wait(for: [expectation], timeout: 5)
        
        cancellable.cancel() // Cancel the Combine subscription to avoid memory leaks
    }
    
    func testGivenServerFailsShouldReturnErrorTrueWhenClickToSignIn() throws{
        let service = MockLoginServiceImpl(result: .failure(LoginError.serverError))
        let viewModel = SignInViewModel(loginService: service)
        let email = "email@email.com"
        let password = "email@"
        let expectation = expectation(description: "User signed up")
        
        viewModel.signIn(email: email, password: password)
        
        let cancellable = viewModel.$isUserSignedIn.compactMap{$0}
            .sink(receiveValue: {signedIn in
                XCTAssertTrue(viewModel.signInFailed)
                XCTAssertFalse(signedIn)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
    
}


