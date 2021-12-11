import Combine

/// An observable object for interacting with HXStats in an efficient matter.
public class HXInterface: ObservableObject {
    init() {
        stats = .init()
    }
    
    // MARK: -
    private(set) var stats: HXStats
    
    public var updateAll: (() async ->()) {
        stats.update
    }
}
