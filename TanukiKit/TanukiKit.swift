import Foundation
import RequestKit

public let TanukiKitErrorDomain = "com.nerdishbynature.TanukiKit"

public struct TanukiKit {
    public let configuration: Configuration
    
    public init(_ config: Configuration = TokenConfiguration()) {
        configuration = config
    }
}
