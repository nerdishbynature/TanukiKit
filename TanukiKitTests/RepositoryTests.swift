import XCTest
import TanukiKit

class RepositoryTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetRepositoriesCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?access_token=12345&archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Repositories", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).repositories(session) { response in
            switch response {
            case .success(let repos):
                XCTAssertEqual(repos[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepositoriesEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/projects?archived=false&page=1&per_page=20&private_token=12345&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Repositories", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
        _ = TanukiKit(config).repositories(session) { response in
            switch response {
            case .success(let repos):
                XCTAssertEqual(repos[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepositories() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        _ = TanukiKit().repositories(session) { response in
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

    func testRepositoriesParsing() {
        let repo = Repository(TestHelper.JSONFromFile(name: "Repository") as! [String: AnyObject])
        XCTAssertEqual(repo.id, 3)
        XCTAssertEqual(repo.name, "Diaspora Project Site")
        XCTAssertEqual(repo.nameWithNamespace, "Diaspora / Diaspora Project Site")
        XCTAssertEqual(repo.isPrivate, false)
        XCTAssertEqual(repo.projectDescription, nil)
        XCTAssertEqual(repo.sshURL, URL(string: "git@example.com:diaspora/diaspora-project-site.git"))
        XCTAssertEqual(repo.cloneURL, URL(string: "http://example.com/diaspora/diaspora-project-site.git"))
        XCTAssertEqual(repo.webURL, URL(string: "http://example.com/diaspora/diaspora-project-site"))
        XCTAssertEqual(repo.path, "diaspora-project-site")
        XCTAssertEqual(repo.pathWithNamespace, "diaspora/diaspora-project-site")
        XCTAssertEqual(repo.containerRegisteryEnabled, false)
        XCTAssertEqual(repo.defaultBranch, "master")
        XCTAssertEqual(repo.tagList!, ["example", "disapora project"])
        XCTAssertEqual(repo.isArchived, false)
        XCTAssertEqual(repo.issuesEnabled, true)
        XCTAssertEqual(repo.mergeRequestsEnabled, true)
        XCTAssertEqual(repo.wikiEnabled, true)
        XCTAssertEqual(repo.buildsEnabled, true)
        XCTAssertEqual(repo.snippetsEnabled, false)
        XCTAssertEqual(repo.sharedRunnersEnabled, true)
        XCTAssertEqual(repo.publicBuilds, true)
        XCTAssertEqual(repo.creatorID, 3)
        XCTAssertEqual(repo.namespace!.id, 3)
        XCTAssertEqual(repo.namespace!.name, "Diaspora")
        XCTAssertEqual(repo.namespace!.path, "diaspora")
        XCTAssertEqual(repo.namespace!.ownerID, 1)
        XCTAssertEqual(repo.namespace!.createdAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(repo.namespace!.updatedAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(repo.namespace!.namespaceDescription, "")
        XCTAssertEqual(repo.namespace!.avatar!.url, nil)
        XCTAssertEqual(repo.namespace!.shareWithGroupLocked, nil)
        XCTAssertEqual(repo.namespace!.visibilityLevel, nil)
        XCTAssertEqual(repo.namespace!.requestAccessEnabled, nil)
        XCTAssertEqual(repo.namespace!.deletedAt, nil)
        XCTAssertEqual(repo.namespace!.lfsEnabled, nil)
        XCTAssertEqual(repo.avatarURL, URL(string: "http://example.com/uploads/project/avatar/3/uploads/avatar.png"))
        XCTAssertEqual(repo.starCount, 0)
        XCTAssertEqual(repo.forksCount, 0)
        XCTAssertEqual(repo.openIssuesCount, 1)
        XCTAssertEqual(repo.visibilityLevel, VisibilityLevel.Private)
        XCTAssertEqual(repo.createdAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(repo.lastActivityAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
        XCTAssertEqual(repo.lfsEnabled, nil)
        XCTAssertEqual(repo.runnersToken, "b8bc4a7a29eb76ea83cf79e4908c2b")
        XCTAssertEqual(repo.onlyAllowMergeIfBuildSucceeds, false)
        XCTAssertEqual(repo.requestAccessEnabled, false)
        XCTAssertEqual(repo.permissions!.projectAccess!.accessLevel, 10)
        XCTAssertEqual(repo.permissions!.projectAccess!.notificationLevel, 3)
        XCTAssertEqual(repo.permissions!.groupAccess!.accessLevel, 50)
        XCTAssertEqual(repo.permissions!.groupAccess!.notificationLevel, 3)
    }
}
