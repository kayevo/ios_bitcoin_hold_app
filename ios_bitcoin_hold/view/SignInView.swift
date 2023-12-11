import SwiftUI
import Combine

struct SignInView: View {
    @State private var email = ""
    @State private var hintEmail = ""
    @State private var password = ""
    @State private var hintPassword = ""
    @State private var isUserSignedIn: Bool = false
    @StateObject private var signInViewModel = SignInViewModel(loginService: LoginServiceImpl())
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    @State private var displayDontSignInMessage: Bool = false
    @State private var dontSignedInMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var userId: String = ""
    
    var body: some View {
        if isUserSignedIn {
            PortfolioView(userId: userId)
        }else{
            NavigationView{
                VStack(alignment: .center) {
                    Spacer()
                    Text("Sign in").foregroundColor(Color(primaryGreen)).font(.title)
                    Form {
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
                        isLoading = true
                        Task {
                            signInViewModel.signIn(email: email, password: password)
                        }
                    }) {
                        Text("Sign in")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .padding(.vertical)
                            .background(Color(primaryGreen))
                            .foregroundColor(Color(primaryLightBlue))
                            .cornerRadius(10)
                    }
                    .onReceive(
                        signInViewModel.$user.compactMap { $0 },
                        perform: { user in
                            userId = user.id
                            self.isLoading = false
                            self.isUserSignedIn = true
                        }
                    )
                    .onReceive(
                        signInViewModel.$dontSignedInMessage.compactMap { $0 },
                        perform:  { message in
                            self.dontSignedInMessage = message
                            self.isLoading = false
                            self.displayDontSignInMessage = true
                        }
                    )
                    .disabled(hintEmail != "Valid e-mail" || hintPassword != "Valid password" || isLoading)
                    .navigationBarBackButtonHidden(true)
                    .alert(
                        "Cannot sign in",
                        isPresented: $displayDontSignInMessage,
                        actions: {
                            Button("Ok", role: .cancel) {}
                        },
                        message: {
                            Text("\(dontSignedInMessage)")
                        }
                    )
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
                .background(Color(primaryDarkBlue))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
