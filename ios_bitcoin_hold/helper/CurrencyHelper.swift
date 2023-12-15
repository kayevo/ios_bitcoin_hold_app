import Foundation

extension Int64 {
    func parseSatoshiToBitcoin() -> String {
        let bitcoinValue = Double(self) / pow(10.0, 8.0)
        return String(format: "%.\(8)f", locale: Locale(identifier: "en_US"), bitcoinValue)
    }
}

extension Double {
    func parseSatoshiToBitcoin() -> String {
        return String(format: "%.\(8)f", locale: Locale(identifier: "en_US"), self / pow(10.0, 8.0))
    }

    func parseBitcoinToSatoshi() -> Double {
        return (self * pow(10.0, 8.0)).rounded() / pow(10.0, 8.0)
    }
}

extension String {
    func parseBitcoinToSatoshi() -> Int64 {
        return Int64((Double(self) ?? 0.0) * pow(10.0, 8.0))
    }

    func parseCurrencyToDouble() -> Double {
        return Double(self.replacingOccurrences(of: ",", with: "")) ?? 0.0
    }
    
    func validateNumber() -> Bool{
        guard !self.isEmpty else {
            return false
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        
        return (formatter.number(from: self) != nil) && !self.hasPrefix(".") && !self.hasSuffix(".")
    }
}



extension Double {
    func parseToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "USD"
        formatter.locale = Locale(identifier: "en_US")

        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString.replacingOccurrences(of: "$", with: "")
        }
        return ""
    }

    func parseToPercentage() -> String {
        let percentageSymbol = self >= 0 ? "+" : "-"
        return "\(percentageSymbol) \(abs(self).parseToCurrency()) %"
    }

    func parseToBRLCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "BRL"
        formatter.locale = Locale(identifier: "pt_BR")

        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString.replacingOccurrences(of: " ", with: "")
        }
        return ""
    }
}
