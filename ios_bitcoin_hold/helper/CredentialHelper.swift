import Foundation

extension String {
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: self)
    }
    
    // requires at least 5 characters and one special character
    func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[@$!%*?&])[A-Za-z@$!%*?&]{5,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordPredicate.evaluate(with: self)
    }
}
