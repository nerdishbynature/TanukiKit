import XCTest
import TanukiKit

class PublicKeyTests: XCTestCase {
    func testPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v4/user/keys", expectedHTTPMethod: "POST", jsonFile: "public_key", statusCode: 201)
        _ = TanukiKit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .success(let publicKey):
                XCTAssertEqual(publicKey.key, "ssh-dss AAAAB3NzaC1kc3MAAACBAMLrhYgI3atfrSD6KDas1b/3n6R/HP+bLaHHX6oh+L1vg31mdUqK0Ac/NjZoQunavoyzqdPYhFz9zzOezCrZKjuJDS3NRK9rspvjgM0xYR4d47oNZbdZbwkI4cTv/gcMlquRy0OvpfIvJtjtaJWMwTLtM5VhRusRuUlpH99UUVeXAAAAFQCVyX+92hBEjInEKL0v13c/egDCTQAAAIEAvFdWGq0ccOPbw4f/F8LpZqvWDydAcpXHV3thwb7WkFfppvm4SZte0zds1FJ+Hr8Xzzc5zMHe6J4Nlay/rP4ewmIW7iFKNBEYb/yWa+ceLrs+TfR672TaAgO6o7iSRofEq5YLdwgrwkMmIawa21FrZ2D9SPao/IwvENzk/xcHu7YAAACAQFXQH6HQnxOrw4dqf0NqeKy1tfIPxYYUZhPJfo9O0AmBW2S36pD2l14kS89fvz6Y1g8gN/FwFnRncMzlLY/hX70FSc/3hKBSbH6C6j8hwlgFKfizav21eS358JJz93leOakJZnGb8XlWvz1UJbwCsnR2VEY8Dz90uIk1l/UqHkA= loic@call")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v4/user/keys", expectedHTTPMethod: "POST", jsonFile: "public_key", statusCode: 403)
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
