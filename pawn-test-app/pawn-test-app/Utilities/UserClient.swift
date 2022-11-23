import Foundation
import Dependencies

/// API Client for user fetching
struct UserClient {
    var users: @Sendable () async throws -> UserSearch
}

extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}

extension UserClient: DependencyKey {
  static let liveValue = UserClient(
    users: { 
      var components = URLComponents(string: "https://randomuser.me/api")!

      let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(UserSearch.self, from: data)
    }
  )
}
