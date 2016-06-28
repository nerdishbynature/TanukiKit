import Foundation
import RequestKit

// MARK: model
@objc public class User: NSObject {
    public var name: String?
    public var login: String?
    public let id: Int
    public var state: String?
    public var avatarURL: NSURL?
    public var webURL: NSURL?
    public var createdAt: NSDate?
    public var isAdmin: Bool?
    public var bio: String?
    public var location: String?
    public var skype: String?
    public var linkedin: String?
    public var twitter: String?
    public var websiteURL: NSURL?
    public var lastSignInAt: NSDate?
    public var confirmedAt: NSDate?
    public var email: String?
    public var themeId: Int?
    public var colorSchemeId: Int?
    public var projectsLimit: Int?
    public var currentSignInAt: NSDate?
    public var canCreateGroup: Bool?
    public var canCreateProject: Bool?
    public var twoFactorEnabled: Bool?
    public var external: Bool?
    public var privateToken: String?

    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            name = json["name"] as? String
            login = json["username"] as? String
            self.id = id
            state = json["state"] as? String
            if let urlString = json["avatar_url"] as? String, url = NSURL(string: urlString) {
                avatarURL = url
            }
            if let urlString = json["web_url"] as? String, url = NSURL(string: urlString) {
                webURL = url
            }
            createdAt = Time.rfc3339Date(json["created_at"] as? String)
            isAdmin = json["is_admin"] as? Bool
            bio = json["bio"] as? String
            location = json["location"] as? String
            skype = json["skype"] as? String
            linkedin = json["linkedin"] as? String
            twitter = json["twitter"] as? String
            if let urlString = json["website_url"] as? String, url = NSURL(string: urlString) {
                websiteURL = url
            }
            lastSignInAt = Time.rfc3339Date(json["last_sign_in_at"] as? String)
            confirmedAt = Time.rfc3339Date(json["confirmed_at"] as? String)
            email = json["email"] as? String
            themeId = json["theme_id"] as? Int
            colorSchemeId = json["color_scheme_id"] as? Int
            projectsLimit = json["projects_limit"] as? Int
            currentSignInAt = Time.rfc3339Date(json["current_sign_in_at"] as? String)
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
    public func me(session: RequestKitURLSession = NSURLSession.sharedSession(), completion: (response: Response<User>) -> Void) {
        let router = UserRouter.ReadAuthenticatedUser(self.configuration)
        router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(response: Response.Success(parsedUser))
                }
            }
        }
    }
}

// MARK: Router

enum UserRouter: Router {
    case ReadAuthenticatedUser(Configuration)

    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedUser(let config): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var path: String {
        switch self {
        case .ReadAuthenticatedUser:
            return "user"
        }
    }

    var params: [String: AnyObject] {
        return [:]
    }
}
