import Foundation
import Combine

class SignUpViewModel: ObservableObject{
    @Published var isUserSignedUp = false
    let loginService: LoginService
    var cancellables = Set<AnyCancellable>()
    
    init(loginService: LoginService){
        self.loginService = loginService
    }
    
    func signUp(email: String, password: String){
        let userCredential = UserCredential(email: email, password: password)
        return loginService.signUp(credential: userCredential)
            .sink{
                _ in
            } receiveValue:{ [weak self] result in
                self?.isUserSignedUp = result
            }
            .store(in: &cancellables)
    }
    
    func mockValidateEmail(email: String) -> Bool{
        return email.count > 4
    }
    
    func mockValidatePassword(password: String) -> Bool{
        return password.count > 4
    }
}
