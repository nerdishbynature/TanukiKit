import XCTest
import TanukiKit

class UserTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetUserCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v4/user?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "User", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).me(session) { response in
            switch response {
            case .success(let user):
                XCTAssertEqual(user.username, "pietbrauer")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUserEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v4/user?private_token=12345", expectedHTTPMethod: "GET", jsonFile: "User", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v4/")
        _ = TanukiKit(config).me(session) { response in
            switch response {
            case .success(let user):
                XCTAssertEqual(user.username, "pietbrauer")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUser() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v4/user", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        _ = TanukiKit().me(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "❌ Should not retrieve user.")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testUserParsing() {
        let subject = TestHelper.codableFromFile("User", type: User.self)
        XCTAssertEqual(subject.name, "Piet Brauer")
        XCTAssertEqual(subject.username, "pietbrauer")
        XCTAssertEqual(subject.avatarURL, URL(string: "https://secure.gravatar.com/avatar/1856b6db24ec5ff8d534726de2d75f13?s=80&d=identicon"))
        XCTAssertEqual(subject.webURL, URL(string: "https://gitlab.com/pietbrauer"))
        XCTAssertEqual(subject.createdAt, TestHelper.parseDate("2014-10-13T16:44:34.133Z"))
        XCTAssertEqual(subject.bio, "I'm a simple test user that Tiago created to test the GitLab API.")
        XCTAssertEqual(subject.location, "World Wide Web")
        XCTAssertEqual(subject.skype, "testMcTestface")
        XCTAssertEqual(subject.linkedin, "testMcTestface")
        XCTAssertEqual(subject.twitter, "@testMcTestface")
        XCTAssertEqual(subject.websiteURL, URL(string: "https://testmctestface.example.com"))
        XCTAssertEqual(subject.lastSignInAt, TestHelper.parseDate("2018-09-13T07:18:36.200Z"))
        XCTAssertEqual(subject.confirmedAt, TestHelper.parseDate("2014-10-13T16:45:10.076Z"))
        XCTAssertEqual(subject.email, "EMAIL")
        XCTAssertEqual(subject.themeId, nil)
        XCTAssertEqual(subject.colorSchemeId, 1)
        XCTAssertEqual(subject.projectsLimit, 100000)
        XCTAssertEqual(subject.currentSignInAt, TestHelper.parseDate("2018-09-13T07:22:06.187Z"))
        XCTAssertEqual(subject.canCreateGroup, true)
        XCTAssertEqual(subject.canCreateProject, true)
        XCTAssertEqual(subject.twoFactorEnabled, false)
        XCTAssertEqual(subject.external, false)
    }
}
