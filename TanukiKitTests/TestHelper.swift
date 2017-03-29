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

    internal class func parseDate(_ date: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateOutput = dateFormatter.date(from: date!)
        return dateOutput
    }
    
    internal class func JSONFromFile(_ name: String) -> Any {
        let bundle = Bundle(for: self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: path)
        let dict: Any? = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return dict!
    }
}
