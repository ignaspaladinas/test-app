import SwiftUI
import ComposableArchitecture


struct LoginView: View {
    let store: StoreOf<Login>
    
    var body: some View {
        
        VStack {
            Text("Login")
                .font(.title)
            emailTextField
            passwordTextField
            loginButton
        }.padding(.horizontal, 24)
    }
    
    private var loginButton: some View {
        WithViewStore(store) { viewStore in
            ActionButton(title: "Login") {
                viewStore.send(.didTapLogin)
            }
        }
    }
    
    private var emailTextField: some View {
        WithViewStore(store) { viewStore in
            TextFieldView(placeholder: "Email",
                          text: viewStore.binding(get: \.email, send: Login.Action.didChangeEmail),
                          errorText: viewStore.emailValidationError)
        }
    }
    
    private var passwordTextField: some View {
        
        WithViewStore(store) { viewStore in
            
            TextFieldView(
                placeholder: "Password",
                text: viewStore.binding(
                    get: \.password,
                    send: Login.Action.didChangePassword),
                errorText: viewStore.passwordValidationError)
        }
    }
    
    struct ActionButton: View {
        
        let title: String
        let action: () -> Void
        
        var body: some View {
            Button(title) {
                action()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    struct TextFieldView: View {
        
        private static let errorColor = Color.red
        private static let backgroundColor = Color(UIColor.systemGray6)
        
        let placeholder: String
        var text: Binding<String>
        var errorText: String?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 1) {
                TextField(placeholder, text: text)
                    .padding(.vertical)
                    .padding(.horizontal, 12)
                    .background(
                        Self.backgroundColor
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(errorText != nil ? Self.errorColor : Self.backgroundColor, lineWidth:  1)
                        
                    }
                
                if let errorText {
                    Text(errorText)
                        .foregroundColor(Self.errorColor)
                        .font(.footnote)
                }
            }
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
