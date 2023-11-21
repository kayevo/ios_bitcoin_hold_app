import Foundation
import Combine

class MockLoginServiceImpl : LoginService, ObservableObject{
    func signIn(credential: UserCredential)-> AnyPublisher<Bool, Error>{
        let publisher = Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        return publisher
    }
    
    func signUp(credential: UserCredential)-> AnyPublisher<Bool, Error>{
        let publisher = Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        return publisher
    }
}
