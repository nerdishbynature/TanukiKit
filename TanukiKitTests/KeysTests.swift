import XCTest
import TanukiKit
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

    // MARK: Actual Request tests

    func testPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        if let json = TestHelper.stringFromFile("public_key") {
            stubRequest("POST", "https://gitlab.com/api/v3/user/keys").withBody("key=test-key&private_token=12345&title=test%20title").andReturn(201).withHeaders(["Content-Type": "application/json"]).withBody(json)
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
