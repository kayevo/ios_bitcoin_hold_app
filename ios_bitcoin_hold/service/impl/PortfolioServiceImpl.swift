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
    
    func addAmount(userId: String, amount: Int64, paidValue: Double, completion: @escaping (Result<Void, Error>) -> Void){
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "portfolio/add"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "amount", value: String(amount)),
            URLQueryItem(name: "paidValue", value: String(paidValue)),
        ]
        
        guard let urlWithParameters = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: urlWithParameters)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "api_key") 
        
        do{
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { element in
                    guard let httpResponse = element.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    if(httpResponse.statusCode == 200){
                        completion(.success(()))
                    }else{
                        completion(.failure(NetworkError.serverError))
                    }
                }
                .sink { completion in } receiveValue: { value in }
                .store(in: &cancellables)
        }catch{
            completion(.failure(NetworkError.serverError))
        }
    }
    
    func removeAmount(userId: String, amount: Int64, receivedValue: Double, completion: @escaping (Result<Void, Error>) -> Void){
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "portfolio/remove"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "amount", value: String(amount)),
            URLQueryItem(name: "receivedValue", value: String(receivedValue)),
        ]
        
        guard let urlWithParameters = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: urlWithParameters)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "api_key")
        
        do{
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { element in
                    guard let httpResponse = element.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    if(httpResponse.statusCode == 200){
                        completion(.success(()))
                    }else{
                        completion(.failure(NetworkError.serverError))
                    }
                }
                .sink { completion in } receiveValue: { value in }
                .store(in: &cancellables)
        }catch{
            completion(.failure(NetworkError.serverError))
        }
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
        request.addValue(apiKey, forHTTPHeaderField: "api_key") 
        
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
