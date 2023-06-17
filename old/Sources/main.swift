// The Swift Programming Language
// https://docs.swift.org/swift-book

let signUp = SignUp(email: "email@email.com", password: "email@email.com")
let signUpService = MockSignUpServiceImpl()
signUp.signUp(signUpService: signUpService)