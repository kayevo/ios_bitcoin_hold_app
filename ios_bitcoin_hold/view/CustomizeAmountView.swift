import SwiftUI

struct CustomizeAmountView: View {
    @ObservedObject var portfolioViewModel: PortfolioViewModel
    @State var amount: String = ""
    @State var hintAmount: String = ""
    @State var totalPaidValue: String = ""
    @State var hintPaidValue: String = ""
    @StateObject var viewModel = CustomizeAmountViewModel(service: PortfolioServiceImpl())
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
                TextField("Paid value", text: $totalPaidValue)
                    .autocapitalization(.none)
                    .keyboardType(.decimalPad)
                    .onChange(
                        of: totalPaidValue,
                        perform: { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0)
                            }
                            if filtered != newValue {
                                totalPaidValue = filtered
                            }
                            if(newValue.validateNumber()){
                                hintPaidValue = "Valid value"
                            }else{
                                hintPaidValue = "Invalid value"
                            }
                        }
                    )
                if(hintPaidValue != "Valid value"){
                    Text("Invalid value")
                        .foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            Button(action: {
                isLoadding = true
                viewModel.customizeAmount(
                    userId: portfolioViewModel.userId,
                    amount: amount.parseBitcoinToSatoshi(),
                    totalPaidValue: totalPaidValue.parseCurrencyToDouble()
                )
            }, label: {
                Label("Add", systemImage: "plus")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 10)
                    .background(Color(.ligthGreen))
                    .foregroundColor(Color(.darkBlue))
                    .cornerRadius(10)
            })
            .onReceive(viewModel.$isAmountCustomized, perform: { isAdded in
                guard isAdded == true else { return }
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

struct CustomizeAmountView_Previews: PreviewProvider {
    @StateObject static var portfolioViewModel = PortfolioViewModel(
        portfolioService: PortfolioServiceImpl(),
        analysisService: AnalysisServiceImpl(),
        userId: mockUserId
    )

    static var previews: some View {
        CustomizeAmountView(portfolioViewModel: portfolioViewModel)
    }
}
