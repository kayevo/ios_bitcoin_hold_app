import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var hintEmail = ""
    @State private var password = ""
    @State private var hintPassword = ""
    @State private var isUserSignedUp: Bool = false
    
    @StateObject private var signUpViewModel = SignUpViewModel(loginService: MockLoginServiceImpl())
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sign up").foregroundColor(Color(primaryGreen)).font(.title)
            Form{
                TextField("E-mail", text: $email)
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
                    Text("Password have less than 4 characteres")
                        .foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .frame(width: .infinity, height: 300)
            .padding(.horizontal, -20)
            Button(action: {
                signUpViewModel.signUp(email: email, password: password)
            }) {
                Text("Sign up")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color(primaryGreen))
                    .foregroundColor(Color(primaryLightBlue))
                    .cornerRadius(10)
            }
            .onReceive(signUpViewModel.$isUserSignedUp) { isUserSignedUp in
                if (isUserSignedUp) {
                    self.isUserSignedUp = isUserSignedUp
                } else {
                    print("Dont signed up")
                }
            }
            .disabled(hintEmail != "Valid e-mail" || hintPassword != "Valid password")
            .alert("User successfully signed up", isPresented: $isUserSignedUp) {
                Button("Ok", role: .cancel) {
                    if (isUserSignedUp) {
                        presentationMode.wrappedValue.dismiss() // back to previous view
                    } else {
                        print("Dont signed up")
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
