import SwiftUI
import Combine

struct SignInView: View {
    @State private var email = ""
    @State private var hintEmail = ""
    @State private var password = ""
    @State private var hintPassword = ""
    @State private var goToPortfolio: Bool = false
    @StateObject private var signInViewModel = SignInViewModel(loginService: MockLoginServiceImpl())
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    @State private var isSignInFailed: Bool = false
    @State private var signInFailedMessage: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Spacer()
                Text("Sign in").foregroundColor(Color(primaryGreen)).font(.title)
                Form {
                    TextField("E-mail", text: $email)
                        .autocapitalization(.none)
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
                if(isLoading){
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                        .foregroundColor(.white)
                        .padding()
                }
                Button(action: {
                    isLoading = true
                    Task {
                        do {
                            signInViewModel.signIn(email: email, password: password)
                        } catch {
                            signInFailedMessage = "Server error, try again in one hour"
                            isSignInFailed = true
                            isLoading = false
                        }
                    }
                }) {
                    Text("Sign in")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.vertical)
                        .background(Color(primaryGreen))
                        .foregroundColor(Color(primaryLightBlue))
                        .cornerRadius(10)
                }
                .onReceive(signInViewModel.$isUserSignedIn.compactMap { $0 }) { isUserSignedIn in
                    if(isUserSignedIn){
                        self.goToPortfolio = true
                        self.signInFailedMessage = ""
                        self.isSignInFailed = false
                    }else{
                        if(signInViewModel.signInFailed){
                            self.signInFailedMessage = "Server error, try again in one hour"
                            
                        }else{
                            self.signInFailedMessage = "User doesn't found"
                        }
                        self.goToPortfolio = false
                        self.isSignInFailed = true
                    }
                    self.isLoading = false
                }
                .disabled(hintEmail != "Valid e-mail" || hintPassword != "Valid password" || isLoading)
                .navigationBarBackButtonHidden(true)
                .fullScreenCover(isPresented: $goToPortfolio) {
                    PortfolioView()
                }
                .alert(signInFailedMessage, isPresented: $isSignInFailed) {
                    Button("Ok", role: .cancel) {}
                }
                NavigationLink(destination: {
                    SignUpView()
                }, label: {
                    Text("Click to Sign Up")    .padding(.vertical)
                        .foregroundColor(Color(.white))
                        .cornerRadius(10)
                })
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
