import ComposableArchitecture

struct Search: ReducerProtocol {
    
    // MARK: - State
    struct State: Equatable {
        
        var searchQuery = ""
        var cellData: [UserCellData] = []
        var pendingUsersCount = 3
        
        var filteredCellData: [UserCellData] {
            guard !searchQuery.isEmpty else { return cellData }
           
            let queryItems: [String] = searchQuery.lowercased().components(separatedBy: " ").filter { $0 != "" }
          
            return cellData.filter { item in
                queryItems.allSatisfy { queryItem in
                    item.user.name.first.lowercased().contains(queryItem) ||
                    item.user.name.last.lowercased().contains(queryItem)
                }
            }
        }
    }
    
    //MARK: - Action
    enum Action: Equatable {
        case didAppear
        case didReceiveUserSearchResponse(TaskResult<UserSearch>)
        case didChangeUserQuery(String)
    }
    
    // MARK: - Dependecies
    @Dependency(\.userClient) var userClient
    private enum FetchUserID {}
    
    
    // MARK: - Reducer
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .didAppear:
            return .task {
                await .didReceiveUserSearchResponse((TaskResult { try await self.userClient.users() }))
            }
            .cancellable(id: FetchUserID.self)
        case .didReceiveUserSearchResponse(.failure(let error)):
            print("Failed to fetch with error: \(error)")
        case .didReceiveUserSearchResponse(.success(let response)):
            
            guard let user = response.results.first else { break }
            state.cellData.append(.init(user: user, id: "user: \(state.pendingUsersCount)"))
            state.pendingUsersCount -= 1
            
            if state.pendingUsersCount > 0 {
                return .task {
                    await .didReceiveUserSearchResponse((TaskResult { try await self.userClient.users() }))
                }
            }
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
