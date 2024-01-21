import Foundation
import Combine

protocol PortfolioService{
    func getPortfolio(userId: String, completion: @escaping (Result<Portfolio, Error>) -> Void)
    func setPortfolio(userId: String, amount: Int64, totalPaidValue: Double, completion: @escaping (Result<Void, Error>) -> Void)
    func addAmount(userId: String, amount: Int64, paidValue: Double, completion: @escaping (Result<Void, Error>) -> Void)
    func removeAmount(userId: String, amount: Int64, receivedValue: Double, completion: @escaping (Result<Void, Error>) -> Void)
}
