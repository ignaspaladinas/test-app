import ComposableArchitecture

struct Search: ReducerProtocol {
    struct State: Equatable {
        var searchQuery = ""
        var cellData: [UserCellData] = []
        var pendingUsersCount = 3
        
        var filteredCellData: [UserCellData] {
            guard !searchQuery.isEmpty else { return cellData }
           
            let queryItems: [String] = searchQuery.lowercased().components(separatedBy: " ").filter { $0 != "" }
            print(queryItems)
            return cellData.filter { item in
                queryItems.allSatisfy { queryItem in
                    item.user.name.first.lowercased().contains(queryItem) ||                     item.user.name.last.lowercased().contains(queryItem)

                }
            }
                
            
            
        }

    }
    
    enum Action: Equatable {
        case didAppear
        case didReceiveUserSearchResponse(TaskResult<UserSearch>)
        case didChangeUserQuery(String)
    }
    
    @Dependency(\.userClient) var userClient
    private enum SearchUserID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .didAppear:
            return .task {
                await .didReceiveUserSearchResponse((TaskResult { try await self.userClient.users() }))
            }
            .cancellable(id: SearchUserID.self)
        case .didReceiveUserSearchResponse(.failure(let error)):
            // do something with error
            ()
        case .didReceiveUserSearchResponse(.success(let response)):
            print(response)
            state.cellData.append(.init(user: response.results.first!, id: "user\(state.pendingUsersCount)"))
            state.pendingUsersCount -= 1
            if state.pendingUsersCount > 0 {
                return .task {
                    await .didReceiveUserSearchResponse((TaskResult { try await self.userClient.users() }))
                }
            }
          //  state.results = response.results
        case .didChangeUserQuery(let query):
            state.searchQuery = query

        }
        return .none
    }
}
struct UserCellData: Equatable, Identifiable {
    let user: User
    let id: String
}
