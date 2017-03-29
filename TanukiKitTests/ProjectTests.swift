import XCTest
import TanukiKit

class ProjectTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetProjectsCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?access_token=12345&archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
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
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/projects?archived=false&page=1&per_page=20&private_token=12345&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
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

    func testGetSpecificProject() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "Project", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).project(session, id: "123") { response in
            switch response {
            case .success(let project):
                XCTAssertEqual(project.name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetProjects() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects?archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", response: json, statusCode: 401)
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

    func testGetVisibleProjects() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/visible?access_token=12345&archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).visibleProjects(session) { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetOwnedProjects() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/owned?access_token=12345&archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).ownedProjects(session) { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetStarredProjects() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/starred?access_token=12345&archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).starredProjects(session) { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetAllProjects() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/all?access_token=12345&archived=false&page=1&per_page=20&search=&simple=false", expectedHTTPMethod: "GET", jsonFile: "Projects", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).allProjects(session) { response in
            switch response {
            case .success(let projects):
                XCTAssertEqual(projects[0].name, "Diaspora Project Site")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetProjectHooks() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123/hooks?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "Hooks", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).projectHooks(session, id: "123") { response in
            switch response {
            case .success(let hooks):
                XCTAssertEqual(hooks[0].id, 1)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetProjectHook() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123/hooks/1?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "Hook", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).projectHook(session, id: "123", hookId: "1") { response in
            switch response {
            case .success(let hook):
                XCTAssertEqual(hook.id, 1)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetEvents() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/projects/123/events?access_token=12345&page=1&per_page=20", expectedHTTPMethod: "GET", jsonFile: "Events", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).projectEvents(session, id: "123") { response in
            switch response {
            case .success(let events):
                XCTAssertEqual(events[0].targetTitle, "Public project search field")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }


    // MARK: Model Tests

    func testProjectsParsing() {
        let project = Project(TestHelper.JSONFromFile("Project") as! [String: AnyObject])
        XCTAssertEqual(project.id, 3)
        XCTAssertEqual(project.name, "Diaspora Project Site")
        XCTAssertEqual(project.nameWithNamespace, "Diaspora / Diaspora Project Site")
        XCTAssertEqual(project.isPrivate, false)
        XCTAssertEqual(project.projectDescription, nil)
        XCTAssertEqual(project.sshURL, URL(string: "git@example.com:diaspora/diaspora-project-site.git"))
        XCTAssertEqual(project.cloneURL, URL(string: "http://example.com/diaspora/diaspora-project-site.git"))
        XCTAssertEqual(project.webURL, URL(string: "http://example.com/diaspora/diaspora-project-site"))
        XCTAssertEqual(project.path, "diaspora-project-site")
        XCTAssertEqual(project.pathWithNamespace, "diaspora/diaspora-project-site")
        XCTAssertEqual(project.containerRegisteryEnabled, false)
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
        XCTAssertEqual(project.namespace!.createdAt, TestHelper.parseDate("2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.namespace!.updatedAt, TestHelper.parseDate("2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.namespace!.namespaceDescription, "")
        XCTAssertEqual(project.namespace!.avatar!.url, nil)
        XCTAssertEqual(project.namespace!.shareWithGroupLocked, nil)
        XCTAssertEqual(project.namespace!.visibilityLevel, nil)
        XCTAssertEqual(project.namespace!.requestAccessEnabled, nil)
        XCTAssertEqual(project.namespace!.deletedAt, nil)
        XCTAssertEqual(project.namespace!.lfsEnabled, nil)
        XCTAssertEqual(project.avatarURL, URL(string: "http://example.com/uploads/project/avatar/3/uploads/avatar.png"))
        XCTAssertEqual(project.starCount, 0)
        XCTAssertEqual(project.forksCount, 0)
        XCTAssertEqual(project.openIssuesCount, 1)
        XCTAssertEqual(project.visibilityLevel, VisibilityLevel.private)
        XCTAssertEqual(project.createdAt, TestHelper.parseDate("2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.lastActivityAt, TestHelper.parseDate("2013-09-30T13:46:02Z"))
        XCTAssertEqual(project.lfsEnabled, nil)
        XCTAssertEqual(project.runnersToken, "b8bc4a7a29eb76ea83cf79e4908c2b")
        XCTAssertEqual(project.onlyAllowMergeIfBuildSucceeds, false)
        XCTAssertEqual(project.requestAccessEnabled, false)
        XCTAssertEqual(project.permissions!.projectAccess!.accessLevel, 10)
        XCTAssertEqual(project.permissions!.projectAccess!.notificationLevel, 3)
        XCTAssertEqual(project.permissions!.groupAccess!.accessLevel, 50)
        XCTAssertEqual(project.permissions!.groupAccess!.notificationLevel, 3)
    }

    func testProjectEventsParsing() {
        let event = Event(TestHelper.JSONFromFile("Event") as! [String: AnyObject])
        XCTAssertEqual(event.title, nil)
        XCTAssertEqual(event.projectID, 37)
        XCTAssertEqual(event.actionName, "pushed to")
        XCTAssertEqual(event.targetID, nil)
        XCTAssertEqual(event.targetType, nil)
        XCTAssertEqual(event.authorID, 8)
        XCTAssertEqual(event.data!.objectKind, "push")
        XCTAssertEqual(event.data!.eventName, "push")
        XCTAssertEqual(event.data!.before, "7a6a450ca607c9c0be539bb91c5c7eb6bdf4cc79")
        XCTAssertEqual(event.data!.after, "bde8115a0d77c6a0bcad8e427ecbc38c4a6a4f5f")
        XCTAssertEqual(event.data!.ref, "refs/heads/master")
        XCTAssertEqual(event.data!.commits![0].message, "The private token is no longer given\n")
        XCTAssertEqual(event.data!.commits![1].message, "Fixture updates and new resources\n")
        XCTAssertEqual(event.data!.commits![2].message, "A little help please?\n")
        XCTAssertEqual(event.data!.totalCommitsCount, 9)
        XCTAssertEqual(event.targetTitle, nil)
        XCTAssertEqual(event.createdAt, TestHelper.parseDate("2016-12-19T09:02:33.673Z"))
        XCTAssertEqual(event.author!.name, "Mirror Bot")
        XCTAssertEqual(event.author!.avatarURL, URL(string: "https://code.tiferrei.com/uploads/user/avatar/8/dock-icon-flat-1.png.9327a09e15d51d0929d58e25f27eae60.png"))
    }

    func testProjectHooksParsing() {
        let hook = ProjectHook(TestHelper.JSONFromFile("Hook") as! [String: AnyObject])
        XCTAssertEqual(hook.id, 1)
        XCTAssertEqual(hook.url, URL(string: "http://example.com/hook"))
        XCTAssertEqual(hook.projectID, 3)
        XCTAssertEqual(hook.pushEvents, true)
        XCTAssertEqual(hook.issuesEvents, true)
        XCTAssertEqual(hook.mergeRequestsEvents, true)
        XCTAssertEqual(hook.tagPushEvents, true)
        XCTAssertEqual(hook.noteEvents, true)
        XCTAssertEqual(hook.buildEvents, true)
        XCTAssertEqual(hook.pipelineEvents, true)
        XCTAssertEqual(hook.wikiPageEvents, true)
        XCTAssertEqual(hook.enableSSLVerification, true)
        XCTAssertEqual(hook.createdAt, TestHelper.parseDate("2012-10-12T17:04:47Z"))
    }
}
