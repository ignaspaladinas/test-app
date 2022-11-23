import SwiftUI
import ComposableArchitecture

struct LoginView: View {
   
    let store: StoreOf<Login>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.title)
                emailTextField
                passwordTextField
                loginButton
            }.padding(.horizontal, 24)
        }
    }
    
    private var loginButton: some View {
        WithViewStore(store) { viewStore in
            VStack {
                NavigationLink("",
                               destination: SearchView(store:
                                    .init(initialState: Search.State(),
                                          reducer: Search()._printChanges())),
                               isActive: viewStore.binding(
                                get: \.isReadyToLogin,
                                send: Login.Action.didProduceOutput
                               )
                )
                ActionButton(title: "Login") {
                    viewStore.send(.didTapLogin)
                }
            }
        }
    }
    
    private var emailTextField: some View {
        WithViewStore(store) { viewStore in
            TextField(
                "Email",
                text:viewStore.binding(get: \.email,
                                       send: Login.Action.didChangeEmail)
            )
            .textFieldStyle(LoginTextFieldStyle(errorText: viewStore.emailValidationError))
        }
    }
    
    private var passwordTextField: some View {
        
        WithViewStore(store) { viewStore in
            
            SecureField(
                "Password",
                text: viewStore.binding(
                    get: \.password,
                    send: Login.Action.didChangePassword)
            )
            .textFieldStyle(LoginTextFieldStyle(errorText: viewStore.passwordValidationError))

        }
    }
    
    struct ActionButton: View {
        
        let title: String
        let action: () -> Void
        
        var body: some View {
            Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .onTapGesture {
                action()
            }
        }
    }
    
    struct TextFieldView: View {
      
        let placeholder: String
        var text: Binding<String>
        var errorText: String?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 1) {
                SecureField(placeholder, text: text)
                    .textFieldStyle(LoginTextFieldStyle(errorText: errorText))
            }
        }
    }
    
    struct LoginTextFieldStyle: TextFieldStyle {
        
        private static let errorColor = Color.red
        private static let backgroundColor = Color(UIColor.systemGray6)
       
        var errorText: String?

        func _body(configuration: TextField<Self._Label>) -> some View {
            VStack (alignment: .leading) {
                
                configuration
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.vertical)
                    .padding(.horizontal, 12)
                    .background(
                        Self.backgroundColor
                    ).overlay {
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

