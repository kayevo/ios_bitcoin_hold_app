import Foundation
import Combine

class SignUpViewModel: ObservableObject{
    @Published var isUserSignedUp: Bool? = nil
    var signUpFailed = false
    let loginService: LoginService
    var cancellables = Set<AnyCancellable>()
    
    init(loginService: LoginService){
        self.loginService = loginService
    }
    
    func signUp(email: String, password: String){
        let userCredential = UserCredential(email: email, password: password)
        
        loginService.signUp(credential: userCredential) { [weak self] result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.signUpFailed = false
                    self?.isUserSignedUp = value
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.signUpFailed = true
                    self?.isUserSignedUp = false
                }
            }
        }
    }
}
