import Foundation
import Combine

class MockSignInServiceImpl : SignInService, ObservableObject{
    func signIn(credential: UserCredential)-> AnyPublisher<Bool, Error>{
        print("User saved.")
        let publisher = Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        return publisher
    }
}
