import Foundation
import Combine

class PortfolioServiceImpl : PortfolioService{
    private var cancellables: Set<AnyCancellable> = []
    let secretDictionary = NSDictionary(
        contentsOfFile: Bundle.main.path(forResource: "Secret", ofType: "plist") ?? ""
    )
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func getPortfolio(userId: String, completion: @escaping (Result<Portfolio, Error>) -> Void) {
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "portfolio"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
        ]
        
        guard let urlWithParameters = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: urlWithParameters)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "api_key") // Insert the value into the header
        
        do{
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    if(httpResponse.statusCode != 200){
                        completion(.failure(NetworkError.serverError))
                    }
                    return data
                }
                .decode(type: Portfolio.self, decoder: JSONDecoder())
                .sink { completion in
                } receiveValue: { portfolioAmount in
                    if(portfolioAmount.bitcoinAveragePrice.isNaN){
                        completion(.failure(NetworkError.serverError))
                    }else{
                        completion(.success(portfolioAmount))
                    }
                }
                .store(in: &cancellables)
        }catch{
            completion(.failure(NetworkError.serverError))
        }
    }
}
