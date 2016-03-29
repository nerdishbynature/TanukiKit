import Foundation
import RequestKit

// MARK: model
@objc public class User: NSObject {
    public let id: Int
    public var login: String?
    public var bio: String?
    public var name: String?
    public var email: String?
    public var privateToken: String?

    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id
            login = json["username"] as? String
            bio = json["bio"] as? String
            name = json["name"] as? String
            email = json["email"] as? String
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

    var params: [String: String] {
        return [:]
    }
}
