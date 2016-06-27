import XCTest
import TanukiKit

class UserTests: XCTestCase {
    
    // MARK: Actual Request tests
    
    func testGetUserCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/user?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "User", statusCode: 200)
        let config = TokenConfiguration("12345")
        TanukiKit(config).me(session) { response in
            switch response {
            case .Success(let user):
                XCTAssertEqual(user.login, "testMcTestface")
            case .Failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetUserEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/user?private_token=12345", expectedHTTPMethod: "GET", jsonFile: "User", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
        TanukiKit(config).me(session) { response in
            switch response {
            case .Success(let user):
                XCTAssertEqual(user.login, "testMcTestface")
            case .Failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
    
    func testFailToGetUser() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/user", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        TanukiKit().me(session) { response in
            switch response {
            case .Success:
                XCTAssert(false, "❌ Should not retrieve user.")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
    
    // MARK: Model Tests
    
    func testUserParsing() {
        let subject = User(TestHelper.JSONFromFile("User") as! [String: AnyObject])
        XCTAssertEqual(subject.name, "Test McTestface")
        XCTAssertEqual(subject.login, "testMcTestface")
        XCTAssertEqual(subject.id, 7)
        XCTAssertEqual(subject.avatarURL, "https://code.tiferrei.com/uploads/user/avatar/7/avatar.png")
        XCTAssertEqual(subject.webURL, "https://code.tiferrei.com/u/testMcTestface")
        XCTAssertEqual(subject.createdAt, "2016-05-03T15:05:46.391Z")
        XCTAssertEqual(subject.isAdmin, false)
        XCTAssertEqual(subject.bio, "I'm a simple test user that Tiago created to test the GitLab API.")
        XCTAssertEqual(subject.location, "World Wide Web")
        XCTAssertEqual(subject.skype, "testMcTestface")
        XCTAssertEqual(subject.linkedin, "testMcTestface")
        XCTAssertEqual(subject.twitter, "@testMcTestface")
        XCTAssertEqual(subject.websiteURL, "https://testmctestface.example.com")
        XCTAssertEqual(subject.lastSignInAt, "2016-05-03T15:06:21.305Z")
        XCTAssertEqual(subject.confirmedAt, "2016-05-03T15:05:46.183Z")
        XCTAssertEqual(subject.email, "EMAIL")
        XCTAssertEqual(subject.themeId, 2)
        XCTAssertEqual(subject.colorSchemeId, 1)
        XCTAssertEqual(subject.projectsLimit, 10)
        XCTAssertEqual(subject.currentSignInAt, "2016-06-26T15:29:16.606Z")
        XCTAssertEqual(subject.canCreateGroup, false)
        XCTAssertEqual(subject.canCreateProject, true)
        XCTAssertEqual(subject.twoFactorEnabled, false)
        XCTAssertEqual(subject.external, false)
        XCTAssertEqual(subject.privateToken, "TOKEN")
    }
}
