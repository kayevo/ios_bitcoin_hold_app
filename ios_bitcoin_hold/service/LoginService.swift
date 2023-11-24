import Foundation
import Combine

protocol LoginService{
    func signIn(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void)
    func signUp(credential: UserCredential) -> AnyPublisher<Bool, Error>
}
