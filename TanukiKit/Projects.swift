import Foundation
import RequestKit

@objc open class Project: NSObject {
    open let id: Int
    open let owner: User
    open var name: String?
    open var nameWithNamespace: String?
    open var isPublic: Bool?
    open var projectDescription: String?
    open var sshURL: String?
    open var cloneURL: String?
    open var webURL: String?
    open var path: String?
    open var pathWithNamespace: String?
    open var contaierRegisteryEnabled: Bool?
    open var defaultBranch: String?
    open var tagList: [String]?
    open var isArchived: Bool?
    open var issuesEnabled: Bool?
    open var mergeRequestsEnabled: Bool?
    open var wikiEnabled: Bool?
    open var buildsEnabled: Bool?
    open var snippetsEnabled: Bool?
    open var sharedRunnersEnabled: Bool?
    open var creatorID: Int?
    @objc open class Namespace: NSObject {
        open var id: Int?
        open var name: String?
        open var path: String?
        open var ownerID: Int?
        open var createdAt: Date?
        open var updatedAt: Date?
        open var description: String?
        open var avatar: URL?
        open var shareWithGroupLock: Bool?
        open var visibilityLevel: Int?
        open var requestAccessEnabled: Bool?
        open var deletedAt: Date?
        open var lfsEnabled: Bool?
    }
    open var avatarURL: String?
    open var starCount: Int?
    open var forksCount: Int?
    open var openIssuesCount: Int?
    open var runnersToken: String?
    open var publicBuilds: Bool?
    open var createdAt: Date?
    open var lastActivityAt: Date?
    open var lfsEnabled: Bool?
    open var visibilityLevel: Int?
    @objc open class SharedWithGroups: NSObject {
        open var groupID: Int?
        open var groupName: String?
        open var groupAccessLevel: Int?
    }
    open var onlyAllowMergeIfBuildSucceeds: Bool?
    open var requestAccessEnabled: Bool?
    @objc open class Permissions: NSObject {
        @objc open class ProjectAccess: NSObject {
            open var accessLevel: Int?
            open var notificationLevel: Int?
        }
        @objc open class GroupAccess: NSObject {
            open var accessLevel: Int?
            open var notificationLevel: Int?
        }
    }

    public init(_ json: [String: AnyObject]) {
        owner = User(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            nameWithNamespace = json["path_with_namespace"] as? String
            isPublic = json["public"] as? Bool
            projectDescription = json["description"] as? String
            sshURL = json["ssh_url_to_repo"] as? String
            cloneURL = json["http_url_to_repo"] as? String
            webURL = json["web_url"] as? String
            path = json["path"] as? String
            pathWithNamespace = json["path_with_namespace"] as? String
            contaierRegisteryEnabled = json["container_registry_enabled"] as? Bool
            defaultBranch = json["default_branch"] as? String
            tagList = json["tag_list"] as? [String]
            isArchived = json["archived"] as? Bool
            issuesEnabled = json["issues_enabled"] as? Bool
            mergeRequestsEnabled = json["merge_requests_enabled"] as? Bool
            wikiEnabled = json["wiki_enabled"] as? Bool
            buildsEnabled = json["builds_enabled"] as? Bool
            snippetsEnabled = json["snippets_enabled"] as? Bool
            sharedRunnersEnabled = json["shared_runners_enabled"] as? Bool
            publicBuilds = json["public_builds"] as? Bool
            creatorID = json["creator_id"] as? Int
            namespace = Namespace(json["namespace"] as? [String: AnyObject] ?? [:])
            avatarURL = json["avatar_url"] as? String
            starCount = json["star_count"] as? Int
            forksCount = json["forks_count"] as? Int
            openIssuesCount = json["open_issues_count"] as? Int
            visibilityLevel = json["visibility_level"] as? Int
            createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
            lastActivityAt = Time.rfc3339Date(string: json["last_activity_at"] as? String)
            lfsEnabled = json["lfs_enabled"] as? Bool
            runnersToken = json["runners_token"] as? String
            // SharedWithGroups
            onlyAllowMergeIfBuildSucceeds = json["only_allow_merge_if_build_succeeds"] as? Bool
            requestAccessEnabled = json["request_access_enabled"] as? Bool
            // Permissions
        } else {
            id = -1
            isPrivate = false
        }
    }
}

// MARK: Helper Classes

public extension TanukiKit {
    /**
     Fetches the Projects for the current user
     - parameter owner: The user or organization that owns the projects. If `nil`, fetches projects for the authenticated user.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func projects(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Project]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readAuthenticatedProjects(configuration, page, perPage)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let projects = json.map { Project($0) }
                completion(Response.success(projects))
            }
        }
    }
}

// MARK: Router

enum ProjectRouter: Router {
    case readAuthenticatedProjects(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .readAuthenticatedProjects(let config, _, _): return config
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
        case .readAuthenticatedProjects(_, let page, let perPage):
            return ["per_page": perPage as AnyObject, "page": page as AnyObject]
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedProjects:
            return "projects"
        }
    }
}
