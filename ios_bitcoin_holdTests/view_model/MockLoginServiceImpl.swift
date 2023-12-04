@testable import ios_bitcoin_hold
import Foundation

class MockLoginServiceImpl : LoginService, ObservableObject{
    var result : Result<Bool, Error>
    
    init(result: Result<Bool, Error>) {
        self.result = result
    }
    
    func signIn(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void){
        completion(result)
    }
    
    func signUp(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void){
        completion(result)
    }
}
