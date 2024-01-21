import Foundation

class AdsServiceImpl: AdsService{
    func getAds(completion: @escaping (Result<AdsResponse, Error>) -> Void) {
        let api = Api()
        let apiResult = api.getRequest(endpoint: "ads/random", httpMethod: "GET", queryItems: nil)
        switch(apiResult){
        case .success(let request):
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { element in
                    guard let httpResponse = element.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    if(httpResponse.statusCode != 200){
                        completion(.failure(NetworkError.serverError))
                    }
                    return element.data
                }
                .decode(type: AdsResponse.self, decoder: JSONDecoder())
                .sink { completion in } receiveValue: { adsResponse in
                    completion(.success(adsResponse))
                }
        case .failure(_):
            print("b")
        }
    }
}
