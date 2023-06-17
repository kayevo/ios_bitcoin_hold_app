class SignUp {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func signUp(signUpService: SignUpService) {
        let credential = UserCredential(email: email, password: password)
        signUpService.signUp(credential: credential)
    }
}