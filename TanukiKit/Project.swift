import Foundation
import RequestKit

public enum VisibilityLevel: String, Codable {
    case `private`
    case `internal`
    case `public`
}

@objc open class Project: NSObject, Codable {
    open var id: Int = 0
    open var owner: User?
    open var name: String?
    open var nameWithNamespace: String?
    open var projectDescription: String?
    open var sshURL: URL?
    open var webURL: URL?
    open var path: String?
    open var pathWithNamespace: String?
    open var containerRegisteryEnabled: Bool?
    open var defaultBranch: String?
    open var tagList: [String]?
    open var issuesEnabled: Bool?
    open var mergeRequestsEnabled: Bool?
    open var wikiEnabled: Bool?
    open var snippetsEnabled: Bool?
    open var sharedRunnersEnabled: Bool?
    open var creatorID: Int?
    open var avatarURL: URL?
    open var starCount: Int?
    open var forksCount: Int?
    open var openIssuesCount: Int?
    open var createdAt: Date?
    open var lastActivityAt: Date?
    open var lfsEnabled: Bool?
    open var visibilityLevel: VisibilityLevel?
    open var onlyAllowMergeIfBuildSucceeds: Bool?
    open var requestAccessEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case nameWithNamespace = "name_with_namespace"
        case projectDescription = "project_description"
        case sshURL = "ssh_url_to_repo"
        case webURL = "http_url_to_repo"
        case path
        case pathWithNamespace = "path_with_namespace"
        case containerRegisteryEnabled = "container_registry_enabled"
        case defaultBranch = "default_branch"
        case tagList = "tag_list"
        case issuesEnabled = "issues_enabled"
        case mergeRequestsEnabled = "merge_requests_enabled"
        case wikiEnabled = "wiki_enabled"
        case snippetsEnabled = "snippets_enabled"
        case sharedRunnersEnabled = "shared_runners_enabled"
        case creatorID = "creator_id"
        case starCount = "star_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case lastActivityAt = "last_activity_at"
        case lfsEnabled = "lfs_enabled"
        case visibilityLevel = "visibility"
        case onlyAllowMergeIfBuildSucceeds = "only_allow_merge_if_pipeline_succeeds"
        case requestAccessEnabled = "request_access_enabled"
    }
}

// MARK: Helper Classes

@objc open class AvatarURL: NSObject, Codable {
    open var url: URL?
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
     Fetches the Projects for which the authenticated user is a member.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter archived: Limit by archived status. Default is false, set to `true` to only show archived projects.
     - parameter visibility: Limit by visibility `public`, `internal` or `private`. Default is `""`
     - parameter orderBy: Return projects ordered by `id`, `name`, `path`, `created_at`, `updated_at`, or `last_activity_at` fields. Default is `created_at`.
     - parameter sort: Return projects sorted in asc or desc order. Default is `desc`.
     - parameter search: Return list of authorized projects matching the search criteria. Default is `""`
     - parameter simple: Return only the ID, URL, name, and path of each project. Default is false, set to `true` to only show simple info.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func projects(_ session: RequestKitURLSession = URLSession.shared, username: String, page: String = "1", perPage: String = "20", archived: Bool = false, visibility: Visibility = Visibility.All, orderBy: OrderBy = OrderBy.CreationDate, sort: Sort = Sort.Descending, search: String = "", simple: Bool = false, completion: @escaping (_ response: Response<[Project]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readAuthenticatedProjects(configuration: configuration, username: username, page: page, perPage: perPage)

        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Project].self) { projects, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let projects = projects {
                completion(Response.success(projects))
            }
        }
    }
}

// MARK: Router

public enum Visibility: String {
    case Public = "public"
    case Internal = "interal"
    case Private = "private"
    case All = ""
}

public enum OrderBy: String {
    case ID = "id"
    case Name = "name"
    case Path = "path"
    case CreationDate = "created_at"
    case UpdateDate = "updated_at"
    case LastActvityDate = "last_activity_at"
}

public enum Sort: String {
    case Ascending = "asc"
    case Descending = "desc"
}

enum ProjectRouter: Router {
    case readAuthenticatedProjects(configuration: Configuration, username: String, page: String, perPage: String)

    var configuration: Configuration {
        switch self {
            case .readAuthenticatedProjects(let config, _, _, _): return config
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
            case .readAuthenticatedProjects(_, _, let page, let perPage):
                return ["page": page, "per_page": perPage, "membership": "true"]
        }
    }

    var path: String {
        switch self {
            case .readAuthenticatedProjects(_, let username, _, _):
                return "users/\(username)/projects"
        }
    }
}
