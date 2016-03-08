import Foundation
import RequestKit

// MARK: model
@objc public class MergeRequest: NSObject {
    public var id: Int
    public var title: String? = nil
    public var mergeRequestDescription: String?
    public var author: User? = nil
    public var mergeStatus: String?
    public var projectID: Int?
    public var sourceBranch: String?
    public var sourceProjectID: Int?
    public var targetBranch: String?
    public var targetProjectID: Int?
    public var workInProgress: Bool?
    
    public init(_ json: [String: AnyObject]) {
        if let authorJSON = json["author"] as? [String: AnyObject] {
            self.author = User(authorJSON)
        }
        if let id = json["id"] as? Int {
            self.id = id
            self.title = json["title"] as? String
            self.mergeRequestDescription = json["description"] as? String
            self.mergeStatus = json["merge_status"] as? String
            self.projectID = json["project_id"] as? Int
            self.sourceBranch = json["source_branch"] as? String
            self.sourceProjectID = json["source_project_id"] as? Int
            self.targetBranch = json["target_branch"] as? String
            self.workInProgress = json["work_in_progress"] as? Bool
            self.targetProjectID = json["target_project_id"] as? Int
        } else {
            self.id = -1
        }
    }
}

extension MergeRequest {
    
}

// MARK: request

public extension TanukiKit {
    /**
     Fetches the open merg requests for the owner/repo combination
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func mergeRequests(repoID: String, page: String = "1", perPage: String = "100", completion: (response:Response<[MergeRequest]>) -> Void) {
        let router = MergeRequestsRouter.ReadMergeRequests(configuration, repoID, page, perPage)
        router.loadJSON([[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let mergeRequests = json.map { MergeRequest($0) }
                    completion(response: Response.Success(mergeRequests))
                }
            }
        }
    }
}

// MARK: Router

enum MergeRequestsRouter: Router {
    case ReadMergeRequests(Configuration, String, String, String)
    
    var configuration: Configuration {
        switch self {
        case .ReadMergeRequests(let config, _, _, _): return config
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
        case .ReadMergeRequests(_, _, let page, let perPage):
            return ["per_page": perPage, "page": page]
        }
    }
    
    var path: String {
        switch self {
        case .ReadMergeRequests(_, let repoID, _, _):
            return "/projects/\(repoID)/merge_requests"
        }
    }
}
