struct UserSearch: Decodable, Equatable, Sendable {
    var results: [User]
}

struct User: Decodable, Equatable, Sendable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let picture: Picture
    
    struct Name: Codable, Equatable {
        let title: String
        let first: String
        let last: String
    }

    struct Location: Codable, Equatable {
        let street: Street
        let city: String
        let state: String
        let country: String
    }

    struct Street: Codable, Equatable {
        let number: Int
        let name: String
    }

    struct Picture: Codable, Equatable {
        let thumbnail: String
    }
}
