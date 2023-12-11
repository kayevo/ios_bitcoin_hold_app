import Foundation
import Combine

class SignInViewModel: ObservableObject{
    @Published private(set) var user: User?
    @Published private(set) var dontSignedInMessage: String?
    private let loginService: LoginService
    private var cancellables = Set<AnyCancellable>()
    
    init(loginService: LoginService){
        self.loginService = loginService
    }
    
    func signIn(email: String, password: String){
        let userCredential = UserCredential(email: email, password: password)
        
        loginService.signIn(credential: userCredential) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if(user == nil){
                        self?.dontSignedInMessage = "User doesn't found"
                    }else{
                        self?.user = user
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.dontSignedInMessage = "Server error, try again in one hour"
                }
            }
        }
    }
}
