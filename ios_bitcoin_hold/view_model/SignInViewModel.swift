import Foundation
import Combine

class SignInViewModel: ObservableObject{
    @Published var userSignIn = false
    let signInService: SignInService
    var cancellables = Set<AnyCancellable>()
    
    init(signInService: SignInService){
        self.signInService = signInService
    }
    
    func signIn(email: String, password: String){
        let userCredential = UserCredential(email: email, password: password)
        return signInService.signIn(credential: userCredential)
            .sink{
                _ in
            } receiveValue:{ [weak self] resultUserSignIn in
                self?.userSignIn = resultUserSignIn
            }
            .store(in: &cancellables)
    }
    
    func validateEmail(email: String) -> Bool{
        return email.count > 4
    }
}
