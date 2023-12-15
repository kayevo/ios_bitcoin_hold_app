import Foundation

class RemoveAmountViewModel: ObservableObject{
    @Published var isAmountRemoved: Bool?
    @Published var dontRemovedMessage: String?
    let portfolioService: PortfolioService
    
    init(portfolioService: PortfolioService) {
        self.portfolioService = portfolioService
    }
    
    func removeAmount(userId: String, amount: Int64, receivedValue: Double){
        portfolioService.removeAmount(
            userId: userId,
            amount: amount,
            receivedValue: receivedValue,
            completion: { [weak self] result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self?.isAmountRemoved = true
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.dontRemovedMessage = "Server error, try again in one hour"
                    }
                }
            }
        )
    }
}
