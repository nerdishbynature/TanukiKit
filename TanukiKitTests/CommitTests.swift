import XCTest
import TanukiKit

class CommitTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetCommits() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123/repository/commits?access_token=12345&ref_name=&since=&until=", expectedHTTPMethod: "GET", jsonFile: "Commits", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).commits(session, id: "123") { response in
            switch response {
            case .success(let commits):
                XCTAssertEqual(commits[0].id, "ed899a2f4b50b4370feeea94676502b42383c746")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

//    func testGetProjectsEECE() {
//        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/projects?archived=false&page=1&per_page=20&private_token=12345&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
//        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
//        _ = TanukiKit(config).projects(session) { response in
//            switch response {
//            case .success(let projects):
//                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
//            case .failure(let error):
//                XCTAssert(false, "❌ Should not retrieve an error –> \(error)")
//            }
//        }
//        XCTAssertTrue(session.wasCalled)
//    }
//
//    func testGetSpecificProject() {
//        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "Project", statusCode: 200)
//        let config = TokenConfiguration("12345")
//        _ = TanukiKit(config).project(session, id: "123") { response in
//            switch response {
//            case .success(let project):
//                XCTAssertEqual(project.name, "Diaspora Project Site")
//            case .failure(let error):
//                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
//            }
//        }
//        XCTAssertTrue(session.wasCalled)
//    }
//
//    func testFailToGetProjects() {
//        let json = "{\"message\":\"401 Unauthorized\"}"
//        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", response: json, statusCode: 401)
//        _ = TanukiKit().projects(session) { response in
//            switch response {
//            case .success:
//                XCTAssert(false, "❌ Should not retrieve projects.")
//            case .failure(let error as NSError):
//                XCTAssertEqual(error.code, 401)
//                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
//            case .failure:
//                XCTAssertTrue(false)
//            }
//        }
//        XCTAssertTrue(session.wasCalled)
//    }
//
//    // MARK: Project Event Tests
//
//    func testGetEvents() {
//        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123/events?access_token=12345&page=1&per_page=20", expectedHTTPMethod: "GET", jsonFile: "Events", statusCode: 200)
//        let config = TokenConfiguration("12345")
//        _ = TanukiKit(config).projectEvents(session, id: "123") { response in
//            switch response {
//            case .success(let events):
//                XCTAssertEqual(events[0].targetTitle, "Public project search field")
//            case .failure(let error):
//                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
//            }
//        }
//        XCTAssertTrue(session.wasCalled)
//    }
//
//
//    // MARK: Model Tests
//
//    func testProjectsParsing() {
//        let project = Project(TestHelper.JSONFromFile(name: "Project") as! [String: AnyObject])
//        XCTAssertEqual(project.id, 3)
//        XCTAssertEqual(project.name, "Diaspora Project Site")
//        XCTAssertEqual(project.nameWithNamespace, "Diaspora / Diaspora Project Site")
//        XCTAssertEqual(project.isPrivate, false)
//        XCTAssertEqual(project.projectDescription, nil)
//        XCTAssertEqual(project.sshURL, URL(string: "git@example.com:diaspora/diaspora-project-site.git"))
//        XCTAssertEqual(project.cloneURL, URL(string: "http://example.com/diaspora/diaspora-project-site.git"))
//        XCTAssertEqual(project.webURL, URL(string: "http://example.com/diaspora/diaspora-project-site"))
//        XCTAssertEqual(project.path, "diaspora-project-site")
//        XCTAssertEqual(project.pathWithNamespace, "diaspora/diaspora-project-site")
//        XCTAssertEqual(project.containerRegisteryEnabled, false)
//        XCTAssertEqual(project.defaultBranch, "master")
//        XCTAssertEqual(project.tagList!, ["example", "disapora project"])
//        XCTAssertEqual(project.isArchived, false)
//        XCTAssertEqual(project.issuesEnabled, true)
//        XCTAssertEqual(project.mergeRequestsEnabled, true)
//        XCTAssertEqual(project.wikiEnabled, true)
//        XCTAssertEqual(project.buildsEnabled, true)
//        XCTAssertEqual(project.snippetsEnabled, false)
//        XCTAssertEqual(project.sharedRunnersEnabled, true)
//        XCTAssertEqual(project.publicBuilds, true)
//        XCTAssertEqual(project.creatorID, 3)
//        XCTAssertEqual(project.namespace!.id, 3)
//        XCTAssertEqual(project.namespace!.name, "Diaspora")
//        XCTAssertEqual(project.namespace!.path, "diaspora")
//        XCTAssertEqual(project.namespace!.ownerID, 1)
//        XCTAssertEqual(project.namespace!.createdAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
//        XCTAssertEqual(project.namespace!.updatedAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
//        XCTAssertEqual(project.namespace!.namespaceDescription, "")
//        XCTAssertEqual(project.namespace!.avatar!.url, nil)
//        XCTAssertEqual(project.namespace!.shareWithGroupLocked, nil)
//        XCTAssertEqual(project.namespace!.visibilityLevel, nil)
//        XCTAssertEqual(project.namespace!.requestAccessEnabled, nil)
//        XCTAssertEqual(project.namespace!.deletedAt, nil)
//        XCTAssertEqual(project.namespace!.lfsEnabled, nil)
//        XCTAssertEqual(project.avatarURL, URL(string: "http://example.com/uploads/project/avatar/3/uploads/avatar.png"))
//        XCTAssertEqual(project.starCount, 0)
//        XCTAssertEqual(project.forksCount, 0)
//        XCTAssertEqual(project.openIssuesCount, 1)
//        XCTAssertEqual(project.visibilityLevel, VisibilityLevel.Private)
//        XCTAssertEqual(project.createdAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
//        XCTAssertEqual(project.lastActivityAt, TestHelper.parseDate(date: "2013-09-30T13:46:02Z"))
//        XCTAssertEqual(project.lfsEnabled, nil)
//        XCTAssertEqual(project.runnersToken, "b8bc4a7a29eb76ea83cf79e4908c2b")
//        XCTAssertEqual(project.onlyAllowMergeIfBuildSucceeds, false)
//        XCTAssertEqual(project.requestAccessEnabled, false)
//        XCTAssertEqual(project.permissions!.projectAccess!.accessLevel, 10)
//        XCTAssertEqual(project.permissions!.projectAccess!.notificationLevel, 3)
//        XCTAssertEqual(project.permissions!.groupAccess!.accessLevel, 50)
//        XCTAssertEqual(project.permissions!.groupAccess!.notificationLevel, 3)
//    }
//
//    func testProjectEventsParsing() {
//        let event = Event(TestHelper.JSONFromFile(name: "Event") as! [String: AnyObject])
//        XCTAssertEqual(event.title, nil)
//        XCTAssertEqual(event.projectID, 37)
//        XCTAssertEqual(event.actionName, "pushed to")
//        XCTAssertEqual(event.targetID, nil)
//        XCTAssertEqual(event.targetType, nil)
//        XCTAssertEqual(event.authorID, 8)
//        XCTAssertEqual(event.data!.objectKind, "push")
//        XCTAssertEqual(event.data!.eventName, "push")
//        XCTAssertEqual(event.data!.before, "7a6a450ca607c9c0be539bb91c5c7eb6bdf4cc79")
//        XCTAssertEqual(event.data!.after, "bde8115a0d77c6a0bcad8e427ecbc38c4a6a4f5f")
//        XCTAssertEqual(event.data!.ref, "refs/heads/master")
//        print("DEBUG: \(event.data!.commits)")
//        XCTAssertEqual(event.data!.commits![0].message, "The private token is no longer given\n")
//        // TODO: Finish Parsing tests
//    }
}
