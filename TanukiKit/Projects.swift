import Foundation
import RequestKit

@objc public class apiProjectClass: NSObject {
    public let id: Int
    public let owner: apiUserClass
    public var name: String?
    public var fullName: String?
    public var isPublic: Bool?
    public var description: String?
    public var sshURL: String?
    public var cloneURL: String?
    public var webURL: String?
    public var defaultBranch: String?
    public var tagList: [String] = []
    public var isArchived: Bool?
    public var issuesEnabled: Bool?
    public var mergeRequestsEnabled: Bool?
    public var wikiEnabled: Bool?
    public var buildsEnabled: Bool?
    public var snippetsEnabled: Bool?
    public var sharedRunnersEnabled: Bool?
    public var creatorID: Int?
    public var avatarURL: String?
    public var starCount: Int?
    public var forksCount: Int?
    public var openIssuesCount: Int?
    public var runnersToken: String?
    public var publicBuilds: Bool?
    public var visibilityLevel: Int?
    
    public init(_ json: [String: AnyObject]) {
        owner = apiUserClass(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            fullName = json["path_with_namespace"] as? String
            isPublic = json["public"] as? Bool
            description = json["description"] as? String
            sshURL = json["ssh_url_to_repo"] as? String
            cloneURL = json["http_url_to_repo"] as? String
            webURL = json["web_url"] as? String
            defaultBranch = json["default_branch"] as? String
            tagList = json["tag_list"] as! [String]
            isArchived = json["archived"] as? Bool
            issuesEnabled = json["issues_enabled"] as? Bool
            mergeRequestsEnabled = json["merge_requests_enabled"] as? Bool
            wikiEnabled = json["wiki_enabled"] as? Bool
            buildsEnabled = json["builds_enabled"] as? Bool
            snippetsEnabled = json["snippets_enabled"] as? Bool
            sharedRunnersEnabled = json["shared_runners_enabled"] as? Bool
            publicBuilds = json["public_builds"] as? Bool
            creatorID = json["creator_id"] as? Int
            avatarURL = json["avatar_url"] as? String
            starCount = json["star_count"] as? Int
            forksCount = json["forks_count"] as? Int
            openIssuesCount = json["open_issues_count"] as? Int
            visibilityLevel = json["visibility_level"] as? Int
            runnersToken = json["runners_token"] as? String
        } else {
            id = -1
        }
    }
}

public extension TanukiKit {
    /**
     Fetches the Projects for the current user
     - parameter owner: The user or organization that owns the Projects. If `nil`, fetches Projects for the authenticated user.
     - parameter page: Current page for repository pagination. `1` by default.
     - parameter perPage: Number of Projects per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func projects(page: String = "1", perPage: String = "100", completion: (response: Response<[apiProjectClass]>) -> Void) {
        let router = ProjectRouter.ReadAuthenticatedProjects(configuration, page, perPage)
        router.loadJSON([[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            }
            
            if let json = json {
                let repos = json.map { apiProjectClass($0) }
                completion(response: Response.Success(repos))
            }
        }
    }
}

// MARK: Router

enum ProjectRouter: Router {
    case ReadAuthenticatedProjects(Configuration, String, String)
    
    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedProjects(let config, _, _): return config
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var encoding: HTTPEncoding {
        return .URL
    }
    
    var params: [String: String] {
        switch self {
        case .ReadAuthenticatedProjects(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        }
    }
    
    var path: String {
        switch self {
        case .ReadAuthenticatedProjects:
            return "/projects"
        }
    }
}
