import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var hintEmail = ""
    @State private var password = ""
    @State private var hintPassword = ""
    @State private var goToSignIn: Bool = false
    @StateObject private var signUpViewModel = SignUpViewModel(loginService: LoginServiceImpl())
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    @Environment(\.presentationMode) var presentationMode
    @State private var signUpResultMessage: String = ""
    @State private var displaySignUpResultMessage: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sign up").foregroundColor(Color(primaryGreen)).font(.title)
            Form{
                TextField("E-mail", text: $email)
                    .autocapitalization(.none)
                    .onChange(of: email) { newEmail in
                        if(UserCredential.validateEmail(email: newEmail)){
                            hintEmail = "Valid e-mail"
                        }else{
                            hintEmail = "Invalid e-mail"
                        }
                    }
                if(hintEmail != "Valid e-mail"){
                    Text("Invalid e-mail address")
                        .foregroundColor(.red)
                }
                SecureField("Password", text: $password)
                    .onChange(of: password) { newPassword in
                        if(UserCredential.validatePassword(password: newPassword)){
                            hintPassword = "Valid password"
                        }else{
                            hintPassword = "Invalid password"
                        }
                    }
                if(hintPassword != "Valid password"){
                    Text("Password requires at least 5 characters and one special character")
                        .foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .frame(width: .infinity, height: 300)
            .padding(.horizontal, -20)
            if(isLoading){
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
                    .foregroundColor(.white)
                    .padding()
            }
            Button(action: {
                Task{
                    signUpViewModel.signUp(email: email, password: password)
                    isLoading = true
                }
            }) {
                Text("Sign up")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color(primaryGreen))
                    .foregroundColor(Color(primaryLightBlue))
                    .cornerRadius(10)
            }
            .onReceive(signUpViewModel.$isUserSignedUp.compactMap { $0 }) { isUserSignedUp in
                if (isUserSignedUp) {
                    self.signUpResultMessage = "User successfully signed up"
                    self.goToSignIn = true
                } else {
                    if(signUpViewModel.signUpFailed){
                        self.signUpResultMessage = "Server error, try again in one hour"
                        self.goToSignIn = false
                    }else{
                        self.signUpResultMessage = "User already exists"
                        self.goToSignIn = false
                    }
                }
                displaySignUpResultMessage = true
                isLoading = false
            }
            .disabled(hintEmail != "Valid e-mail" || hintPassword != "Valid password" || isLoading)
            .alert(signUpResultMessage, isPresented: $displaySignUpResultMessage) {
                Button("Ok", role: .cancel) {
                    if (goToSignIn) {
                        presentationMode.wrappedValue.dismiss() // back to previous view
                    }
                }
            }
            Spacer()
        }
        .padding(20)
        .background(Color(primaryDarkBlue))
    }
}

#Preview {
    SignUpView()
}
