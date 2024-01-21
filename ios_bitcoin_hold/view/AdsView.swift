import SwiftUI

struct AdsView: View {
    @State var isLoading: Bool = true
    @StateObject private var viewModel = AdsViewModel(
        service: AdsServiceImpl())
    @State var goToSignIn = false
    
    var body: some View {
        if (goToSignIn){
            SignInView()
        }else {
            if(isLoading){
                ProgressView()
                    .onReceive(
                        viewModel.$adsResponse.compactMap { $0 },
                        perform: { adsResponse in
                            isLoading = false
                        }
                    )
                    .onReceive(
                        viewModel.$adsFails,
                        perform: { adsFails in
                            if(adsFails){ goToSignIn = true }
                        }
                    )
            }else {
                NavigationView {
                    VStack{
                        Spacer()
                        AsyncImage(url: URL(string: viewModel.adsResponse?.posterUrl ?? ""))
                        { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: .infinity, height: .infinity)
                        .padding(20)
                        Button(
                            action: {
                                goToSignIn = true
                            },
                            label: {
                                Text("Go to sign in")
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .padding(.vertical, 10)
                                    .background(Color(.ligthGreen))
                                    .foregroundColor(Color(.ligthBlue))
                                    .cornerRadius(10)
                            }
                        )
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        Button(
                            action: {
                                
                                let urlString = viewModel.adsResponse?.webLink ?? ""
                                
                                if let url = URL(string: urlString) {
                                    if UIApplication.shared.canOpenURL(url)
                                    {
                                        UIApplication.shared.open(url)
                                    }
                                } else {
                                    // TODO Handle the case where the URL string is not valid
                                    print("Invalid URL string")
                                }
                            },
                            label: {
                                Text("Visit advertiser")
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .padding(.vertical, 10)
                                    .background(Color(.ligthGreen))
                                    .foregroundColor(Color(.ligthBlue))
                                    .cornerRadius(10)
                            }
                        )
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    .padding(20)
                    .background(Color(.darkBlue))
                }
            }
        }
    }
}

#Preview {
    AdsView()
}
