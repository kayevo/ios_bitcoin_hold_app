import Foundation
import Combine

protocol AnalysisService{
    func getAnalysis(userId: String, completion: @escaping (Result<Analysis, Error>) -> Void)
}
