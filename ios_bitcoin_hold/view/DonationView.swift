import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct DonationView: View {
    let primaryDarkBlue = UIColor(red: 0.16, green: 0.19, blue: 0.24, alpha: 1)
    let primaryLightBlue = UIColor(red: 0.2, green: 0.24, blue: 0.29, alpha: 1)
    let primaryGreen = UIColor(red: 0.1, green: 0.77, blue: 0.51, alpha: 1)
    let secretDictionary = NSDictionary(
        contentsOfFile: Bundle.main.path(forResource: "Secret", ofType: "plist") ?? ""
    )
    
    var body: some View {
        VStack{
            Spacer()
            Text("Lightning network address:")
                .foregroundColor(.white)
                .font(.title)
            Image("qr_code_bitcoin_ln_address")
            Button(
                action: {
                    let bitcoinLNAddress: String = (secretDictionary?["BITCOIN_LN_ADDRESS"] as? String) ?? ""
                    copyToClipboard(text: bitcoinLNAddress)
                },
                label: {
                    Text("Copy lightning address")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.vertical)
                        .background(Color(primaryGreen))
                        .foregroundColor(Color(primaryLightBlue))
                        .cornerRadius(10)
                }
            )
            Spacer()
            Text("Bitcoin address:")
                .foregroundColor(.white)
                .font(.title)
            Text("bc1qlk0jv6klr7grnkdxfx55f5f9zu5p6gy55azqxa")
                .foregroundColor(.white)
            Button(
                action: {
                    let bitcoinAddress: String = (secretDictionary?["BITCOIN_ADDRESS"] as? String) ?? ""
                    copyToClipboard(text: bitcoinAddress)
                },
                label: {
                    Text("Copy bitcoin address")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.vertical)
                        .background(Color(primaryGreen))
                        .foregroundColor(Color(primaryLightBlue))
                        .cornerRadius(10)
                }
            )
            Spacer()
        }.padding(.horizontal, 50)
            .padding(20)
            .background(Color(primaryDarkBlue))
    }
    private func copyToClipboard(text: String) {
        UIPasteboard.general.setValue(text,
                                      forPasteboardType: UTType.plainText.identifier)
    }
}

#Preview {
    DonationView()
}
