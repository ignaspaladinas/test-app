import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    
    let store: StoreOf<Search>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                usersTableView
            }
            .searchable(text: viewStore.binding(
                get: \.searchQuery,
                send: Search.Action.didChangeUserQuery
            ))
        }
    }
    
    private var usersTableView: some View {
        WithViewStore(store.scope(state: \.filteredCellData)) { viewStore in
            List {
                ForEach(viewStore.state) { cell in
                    let user = cell.user
                    UserCellView(name: user.name.first,
                                 surname: user.name.last,
                                 email: user.email,
                                 location: user.location,
                                 pictureURL: user.picture.medium)
                }
            }
            .onAppear{
                viewStore.send(.didAppear)
            }
        }
    }
    
    private var searchField: some View {
        WithViewStore(store) { viewStore in
            TextField(
                "Name, surname",
                text: viewStore
                    .binding(
                        get: \.searchQuery,
                        send: Search.Action.didChangeUserQuery
                    ))
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.vertical)
            .padding(.horizontal, 12)
            .background(
                Color(UIColor.systemGray6)
            )
        }
    }
}

struct UserCellView: View {
    
    let name: String
    let surname: String
    let email: String
    let location: User.Location
    let pictureURL: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: pictureURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .clipShape(Capsule(style: .continuous))
            VStack(alignment: .leading) {
                HStack {
                    Text(name)
                    Text(surname)
                }
                .fontWeight(.bold)
                Text(email)
                Text(addressText)
                    .font(.callout)
            }
        }
    }
    
    private var addressText: String { "\(location.street.name) \(location.street.number) \(location.city) \(location.state) \(location.country)" }
}
