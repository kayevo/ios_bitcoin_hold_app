import Foundation
import Combine

protocol LoginService{
    func signIn(credential: UserCredential, completion: @escaping (Result<User?, Error>) -> Void)
    func signUp(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void)
}
