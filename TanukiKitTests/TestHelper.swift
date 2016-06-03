import Foundation

internal class TestHelper {
    internal class func stringFromFile(name: String) -> String? {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")
        if let path = path {
            let string = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            return string
        }
        return nil
    }
}