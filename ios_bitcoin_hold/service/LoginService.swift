import Foundation
import Combine

protocol LoginService{
    func signIn(credential: UserCredential) -> AnyPublisher<Bool, Error>
    func signUp(credential: UserCredential) -> AnyPublisher<Bool, Error>
}
