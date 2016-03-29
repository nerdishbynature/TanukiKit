import XCTest
import TanukiKit

class PublicKeyTests: XCTestCase {
    func testPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/user/keys", expectedHTTPMethod: "POST", jsonFile: "public_key", statusCode: 201)
        TanukiKit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .Success(let publicKey):
                XCTAssertEqual(publicKey, "test-key")
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}
