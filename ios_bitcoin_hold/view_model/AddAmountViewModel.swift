import Foundation

class AddAmountViewModel: ObservableObject{
    @Published var isAmountAdded: Bool?
    @Published var dontAddedMessage: String?
    let service: PortfolioService
    
    init(service: PortfolioService) {
        self.service = service
    }
    
    func addAmount(userId: String, amount: Int64, paidValue: Double){
        service.addAmount(userId: userId, amount: amount, paidValue: paidValue,
                             completion: { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.isAmountAdded = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.dontAddedMessage = "Server error, try again in one hour"
                }
            }
        }
        )
    }
}
