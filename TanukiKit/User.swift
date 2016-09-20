import Foundation
import RequestKit

// MARK: model
@objc open class User: NSObject {
    open let id: Int
    open var login: String?
    open var state: String?
    open var avatarURL: URL?
    open var webURL: URL?
    open var createdAt: Date?
    open var isAdmin: Bool?
    open var bio: String?
    open var name: String?
    open var location: String?
    open var skype: String?
    open var linkedin: String?
    open var twitter: String?
    open var websiteURL: URL?
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
    open var privateToken: String?

    public init(_ json: [String: Any]) {
        if let id = json["id"] as? Int {
            name = json["name"] as? String
            login = json["username"] as? String
            self.id = id
            state = json["state"] as? String
            if let urlString = json["avatar_url"] as? String, let url = URL(string: urlString) {
                avatarURL = url
            }
            if let urlString = json["web_url"] as? String, let url = URL(string: urlString) {
                webURL = url
            }
            createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
            isAdmin = json["is_admin"] as? Bool
            bio = json["bio"] as? String
            location = json["location"] as? String
            skype = json["skype"] as? String
            linkedin = json["linkedin"] as? String
            twitter = json["twitter"] as? String
            if let urlString = json["website_url"] as? String, let url = URL(string: urlString) {
                websiteURL = url
            }
            lastSignInAt = Time.rfc3339Date(string: json["last_sign_in_at"] as? String)
            confirmedAt = Time.rfc3339Date(string: json["confirmed_at"] as? String)
            email = json["email"] as? String
            themeId = json["theme_id"] as? Int
            colorSchemeId = json["color_scheme_id"] as? Int
            projectsLimit = json["projects_limit"] as? Int
            currentSignInAt = Time.rfc3339Date(string: json["current_sign_in_at"] as? String)
            canCreateGroup = json["can_create_group"] as? Bool
            canCreateProject = json["can_create_project"] as? Bool
            twoFactorEnabled = json["two_factor_enabled"] as? Bool
            external = json["external"] as? Bool
            privateToken = json["private_token"] as? String
        } else {
            id = -1
        }
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
        return router.loadJSON(session, expectedResultType: [String: Any].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(Response.success(parsedUser))
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
