import XCTest
@testable import TanukiKit
import Nocilla

class PublicKeyTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }

    // MARK: URLRequest Tests

    func testPostPublicKeyURLRequest() {
        let kit = TanukiKit(TokenConfiguration("12345"))
        let request = PublicKeyRouter.PostPublicKey("test-key", "test title", kit.configuration).URLRequest
        XCTAssertEqual(request?.URL, NSURL(string: "https://gitlab.com/api/v3/user/keys?access_token=12345")!)
    }

    // MARK: Actual Request tests

    func testPostPublicKey() {
        let config = TokenConfiguration("12345")
        if let json = TestHelper.stringFromFile("public_key") {
            stubRequest("POST", "https://gitlab.com/api/v3/user/keys?access_token=12345").andReturn(201).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("public_key")
            TanukiKit(config).postPublicKey("test-key", title: "test title") { response in
                switch response {
                case .Success(let publicKey):
                    XCTAssertEqual(publicKey, "test-key")
                    expectation.fulfill()
                case .Failure:
                    XCTAssert(false, "should not get an error")
                    expectation.fulfill()
                }
            }
            waitForExpectationsWithTimeout(1) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }
}
