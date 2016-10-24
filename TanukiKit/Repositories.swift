import Foundation
import RequestKit

@objc open class Repository: NSObject {
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
            if let urlString = json["ssh_url_to_repo"] as? String, let url = URL(string: urlString) {
                sshURL = url
            }
            if let urlString = json["http_url_to_repo"] as? String, let url = URL(string: urlString) {
                cloneURL = url
            }
            if let urlString = json["web_url"] as? String, let url = URL(string: urlString) {
                webURL = url
            }
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
            if let urlString = json["avatar_url"] as? String, let url = URL(string: urlString) {
                avatarURL = url
            }
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

// TODO: Uncomment when project conversion is done.

//@objc open class Event: NSObject {
//    open var title: String?
//    open var projectID: Int?
//    open var actionName: String?
//    open var targetID: Int?
//    open var targetType: String?
//    open var authorID: Int?
//    open var data: EventData?
//    open var targetTitle: String?
//    open var author: User?
//    open var authorUsername: String?
//    open var createdAt: Date?
//    open var note: Note?
//
//    public init(_ json: [String: AnyObject]) {
//        title = json["title"] as? String
//        projectID = json["project_id"] as? Int
//        actionName = json["action_name"] as? String
//        targetID = json["target_id"] as? Int
//        targetType = json["target_title"] as? String
//        authorID = json["author_id"] as? Int
//        data = EventData(json["data"] as? [String: AnyObject] ?? [:])
//        targetTitle = json["target_title"] as? String
//        author = User(json["author"] as? [String: AnyObject] ?? [:])
//        authorUsername = json["author_username"] as? String
//        createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
//        note = Note(json["note"] as? [String: AnyObject] ?? [:])
//    }
//}

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
        if let urlString = json["url"] as? String, let urlFromString = URL(string: urlString) {
            url = urlFromString
        }
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

//@objc open class EventData: NSObject {
//    open var before: String?
//    open var after: String?
//    open var ref: String?
//    open var userID: Int?
//    open var userName: String?
//    open var repository: Repository? // This is one of the cases where it causes conflict.
//    open var project: Repository? // TODO: Change to project
//    open var commits: [Commit]? // TODO: Implement Commit GET request.
//    open var totalCommitsCount: Int?
//
//    public init(_ json: [String: AnyObject]) {
//        before = json["before"] as? String
//        after = json["after"] as? String
//        ref = json["ref"] as? String
//        userID = json["user_id"] as? Int
//        userName = json["user_name"] as? String
//        repository = Repository1(json["repository"] as? [String: AnyObject] ?? [:]) // TODO: Change to repository
//        project = Repository(json["project"] as? [String: AnyObject] ?? [:]) // TODO: Change to project
//        totalCommitsCount = json["total_commits_count"] as? Int
//    }
//}

//@objc open class Note: NSObject {
//    open var id: Int?
//    open var body: String?
//    open var attachment: String?
//    open var author: User?
//    open var createdAt: Date?
//    open var system: Bool?
//    open var upvote: Bool?
//    open var downvote: Bool?
//    open var noteableID: Int?
//    open var noteableType: String?
//
//    public init(_ json: [String: AnyObject]) {
//        id = json["id"] as? Int
//        body = json["body"] as? String
//        attachment = json["attachment"] as? String
//        author = User(json["author"] as? [String: AnyObject] ?? [:])
//        createdAt = Time.rfc3339Date(string: json["created_at"] as? String)
//        system = json["system"] as? Bool
//        upvote = json["upvote"] as? Bool
//        downvote = json["downvote"] as? Bool
//        noteableID = json["noteable_id"] as? Int
//        noteableType = json["noteable_type"] as? String
//    }
//}

public extension TanukiKit {
    /**
     Fetches the Projects for which the authenticated user is a member.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter archived: Limit by archived status. Default is `""`, set to `true` to enable.
     - parameter visibility: Limit by visibility `public`, `internal` or `private`. Default is `""`
     - parameter orderBy: Return projects ordered by `id`, `name`, `path`, `created_at`, `updated_at`, or `last_activity_at` fields. Default is `created_at`.
     - parameter sort: Return projects sorted in asc or desc order. Default is `desc`.
     - parameter search: Return list of authorized projects matching the search criteria. Default is `""`
     - parameter simple: Return only the ID, URL, name, and path of each project. Default is `""`, set to `true` to enable.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: projects convertion.
    public func repositories(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "20", archived: String = "", visibility: String = "", orderBy: String = "created_at", sort: String = "desc", search: String = "", simple: String = "", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readAuthenticatedProjects(configuration: configuration, page: page, perPage: perPage, archived: archived, visibility: visibility, orderBy: orderBy, sort: sort, search: search, simple: simple)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                // TODO: Change to projects.
                let repos = json.map { Repository($0) }
                completion(Response.success(repos))
            }
        }
    }

    /**
     Fetches project for a specified ID.
     - parameter id: The ID or NAMESPACE/PROJECT_NAME of the project.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: project convertion.
    public func repository(_ session: RequestKitURLSession = URLSession.shared, id: String, completion: @escaping (_ response: Response<Repository>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readSingleProject(configuration: configuration, id: id)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let project = Repository(json)
                completion(Response.success(project))
            }
        }
    }

    /**
     Fetches the Projects which the authenticated user can see.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter archived: Limit by archived status. Default is `""`, set to `true` to enable.
     - parameter visibility: Limit by visibility `public`, `internal` or `private`. Default is `""`
     - parameter orderBy: Return projects ordered by `id`, `name`, `path`, `created_at`, `updated_at`, or `last_activity_at` fields. Default is `created_at`.
     - parameter sort: Return projects sorted in asc or desc order. Default is `desc`.
     - parameter search: Return list of authorized projects matching the search criteria. Default is `""`
     - parameter simple: Return only the ID, URL, name, and path of each project. Default is `""`, set to `true` to enable.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: visibleProjects convertion.
    public func visibleRepos(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "20", archived: String = "", visibility: String = "", orderBy: String = "created_at", sort: String = "desc", search: String = "", simple: String = "", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readVisibleProjects(configuration: configuration, page: page, perPage: perPage, archived: archived, visibility: visibility, orderBy: orderBy, sort: sort, search: search, simple: simple)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let projects = json.map { Repository($0) }
                completion(Response.success(projects))
            }
        }
    }

    /**
     Fetches the Projects which are owned by the authenticated user.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter archived: Limit by archived status. Default is `""`, set to `true` to enable.
     - parameter visibility: Limit by visibility `public`, `internal` or `private`. Default is `""`
     - parameter orderBy: Return projects ordered by `id`, `name`, `path`, `created_at`, `updated_at`, or `last_activity_at` fields. Default is `created_at`.
     - parameter sort: Return projects sorted in asc or desc order. Default is `desc`.
     - parameter search: Return list of authorized projects matching the search criteria. Default is `""`
     - parameter simple: Return only the ID, URL, name, and path of each project. Default is `""`, set to `true` to enable.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: ownedProjects convertion.
    public func ownedRepos(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "20", archived: String = "", visibility: String = "", orderBy: String = "created_at", sort: String = "desc", search: String = "", simple: String = "", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readOwnedProjects(configuration: configuration, page: page, perPage: perPage, archived: archived, visibility: visibility, orderBy: orderBy, sort: sort, search: search, simple: simple)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let projects = json.map { Repository($0) }
                completion(Response.success(projects))
            }
        }
    }

    /**
     Fetches the Projects which are starred by the authenticated user.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter archived: Limit by archived status. Default is `""`, set to `true` to enable.
     - parameter visibility: Limit by visibility `public`, `internal` or `private`. Default is `""`
     - parameter orderBy: Return projects ordered by `id`, `name`, `path`, `created_at`, `updated_at`, or `last_activity_at` fields. Default is `created_at`.
     - parameter sort: Return projects sorted in asc or desc order. Default is `desc`.
     - parameter search: Return list of authorized projects matching the search criteria. Default is `""`
     - parameter simple: Return only the ID, URL, name, and path of each project. Default is `""`, set to `true` to enable.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: starredProjects convertion.
    public func starredRepos(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "20", archived: String = "", visibility: String = "", orderBy: String = "created_at", sort: String = "desc", search: String = "", simple: String = "", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readStarredProjects(configuration: configuration, page: page, perPage: perPage, archived: archived, visibility: visibility, orderBy: orderBy, sort: sort, search: search, simple: simple)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let projects = json.map { Repository($0) }
                completion(Response.success(projects))
            }
        }
    }

    /**
     Fetches all GitLab projects in the server **(admin only)**.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter archived: Limit by archived status. Default is `""`, set to `true` to enable.
     - parameter visibility: Limit by visibility `public`, `internal` or `private`. Default is `""`
     - parameter orderBy: Return projects ordered by `id`, `name`, `path`, `created_at`, `updated_at`, or `last_activity_at` fields. Default is `created_at`.
     - parameter sort: Return projects sorted in asc or desc order. Default is `desc`.
     - parameter search: Return list of authorized projects matching the search criteria. Default is `""`
     - parameter simple: Return only the ID, URL, name, and path of each project. Default is `""`, set to `true` to enable.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: allProjects convertion.
    public func allRepos(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "20", archived: String = "", visibility: String = "", orderBy: String = "created_at", sort: String = "desc", search: String = "", simple: String = "", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ProjectRouter.readAllProjects(configuration: configuration, page: page, perPage: perPage, archived: archived, visibility: visibility, orderBy: orderBy, sort: sort, search: search, simple: simple)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let projects = json.map { Repository($0) }
                completion(Response.success(projects))
            }
        }
    }

    /**
     Fetches the events for the specified project. Sorted from newest to oldest.
     - parameter page: Current page for project pagination. `1` by default.
     - parameter perPage: Number of projects per page. `100` by default.
     - parameter id: The ID or NAMESPACE/PROJECT_NAME of the project.
     - parameter completion: Callback for the outcome of the fetch.
     */

