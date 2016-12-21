import Foundation
import RequestKit

let gitlabBaseURL = "https://gitlab.com/api/v3/"
let gitlabWebURL = "https://gitlab.com/"

// FIXME: Remove Warnings Build Script (Piet won't like it)

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

    public func authenticate() -> URL? {
        return OAuthRouter.authorize(self, redirectURI).URLRequest?.url
    }

    public func authorize(session: RequestKitURLSession = URLSession.shared, code: String, completion: @escaping (_ config: TokenConfiguration) -> Void) {
        let request = OAuthRouter.accessToken(self, code, redirectURI).URLRequest
        if let request = request {
            let task = session.dataTask(with: request) { data, response, err in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        guard let data = data else {
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                            if let json = json, let accessToken = json["access_token"] as? String {
                                let config = TokenConfiguration(accessToken, url: self.apiEndpoint)
                                completion(config)
                            }
                        } catch {
                            return
                        }
                    }
                }
            }
            task.resume()
        }
    }

    public func handleOpenURL(_ session: RequestKitURLSession = URLSession.shared, url: URL, completion: @escaping (_ config: TokenConfiguration) -> Void) {
        if let code = url.absoluteString.components(separatedBy: "=").last {
            authorize(session: session, code: code) { (config) in
                completion(config)
            }
        }
    }
}

enum OAuthRouter: Router {
    case authorize(OAuthConfiguration, String)
    case accessToken(OAuthConfiguration, String, String)

    var configuration: Configuration {
        switch self {
        case .authorize(let config, _): return config
        case .accessToken(let config, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .GET
        case .accessToken:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .authorize:
            return .url
        case .accessToken:
            return .form
        }
    }

    var path: String {
        switch self {
        case .authorize:
            return "oauth/authorize"
        case .accessToken:
            return "oauth/token"
        }
    }

    var params: [String: Any] {
        switch self {
        case .authorize(let config, let redirectURI):
            return ["client_id": config.token as AnyObject, "response_type": "code" as AnyObject, "redirect_uri": redirectURI as AnyObject]
        case .accessToken(let config, let code, let rediredtURI):
            return ["client_id": config.token as AnyObject, "client_secret": config.secret as AnyObject, "code": code as AnyObject, "grant_type": "authorization_code" as AnyObject, "redirect_uri": rediredtURI as AnyObject]
        }
    }

    var URLRequest: Foundation.URLRequest? {
        switch self {
        case .authorize(let config, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        case .accessToken(let config, _, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        }
    }
}

