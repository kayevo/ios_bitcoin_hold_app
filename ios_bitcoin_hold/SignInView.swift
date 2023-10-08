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
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: primaryGreen]
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(primaryLightBlue)
                    .ignoresSafeArea()
                
                Form {
                    TextField("E-mail", text: $email)
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Login")
            }
        }
        /*
        NavigationView{
            ZStack{
                let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
                let primaryLigthBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
                let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
                Color(uiColor: primaryLigthBlue)
                    .ignoresSafeArea()
                VStack{
                    Text("Bitcoin Hold")
                        .font(.largeTitle)
                        .foregroundColor(Color(white: 1))
                    TextField("E-mail", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background()
                        .cornerRadius(10)
                        .onChange(of: email) { newValue in
                            // This function will be called every time the 'email' variable changes
                            // You can perform your desired actions here
                            print("Text typed: \(newValue)")
                        }
                    Text("Invalid e-mail")
                        .font(.title3)
                        .foregroundColor(Color(white: 1))
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background()
                        .cornerRadius(10)
                    Button("SignIn"){
                        signInViewModel.signIn(email: email, password: password)
                        logged = signInViewModel.userSignIn
                    }
                    .frame(width: 300, height: 50)
                    .background(Color(primaryGreen))
                    .foregroundColor(Color(primaryLigthBlue))
                    .cornerRadius(10)
                    .padding(.top, 20)
                    
                    NavigationLink(destination: Text("Logged in"), isActive: $logged){
                        EmptyView()
                    }
                }
            }
        }
    */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
