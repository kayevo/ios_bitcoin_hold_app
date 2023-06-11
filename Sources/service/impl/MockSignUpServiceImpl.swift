class MockSignUpServiceImpl : SignUpService{
    func signUp(credential: UserCredential){
        print("User saved.")
    }
}