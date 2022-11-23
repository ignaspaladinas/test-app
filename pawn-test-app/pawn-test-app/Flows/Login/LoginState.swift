import ComposableArchitecture
import Foundation

struct Login: ReducerProtocol {
    
    
    // MARK: - State
    struct State: Equatable {
      
        var email: String = ""
        var password: String = ""
        
        var emailValidationError: String?
        var passwordValidationError: String?
        var textFieldsValidated = false
        
        var isReadyToLogin: Bool { textFieldsValidated && emailValidationError == nil && passwordValidationError == nil }
    }
    
    // MARK: - Action
    enum Action {
        case didChangeEmail(String)
        case didChangePassword(String)
        case didTapLogin
        case didProduceOutput
    }
    
    // MARK: - Reducer
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didChangeEmail(let email):
            state.email = email
        case .didChangePassword(let password):
            state.password = password
        case .didTapLogin:
            state.validateTextFields()
            
        case .didProduceOutput:
            state.textFieldsValidated = false
        }
        return .none
    }
}

extension Login.State {
    
    // MARK: - Validation
    
    private func isEmailValid(email: String) -> Bool {
        let emailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        
        return emailValidationPredicate.evaluate(with: email)
    }
    
    private mutating func validateEmail() {
        if isEmailValid(email: email) {
            emailValidationError = nil
        } else {
            emailValidationError = "Invalid email format"
        }
    }
    
    private mutating func validatePassword() {
        if password.count < 6 {
            passwordValidationError = "Password must be at least 6 characters"
        } else {
            passwordValidationError = nil
        }
    }
    
    mutating func validateTextFields() {
        validateEmail()
        validatePassword()
        textFieldsValidated = true
    }
}
