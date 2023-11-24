import Foundation
import Combine

class SignInViewModel: ObservableObject{
    @Published var isUserSignedIn: Bool? = nil
    let loginService: LoginService
    var cancellables = Set<AnyCancellable>()
    
    init(loginService: LoginService){
        self.loginService = loginService
    }
    
    func signIn(email: String, password: String) {
        let userCredential = UserCredential(email: email, password: password)
        
        loginService.signIn(credential: userCredential) { [weak self] result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.isUserSignedIn = value
                }
            case .failure(let error):
                print("Sign-in error: \(error)")
            }
        }
    }
    
    func mockValidateEmail(email: String) -> Bool{
        return email.count > 4
    }
    
    func mockValidatePassword(password: String) -> Bool{
        return password.count > 4
    }
}
