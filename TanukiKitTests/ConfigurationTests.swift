import XCTest
import Foundation
import TanukiKit

private let enterpriseURL = "https://gitlab.example.com/api/v3"

class ConfigurationTests: XCTestCase {
    func testTokenConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, "https://gitlab.com/api/v3")
    }

    func testEnterpriseTokenConfiguration() {
        let subject = TokenConfiguration("12345", url: enterpriseURL)
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testEnterprisePrivateTokenConfiguration() {
        let subject = PrivateTokenConfiguration("12345", url: enterpriseURL)
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
        XCTAssertEqual(subject.accessTokenFieldName, "private_token")
    }

    func testOAuthConfiguration() {
        let subject = OAuthConfiguration(token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, "https://gitlab.com/api/v3")
    }

    func testOAuthTokenConfiguration() {
        let subject = OAuthConfiguration(enterpriseURL, token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testHandleOpenURL() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        let json = "{\"access_token\": \"017ec60f4a182\", \"token_type\": \"bearer\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/oauth/token", expectedHTTPMethod: "POST", response: json, statusCode: 200)
        let url = NSURL(string: "https://oauth.example.com/gitlab_oauth?code=dhfjgh23493")!
        var token: TokenConfiguration?
        config.handleOpenURL(session, url: url) { resultingConfig in
            token = resultingConfig
        }
        XCTAssertEqual(token?.accessToken, "017ec60f4a182")
        XCTAssertTrue(session.wasCalled)
    }
}
