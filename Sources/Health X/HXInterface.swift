import Combine

/// An observable object for interacting with HXStats in an efficient matter.
public class HXInterface: ObservableObject {
    public init() {
        stats = .init()
    }
    
    // MARK: -
    public private(set) var stats: HXStats
    
    public var updateAll: (() async ->()) {
        stats.update
    }
}
