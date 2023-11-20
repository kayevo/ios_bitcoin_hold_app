import SwiftUI
import Combine

struct SignInView: View {
    @State private var email = ""
    @State private var hintEmail = ""
    @State private var password = ""
    @State private var hintPassword = ""
    @State private var logged: Bool = false
    @StateObject private var signInViewModel = SignInViewModel(signInService: MockSignInServiceImpl())
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    
    init() {
        UINavigationBar
            .appearance()
            .largeTitleTextAttributes = [.foregroundColor: primaryGreen] // Change the color of title navigationbar
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Spacer()
                HStack(){
                    Text("Sign in").foregroundColor(Color(primaryGreen)).font(.title)
                    Spacer()
                }
                Form {
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
                .scrollContentBackground(.hidden)
                .frame(width: .infinity, height: 300)
                .padding(.horizontal, -20)
                Button(action: {
                    signInViewModel.signIn(email: email, password: password)
                    print("TEST 1")
                }) {
                    Text("Sign in")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.vertical)
                        .background(Color(primaryGreen))
                        .foregroundColor(Color(primaryLightBlue))
                        .cornerRadius(10)
                }
                .onReceive(signInViewModel.$userSignIn) { isUserSignIn in
                    if (isUserSignIn) {
                        logged = isUserSignIn
                    } else {
                        print("Dont sign in")
                    }
                }
                .disabled(hintEmail != "Valid e-mail" || hintPassword != "Valid password")
                .navigationBarBackButtonHidden(true)
                .fullScreenCover(isPresented: $logged) {
                    PortfolioView()
                }
                Spacer()
            }
            .padding(20)
            .background(Color(primaryLightBlue))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
