import Combine

/// An observable object for interacting with HXStats in an efficient matter.
public class HXInterface: ObservableObject {
    init() {
        stats = .init()
    }
    
    // MARK: -
    var stats: HXStats
}
