import SwiftUI
import Combine

struct PortfolioView: View {
    let userId: String
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    @State var bitcoins: String = "loading..."
    @State var totalPaid: String = "loading..."
    @State var averagePrice: String = "loading..."
    @State var portfolioValue: String = "loading..."
    @State var bitcoinPrice: String = "loading..."
    @State var profits: String = "loading..."
    @StateObject var viewModel: PortfolioViewModel
    private var cancellables = Set<AnyCancellable>()
    let secretDictionary = NSDictionary(
        contentsOfFile: Bundle.main.path(forResource: "Secret", ofType: "plist") ?? ""
    )
    let supportEmail: String
    @State var displaySupportEmail = false
    @State var isLoggedIn = true
    @State var isAddModalPresented = false
    
    init(userId: String){
        
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: PortfolioViewModel(
            portfolioService: PortfolioServiceImpl(),
            analysisService: AnalysisServiceImpl(),
            userId: userId
        ))
        self.supportEmail = (secretDictionary?["SUPPORT_EMAIL"] as? String) ?? ""
    }
    
    var body: some View {
        if isLoggedIn{
            NavigationStack {
                VStack{
                    Spacer()
                    Text("Portfolio")
                        .foregroundColor(Color(primaryGreen))
                        .font(.title)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Menu {
                                    NavigationLink(destination: {
                                        DonationView()
                                    }, label: {
                                        Label("Donations", systemImage: "creditcard")
                                    })
                                    NavigationLink(destination: {
                                        // TODO add customize view, dont do modal
                                    }, label: {
                                        Label("Customize portfolio amount", systemImage: "square.and.pencil")
                                    })
                                    Button(action: {
                                        displaySupportEmail = true
                                    }, label: {
                                        Label("Support", systemImage: "person.wave.2")
                                    })
                                    Button(action: {
                                        isLoggedIn = false
                                    }, label: {
                                        Label("Logout", systemImage: "arrow.up.forward.app")
                                    })
                                }
                            label: {
                                VStack{
                                    Image(systemName: "slider.horizontal.3")
                                    Text("Menu").foregroundColor(.white)
                                }
                            }
                            }
                        }
                    HStack {
                        Text("Bitcoins:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(bitcoins)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Total paid:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(totalPaid)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Average price:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(averagePrice)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 60)
                    Text("Analysis")
                        .foregroundColor(Color(primaryGreen))
                        .font(.title)
                    HStack {
                        Text("Bitcoin price:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(bitcoinPrice)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Portfolio value:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(portfolioValue)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Profits:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(profits)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack{
                        NavigationLink(destination: {
                            RemoveAmountView(portfolioViewModel: viewModel)
                        }, label: {
                            Label("Remove", systemImage: "minus")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .padding(.vertical, 10)
                                .background(Color(primaryGreen))
                                .foregroundColor(Color(primaryLightBlue))
                                .cornerRadius(10)
                        })
                        Spacer()
                        NavigationLink(destination: {
                            AddAmountView(portfolioViewModel: viewModel)
                        }, label: {
                            Label("Add", systemImage: "plus")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .padding(.vertical, 10)
                                .background(Color(primaryGreen))
                                .foregroundColor(Color(primaryLightBlue))
                                .cornerRadius(10)
                        })
                        
                    }
                    .padding(.horizontal, -20)
                }
                .padding(.horizontal, 50)
                .padding(20)
                .background(Color(primaryDarkBlue))
                .onReceive(viewModel.$analysis
                    .compactMap { $0 }, perform: {analysis in
                        self.bitcoinPrice = "\(analysis.bitcoinPriceInBrl.parseToCurrency())"
                        self.portfolioValue = "\(analysis.portfolioValue.parseToCurrency())"
                        self.profits = "\(analysis.profits.parseToPercentage())"
                    }
                )
                .onReceive(viewModel.$portfolioAmount
                    .compactMap { $0 }, perform: {portfolioAmount in
                        self.bitcoins = "\(portfolioAmount.satoshiAmount.parseSatoshiToBitcoin())"
                        self.totalPaid = "\(portfolioAmount.totalPaidValue.parseToCurrency())"
                        self.averagePrice = "\(portfolioAmount.bitcoinAveragePrice.parseToCurrency())"
                    })
                .alert(
                    "Support email",
                    isPresented: $displaySupportEmail,
                    actions: {
                        Button("Ok", role: .cancel) {}
                    },
                    message: {
                        Text("\(supportEmail)")
                    }
                )
            }
        }else{
            SignInView()
        }
    }
}

let secretDictionary = NSDictionary(
    contentsOfFile: Bundle.main.path(forResource: "Secret", ofType: "plist") ?? ""
)
let mockUserId: String = (secretDictionary?["MOCK_USER_ID"] as? String) ?? ""

#Preview {
    PortfolioView(userId: mockUserId)
}
