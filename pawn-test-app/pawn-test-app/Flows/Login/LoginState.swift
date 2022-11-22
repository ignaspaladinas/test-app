import ComposableArchitecture
import Foundation

struct Login: ReducerProtocol {
    
    
    // MARK: - State
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        
        var emailValidationError: String?
        var passwordValidationError: String?
        
        var isReadyToLogin: Bool { emailValidationError == nil && passwordValidationError == nil }
    }
    
    // MARK: - Action
    enum Action {
        case didChangeEmail(String)
        case didChangePassword(String)
        case didTapLogin
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
            if state.isReadyToLogin {
                // Open other screen
            }
        }
        return .none
    }
}

extension Login.State {
    
    // MARK: - Validation
    private mutating func validateEmail() {
        let emailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", email)
        
        if !emailValidationPredicate.evaluate(with: emailValidationRegex) {
            emailValidationError = "Invalid email format"
        } else {
            emailValidationError = nil
        }
    }
    
    private mutating func validatePassword() {
        if password.count < 6 {
            passwordValidationError = "Password must be at leat 6 characters"
        } else {
            passwordValidationError = nil
        }
    }
    
    mutating func validateTextFields() {
        validateEmail()
        validatePassword()
    }
}
