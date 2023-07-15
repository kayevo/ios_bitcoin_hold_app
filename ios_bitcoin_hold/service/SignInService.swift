import Foundation
import Combine

protocol SignInService{
    func signIn(credential: UserCredential) -> AnyPublisher<Bool, Error>
}
