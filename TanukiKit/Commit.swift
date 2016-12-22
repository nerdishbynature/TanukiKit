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

@objc open class CommitComment: NSObject {
    open var note: String?
    open var author: User?

    public init(_ json: [String: Any]) {
        note = json["note"] as? String
        author = User(json["author"] as? [String: AnyObject] ?? [:])
    }
}

@objc open class CommitStatus: NSObject {
    open var status: String?
    open var createdAt: Date?
    open var startedAt: Date?
    open var name: String?
    open var allowFailure: Bool?
    open var author: User?
    open var statusDescription: String?
    open var sha: String?
    open var targetURL: URL?
    open var finishedAt: Date?
    open var id: Int?
    open var ref: String?

    public init(_ json: [String: Any]) {
        status = json["status"] as? String
        createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
        startedAt = Time.rfc3339Date(string: json["started_at"] as? String)
        name = json["name"] as? String
        allowFailure = json["allow_failure"] as? Bool
        author = User(json["author"] as? [String: AnyObject] ?? [:])
        statusDescription = json["description"] as? String
        sha = json["sha"] as? String
        if let urlString = json["target_url"] as? String, let urlFromString = URL(string: urlString) {
            targetURL = urlFromString
        }
        finishedAt = Time.rfc3339Date(string: json["finished_at"] as? String)
        id = json["id"] as? Int
        ref = json["ref"] as? String
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
                    let commitDiffs = json.map{ CommitDiff($0) }
                    completion(Response.success(commitDiffs))
                }
            }
        }
    }

    /**
     Get the comments of a commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func commitComments(_ session: RequestKitURLSession = URLSession.shared, id: String, sha: String, completion: @escaping (_ response: Response<[CommitComment]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = CommitRouter.readCommitComments(self.configuration, id: id, sha: sha)
        return router.loadJSON(session, expectedResultType: [[String: Any]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let commitComments = json.map{ CommitComment($0) }
                    completion(Response.success(commitComments))
                }
            }
        }
    }

    /**
     Get the statuses of a commit in a project.
     - parameter id: The ID of a project or namespace/project name owned by the authenticated user.
     - parameter sha: The commit hash or name of a repository branch or tag.
     - parameter ref: The name of a repository branch or tag or, if not given, the default branch.
     - parameter stage: Filter by build stage, e.g. `test`.
     - parameter name: Filter by job name, e.g. `bundler:audit`.
     - parameter all: Return all statuses, not only the latest ones. (Boolean value)
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func commitStatuses(_ session: RequestKitURLSession = URLSession.shared, id: String, sha: String, ref: String = "", stage: String = "", name: String = "", all: Bool = false, completion: @escaping (_ response: Response<[CommitStatus]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = CommitRouter.readCommitStatuses(self.configuration, id: id, sha: sha, ref: ref, stage: stage, name: name, all: all)
        return router.loadJSON(session, expectedResultType: [[String: Any]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let commitStatuses = json.map{ CommitStatus($0) }
                    completion(Response.success(commitStatuses))
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
    case readCommitComments(Configuration, id: String, sha: String)
    case readCommitStatuses(Configuration, id: String, sha: String, ref: String, stage: String, name: String, all: Bool)

    var configuration: Configuration {
        switch self {
            case .readCommits(let config, _, _, _, _): return config
            case .readCommit(let config, _, _): return config
            case .readCommitDiffs(let config, _, _): return config
            case .readCommitComments(let config, _, _): return config
            case .readCommitStatuses(let config, _, _, _, _, _, _): return config
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
            case .readCommitComments(_, _, _):
                return [:]
            case .readCommitStatuses(_, _, _, let ref, let stage, let name, let all):
                return ["ref": ref, "stage": stage, "name": name, "all": String(all)]
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
        case .readCommitComments(_, let id, let sha):
            return "project/\(id)/repository/commits/\(sha)/comments"
        case .readCommitStatuses(_, _, _, _, _, let id, let sha):
            return "project/\(id)/repository/commits/\(sha)/statuses"
        }
    }
}
