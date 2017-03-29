import XCTest
import TanukiKit

class CommitTests: XCTestCase {

    // MARK: Actual Request tests

    func testGetCommitsCOM() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project/123/repository/commits?access_token=12345&ref_name=&since=&until=", expectedHTTPMethod: "GET", jsonFile: "Commits", statusCode: 200)
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

    func testGetCommitsEECE() {
        let session = TanukiKitURLTestSession(expectedURL: "https://code.tiferrei.com/api/v3/project/123/repository/commits?private_token=12345&ref_name=&since=&until=", expectedHTTPMethod: "GET", jsonFile: "Commits", statusCode: 200)
        let config = PrivateTokenConfiguration("12345", url: "https://code.tiferrei.com/api/v3/")
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

    func testFailToGetCommits() {
        let json = "{\"message\":\"401 Unauthorized\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project/123/repository/commits?ref_name=&since=&until=", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        _ = TanukiKit().commits(session, id: "123") { response in
            switch response {
            case .success:
                XCTAssert(false, "❌ Should not retrieve commits.")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetCommit() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project/123/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "Commit", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).commit(session, id: "123", sha: "6104942438c14ec7bd21c6cd5bd995272b3faff6") { response in
            switch response {
            case .success(let commit):
                XCTAssertEqual(commit.id, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetCommit() {
        let json = "{\"error\":\"404 Not Found\"}"
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project//repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6?access_token=12345", expectedHTTPMethod: "GET", response: json, statusCode: 404)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).commit(session, id: "", sha: "6104942438c14ec7bd21c6cd5bd995272b3faff6") { response in
            switch response {
            case .success:
                XCTAssert(false, "❌ Should not retrieve commit, no project ID given.")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, TanukiKitErrorDomain)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetCommitDiffs() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project/123/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "CommitDiff", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).commitDiffs(session, id: "123", sha: "6104942438c14ec7bd21c6cd5bd995272b3faff6") { response in
            switch response {
            case .success(let commitDiffs):
                XCTAssertEqual(commitDiffs[0].diff, "--- a/doc/update/5.4-to-6.0.md\n+++ b/doc/update/5.4-to-6.0.md\n@@ -71,6 +71,8 @@\n sudo -u git -H bundle exec rake migrate_keys RAILS_ENV=production\n sudo -u git -H bundle exec rake migrate_inline_notes RAILS_ENV=production\n \n+sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production\n+\n ```\n \n ### 6. Update config files")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetCommitComments() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project/123/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "CommitComment", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).commitComments(session, id: "123", sha: "6104942438c14ec7bd21c6cd5bd995272b3faff6") { response in
            switch response {
            case .success(let commitComments):
                XCTAssertEqual(commitComments[0].note, "this code is really nice")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetCommitStatuses() {
        let session = TanukiKitURLTestSession(expectedURL: "https://gitlab.com/api/v3/project/123/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/statuses?access_token=12345&all=false&name=&ref=&stage=", expectedHTTPMethod: "GET", jsonFile: "CommitStatus", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = TanukiKit(config).commitStatuses(session, id: "123", sha: "6104942438c14ec7bd21c6cd5bd995272b3faff6") { response in
            switch response {
            case .success(let commitStatuses):
                XCTAssertEqual(commitStatuses[0].status, "pending")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testCommitsParsing() {
        let commit = Commit(TestHelper.JSONFromFile("Commit") as! [String: AnyObject])
        XCTAssertEqual(commit.id, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
        XCTAssertEqual(commit.shortID, "6104942438c")
        XCTAssertEqual(commit.title, "Sanitize for network graph")
        XCTAssertEqual(commit.authorName, "randx")
        XCTAssertEqual(commit.authorEmail, "dmitriy.zaporozhets@gmail.com")
        XCTAssertEqual(commit.committerName, "Dmitriy")
        XCTAssertEqual(commit.committerEmail, "dmitriy.zaporozhets@gmail.com")
        XCTAssertEqual(commit.createdAt, TestHelper.parseDate("2012-09-20T09:06:12+03:00"))
        XCTAssertEqual(commit.message, "Sanitize for network graph")
        XCTAssertEqual(commit.committedDate, TestHelper.parseDate("2012-09-20T09:06:12+03:00"))
        XCTAssertEqual(commit.authoredDate, TestHelper.parseDate("2012-09-20T09:06:12+03:00"))
        XCTAssertEqual(commit.parentIDs?[0], "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba")
        XCTAssertEqual(commit.stats!.additions, 15)
        XCTAssertEqual(commit.stats!.deletions, 10)
        XCTAssertEqual(commit.stats!.total, 25)
        XCTAssertEqual(commit.status, "running")
    }

    func testCommitDiffsParsing() {
        let commitDiff = CommitDiff(TestHelper.JSONFromFile("CommitDiff") as! [String: AnyObject])
        XCTAssertEqual(commitDiff.diff, "--- a/doc/update/5.4-to-6.0.md\n+++ b/doc/update/5.4-to-6.0.md\n@@ -71,6 +71,8 @@\n sudo -u git -H bundle exec rake migrate_keys RAILS_ENV=production\n sudo -u git -H bundle exec rake migrate_inline_notes RAILS_ENV=production\n \n+sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production\n+\n ```\n \n ### 6. Update config files")
        XCTAssertEqual(commitDiff.newPath, "doc/update/5.4-to-6.0.md")
        XCTAssertEqual(commitDiff.oldPath, "doc/update/5.4-to-6.0.md")
        XCTAssertEqual(commitDiff.aMode, nil)
        XCTAssertEqual(commitDiff.bMode, "100644")
        XCTAssertEqual(commitDiff.newFile, false)
        XCTAssertEqual(commitDiff.renamedFile, false)
        XCTAssertEqual(commitDiff.deletedFile, false)
    }

    func testCommitCommentsParsing() {
        let commitComment = CommitComment(TestHelper.JSONFromFile("CommitComment") as! [String: AnyObject])
        XCTAssertEqual(commitComment.note, "this code is really nice")
        XCTAssertEqual(commitComment.author!.id, 11)
        XCTAssertEqual(commitComment.author!.username, "admin")
        XCTAssertEqual(commitComment.author!.email, "admin@local.host")
        XCTAssertEqual(commitComment.author!.name, "Administrator")
        XCTAssertEqual(commitComment.author!.state, "active")
        XCTAssertEqual(commitComment.author!.createdAt, TestHelper.parseDate("2014-03-06T08:17:35.000Z"))
    }

    func testCommitStatusParsing() {
        let commitStatus = CommitStatus(TestHelper.JSONFromFile("CommitStatus") as! [String: AnyObject])
        XCTAssertEqual(commitStatus.status, "pending")
        XCTAssertEqual(commitStatus.createdAt, TestHelper.parseDate("2016-01-19T08:40:25.934Z"))
        XCTAssertEqual(commitStatus.startedAt, nil)
        XCTAssertEqual(commitStatus.name, "bundler:audit")
        XCTAssertEqual(commitStatus.allowFailure, true)
        XCTAssertEqual(commitStatus.author!.username, "thedude")
        XCTAssertEqual(commitStatus.author!.webURL, URL(string: "https://gitlab.example.com/thedude"))
        XCTAssertEqual(commitStatus.author!.avatarURL, URL(string: "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png"))
        XCTAssertEqual(commitStatus.author!.id, 28)
        XCTAssertEqual(commitStatus.author!.name, "Jeff Lebowski")
        XCTAssertEqual(commitStatus.statusDescription, nil)
        XCTAssertEqual(commitStatus.sha, "18f3e63d05582537db6d183d9d557be09e1f90c8")
        XCTAssertEqual(commitStatus.targetURL, URL(string: "https://gitlab.example.com/thedude/gitlab-ce/builds/91"))
        XCTAssertEqual(commitStatus.finishedAt, nil)
        XCTAssertEqual(commitStatus.id, 91)
        XCTAssertEqual(commitStatus.ref, "master")
    }

}
