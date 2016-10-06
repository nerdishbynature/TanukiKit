import XCTest
import TanukiKit

class ProjectsTest: XCTestCase {
    // MARK: Actual Request tests

    func testGetProjectsCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?access_token=12345&page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "Repositories", statusCode: 200)
        let config = TokenConfiguration("12345")
        TanukiKit(config).repositories(session) { response in
            switch response {
            case .Success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .Failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetProjectsEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/projects?page=1&per_page=100&private_token=12345", expectedHTTPMethod: "GET", jsonFile: "User", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
        TanukiKit(config).repositories(session) { response in
            switch response {
            case .Success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .Failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUser() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?page=1&per_page=100", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        TanukiKit().repositories(session) { response in
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

}
