import SwiftUI
import Combine

class TextValidator: ObservableObject {

    @Published var text = ""

}

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var wrongUsername = ""
    @State private var wrongPassword = ""
    @State private var logged = false
    @StateObject private var signInViewModel = SignInViewModel(userService: MockSignInServiceImpl())
    @StateObject private var textValidator = TextValidator()
    
    
    var body: some View {
        
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
                    /*
                    TextField("E-mail", text: $textValidator.text)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background()
                        .cornerRadius(10)
                        .onReceive(Just(textValidator.text)){ newValue in
                            if(newValue)
                            
                        }
                    
                     Text("E-mail validator")
                        .font(.title3)
                        .foregroundColor(Color(white: 1))
                     */
                     SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background()
                        .cornerRadius(10)
                    /*Text("Password validator")
                        .font(.title3)
                        .foregroundColor(Color(white: 1))
                    */
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
