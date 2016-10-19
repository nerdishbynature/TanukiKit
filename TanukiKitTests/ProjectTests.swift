import XCTest
import TanukiKit

class ProjectTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetProjectsCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?access_token=12345&page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).projects(session) { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetProjectsEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/projects?page=1&per_page=100&private_token=12345", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
        _ = TanukiKit(config).projects(session) { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetProjects() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?page=1&per_page=100", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        _ = TanukiKit().projects(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "❌ Should not retrieve user.")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testProjectsParsing() {
        let projects = Project(TestHelper.JSONFromFile(name: "Projects") as! [String: AnyObject]) //Get all as list?
        XCTAssertEqual(projects[0].id, 3)
        XCTAssertEqual(projects[0].owner.id, 3)
        XCTAssertEqual(projects[0].name, "Diaspora Project Site")
        XCTAssertEqual(projects[0].nameWithNamespace, "Diaspora / Diaspora Project Site")
        XCTAssertEqual(projects[0].isPublic, false)
        // . . .
        XCTAssertEqual(projects[0].namespace.name, "Diaspora")
        // . . .
    }
}
