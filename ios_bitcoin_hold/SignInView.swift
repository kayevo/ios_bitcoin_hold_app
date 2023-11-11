import SwiftUI
import Combine

class TextValidator: ObservableObject {
    
    @Published var text = ""
    
}

struct SignInView: View {
    @State private var email = ""
    @State private var hintEmail = ""
    @State private var password = ""
    @State private var hintPassword = ""
    @State private var logged = false
    @StateObject private var signInViewModel = SignInViewModel(signInService: MockSignInServiceImpl())
    @StateObject private var textValidator = TextValidator()
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: primaryGreen] // Change the color of title navigationbar
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(primaryLightBlue)
                    .ignoresSafeArea()
                Form {
                    Section(header: Text("Sign in")) {
                        TextField("E-mail", text: $email)
                            .onChange(of: email) { newEmail in
                                if(signInViewModel.mockValidateEmail(email: newEmail)){
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
                                if(signInViewModel.mockValidatePassword(password: newPassword)){
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
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Sign in")
                Button("Sign In"){
                    signInViewModel.signIn(email: email, password: password)
                }
                .onReceive(signInViewModel.$userSignIn) { isUserSignIn in
                    if (isUserSignIn) {
                        print("Sign in")
                        logged = isUserSignIn
                    } else {
                        print("Dont sign in")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(primaryGreen))
                .foregroundColor(Color(primaryLightBlue))
                .cornerRadius(10)
                .padding(.top, -80)
                .padding(.horizontal, 20)
                .disabled(hintEmail != "Valid e-mail" || hintPassword != "Valid password")
                NavigationLink(destination: Text("Signed in"), isActive: $logged){
                    EmptyView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
