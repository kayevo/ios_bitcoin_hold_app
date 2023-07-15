import Foundation
import Combine

class SignInViewModel: ObservableObject{
    @Published var userSignIn = false
    let userService: SignInService
    var cancellables = Set<AnyCancellable>()
    
    init(userService: SignInService){
        self.userService = userService
    }
    
    func signIn(email: String, password: String){
        return userService.signIn(credential: UserCredential(email: email, password: password))
            .sink{
                _ in
            } receiveValue:{ [weak self] resultUserSignIn in
                self?.userSignIn = resultUserSignIn
            }
            .store(in: &cancellables)
    }
}
