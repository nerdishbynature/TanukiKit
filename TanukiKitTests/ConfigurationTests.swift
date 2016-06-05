import XCTest
import Foundation
import TanukiKit
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
