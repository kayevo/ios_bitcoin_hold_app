import XCTest
@testable import ios_bitcoin_hold
import Foundation
import Combine

final class SignInViewModelTest: XCTestCase {
    var service: MockLoginServiceImpl!
    var viewModel: SignInViewModel!
    
    class MockLoginServiceImpl : LoginService, ObservableObject{
        var response: AnyPublisher<Bool, Error>?
        
        func signIn(credential: UserCredential)-> AnyPublisher<Bool, Error>{
            if let response = response {
                return response
            } else {
                let mockData = true
                return Result.Publisher(mockData).eraseToAnyPublisher()
            }
        }
        
        func signUp(credential: UserCredential)-> AnyPublisher<Bool, Error>{
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
        service = MockLoginServiceImpl()
        viewModel = SignInViewModel(loginService: service)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldSignInUserWhenUserCredentialsAreValid() throws {
        viewModel.signIn(email: "abc", password: "abc")
        XCTAssertTrue(viewModel.isUserSignedIn)
    }
    
    func testShouldNotSignInUserWhenUserCredentialsAreInvalid() throws {
        service.response = Result.Publisher(false).eraseToAnyPublisher()
        viewModel.signIn(email: "abc", password: "abc")
        XCTAssertTrue(!viewModel.isUserSignedIn)
    }
    
}
