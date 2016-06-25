import Foundation
import RequestKit

@objc public class Commit: NSObject {
    public let id: String
    public var shortId: String?
    public var title: String?
    public var authorName: String?
    public var authorEmail: String?
    public var createdAt: String?
    public var message: String?
    
    public init(_ json: [String : AnyObject]) {
        if let id = json["id"] as? String {
            self.id = id
            shortId = json["short_id"] as? String
            title = json["title"] as? String
            authorName = json["author_name"] as? String
            authorEmail = json["author_email"] as? String
            createdAt = json["created_at"] as? String
            message = json["message"] as? String
        } else {
            id = "ERROR"
        }
    }
}

public extension TanukiKit {
    
    /**
     Fetches the Commits for the specified Project.
     - parameter Project: The Project to get the Commits from.
     - parameter completion: Callback for the outcome of the fetch.
     */
    
    public func commits(session: RequestKitURLSession = NSURLSession.sharedSession(), project: String, completion: (response: Response<Commit>) -> Void) {
        let router = CommitRouter.ReadProjectCommits(self.configuration, project)
        router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let commits = Commit(json)
                    completion(response: Response.Success(commits))
                }
            }
        }
    }

}

// MARK: Router

enum CommitRouter: Router {
    case ReadProjectCommits(Configuration, String)
    
    var configuration: Configuration {
        switch self {
        case .ReadProjectCommits(let config, _): return config
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var encoding: HTTPEncoding {
        return .URL
    }
    
    var params: [String: AnyObject] {
        return [:]
    }
    
    var path: String {
        switch self {
        case .ReadProjectCommits(_, let project):
            return "projects/\(project)/repository/commits"
        }
    }
}
