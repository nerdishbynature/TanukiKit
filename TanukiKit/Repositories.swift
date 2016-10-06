import Foundation
import RequestKit

@objc public class Repository: NSObject {
    public let id: Int
    public let owner: User
    public var name: String?
    public var fullName: String?
    public var isPrivate: Bool
    public var repositoryDescription: String?
    public var sshURL: String?
    public var cloneURL: String?

    public init(_ json: [String: AnyObject]) {
        owner = User(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            fullName = json["path_with_namespace"] as? String
            isPrivate = json["visibility_level"] as? Int == 0
            repositoryDescription = json["description"] as? String
            sshURL = json["ssh_url_to_repo"] as? String
            cloneURL = json["http_url_to_repo"] as? String
        } else {
            id = -1
            isPrivate = false
        }
    }
}

public extension TanukiKit {
    /**
     Fetches the Repositories for the current user
     - parameter owner: The user or organization that owns the repositories. If `nil`, fetches repositories for the authenticated user.
     - parameter page: Current page for repository pagination. `1` by default.
     - parameter perPage: Number of repositories per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func repositories(session: RequestKitURLSession = NSURLSession.sharedSession(), page: String = "1", perPage: String = "100", completion: (response: Response<[Repository]>) -> Void) {
        let router = RepositoryRouter.ReadAuthenticatedRepositories(configuration, page, perPage)
        router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                let repos = json.map { Repository($0) }
                completion(response: Response.Success(repos))
            }
        }
    }
}

// MARK: Router

enum RepositoryRouter: Router {
    case ReadAuthenticatedRepositories(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedRepositories(let config, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var params: [String: AnyObject] {
        switch self {
        case .ReadAuthenticatedRepositories(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        }
    }

    var path: String {
        switch self {
        case .ReadAuthenticatedRepositories:
            return "projects"
        }
    }
}
