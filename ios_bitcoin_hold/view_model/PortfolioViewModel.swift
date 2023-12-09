import Foundation
import Combine

class PortfolioViewModel: ObservableObject{
    @Published var portfolioAmount: Portfolio? = nil
    @Published var analysis: Analysis? = nil
    let portfolioService: PortfolioService
    let analysisService: AnalysisService
    let userId: String
    var getPortfolioFailed: Bool = false
    var getAnalysisFailed: Bool = false
    
    init(portfolioService: PortfolioService, analysisService: AnalysisService, userId: String) {
        self.analysisService = analysisService
        self.portfolioService = portfolioService
        self.userId = userId
        getPortfolio()
        getAnalysis()
    }
    
    func getPortfolio(){
        portfolioService.getPortfolio(userId: self.userId) { [weak self] result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.getPortfolioFailed = false
                    self?.portfolioAmount = value
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.getPortfolioFailed = false
                    self?.portfolioAmount = nil
                }
            }
        }
    }
    
    func getAnalysis(){
        analysisService.getAnalysis(userId: self.userId){ [weak self] result in
            switch result {
            case .success(let analysis):
                DispatchQueue.main.async {
                    self?.getAnalysisFailed = false
                    self?.analysis = analysis
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.getAnalysisFailed = true
                    self?.analysis = nil
                }
            }
        }
    }
}
