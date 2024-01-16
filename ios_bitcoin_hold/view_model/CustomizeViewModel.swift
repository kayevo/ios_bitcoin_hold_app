import Foundation

class CustomizeAmountViewModel: ObservableObject{
    @Published var isAmountCustomized: Bool?
    @Published var dontCustomizedMessage: String?
    let service: PortfolioService
    
    init(service: PortfolioService) {
        self.service = service
    }
    
    func customizeAmount(userId: String, amount: Int64, totalPaidValue: Double){
        service.setPortfolio(userId: userId, amount: amount, totalPaidValue: totalPaidValue,
                             completion: { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.isAmountCustomized = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.dontCustomizedMessage = "Server error, try again in one hour"
                }
            }
        }
        )
    }
}
