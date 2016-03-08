import XCTest
import TanukiKit
import Nocilla

class MergeRequestsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }
    
    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }
    
    func testJSONParsing() {
        let json = (TestHelper.loadJSON("merge_requests") as! [[String: AnyObject]]).first!
        
        let subject = MergeRequest(json)
        XCTAssertEqual(subject.title, "Add star")
        XCTAssertEqual(subject.mergeRequestDescription, "")
        XCTAssertEqual(subject.author?.name, "Piet Brauer")
        XCTAssertEqual(subject.mergeStatus, "can_be_merged")
        XCTAssertEqual(subject.projectID, 639042)
        XCTAssertEqual(subject.sourceBranch, "test-images")
        XCTAssertEqual(subject.sourceProjectID, 945182)
        XCTAssertEqual(subject.targetBranch, "master")
        XCTAssertEqual(subject.targetProjectID, 639042)
        XCTAssertFalse(subject.workInProgress ?? true)
    }
    
    // MARK: Actual Request tests
    
    func testPostPublicKey() {
        let config = PrivateTokenConfiguration("12345")
        if let json = TestHelper.stringFromFile("merge_requests") {
            stubRequest("GET", "https://gitlab.com/api/v3/projects/1234/merge_requests?page=1&per_page=100&private_token=12345").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("public_key")
            TanukiKit(config).mergeRequests("1234") { response in
                switch response {
                case .Success(let mergeRequests):
                    XCTAssertEqual(mergeRequests.count, 2)
                    expectation.fulfill()
                case .Failure:
                    XCTAssert(false, "should not get an error")
                    expectation.fulfill()
                }
            }
            waitForExpectationsWithTimeout(1) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }
}
