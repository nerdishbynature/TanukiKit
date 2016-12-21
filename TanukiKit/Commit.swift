import Foundation
import RequestKit

// MARK: model
@objc open class Commit: NSObject {
    open var id: String
    open var shortID: String?
    open var title: String?
    open var authorName: String?
    open var authorEmail: String?
    open var comitterName: String?
    open var comitterEmail: String?
    open var createdAt: Date?
    open var comitterEmail: String?
    open var createdAt: Date?
    open var message: String?
    open var comittedDate: Date?
    open var authoredDate: Date?
    open var parentIDs: [String]?
    open var stats: CommitStats?
    open var status: String?

    public init(_ json: [String: Any]) {
        if let id = json["id"] as? String {
            self.id = id
            shortID = json["short_id"] as? String
            title = json["title"] as? String
            authorName = json["author_name"] as? String
            authorEmail = json["author_email"] as? String
            comitterName = json["comitter_name"] as? String
            comitterEmail = json["comitter_email"] as? String
            createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
            message = json["message"] as? String
            comittedDate = Time.rfc3339Date(string: json["comitted_date"] as? String)
            authoredDate = Time.rfc3339Date(string: json["authored_date"] as? String)
            parentIDs = json["parent_ids"] as? [String]
            stats = CommitStats(json["stats"] as? [String: AnyObject] ?? [:])
            status = json["status"] as? String
        } else {
            id = "ERROR 404"
        }
    }
}

@objc open class CommitStats: NSObject {
    open var additions: Int?
    open var deletions: Int?
    open var total: Int?

    public init(_ json: [String: Any]) {
        additions = json["additions"] as? Int
        deletions = json["deletions"] as? Int
        total = json["total"] as? Int
    }
}

@objc open class CommitDiff: NSObject {
    open var diff: String?
    open var newPath: String?
    open var aMode: String?
    open var bMode: String?
    open var newFile: Bool?
    open var renamedFile: Bool?
    open var deletedFile: Bool?

    public init(_ json: [String: Any]) {
        diff = json["diff"] as? String
        newPath = json["new_path"] as? String
        aMode = json["a_mode"] as? String
        bMode = json["b_mode"] as? String
        newFile = json["new_file"] as? Bool
        renamedFile = json["renamed_file"] as? Bool
        deletedFile = json["deleted_file"] as? Bool
    }
}

// MARK: request

public extension TanukiKit {

    /**
     Get a list of repository commits in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter refName: The name of a repository branch or tag or if not given the default branch.
     - parameter since: Only commits after or in this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ.
     - parameter until: Only commits before or in this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func commits(_ session: RequestKitURLSession = URLSession.shared, id: String, refName: String = "", since: String = "", until: String = "", completion: @escaping (_ response: Response<[Commit]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = CommitRouter.readCommits(self.configuration, id: id, refName: refName, since: since, until: until)
        return router.loadJSON(session, expectedResultType: [[String: Any]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let commits = json.map{ Commit($0) }
                    completion(Response.success(commits))
                }
            }
        }
    }

    /**
     Get a specific commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func commit(_ session: RequestKitURLSession = URLSession.shared, id: String, sha: String, completion: @escaping (_ response: Response<Commit>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = CommitRouter.readCommit(self.configuration, id: id, sha: sha)
        return router.loadJSON(session, expectedResultType: [String: Any].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let commit = Commit(json)
                    completion(Response.success(commit))
                }
            }
        }
    }

    /**
     Get a diff of a commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func commitDiffs(_ session: RequestKitURLSession = URLSession.shared, id: String, sha: String, completion: @escaping (_ response: Response<[CommitDiff]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = CommitRouter.readCommitDiffs(self.configuration, id: id, sha: sha)
        return router.loadJSON(session, expectedResultType: [[String: Any]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let commitDiff = json.map{ CommitDiff($0) }
                    completion(Response.success(commitDiff))
                }
            }
        }
    }

}

// MARK: Router

enum CommitRouter: Router {
    case readCommits(Configuration, id: String, refName: String, since: String, until: String)
    case readCommit(Configuration, id: String, sha: String)
    case readCommitDiffs(Configuration, id: String, sha: String)

    var configuration: Configuration {
        switch self {
            case .readCommits(let config, _, _, _, _): return config
            case .readCommit(let config, _, _): return config
            case .readCommitDiffs(let config, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var params: [String: Any] {
        switch self {
            case .readCommits(_, _, let refName, let since, let until):
                return ["ref_name": refName, "since": since, "until": until]
            case .readCommit(_, _, _):
                return [:]
            case .readCommitDiffs(_, _, _):
                return [:]
        }
    }

    var path: String {
        switch self {
        case .readCommits(let id):
            return "project/\(id)/repository/commits"
        case .readCommit(_, let id, let sha):
            return "project/\(id)/repository/commits/\(sha)"
        case .readCommitDiffs(_, let id, let sha):
            return "project/\(id)/repository/commits/\(sha)/diff"
        }
    }
}
