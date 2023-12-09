import SwiftUI
import Combine

struct PortfolioView: View {
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    @State var bitcoins: String = "loading..."
    @State var averagePrice: String = "loading..."
    @State var portfolioValue: String = "loading..."
    @State var bitcoinPrice: String = "loading..."
    @State var profits: String = "loading..."
    @StateObject private var portfolioViewModel = PortfolioViewModel(
        portfolioService: PortfolioServiceImpl(),
        analysisService: AnalysisServiceImpl(),
        userId: "656a47acbf50ef9a4ca89476"
    )
    private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("Portfolio")
                .foregroundColor(Color(primaryGreen))
                .font(.title)
            HStack {
                Text("Bitcoins:")
                    .foregroundColor(.white)
                Spacer()
                Text(bitcoins)
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
           
        }
        .padding(.horizontal, 50)
        .padding(20)
        .background(Color(primaryLightBlue))
        .onReceive(portfolioViewModel.$portfolioAmount
            .compactMap { $0 }){portfolioAmount in
                self.bitcoins = "\(portfolioAmount.satoshiAmount.parseSatoshiToBitcoin())"
                self.averagePrice = "\(portfolioAmount.bitcoinAveragePrice.parseToCurrency())"
            }
            .onReceive(portfolioViewModel.$analysis
                .compactMap { $0 }){analysis in
                    self.bitcoinPrice = "\(analysis.bitcoinPriceInBrl.parseToCurrency())"
                    self.portfolioValue = "\(analysis.portfolioValue.parseToCurrency())"
                    self.profits = "\(analysis.profits.parseToPercentage())"
                }
    }
    
}

#Preview {
    PortfolioView()
}
