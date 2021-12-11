import XCTest
@testable import Health_X

final class InterfaceTests: XCTestCase {
    
    var interface: HXInterface
    
    override init() {
        interface = HXInterface()
        super.init()
    }
    
    func getStepsTest() async {
        await interface.updateAll()
       let stepCount = interface.stats.stepCount
        XCTAssertNotNil(stepCount, "Step count is nil.")
        XCTAssertNotEqual(stepCount, 0, "Step count is zero.")

    }
}
