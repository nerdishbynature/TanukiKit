import XCTest
import TanukiKit

class ProjectTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetProjectsCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?access_token=12345&archived=&order_by=created_at&page=1&per_page=20&search=&simple=&sort=desc&visibility=", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
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
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/projects?archived=&order_by=created_at&page=1&per_page=20&private_token=12345&search=&simple=&sort=desc&visibility=", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
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
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?archived=&order_by=created_at&page=1&per_page=20&search=&simple=&sort=desc&visibility=", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        _ = TanukiKit().projects(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "❌ Should not retrieve projects.")
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
        let project = Project(TestHelper.JSONFromFile(name: "Project") as! [String: AnyObject])
        XCTAssertEqual(project.id, 3)
        XCTAssertEqual(project.name, "Diaspora Project Site")
        XCTAssertEqual(project.nameWithNamespace, "Diaspora / Diaspora Project Site")
        XCTAssertEqual(project.isPublic, false)
        XCTAssertEqual(project.projectDescription, nil)
        XCTAssertEqual(project.sshURL, URL(string: "git@example.com:diaspora/diaspora-project-site.git"))
        XCTAssertEqual(project.cloneURL, URL(string: "http://example.com/diaspora/diaspora-project-site.git"))
        XCTAssertEqual(project.webURL, URL(string: "http://example.com/diaspora/diaspora-project-site"))
        XCTAssertEqual(project.path, "diaspora-project-site")
        XCTAssertEqual(project.pathWithNamespace, "diaspora/diaspora-project-site")
        XCTAssertEqual(project.contaierRegisteryEnabled, false)
        XCTAssertEqual(project.defaultBranch, "master")
        XCTAssertEqual(project.tagList!, ["example", "disapora project"])
        XCTAssertEqual(project.isArchived, false)
        XCTAssertEqual(project.issuesEnabled, true)
        XCTAssertEqual(project.mergeRequestsEnabled, true)
        XCTAssertEqual(project.wikiEnabled, true)
        XCTAssertEqual(project.buildsEnabled, true)
        XCTAssertEqual(project.snippetsEnabled, false)
        XCTAssertEqual(project.sharedRunnersEnabled, true)
        XCTAssertEqual(project.publicBuilds, true)
        XCTAssertEqual(project.creatorID, 3)
        XCTAssertEqual(project.namespace!.id, 3)
        XCTAssertEqual(project.namespace!.name, "Diaspora")
        XCTAssertEqual(project.namespace!.path, "diaspora")
        XCTAssertEqual(project.namespace!.ownerID, 1)
        XCTAssertEqual(project.namespace!.createdAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.namespace!.updatedAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.namespace!.namespaceDescription, "")
        XCTAssertEqual(project.namespace!.avatar!.url, nil)
        XCTAssertEqual(project.namespace!.shareWithGroupLock, nil)
        XCTAssertEqual(project.namespace!.visibilityLevel, nil)
        XCTAssertEqual(project.namespace!.requestAccessEnabled, nil)
        XCTAssertEqual(project.namespace!.deletedAt, nil)
        XCTAssertEqual(project.namespace!.lfsEnabled, nil)
        XCTAssertEqual(project.avatarURL, URL(string: "http://example.com/uploads/project/avatar/3/uploads/avatar.png"))
        XCTAssertEqual(project.starCount, 0)
        XCTAssertEqual(project.forksCount, 0)
        XCTAssertEqual(project.openIssuesCount, 1)
        XCTAssertEqual(project.visibilityLevel, 0)
        XCTAssertEqual(project.createdAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.lastActivityAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.lfsEnabled, nil)
        XCTAssertEqual(project.runnersToken, "b8bc4a7a29eb76ea83cf79e4908c2b")
        XCTAssertEqual(project.onlyAllowMergeIfBuildSucceeds, false)
        XCTAssertEqual(project.requestAccessEnabled, false)
        XCTAssertEqual(project.permissions!.projectAccess!.accessLevel, 10)
        XCTAssertEqual(project.permissions!.projectAccess!.notificationLevel, 3)
        XCTAssertEqual(project.permissions!.groupAccess!.accessLevel, 50)
        XCTAssertEqual(project.permissions!.groupAccess!.notificationLevel, 3)
    }
}
