import Foundation

protocol AdsService{
    func getAds(completion: @escaping (Result<AdsResponse, Error>) -> Void)
}
