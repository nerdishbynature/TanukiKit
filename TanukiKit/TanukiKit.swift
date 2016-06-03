import Foundation
import RequestKit

public struct TanukiKit {
    public let configuration: Configuration

    public init(_ config: Configuration = TokenConfiguration()) {
        configuration = config
    }
}
