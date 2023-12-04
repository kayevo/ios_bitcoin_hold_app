import Foundation
import Combine

class LoginServiceImpl : LoginService, ObservableObject{
    private var cancellables: Set<AnyCancellable> = []
    let secretDictionary = NSDictionary(
        contentsOfFile: Bundle.main.path(forResource: "Secret", ofType: "plist") ?? ""
    )
    
    func signIn(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void){
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "user/auth"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(LoginError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "email", value: credential.email),
            URLQueryItem(name: "password", value: credential.password)
        ]
        
        guard let urlWithParameters = components?.url else {
            completion(.failure(LoginError.invalidURL))
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
                    
                    if(httpResponse.statusCode == 200){
                        completion(.success(true))
                    }else if(httpResponse.statusCode == 404){
                        completion(.success(false))
                    }else{
                        completion(.failure(LoginError.serverError))
                    }
                    return data
                }
                .decode(type: User.self, decoder: JSONDecoder())
                .sink { completion in // Handle completion if needed
                } receiveValue: { user in
                    if(user.id.isEmpty){
                        completion(.failure(LoginError.serverError))
                    }
                }
                .store(in: &cancellables)
        }catch{
            completion(.failure(LoginError.serverError))
        }
    }
    
    func signUp(credential: UserCredential, completion: @escaping (Result<Bool, Error>) -> Void){
        let urlString: String = ((secretDictionary?["API_BASE_URL"] as? String) ?? "") + "user"
        let apiKey: String = (secretDictionary?["API_KEY"] as? String) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(LoginError.invalidURL))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "email", value: credential.email),
            URLQueryItem(name: "password", value: credential.password)
        ]
        
        guard let urlWithParameters = components?.url else {
            completion(.failure(LoginError.invalidURL))
            return
        }
        
        var request = URLRequest(url: urlWithParameters)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "api_key") // Insert the value into the header
        
        do{
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { element in
                    print("Data: ", element.data)
                    print("Response: ", element.response)
                    guard let httpResponse = element.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    if(httpResponse.statusCode == 201){
                        completion(.success(true))
                    }else if(httpResponse.statusCode == 409){
                        completion(.success(false))
                    }else{
                        completion(.failure(LoginError.serverError))
                    }
                }
                .sink { completion in
                    //completion.self
                    // Optional: Handle completion if needed
                } receiveValue: { value in
                    // Optional: Handle received value if needed
                }
                .store(in: &cancellables)
        }catch{
            completion(.failure(LoginError.serverError))
        }
    }
}

enum LoginError: Error{
    case invalidURL
    case invalidResponse
    case serverError
}
