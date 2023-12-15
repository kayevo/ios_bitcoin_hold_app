import SwiftUI

struct RemoveAmountView: View {
    @ObservedObject var portfolioViewModel: PortfolioViewModel
    @State var amount: String = ""
    @State var hintAmount: String = ""
    @State var receivedValue: String = ""
    @State var hintReceivedValue: String = ""
    @StateObject var viewModel = RemoveAmountViewModel(portfolioService: PortfolioServiceImpl())
    @Environment(\.presentationMode) var presentationMode
    @State var isLoadding = false
    
    var body: some View {
        VStack {
            Form {
                TextField("Bitcoin amount", text: $amount)
                    .autocapitalization(.none)
                    .keyboardType(.decimalPad)
                    .onChange(
                        of: amount,
                        perform: { newAmount in
                            let filtered = newAmount.filter { "0123456789.".contains($0)
                            }
                            if filtered != newAmount {
                                amount = filtered
                            }
                            if(newAmount.validateNumber()){
                                hintAmount = "Valid amount"
                            }else{
                                hintAmount = "Invalid amount"
                            }
                        }
                    )
                if(hintAmount != "Valid amount"){
                    Text("Invalid amount")
                        .foregroundColor(.red)
                }
                TextField("Received value", text: $receivedValue)
                    .autocapitalization(.none)
                    .keyboardType(.decimalPad)
                    .onChange(
                        of: receivedValue,
                        perform: { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0)
                            }
                            if filtered != newValue {
                                receivedValue = filtered
                            }
                            if(newValue.validateNumber()){
                                hintReceivedValue = "Valid value"
                            }else{
                                hintReceivedValue = "Invalid value"
                            }
                        }
                    )
                if(hintReceivedValue != "Valid value"){
                    Text("Invalid value")
                        .foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            Button(action: {
                isLoadding = true
                viewModel.removeAmount(
                    userId: portfolioViewModel.userId,
                    amount: amount.parseBitcoinToSatoshi(),
                    receivedValue: receivedValue.parseCurrencyToDouble()
                )
            }, label: {
                Label("Remove", systemImage: "minus")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 10)
                    .background(Color(.ligthGreen))
                    .foregroundColor(Color(.darkBlue))
                    .cornerRadius(10)
            })
            .onReceive(viewModel.$isAmountRemoved, perform: { isRemoved in
                guard isRemoved == true else { return }
                isLoadding = false
                portfolioViewModel.getPortfolio()
                portfolioViewModel.getAnalysis()
                presentationMode.wrappedValue.dismiss()
            })
        }
        .padding(.horizontal, 30)
        .padding(20)
        .background(Color(.darkBlue))
    }
}


struct RemoveAmountView_Previews: PreviewProvider {
    @StateObject static var portfolioViewModel = PortfolioViewModel(
        portfolioService: PortfolioServiceImpl(),
        analysisService: AnalysisServiceImpl(),
        userId: mockUserId
    )
    
    static var previews: some View {
        RemoveAmountView(portfolioViewModel: portfolioViewModel)
    }
}
