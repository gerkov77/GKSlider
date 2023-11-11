import XCTest
@testable import GKSlider
import SwiftUI

var sut: TestView!
final class GKSliderTests: XCTestCase {

    override class func setUp() {
        sut = TestView()
    }

    func testSliderValueEquals_5() throws {

        let slider = sut.slider()

        XCTAssertEqual(slider.sliderValue, 5.0)
    }

    func testPositionEquals5() {
        let slider = sut.slider()
        let position =   400 * (slider.sliderValue + 10) / 20
        XCTAssertEqual(slider.position.x, position)
    }
}



struct TestView: View {
    @State private(set) var value: Double = 5.0

    var body: some View {
            slider()
            .frame(width: 400, height: 30)
    }

    func slider() -> GKSlider<Double> {
        GKSlider(range: -10...10, sliderValue: $value)

    }
}
