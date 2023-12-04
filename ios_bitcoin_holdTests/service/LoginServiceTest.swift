@testable import ios_bitcoin_hold
import XCTest
import Combine

final class LoginServiceTest: XCTestCase {
    let encoder = JSONEncoder()
    let service = LoginServiceImpl()
    
    override func setUpWithError() throws {
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDownWithError() throws {
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testGivenCreatedUserShouldSignInWhenCallsSignIn() throws {
        let credential = UserCredential(email: "email@email.com", password: "email@")
        let expectation = expectation(description: "User signed up")
        let user = User(id: "testId")
        
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            do {
                let userData = try self.encoder.encode(user)
                return (response, userData)
            } catch {
                XCTFail()
                return (response, Data())
            }
        }
        
        service.signIn(credential: credential, completion: { result in
            switch result {
            case .success(let value):
                XCTAssertTrue(value)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGivenNotCreatedUserShouldDontSingInWhenCallsSignIn() throws{
        let credential = UserCredential(email: "email@email.com", password: "email@")
        let expectation = expectation(description: "User signed up")
        
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, Data())
        }
        
        service.signIn(credential: credential, completion: { result in
            switch result {
            case .success(let value):
                XCTAssertFalse(value)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGivenServerFailsShouldExecuteFailureWhenCallsSignIn() throws{
        let credential = UserCredential(email: "email@email.com", password: "email@")
        let expectation = expectation(description: "User signed up")
        
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, Data())
        }
        
        service.signIn(credential: credential, completion: { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                if let loginError = error as? LoginError {
                    XCTAssertEqual(loginError, .serverError)
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected error type")
                }
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
}
