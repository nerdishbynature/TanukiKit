import XCTest
import Foundation
@testable import TanukiKit
import Nocilla

private let enterpriseURL = "https://gitlab.example.com/api/v3"

class ConfigurationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }

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

    func testOAuthConfiguration() {
        let subject = OAuthConfiguration(token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
    }

    func testOAuthTokenConfiguration() {
        let subject = OAuthConfiguration(enterpriseURL, token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testAuthorizeURLRequest() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        let request = OAuthRouter.Authorize(config, "https://oauth.example.com/gitlab_oauth").URLRequest
        let expected = NSURL(string: "https://gitlab.com/oauth/authorize?client_id=12345&redirect_uri=https%3A//oauth.example.com/gitlab_oauth&response_type=code")!
        XCTAssertEqual(request?.URL, expected)
    }

    func testAccessTokenURLRequest() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        let request = OAuthRouter.AccessToken(config, "dhfjgh23493", "https://oauth.example.com/gitlab_oauth").URLRequest
        let expected = NSURL(string: "https://gitlab.com/oauth/token")!
        let expectedBody = "client_id=12345&client_secret=6789&code=dhfjgh23493&grant_type=authorization_code&redirect_uri=https%3A//oauth.example.com/gitlab_oauth"
        XCTAssertEqual(request?.URL, expected)
        let string = NSString(data: request!.HTTPBody!, encoding: NSUTF8StringEncoding)!
        XCTAssertEqual(string as String, expectedBody)
    }

    func testHandleOpenURL() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", redirectURI: "https://oauth.example.com/gitlab_oauth")
        let json = "{\"access_token\": \"017ec60f4a182\", \"token_type\": \"bearer\"}"
        stubRequest("POST", "https://gitlab.com/oauth/token").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
        let expectation = expectationWithDescription("access_token")
        let url = NSURL(string: "https://oauth.example.com/gitlab_oauth?code=dhfjgh23493")!
        config.handleOpenURL(url) { token in
            XCTAssertEqual(token.accessToken, "017ec60f4a182")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: { error in
            XCTAssertNil(error, "\(error)")
        })
    }
}
