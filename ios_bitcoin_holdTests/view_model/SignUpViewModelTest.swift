@testable import ios_bitcoin_hold
import XCTest

final class SignUpViewModelTest: XCTestCase {
    
    override func setUpWithError() throws {
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDownWithError() throws {
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testGivenNotCreatedUserShouldSignUpWhenClickSignUp() throws {
        let service = MockLoginServiceImpl(result: .success(true))
        let viewModel = SignUpViewModel(loginService: service)
        let email = "email@email.com"
        let password = "email@"
        let expectation = expectation(description: "User signed up")
        
        MockURLProtocol.requestHandler = { _ in
                    let response = HTTPURLResponse(
                        url: URL(string: "https://example.com")!,
                        statusCode: 201,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                    let data = "{}".data(using: .utf8)!
                    return (response, data)
                }

        viewModel.signUp(email: email, password: password)
        
        let cancellable = viewModel.$isUserSignedUp.compactMap{$0}
            .sink(receiveValue: {signedUp in
                XCTAssertFalse(viewModel.signUpFailed)
                XCTAssertTrue(signedUp)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
    
    func testGivenCreatedUserShouldDontSignUpWhenClickToSignUp() throws{
        let service = MockLoginServiceImpl(result: .success(false))
        let viewModel = SignUpViewModel(loginService: service)
        let email = "email@email.com"
        let password = "email@"
        let expectation = expectation(description: "User signed up")

        viewModel.signUp(email: email, password: password)
        
        let cancellable = viewModel.$isUserSignedUp.compactMap{$0}
            .sink(receiveValue: {signedUp in
                XCTAssertFalse(viewModel.signUpFailed)
                XCTAssertFalse(signedUp)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
    
    func testGivenServerFailsShouldReturnErrorTrueWhenClickToSignUp() throws{
        let service = MockLoginServiceImpl(result: .failure(NetworkError.serverError))
        let viewModel = SignUpViewModel(loginService: service)
        let email = "email@email.com"
        let password = "email@"
        let expectation = expectation(description: "User signed up")
        
        viewModel.signUp(email: email, password: password)
        
        let cancellable = viewModel.$isUserSignedUp.compactMap{$0}
            .sink(receiveValue: {signedUp in
                XCTAssertTrue(viewModel.signUpFailed)
                XCTAssertFalse(signedUp)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
}
