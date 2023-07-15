import SwiftUI
import Combine

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var wrongUsername = ""
    @State private var wrongPassword = ""
    @State private var logged = false
    @StateObject private var signInViewModel = SignInViewModel(userService: MockSignInServiceImpl())
        
    var body: some View {
        NavigationView{
            ZStack{
                Color.gray
                    .ignoresSafeArea()
                VStack{
                    Text("Bitcoin Hold")
                        .font(.largeTitle)
                    TextField("E-mail", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background()
                        .cornerRadius(10)
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
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: Text("Logged in"), isActive: $logged){
                        EmptyView()
                    }
                    
                }
            }
            .navigationBarHidden(true)
        }
    }
    func authenticateUser(username: String, password: String) -> Bool{
        
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
