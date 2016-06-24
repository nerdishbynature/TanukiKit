import Foundation

internal class TestHelper {
    internal class func stringFromFile(_ name: String) -> String? {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "json")
        if let path = path {
            let string = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return string
        }
        return nil
    }

    internal class func parseDate(date: String?) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let dateOutput = dateFormatter.dateFromString(date!)
        return dateOutput
    }
    
    internal class func JSONFromFile(name: String) -> AnyObject {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let dict: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        return dict!
    }
}
