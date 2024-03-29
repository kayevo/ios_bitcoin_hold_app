import Foundation
import Combine

class LoginServiceImpl : LoginService{
    private var cancellables: Set<AnyCancellable> = []
    let secretDictionary = NSDictionary(
        contentsOfFile: Bundle.main.path(forResource: "Secret", ofType: "plist") ?? ""
    )
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func signIn(credential: UserCredential, completion: @escaping (Result<User?, Error>) -> Void){
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "user/auth"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "email", value: credential.email),
            URLQueryItem(name: "password", value: credential.password)
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
                    
                    if(httpResponse.statusCode == 404){
                        completion(.success(nil))
                    }else if(httpResponse.statusCode == 500){
                        completion(.failure(NetworkError.serverError))
                    }
                    return data
                }
                .decode(type: User.self, decoder: JSONDecoder())
                .sink { completion in
                } receiveValue: { user in
                    completion(.success(user))
                }
                .store(in: &cancellables)
        }catch{
            completion(.failure(NetworkError.serverError))
        }
    }
    
    func signUp(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void){
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "user"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "email", value: credential.email),
            URLQueryItem(name: "password", value: credential.password)
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
                    
                    if(httpResponse.statusCode == 201){
                        completion(.success(true))
                    }else if(httpResponse.statusCode == 409){
                        completion(.success(false))
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
}

enum NetworkError: Error{
    case invalidURL
    case invalidResponse
    case serverError
    case serviceError
}
