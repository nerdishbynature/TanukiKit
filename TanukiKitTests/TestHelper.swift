import Foundation
@testable import TanukiKit


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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSv"
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

    internal class func codableFromFile<T>(_ name: String, type: T.Type) -> T where T: Codable {
        let bundle = Bundle(for: self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try! decoder.decode(T.self, from: data)
    }
}
