import Foundation
import RequestKit

// MARK: model
@objc open class User: NSObject, Codable {
    open var username: String?
    open var state: String?
    open var avatarURL: URL?
    open var webURL: URL?
    open var createdAt: Date?
    open var bio: String?
    open var name: String?
    open var location: String?
    open var skype: String?
    open var linkedin: String?
    open var twitter: String?
    open var websiteURL: String?
    open var lastSignInAt: Date?
    open var confirmedAt: Date?
    open var email: String?
    open var themeId: Int?
    open var colorSchemeId: Int?
    open var projectsLimit: Int?
    open var currentSignInAt: Date?
    open var canCreateGroup: Bool?
    open var canCreateProject: Bool?
    open var twoFactorEnabled: Bool?
    open var external: Bool?

    enum CodingKeys: String, CodingKey {
        case username
        case state
        case avatarURL = "avatar_url"
        case webURL = "web_url"
        case createdAt = "created_at"
        case bio
        case name
        case location
        case skype
        case linkedin
        case twitter
        case websiteURL = "website_url"
        case lastSignInAt = "last_sign_in_at"
        case confirmedAt = "confirmed_at"
        case email = "email"
        case themeId = "theme_id"
        case colorSchemeId = "color_scheme_id"
        case projectsLimit = "projects_limit"
        case currentSignInAt = "current_sign_in_at"
        case canCreateGroup = "can_create_group"
        case canCreateProject = "can_create_project"
        case twoFactorEnabled = "two_factor_enabled"
        case external
    }
}

// MARK: request

public extension TanukiKit {

    /**
     Fetches the currently logged in user
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func me(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = UserRouter.readAuthenticatedUser(self.configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: User.self) { user, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let user = user {
                    completion(Response.success(user))
                }
            }
        }
    }
}

// MARK: Router

enum UserRouter: Router {
    case readAuthenticatedUser(Configuration)

    var configuration: Configuration {
        switch self {
        case .readAuthenticatedUser(let config): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var path: String {
        switch self {
        case .readAuthenticatedUser:
            return "user"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
