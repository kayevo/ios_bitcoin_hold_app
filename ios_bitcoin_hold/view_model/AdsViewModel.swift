import Foundation

class AdsViewModel: ObservableObject{
    @Published var adsResponse: AdsResponse?
    @Published var adsFails: Bool = false
    let service: AdsService
    
    
    init(service: AdsService){
        self.service = service
        self.getAds()
    }
    
    func getAds(){
        service.getAds(completion: {[weak self] result in
            switch(result){
            case .success(let adsResponse):
                self?.adsResponse = adsResponse
            case .failure:
                self?.adsFails = true
            }
        })
    }
}
