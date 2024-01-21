import Foundation

class Api{
    let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "")
    let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
    
    func getRequest(
        endpoint: String,
        httpMethod: String,
        queryItems: [URLQueryItem]?
    ) -> Result<URLRequest, Error> {
        guard var url = URL(string: urlString + endpoint) else {
            return .failure(NetworkError.invalidURL)
        }
        
        if(queryItems != nil){
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            
            components?.queryItems = queryItems
            
            guard let urlWithParameters = components?.url else {
                return .failure(NetworkError.invalidURL)
            }
            url = urlWithParameters
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(apiKey, forHTTPHeaderField: "api_key")
        
        return .success(request)
    }
}