    // TODO: Uncomment when project conversion is done.

//    public func repoEvents(_ session: RequestKitURLSession = URLSession.shared, id: String, page: String = "1", perPage: String = "20", completion: @escaping (_ response: Response<[Event]>) -> Void) -> URLSessionDataTaskProtocol? {
//        let router = ProjectRouter.readProjectEvents(configuration: configuration, id: id, page: page, perPage: perPage)
//        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
//            if let error = error {
//                completion(Response.failure(error))
//            }
//
//            if let json = json {
//                let events = json.map { Event($0) }
//                completion(Response.success(events))
//                // TODO: Define Event Class
//            }
//        }
//    }
}

// MARK: Router

enum ProjectRouter: Router {
    case readAuthenticatedProjects(configuration: Configuration, page: String, perPage: String, archived: String, visibility: String, orderBy: String, sort: String, search: String, simple: String)
    case readVisibleProjects(configuration: Configuration, page: String, perPage: String, archived: String, visibility: String, orderBy: String, sort: String, search: String, simple: String)
    case readOwnedProjects(configuration: Configuration, page: String, perPage: String, archived: String, visibility: String, orderBy: String, sort: String, search: String, simple: String)
    case readStarredProjects(configuration: Configuration, page: String, perPage: String, archived: String, visibility: String, orderBy: String, sort: String, search: String, simple: String)
    case readAllProjects(configuration: Configuration, page: String, perPage: String, archived: String, visibility: String, orderBy: String, sort: String, search: String, simple: String)
    case readSingleProject(configuration: Configuration, id: String)
//    case readProjectEvents(configuration: Configuration, id: String, page: String, perPage: String)

