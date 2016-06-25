import Foundation
import RequestKit

@objc public class Build: NSObject {
    public let id: Int
    public let user: User
    public var status: String?
    public var stage: String?
    public var ref: String?
    public var tag: Bool?
    public var coverage: Double?
    public var createdAt: String?
    public var startedAt: String?
    public var finishedAt: String?
    public var commit: Commit
    // TODO: Add runner: apiRunnerClass
    
    public init(_ json: [String : AnyObject]) {
        user = User(json["user"] as? [String: AnyObject] ?? [:])
        commit = Commit(json["commit"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            status = json["status"] as? String
            stage = json["stage"] as? String
            ref = json["ref"] as? String
            tag = json["tag"] as? Bool
            coverage = json["coverage"] as? Double
            createdAt = json["created_at"] as? String
            startedAt = json["started_at"] as? String
            finishedAt = json["finished_at"] as? String
        } else {
            id = -1
        }
    }
}

public extension TanukiKit {
    /**
     Fetches the Builds for the specified Project
     - parameter Project: The Project to get the builds from.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func builds(session: RequestKitURLSession = NSURLSession.sharedSession(), project: String, completion: (response: Response<Build>) -> Void) {
        let router = BuildRouter.ReadProjectBuilds(self.configuration, project)
        router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let builds = Build(json)
                    completion(response: Response.Success(builds))
                }
            }
        }
    }
}

// MARK: Router

enum BuildRouter: Router {
    case ReadProjectBuilds(Configuration, String)
    
    var configuration: Configuration {
        switch self {
        case .ReadProjectBuilds(let config, _): return config
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
        case .ReadProjectBuilds(_, let project):
            return "projects/\(project)/builds"
        }
    }
}
