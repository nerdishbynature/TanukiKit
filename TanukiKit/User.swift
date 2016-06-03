import Foundation
import RequestKit

// MARK: model
@objc public class apiUserClass: NSObject {
    public var id: Int
    public var login: String?
    public var bio: String?
    public var name: String?
    public var email: String?
    public var privateToken: String?
    public var avatarURL: String?
    public var webURL: String?
    public var websiteURL: String?
    public var skype: String?
    public var linkedin: String?
    public var twitter: String?
    public var isAdmin: Bool?
    public var projectsLimit: Int?
    public var canCreateProject: Bool?
    public var canCreateGroup: Bool?
    
    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id
            login = json["username"] as? String
            bio = json["bio"] as? String
            name = json["name"] as? String
            email = json["email"] as? String
            privateToken = json["private_token"] as? String
            avatarURL = json["avatar_url"] as? String
            webURL = json["web_url"] as? String
            websiteURL = json["website_url"] as? String
            skype = json["skype"] as? String
            linkedin = json["linkedin"] as? String
            twitter = json["twitter"] as? String
            isAdmin = json["is_admin"] as? Bool
            projectsLimit = json["projects_limit"] as? Int
            canCreateProject = json["can_create_project"] as? Bool
            canCreateGroup = json["can_create_group"] as? Bool
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
    public func me(completion: (response: Response<apiUserClass>) -> Void) {
        let router = UserRouter.ReadAuthenticatedUser(self.configuration)
        router.loadJSON([String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUser = apiUserClass(json)
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
    
    var params: [String: String] {
        return [:]
    }
}
