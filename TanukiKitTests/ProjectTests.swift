import XCTest
import TanukiKit

class ProjectTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetProjectsCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v4/users/myself/projects?access_token=12345&page=1&per_page=20", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).projects(session, username: "myself") { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "www-gitlab-com")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetProjectsEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/users/myself/projects?page=1&per_page=20&private_token=12345", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
        _ = TanukiKit(config).projects(session, username: "myself") { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "www-gitlab-com")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetProjects() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v4/users/myself/projects?page=1&per_page=20", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        _ = TanukiKit().projects(session, username: "myself") { response in
            switch response {
            case .success:
                XCTAssert(false, "❌ Should not retrieve projects.")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testProjectsParsing() {
        let project = TestHelper.codableFromFile("Project", type: Project.self)
        XCTAssertEqual(project.id, 945182)
        XCTAssertEqual(project.name, "git2go-test-repo")
        XCTAssertEqual(project.nameWithNamespace, "Piet Brauer / git2go-test-repo")
        XCTAssertEqual(project.visibilityLevel, .public)
        XCTAssertEqual(project.projectDescription, nil)
        XCTAssertEqual(project.sshURL, URL(string: "git@gitlab.com:pietbrauer/git2go-test-repo.git"))
        XCTAssertEqual(project.webURL, URL(string: "https://gitlab.com/pietbrauer/git2go-test-repo.git"))
        XCTAssertEqual(project.path, "git2go-test-repo")
        XCTAssertEqual(project.pathWithNamespace, "pietbrauer/git2go-test-repo")
        XCTAssertEqual(project.containerRegisteryEnabled, nil)
        XCTAssertEqual(project.defaultBranch, "master")
        XCTAssertEqual(project.tagList!, [])
        XCTAssertEqual(project.issuesEnabled, true)
        XCTAssertEqual(project.mergeRequestsEnabled, true)
        XCTAssertEqual(project.wikiEnabled, true)
        XCTAssertEqual(project.snippetsEnabled, false)
        XCTAssertEqual(project.sharedRunnersEnabled, true)
        XCTAssertEqual(project.creatorID, 61673)
        XCTAssertEqual(project.avatarURL, nil)
        XCTAssertEqual(project.starCount, 0)
        XCTAssertEqual(project.forksCount, 0)
        XCTAssertEqual(project.openIssuesCount, 0)
        XCTAssertEqual(project.createdAt, TestHelper.parseDate("2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.lastActivityAt, TestHelper.parseDate("2016-03-08T02:02:44.440Z"))
        XCTAssertEqual(project.lfsEnabled, true)
        XCTAssertEqual(project.onlyAllowMergeIfBuildSucceeds, false)
        XCTAssertEqual(project.requestAccessEnabled, true)
    }
}