    var configuration: Configuration {
        switch self {
            case .readAuthenticatedProjects(let config, _, _, _, _, _, _, _, _): return config
            case .readVisibleProjects(let config, _, _, _, _, _, _, _, _): return config
            case .readOwnedProjects(let config, _, _, _, _, _, _, _, _): return config
            case .readStarredProjects(let config, _, _, _, _, _, _, _, _): return config
            case .readAllProjects(let config, _, _, _, _, _, _, _, _): return config
            case .readSingleProject(let config, _): return config
//            case .readProjectEvents(let config, _, _, _): return config
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
            case .readAuthenticatedProjects(_, let page, let perPage, let archived, let visibility, let orderBy, let sort, let search, let simple):
                return ["page": page, "per_page": perPage, "archived": archived, "visibility": visibility, "order_by": orderBy, "sort": sort, "search": search, "simple": simple]
            case .readVisibleProjects(_, let page, let perPage, let archived, let visibility, let orderBy, let sort, let search, let simple):
                return ["page": page, "per_page": perPage, "archived": archived, "visibility": visibility, "order_by": orderBy, "sort": sort, "search": search, "simple": simple]
            case .readOwnedProjects(_, let page, let perPage, let archived, let visibility, let orderBy, let sort, let search, let simple):
                return ["page": page, "per_page": perPage, "archived": archived, "visibility": visibility, "order_by": orderBy, "sort": sort, "search": search, "simple": simple]
            case .readStarredProjects(_, let page, let perPage, let archived, let visibility, let orderBy, let sort, let search, let simple):
                return ["page": page, "per_page": perPage, "archived": archived, "visibility": visibility, "order_by": orderBy, "sort": sort, "search": search, "simple": simple]
            case .readAllProjects(_, let page, let perPage, let archived, let visibility, let orderBy, let sort, let search, let simple):
                return ["page": page, "per_page": perPage, "archived": archived, "visibility": visibility, "order_by": orderBy, "sort": sort, "search": search, "simple": simple]
            case .readSingleProject:
                return [:]
//            case .readProjectEvents(_, _, let page, let perPage):
//                return ["per_page": perPage, "page": page]
        }
    }

    var path: String {
        switch self {
            case .readAuthenticatedProjects:
                return "projects"
            case .readVisibleProjects:
                return "projects/visible"
            case .readOwnedProjects:
                return "projects/owned"
            case .readStarredProjects:
                return "projects/starred"
            case .readAllProjects:
                return "projects/all"
            case .readSingleProject(_, let id):
                return "projects/\(id)"
//            case .readProjectEvents(_, let id, _, _):
//                return "projects/\(id)/events"
        }
    }
}
