import Foundation
import RequestKit

@objc open class Project: NSObject {
    open let id: Int
    open let owner: User
    open var name: String?
    open var nameWithNamespace: String?
    open var isPublic: Bool?
    open var projectDescription: String?
    open var sshURL: URL?
    open var cloneURL: URL?
    open var webURL: URL?
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
    open var namespace: Namespace?
    open var avatarURL: URL?
    open var starCount: Int?
    open var forksCount: Int?
    open var openIssuesCount: Int?
    open var runnersToken: String?
    open var publicBuilds: Bool?
    open var createdAt: Date?
    open var lastActivityAt: Date?
    open var lfsEnabled: Bool?
    open var visibilityLevel: Int?
    open var onlyAllowMergeIfBuildSucceeds: Bool?
    open var requestAccessEnabled: Bool?
    open var permissions: Permissions?

    public init(_ json: [String: AnyObject]) {
        owner = User(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            nameWithNamespace = json["name_with_namespace"] as? String
            isPublic = json["public"] as? Bool
            projectDescription = json["description"] as? String
            if let urlString = json["ssh_url_to_repo"] as? String, let url = URL(string: urlString) { sshURL = url }
            if let urlString = json["http_url_to_repo"] as? String, let url = URL(string: urlString) { cloneURL = url }
            if let urlString = json["web_url"] as? String, let url = URL(string: urlString) { webURL = url }
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
            if let urlString = json["avatar_url"] as? String, let url = URL(string: urlString) { avatarURL = url }
            starCount = json["star_count"] as? Int
            forksCount = json["forks_count"] as? Int
            openIssuesCount = json["open_issues_count"] as? Int
            visibilityLevel = json["visibility_level"] as? Int
            createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
            lastActivityAt = Time.rfc3339Date(string: json["last_activity_at"] as? String)
            lfsEnabled = json["lfs_enabled"] as? Bool
            runnersToken = json["runners_token"] as? String
            onlyAllowMergeIfBuildSucceeds = json["only_allow_merge_if_build_succeeds"] as? Bool
            requestAccessEnabled = json["request_access_enabled"] as? Bool
            permissions = Permissions(json["permissions"] as? [String: AnyObject] ?? [:])
        } else {
            id = -1
            isPublic = false
        }
    }
}

// MARK: Helper Classes

@objc open class Namespace: NSObject {
    open var id: Int?
    open var name: String?
    open var path: String?
    open var ownerID: Int?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var namespaceDescription: String?
    open var avatar: AvatarURL?
    open var shareWithGroupLock: Bool?
    open var visibilityLevel: Int?
    open var requestAccessEnabled: Bool?
    open var deletedAt: Date?
    open var lfsEnabled: Bool?

    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            path = json["path"] as? String
            ownerID = json["owner_id"] as? Int
            createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
            updatedAt = Time.rfc3339Date(string: json["updated_at"] as? String)
            namespaceDescription = json["description"] as? String
            avatar = AvatarURL(json["avatar"] as? [String: AnyObject] ?? [:])
            shareWithGroupLock = json["share_with_group_lock"] as? Bool
            visibilityLevel = json["visibility_level"] as? Int
            requestAccessEnabled = json["request_access_enabled"] as? Bool
            deletedAt = Time.rfc3339Date(string: json["deleted_at"] as? String)
            lfsEnabled = json["lfs_enabled"] as? Bool
        }
    }
}

@objc open class AvatarURL: NSObject {
    open var url: URL?

    public init(_ json: [String: AnyObject]) {
        if let urlString = json["url"] as? String, let urlFromString = URL(string: urlString) { url = urlFromString }
    }
}

@objc open class Permissions: NSObject {
    open var projectAccess: ProjectAccess?
    open var groupAccess: GroupAccess?

    public init(_ json: [String: AnyObject]) {
        projectAccess = ProjectAccess(json["project_access"] as? [String: AnyObject] ?? [:])
        groupAccess = GroupAccess(json["group_access"] as? [String: AnyObject] ?? [:])
    }
}

@objc open class ProjectAccess: NSObject {
    open var accessLevel: Int?
    open var notificationLevel: Int?

    public init(_ json: [String: AnyObject]) {
        accessLevel = json["access_level"] as? Int
        notificationLevel = json["notification_level"] as? Int
    }
}

@objc open class GroupAccess: NSObject {
    open var accessLevel: Int?
    open var notificationLevel: Int?

    public init(_ json: [String: AnyObject]) {
        accessLevel = json["access_level"] as? Int
        notificationLevel = json["notification_level"] as? Int
    }
}

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
