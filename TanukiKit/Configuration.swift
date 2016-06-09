import Foundation
import RequestKit

let gitlabBaseURL = "https://gitlab.com/api/v3/"
let gitlabWebURL = "https://gitlab.com/"

public struct TokenConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?
    public let errorDomain = TanukiKitErrorDomain
    
    public init(_ token: String? = nil, url: String = gitlabBaseURL) {
        apiEndpoint = url
        accessToken = token
    }
}

public struct PrivateTokenConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?
    public let errorDomain = TanukiKitErrorDomain
    
    public init(_ token: String? = nil, url: String = gitlabBaseURL) {
        apiEndpoint = url
        accessToken = token
    }
    
    public var accessTokenFieldName: String {
        return "private_token"
    }
}

public struct OAuthConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?
    public let token: String
    public let secret: String
    public let redirectURI: String
    public let webEndpoint: String
    public let errorDomain = TanukiKitErrorDomain
    
    public init(_ url: String = gitlabBaseURL, webURL: String = gitlabWebURL,
                  token: String, secret: String, redirectURI: String) {
        apiEndpoint = url
        webEndpoint = webURL
        self.token = token
        self.secret = secret
        self.redirectURI = redirectURI
    }
    
    public func authenticate() -> NSURL? {
        return OAuthRouter.Authorize(self, redirectURI).URLRequest?.URL
    }
    
    public func authorize(session: RequestKitURLSession = NSURLSession.sharedSession(), code: String, completion: (config: TokenConfiguration) -> Void) {
        let request = OAuthRouter.AccessToken(self, code, redirectURI).URLRequest
        if let request = request {
            let task = session.dataTaskWithRequest(request) { data, response, err in
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        if let data = data, json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments), accessToken = json["access_token"] as? String {
                            let config = TokenConfiguration(accessToken, url: self.apiEndpoint)
                            completion(config: config)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    public func handleOpenURL(session: RequestKitURLSession = NSURLSession.sharedSession(), url: NSURL, completion: (config: TokenConfiguration) -> Void) {
        if let code = url.absoluteString.componentsSeparatedByString("=").last {
            authorize(session, code: code) { (config) in
                completion(config: config)
            }
        }
    }
}

enum OAuthRouter: Router {
    case Authorize(OAuthConfiguration, String)
    case AccessToken(OAuthConfiguration, String, String)
    
    var configuration: Configuration {
        switch self {
        case .Authorize(let config, _): return config
        case .AccessToken(let config, _, _): return config
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .Authorize:
            return .GET
        case .AccessToken:
            return .POST
        }
    }
    
    var encoding: HTTPEncoding {
        switch self {
        case .Authorize:
            return .URL
        case .AccessToken:
            return .FORM
        }
    }
    
    var path: String {
        switch self {
        case .Authorize:
            return "oauth/authorize"
        case .AccessToken:
            return "oauth/token"
        }
    }
    
    var params: [String: AnyObject] {
        switch self {
        case .Authorize(let config, let redirectURI):
            return ["client_id": config.token, "response_type": "code", "redirect_uri": redirectURI]
        case .AccessToken(let config, let code, let rediredtURI):
            return ["client_id": config.token, "client_secret": config.secret, "code": code, "grant_type": "authorization_code", "redirect_uri": rediredtURI]
        }
    }
    
    var URLRequest: NSURLRequest? {
        switch self {
        case .Authorize(let config, _):
            let url = NSURL(string: path, relativeToURL: NSURL(string: config.webEndpoint))
            let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        case .AccessToken(let config, _, _):
            let url = NSURL(string: path, relativeToURL: NSURL(string: config.webEndpoint))
            let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        }
    }
}
