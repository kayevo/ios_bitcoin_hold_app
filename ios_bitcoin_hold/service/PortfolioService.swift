import Foundation
import Combine

protocol PortfolioService{
    func getPortfolio(userId: String, completion: @escaping (Result<Portfolio, Error>) -> Void)
}
