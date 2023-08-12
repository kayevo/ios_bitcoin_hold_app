import XCTest
@testable import ios_bitcoin_hold
import Foundation
import Combine

final class SignInViewModelTest: XCTestCase {
    var service: MockSignInServiceImpl!
    var viewModel: SignInViewModel!
    
    class MockSignInServiceImpl : SignInService, ObservableObject{
        var response: AnyPublisher<Bool, Error>?
        
        func signIn(credential: UserCredential)-> AnyPublisher<Bool, Error>{
            if let response = response {
                return response
            } else {
                let mockData = true
                return Result.Publisher(mockData).eraseToAnyPublisher()
            }
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        service = MockSignInServiceImpl()
        viewModel = SignInViewModel(signInService: service)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldSignInUserWhenUserCredentialsAreValid() throws {
        viewModel.signIn(email: "abc", password: "abc")
        XCTAssertTrue(viewModel.userSignIn)
    }
    
    func testShouldNotSignInUserWhenUserCredentialsAreInvalid() throws {
        service.response = Result.Publisher(false).eraseToAnyPublisher()
        viewModel.signIn(email: "abc", password: "abc")
        XCTAssertTrue(!viewModel.userSignIn)
    }
    
}
