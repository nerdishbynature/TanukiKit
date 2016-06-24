import XCTest
import TanukiKit

class PublicKeyTests: XCTestCase {
    func testPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/user/keys", expectedHTTPMethod: "POST", jsonFile: "public_key", statusCode: 201)
        _ = TanukiKit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .success(let publicKey):
                XCTAssertEqual(publicKey, "test-key")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/user/keys", expectedHTTPMethod: "POST", jsonFile: "public_key", statusCode: 403)
        _ = TanukiKit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .success:
                XCTAssert(false, "should not get a public key")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, 403)
                XCTAssertEqual((error as NSError).domain, TanukiKitErrorDomain)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}
